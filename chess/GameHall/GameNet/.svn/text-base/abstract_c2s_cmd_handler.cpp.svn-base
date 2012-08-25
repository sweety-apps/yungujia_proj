#include "vdt_c2s_cmd_handler.h"
#include "asynio/asyn_tcp_device.h"
#include "common/utility.h"
#include "command/GameCmdBase.h"
#include "command/GameCmdFactory.h"

IMPL_LOGGER_EX(abstract_c2s_cmd_handler, GN);
IMPL_LOGGER_EX(pooled_operation_manager, GN);

vdt_io_operation::vdt_io_operation(abstract_c2s_cmd_handler *handler_ptr, unsigned long buffer_len, bool is_pooled_operation)
	: asyn_io_operation(handler_ptr, buffer_len)
{
	_data_total_len = 0;
	_data_len = 0;
	_data_pos = 0;
	_is_header_received = false;
	_is_pooled_operation = is_pooled_operation;
	_pooled_mgr = NULL;
}

pooled_operation_manager::pooled_operation_manager(int max_pooled_size)
{
	if(max_pooled_size > 0)
		_max_pooled_size = max_pooled_size;
	else
		_max_pooled_size = OPERTION_POOL_SIZE;

	_cur_pooled_size = 0;
}

bool pooled_operation_manager::add_to_pool(vdt_io_operation* operation_ptr)
{
	if(!operation_ptr->is_pooled_operation())
		return false;

	if(_cur_pooled_size >= _max_pooled_size)
	{
		LOG_WARN( "current pooled operation size(" << _cur_pooled_size <<") >= _max_pooled_size(" << _max_pooled_size <<")!" ); 
		return false;
	}

	//ysh_assert(!operation_ptr->is_pending());
	operation_ptr->set_operation_state(false);
	std::pair< std::set<vdt_io_operation*>::iterator, bool> result = _unique_operation_ptrs.insert(operation_ptr);
	if(!result.second)
	{
		LOG_WARN( "io-operation " << operation_ptr << " already in the pool!"); 		
		return false;
	}

	operation_ptr->_data_total_len = 0;
	operation_ptr->_data_len = 0;
	operation_ptr->_data_pos = 0;

	_pooled_operation_ptrs.push_back(operation_ptr);
	_cur_pooled_size++;
	LOG_DEBUG( "after add_to_pool(), pooled io-operation size is " << _cur_pooled_size);
	return true;
}

vdt_io_operation* pooled_operation_manager::fetch_from_pool()
{
	if(_pooled_operation_ptrs.empty())
		return NULL;

	vdt_io_operation* operation_ptr = _pooled_operation_ptrs.front();
	int affected = (int)_unique_operation_ptrs.erase(operation_ptr);
	ysh_assert(affected > 0);
	_pooled_operation_ptrs.pop_front();
	_cur_pooled_size--;

	LOG_DEBUG( "after fetch_from_pool(), pooled io-operation size is " << _cur_pooled_size); 
	return operation_ptr;
}

void pooled_operation_manager::fetch_specified_operation(vdt_io_operation* operation_ptr)
{
	if(operation_ptr == NULL)
		return;

	int affected = (int)_unique_operation_ptrs.erase(operation_ptr);
	if(affected < 1)
	{
		LOG_WARN( "io-operation " << operation_ptr << " not in the pool!");
		return;
	}

	for(std::list<vdt_io_operation*>::iterator it = _pooled_operation_ptrs.begin(); it != _pooled_operation_ptrs.end(); it++)
	{
		if(*it == operation_ptr)
		{
			_pooled_operation_ptrs.erase(it);
            _cur_pooled_size--;
			break;
		}
	}
}

void pooled_operation_manager::clear()
{
	_pooled_operation_ptrs.clear();
	_unique_operation_ptrs.clear();
}

abstract_c2s_cmd_handler::abstract_c2s_cmd_handler(const std::string &host, unsigned short port, bool is_session_conn )
	: _host(host), _curr_host(host), _port(port), _is_session_conn(is_session_conn)
{
	_socket_ptr			= NULL;

	_is_connected = false;
	_allow_receive = false; 

	_using_udp_protocol = false;
	_is_tracer_enabled = false;
	_proxy_connected = false;
	_sending_http_connect	= false;
	m_conn_id = -1;

	_pooled_send_operation_mgr = NULL;
	_pooled_recv_operation_mgr = NULL;

	_request_send_times = 0;
	_response_recv_times = 0;
}

