#include "vdt_tcp_cmd_handler.h"
#include "asynio/asyn_io_frame.h"

IMPL_LOGGER_EX(vdt_tcp_cmd_handler, GN);

using namespace std;

#define D_TCP_FAST_RECONN_INTERVAL 5
#define D_TCP_SLOW_RECONN_INTERVAL 30
#define D_TCP_RECONN_INTERVAL_3 1

#define FAST_RETRY_MAX_TIMES	5
#define TCP_RECONN_TIMER 20

#define D_TCP_CONN_STAT_INITIAL 1
#define D_TCP_CONN_STAT_NORMAL 2
#define D_TCP_CONN_STAT_FAST_RECONN_WAIT_FOR_TIMER 3
#define D_TCP_CONN_STAT_FAST_RECONN_WAIT_FOR_RESULT 4
#define D_TCP_CONN_STAT_FAST_RECONN_WAIT_FOR_SLOW_RECONN_RESULT 5
#define D_TCP_CONN_STAT_SLOW_RECONN_WAIT_FOR_TIMER 6
#define D_TCP_CONN_STAT_SLOW_RECONN_WAIT_FOR_RESULT 7

vdt_tcp_cmd_handler::vdt_tcp_cmd_handler(const std::string &host, unsigned short port, bool is_session_conn,bool is_tracer_enabled)
 : vdt_c2s_cmd_handler(host,port, is_session_conn)
{
	_using_udp_protocol = false;
	_is_tracer_enabled = is_tracer_enabled;
}

vdt_tcp_cmd_handler::~vdt_tcp_cmd_handler(void)
{
}

void vdt_tcp_cmd_handler::connect()
{
	// 创建套接字并连接服务器
	LOG_DEBUG( "vdt_tcp_cmd_handler begin to connect [" << _host << ":" << _port << "] ..." );	

    if(_pooled_recv_operation_mgr == NULL || _pooled_send_operation_mgr == NULL)
    {
        init_operation_pool();
    }

    _curr_host = _host.c_str();

	LOG_DEBUG( "vdt_tcp_cmd_handler select connect: " << _curr_host );
    
	vdt_io_operation* sending_operation_ptr = _pooled_send_operation_mgr->fetch_from_pool(); 
	//ysh_assert(sending_operation_ptr != NULL);
    if(sending_operation_ptr == NULL)
    {
        LOG_ERROR( "asyn connect exception = null" );
        handle_network_error(false,2000,D_CONN_ERROR);
        return;
    }

	//try
	{
		asyn_tcp_device* tcp_socket = new asyn_tcp_device();
		tcp_socket->set_recv_timeout(0xFFFFFFFF);
		_socket_ptr = tcp_socket; // new asyn_tcp_device(); // 查询资源的连接优先级高
		sending_operation_ptr->set_operation_type( OP_SOCK_CONNECT );         
		tcp_socket->connect( _curr_host, _port, sending_operation_ptr );
	}
	/* TODO
	catch( vdt_exception &e )
	{
		_pooled_send_operation_mgr->add_to_pool(sending_operation_ptr);
		
		LOG_ERROR( "asyn connect exception = " << e.what() );
		handle_network_error(false,2000,D_CONN_ERROR);
		return;
	}
	*/
}