abstract_c2s_cmd_handler::~abstract_c2s_cmd_handler(void)
{
	LOG_DEBUG( "abstract_c2s_cmd_handler::~abstract_c2s_cmd_handler() called" ); 
	close();
}

void abstract_c2s_cmd_handler::handle_io_complete( asyn_io_operation* result )
{
	bool expected_bytes_received = false;	
	unsigned long transfered_bytes = 0;
	unsigned long error_code = 0;
	unsigned long total_recv_bytes = 0;
	unsigned long op_type = result->get_operation_type();
	LOG_INFO("handle_io_complete operation_ptr:" << result << " type=" << result->get_operation_type());
	
	vdt_io_operation* vdt_result = (vdt_io_operation*)result;

	bool is_operation_should_recycle = vdt_result->is_pooled_operation(); // 是否需要回收(到池中)？
	bool is_operation_recycled = false; // 是否已经回收到池中（本次操作中）？

	bool complete_result = result->get_complete_result( transfered_bytes, error_code );
	if(OP_SOCK_SEND == result->get_operation_type())
	{
		LOG_DEBUG(  "send finished in handle_io_complete(), transfered_bytes=" << transfered_bytes << ", err_code=" << error_code);
	}
	else if(OP_SOCK_RECV == result->get_operation_type())
	{
		LOG_DEBUG( "recv finished in handle_io_complete(), data_len=" << vdt_result->_data_len << ", transfered_bytes=" << transfered_bytes << ", err_code=" << error_code);
	}
	
	if( complete_result )
	{
		// 如果是发送操作
		if( OP_SOCK_SEND == result->get_operation_type() )
		{
			LOG_DEBUG(  "socket send " << transfered_bytes);
			vdt_result->_data_pos += transfered_bytes;
			vdt_result->_data_len -= transfered_bytes;

			if( vdt_result->_data_len > 0 ) // 待发送的数据没有发送完全
			{
				//try
				{
					LOG_DEBUG(  "socket send ["
						<< transfered_bytes << "] bytes less than expect ["
						<< vdt_result->_data_len+transfered_bytes << "]. so retry send range["
						<< vdt_result->_data_pos << "," << vdt_result->_data_len << "]." );
					// 发送剩余的数据
					result->set_operation_type( OP_SOCK_SEND );
					_socket_ptr->write( result, vdt_result->_data_len, vdt_result->_data_pos );
                    
					is_operation_should_recycle = false;
					return;
				}
				/* TODO
				catch( vdt_exception &e )
				{
					e;
					LOG_ERROR(  "send exception = " << e.what() );
					vdt_result->get_pooled_operation_mgr()->add_to_pool(vdt_result);
//					_pooled_send_operation_mgr->add_to_pool(vdt_result);
					is_operation_recycled = true;
					handle_network_error(false,error_code,D_SEND_ERROR);
					return;
				}
				*/
			}
			else
			{
				LOG_DEBUG(  "socket send over");
				// 设置处理中可能会获取总体发送的字节数
				// result->set_bytes_transfered( _data_total_len );
				vdt_result->_data_total_len = 0;
				vdt_result->_data_pos = 0;
				vdt_result->_data_len = 0;
				
				// 全部数据发送完成
				if(!_allow_receive)
					_allow_receive = true;
			}
		}
		else if( OP_SOCK_RECV == result->get_operation_type() )
		{
			vdt_result->_data_pos += transfered_bytes;
			if (vdt_result->_data_len != 0)
				vdt_result->_data_len -= transfered_bytes;
			LOG_TRACE(  "socket recv " );			

			if( vdt_result->_data_len > 0 && transfered_bytes && !_using_udp_protocol) // 待接收的数据没有接收完全
			{
				//try
				{
					LOG_TRACE(  "socket recv ["
						<< transfered_bytes << "] bytes less than expect ["
						<< vdt_result->_data_len + transfered_bytes << "]. so retry recv range["
						<< vdt_result->_data_pos << "," << vdt_result->_data_len << "]." );
					// 接收剩余的数据
					result->set_operation_type( OP_SOCK_RECV );
					_socket_ptr->read( result, vdt_result->_data_len, vdt_result->_data_pos );
                    
					is_operation_should_recycle = false;
					return;
				}
				/* TODO
				catch( vdt_exception &e )
				{
					e;
					LOG_ERROR(  "recv exception = " << e.what() );
					vdt_result->get_pooled_operation_mgr()->add_to_pool(vdt_result);
					is_operation_recycled = true;

					handle_network_error(false,error_code,D_RECV_ERROR );
					return;
				}
				*/
			}
			// 接收到0个字节，对方端口已经关闭
			else if( 0 == transfered_bytes )
			{
				LOG_ERROR(  "received 0 bytes. remote socket gracefully closed." );
				complete_result = false; // 模拟为错误
				error_code = 1;
			}
			else
			{				
				//result->set_bytes_transfered( _data_total_len );
				total_recv_bytes = vdt_result->_data_total_len; //_recv_data_total_len;
				
				vdt_result->_data_pos = 0;
				vdt_result->_data_len = 0;
				vdt_result->_data_total_len = 0;

				expected_bytes_received = true;
			}
		}
	}

	if(is_operation_should_recycle && !is_operation_recycled)
	{
		// 需要回收，但还没有回收
		vdt_result->get_pooled_operation_mgr()->add_to_pool(vdt_result);
//		_pooled_send_operation_mgr->add_to_pool(vdt_result);
		is_operation_recycled = true;
	}
	
	bool has_more_cmd = false;
	if( false == complete_result && error_code != 0)  // 操作失败的处理
	{
		LOG_ERROR(  "error occurred, error_code = ["
			<< error_code << "], current status: is_connected=" << _is_connected 
			<<  ", allow_receive=" << _allow_receive << ", op_type=" << op_type);

		unsigned char errtype;
		if(OP_SOCK_SEND == op_type)
			errtype = D_SEND_ERROR;
		else if(OP_SOCK_RECV == op_type)
			errtype = D_RECV_ERROR;
		else
			errtype = D_CONN_ERROR;

		bool recv_error = false;
        
        //vdt_result->get_pooled_operation_mgr()->add_to_pool(vdt_result);        
		handle_network_error(recv_error,error_code, errtype);
	}
	else // 操作成功的处理
	{
		if(!_is_connected)
		{
			LOG_INFO( "connect ok." );
			handle_connect_result( result );
			return;
		}

		bool has_cmd_to_send = false;
		if(expected_bytes_received)
		{
			handle_received(result, total_recv_bytes);
			has_cmd_to_send = send_queued_command();
		}
		else
		{
			has_cmd_to_send = send_queued_command();
			if(_allow_receive)
			{
				LOG_TRACE("begin to receive cmd response from server ...");
				receive();
			}
		}
		
		has_more_cmd = has_cmd_to_send;
	}
	
	before_exit_io_complete(result, has_more_cmd);
}

void abstract_c2s_cmd_handler::handle_received( asyn_io_operation *result, unsigned long received_bytes )
{
	LOG_DEBUG( "handle received bytes(len=" << received_bytes << ")");
//    vdt_session* p_session = vdt_session::get_instance();

	if(_using_udp_protocol)
	{
		// UDP接收一次就可，接收到了完整的命令
		decode_response( (char *)(result->buffer_ptr()), result->buffer_len() );

		return;
	}
	
	vdt_io_operation* vdt_operation = (vdt_io_operation*)result;
	const static int CMD_HEADER_LEN = GameCmdBase::get_header_length();
    if(CMD_HEADER_LEN == received_bytes && !vdt_operation->_is_header_received) //transfered_bytes)
	{
		//接收到完整头部
		void* buf_ptr = (void*)result->buffer_ptr();
		GameCmdHeader vdt_header;
		GameCmdBase::read_header((byte*)buf_ptr, vdt_header);
//		GameCmdHeader* vdt_header = (GameCmdHeader*)buf_ptr;

		int body_len = vdt_header.EncryptLen;

		if(body_len <= 0 || body_len > FIXED_OPERATION_BUFFER_LENGTH  )
		{
			LOG_ERROR( "invalid body_len: " << body_len );
			handle_network_error(false,20000,D_PACKET_ERROR );
			return;
		}

		init_body_io_operation(CMD_HEADER_LEN, body_len);

		LOG_TRACE(  "begin to receive command body, expected bytes = ["
			<< (unsigned int)body_len << "]." );
		_pooled_recv_operation_mgr->fetch_specified_operation((vdt_io_operation*)result);
		vdt_operation->_is_header_received = true;
		socket_receive( result, body_len, CMD_HEADER_LEN );

	}
	else 
	{
		_response_recv_times++;
		// 接收到了完整的命令
		decode_response( (char *)(result->buffer_ptr()), result->buffer_len() );

	}
}


void abstract_c2s_cmd_handler::decode_response( char * buffer_ptr, unsigned long buffer_len )
{    
#ifdef LOGGER
	GameCmdHeader cmd_header;
	GameCmdBase::read_header((byte*)buffer_ptr, cmd_header);
	int nRealLen = GameCmdBase::get_header_length() + cmd_header.EncryptLen;

	unsigned long dump_len = nRealLen > 512 ? 512 : nRealLen;
	LOG_TRACE( "decode_response() called, binary data details: " << utility::ch2str((byte*)buffer_ptr, dump_len));
#endif // #ifdef LOGGER

    unsigned short cmd_typeid = GameCmdBase::parse_cmd_type((const unsigned char*)buffer_ptr);
    LOG_DEBUG("decode_response - cmdid=" << cmd_typeid);

	IGameCommand* cmd_ptr_received = GameCmdFactory::create_cmd_by_typeid(cmd_typeid);
	if(cmd_ptr_received == NULL)
	{
		if(_using_udp_protocol)
			receive();

		return;
	}

	//try
	{
		LOG_DEBUG( "received command[" << cmd_ptr_received->CmdName() << "], length:" << buffer_len);
		cmd_ptr_received->Decode( buffer_ptr, buffer_len );        
	}
	/* TODO catch( vdt_exception &e )
	{
		e;
		LOG_ERROR( "[decode exception = " << e.what() << "]." );

		delete cmd_ptr_received;
		cmd_ptr_received = NULL;
		
		if(_using_udp_protocol)
			receive();
		else
			handle_network_error(false,20000, D_PACKET_ERROR );

		return;
	}
	*/

	LOG_INFO( "received command details: " << cmd_ptr_received->Description()); 

	// 上层处理命令回复
	bool handle_succ = false;
	//try
	{
		handle_succ = handle_response( cmd_ptr_received );
	}
	/*
	 TODO
	catch (vdt_exception &e)
	{	
		e;
		LOG_ERROR( "[handle response exception = " << e.what() << "]." );
	}
	*/

	if(is_session_connection())
	{
		if(handle_succ || _using_udp_protocol)
		{
			// 继续接收下面的命令
			LOG_DEBUG( "after handle one cmd response, begin to receive next cmd ... ");
			receive();
		}
	}
}

void abstract_c2s_cmd_handler::close()
{
	LOG_DEBUG("close() called");

    uninit_operation_pool();
	close_connection();

	_is_connected = false;
	_allow_receive = false; 
	_using_udp_protocol = false;
}

void abstract_c2s_cmd_handler::send(vdt_io_operation* sending_operation_ptr)
{
	ysh_assert( sending_operation_ptr );
//    vdt_session* p_session = vdt_session::get_instance();

	//try
	{
		// 给派生类一个改变缓冲区内容的机会

		if ( false == before_send( sending_operation_ptr, sending_operation_ptr->_data_total_len ) )
		{
			// 返回false说明发生了错误
			LOG_WARN( "before_send() returns false!!" );
			return;
		}

		LOG_DEBUG( "begin to send command. expect send [" 
			<< (unsigned int)sending_operation_ptr->_data_total_len << "] bytes" );
		sending_operation_ptr->_data_len = sending_operation_ptr->_data_total_len;
		sending_operation_ptr->_data_pos = 0;

		sending_operation_ptr->set_operation_type( OP_SOCK_SEND );
		_socket_ptr->write( sending_operation_ptr, sending_operation_ptr->_data_len );
	}
	/* TODO
	catch( vdt_exception &e )
	{
		e;
		LOG_ERROR( "send exception = " << e.what() );

		_pooled_send_operation_mgr->add_to_pool(sending_operation_ptr);

		handle_network_error(false,20000, D_SEND_ERROR);
		return;
	}
	*/
}

bool abstract_c2s_cmd_handler::before_send( asyn_io_operation*  opt_ptr, unsigned long& encode_length )
{
	// 在派生类中实现该函数，可以在命令发送之前改变命令内容
	// 比如取得socketIP之后，修改命令中本机IP字段
	return true;
}

void abstract_c2s_cmd_handler::receive()
{
	if(!_allow_receive)
	{
		LOG_WARN( "not allowed to receive server response now!" );
		return;
	}

	if(_pooled_recv_operation_mgr->is_pool_empty())
	{
		LOG_DEBUG( "all receive io-operation is in RECEIVING status!" );
		return;
	}
/*
	if(_is_receiving)
	{
		LOG_INFO( "already in RECEIVING status!" );
		return;
	}
*/

	while(!_pooled_recv_operation_mgr->is_pool_empty())
	{
		vdt_io_operation* operation_ptr = _pooled_recv_operation_mgr->fetch_from_pool();
		ysh_assert(operation_ptr);

		int header_len = GameCmdBase::get_header_length();

		int new_length = init_header_io_opeation(header_len);

		LOG_DEBUG( "begin to receive command header on operation: " <<  operation_ptr);
		operation_ptr->_is_header_received = false;
		socket_receive( operation_ptr, new_length );
	}

//	_is_receiving = true;
}

void abstract_c2s_cmd_handler::socket_receive(	asyn_io_operation* operation_ptr, 
									 unsigned long expected_bytes,
									 unsigned long buffer_pos,
									 bool must_receive_expected )
{
	LOG_DEBUG("socket_receive");
	vdt_io_operation* vdt_opeation = (vdt_io_operation*)operation_ptr;
	//try
	{
		if ( must_receive_expected )
		{
			vdt_opeation->_data_total_len = expected_bytes;
			vdt_opeation->_data_pos = buffer_pos;
			vdt_opeation->_data_len = expected_bytes;

		}
		else
		{
			vdt_opeation->_data_total_len = 0;
			vdt_opeation->_data_pos = 0;
			vdt_opeation->_data_len = 0;

		}
		operation_ptr->set_operation_type( OP_SOCK_RECV );
//        _recv_operation_ptr->set_operation_state(true);
		_socket_ptr->read( operation_ptr, expected_bytes, buffer_pos );
	}
	/* TODO
	catch( vdt_exception &e )
	{
		e;
		LOG_ERROR( "asyn socket read exception = "
			<< e.what() << "]." );
//        _recv_operation_ptr->set_operation_state(false);

		//added by panxiangrong 08-7-30
		_pooled_recv_operation_mgr->add_to_pool(vdt_opeation);

		handle_network_error(false,20000, D_RECV_ERROR );
		return;
	}
	*/
}

//cmd_ptr的拥有权归调用者
void abstract_c2s_cmd_handler::execute_cmd( IGameCommand* cmd_ptr )
{
	if(_pooled_recv_operation_mgr == NULL || _pooled_send_operation_mgr == NULL)
	{
		init_operation_pool();
	}

	LOG_DEBUG("try to send command '" << cmd_ptr->CmdName() << "' now.");

	bool send_now = true;
	if(_socket_ptr == NULL || !_is_connected)
	{
		_command_queue.push_back(cmd_ptr);
		send_now = false;
		LOG_DEBUG( "number of queued commands is: " << (int)_command_queue.size());
	}


	//ysh_assert( _cmd_response_ptr );
	//	LOG4CPLUS_THIS_SAFE(s_logger, cmd_ptr->description());
	if( _socket_ptr == NULL)
	{
		LOG_DEBUG("connection not established, try to connect now.");
		// 未连接，开始连接
		connect();
	}
	else if(send_now)
	{
		if(_pooled_send_operation_mgr->is_pool_empty())
		{
			LOG_WARN( "No idle sending-operation available for new cmd: " << cmd_ptr->Description()); 
			_command_queue.push_back(cmd_ptr);			
			LOG_DEBUG( "number of queued commands is: " << (int)_command_queue.size());
			return;
		}

		LOG_INFO( "try to submit command, cmd details:" << cmd_ptr->Description()); 
		
		vdt_io_operation* sending_operation_ptr = create_cmd_operation(cmd_ptr);

		if ( sending_operation_ptr == NULL)
		{
			LOG_ERROR( "create asyn operation failed." );
			handle_network_error(false,20000,  D_SENDPOOL_ERROR );
			return;
		}

		// 如果已经连接，则直接发送命令
		send(sending_operation_ptr);

	}
}


void abstract_c2s_cmd_handler::handle_connect_result( asyn_io_operation * result )
{
	LOG_DEBUG( "handle_connect_result() called." );		

	_is_connected = true;

	LOG_DEBUG( "try to send queued cmd ..." );		
	send_queued_command();
}

vdt_io_operation* abstract_c2s_cmd_handler::create_cmd_operation( IGameCommand * cmd_ptr )
{
	if(_pooled_send_operation_mgr->is_pool_empty())
	{
		LOG_WARN( "No idle sending io-operation available for new cmd!");
		return NULL;
	}

	vdt_io_operation* sending_operation = _pooled_send_operation_mgr->fetch_from_pool(); // _pooled_sending_operation.front();
	ysh_assert(sending_operation);

	sending_operation->_data_total_len = cmd_ptr->Length();
    ysh_assert( sending_operation->_data_total_len <= FIXED_OPERATION_BUFFER_LENGTH);

	//try
	{
		cmd_ptr->Encode( sending_operation->buffer_ptr(), sending_operation->_data_total_len );
		
		// 记录异步操作对应的命令名
		//_opt_cmd_name[_operation_ptr] = cmd_ptr->_name_decrible;

		LOG_DEBUG( "command ["
			<< cmd_ptr->CmdName() << "] encode ok, encoded bytes = ["
			<< (unsigned int)sending_operation->_data_total_len << "].");

#ifdef LOGGER
		unsigned long dump_len = sending_operation->_data_total_len > 512 ? 512 : sending_operation->_data_total_len;
		LOG_TRACE( "cmd binary data details: " << utility::ch2str((byte*)sending_operation->buffer_ptr(), dump_len));
#endif // #ifdef LOGGER

		delete cmd_ptr;

		//LOG_DEBUG( "encode_data:" << utility::ch2str(_operation_ptr->buffer_ptr(), _operation_encode_length));

	}
	/* TODO
	catch (vdt_exception & e)
	{
		e;
		LOG_ERROR( "encode exception = " << e.what() );
		_pooled_send_operation_mgr->add_to_pool(sending_operation);
		return NULL;
	}
	*/

	return sending_operation;
}


void abstract_c2s_cmd_handler::close_connection()
{
	if ( _socket_ptr )
	{
		LOG_INFO( "close the connection." );

		_socket_ptr->close();
		delete _socket_ptr;
		_socket_ptr = NULL;
	}
	_connection_finished = false;
    _is_connected = false;

	_proxy_connected = false;
	_sending_http_connect = false;

	_request_send_times = 0;
	_response_recv_times = 0;
}

bool abstract_c2s_cmd_handler::send_queued_command()
{
	LOG_TRACE("entrance");
	if(!_is_connected)
	{
		LOG_WARN( "connection not established!" );
		return false;
	}

	if(_command_queue.empty())
	{
		LOG_DEBUG( "no extra command to send" );
		return false;
	}

	if(_pooled_send_operation_mgr->is_pool_empty())
	{
		LOG_WARN( "No idle sending io-operation available to send queued cmd!" );
		return false;
	}

	if(!is_session_connection() && _request_send_times > _response_recv_times)
	{
		LOG_INFO("Response not returned, so queued request do not send now.");
		return true;
	}

	IGameCommand* cmd_ptr = _command_queue.front();
	_command_queue.pop_front();

	LOG_INFO( "try to send command in queue, cmd details:" << cmd_ptr->Description()); 
	
	vdt_io_operation* sending_operation = create_cmd_operation(cmd_ptr);
	if (sending_operation == NULL)
	{
		LOG_ERROR( "create asyn operation failed." );
		handle_network_error(false,2000, D_SENDPOOL_ERROR );
		return false;
	}

	send(sending_operation);

	LOG_DEBUG( "send one command in queue ok."); 
	_request_send_times++;

	LOG_TRACE("exit");
	return true;
}

std::string abstract_c2s_cmd_handler::get_socket_address()
{
//	return utility::inet_addr2str( p2p_transfer_layer::get_instance()->get_local_ip() );
	return "";
}

int abstract_c2s_cmd_handler::init_header_io_opeation(int header_len)
{
	return GameCmdBase::get_header_length();
}

// init receive asyn_io_operation for cmd body
void abstract_c2s_cmd_handler::init_body_io_operation(int header_len, int body_len)
{
    ysh_assert(header_len + body_len <= FIXED_OPERATION_BUFFER_LENGTH);
}

void abstract_c2s_cmd_handler::init_operation_pool()
{
	_pooled_send_operation_mgr = new pooled_operation_manager(OPERTION_POOL_SIZE);
    for(int i = 0; i != OPERTION_POOL_SIZE; i++)
    {
        vdt_io_operation* operation_ptr = new vdt_io_operation(this, FIXED_OPERATION_BUFFER_LENGTH, true); // create_io_operation(FIXED_OPERATION_BUFFER_LENGTH);
		operation_ptr->set_pooled_operation_manager(_pooled_send_operation_mgr);
		operation_ptr->get_pooled_operation_mgr()->add_to_pool(operation_ptr);

		_all_sending_operation.push_back(operation_ptr);
    }
	
	int recv_operation_size = get_recv_operation_num();
	LOG_DEBUG( "recv io-operation number is: " << recv_operation_size); 
	_pooled_recv_operation_mgr = new pooled_operation_manager(recv_operation_size);
	for(int i = 0; i != recv_operation_size; i++)
	{
		vdt_io_operation* operation_ptr = new vdt_io_operation(this, FIXED_OPERATION_BUFFER_LENGTH, true); // create_io_operation(FIXED_OPERATION_BUFFER_LENGTH);
		operation_ptr->set_pooled_operation_manager(_pooled_recv_operation_mgr);
		operation_ptr->get_pooled_operation_mgr()->add_to_pool(operation_ptr);

		_all_recving_operation.push_back(operation_ptr);
	}

//	_recv_operation_ptr = new vdt_io_operation(this, FIXED_OPERATION_BUFFER_LENGTH); // create_io_operation(FIXED_OPERATION_BUFFER_LENGTH);
}

void abstract_c2s_cmd_handler::uninit_operation_pool()
{

	if(_pooled_send_operation_mgr != NULL)
	{
		for(int i = 0; i != _all_sending_operation.size(); i++)
		{
			asyn_io_operation* operation_ptr = _all_sending_operation[i];
			close_asyn_operation_ptr(operation_ptr);
		}
		_all_sending_operation.clear();
		_pooled_send_operation_mgr->clear();
		delete _pooled_send_operation_mgr;
		_pooled_send_operation_mgr = NULL;

	}


	if(_pooled_recv_operation_mgr != NULL)
	{
		for(int i = 0; i != _all_recving_operation.size(); i++)
		{
			asyn_io_operation* operation_ptr = _all_recving_operation[i];
			close_asyn_operation_ptr(operation_ptr);
		}
		_all_recving_operation.clear();
		_pooled_recv_operation_mgr->clear();
		delete _pooled_recv_operation_mgr;
		_pooled_recv_operation_mgr = NULL;
	}

//	close_asyn_operation_ptr(_recv_operation_ptr);
}

void abstract_c2s_cmd_handler::close_asyn_operation_ptr(asyn_io_operation* operation_ptr)
{
    if ( operation_ptr )
    {
        delete_io_operation(operation_ptr);
        operation_ptr = NULL;
    }
}
