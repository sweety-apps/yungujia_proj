#ifndef __ABSTRACT_C2S_CMD_HANDLER_H_
#define __ABSTRACT_C2S_CMD_HANDLER_H_

#include "common/SDLogger.h"
#include "common/GameNetInf.h"
#include "asynio/asyn_io_device.h"
#include "asynio/asyn_io_operation.h"
#include "asynio/asyn_io_handler.h"
#include <list>
#include <vector>
#include <map>

const int FIXED_OPERATION_BUFFER_LENGTH = 256 * 1024;
const int OPERTION_POOL_SIZE = 1;
const int EXTRA_BUFFER_SIZE	= 8192;

class abstract_c2s_cmd_handler;
class pooled_operation_manager;

class vdt_io_operation : public asyn_io_operation
{
public:
	vdt_io_operation(abstract_c2s_cmd_handler *handler_ptr, unsigned long buffer_len = 0, bool is_pooled_operation = false);
	virtual ~vdt_io_operation() { }

	bool is_pooled_operation() { return _is_pooled_operation; }
	void set_pooled_operation_manager(pooled_operation_manager* pooled_mgr)
	{
		if(_is_pooled_operation)
			_pooled_mgr = pooled_mgr;
	}
	pooled_operation_manager* get_pooled_operation_mgr() { return _pooled_mgr; }

public:
	unsigned long			_data_total_len;// 用于记录socket发送（接收）不完整时的数据原始长度
	unsigned long			_data_pos;		// 用于记录socket发送（接收）不完整时的数据位置
	unsigned long			_data_len;		// 用于记录socket发送（接收）不完整时的数据长度
	bool					_is_header_received;  // 包头是否接收完
	string					_cmd_desc;  // tracer启用时，才会使用此字段

private:
	bool _is_pooled_operation;
	pooled_operation_manager* _pooled_mgr;
};

class pooled_operation_manager
{
public:
	pooled_operation_manager(int max_pooled_size);

	bool is_pool_empty() { return _pooled_operation_ptrs.empty(); }
	bool add_to_pool(vdt_io_operation* operation_ptr);
	vdt_io_operation* fetch_from_pool();
	void fetch_specified_operation(vdt_io_operation* operation_ptr);
	void clear();
	int max_pooled_size() {return _max_pooled_size;}
	int cur_pooled_size() {return _cur_pooled_size;}

private:
	std::list<vdt_io_operation*> _pooled_operation_ptrs;
	std::set<vdt_io_operation*> _unique_operation_ptrs;
	int _max_pooled_size;
	int _cur_pooled_size;

	DECL_LOGGER;
};

#define D_SEND_ERROR 0
#define D_RECV_ERROR 1
#define D_CONN_ERROR 2
#define D_PACKET_ERROR 3
#define D_SENDPOOL_ERROR 4

class abstract_c2s_cmd_handler :	public asyn_io_handler
{
public:
	abstract_c2s_cmd_handler(const std::string &host, unsigned short port, bool is_session_conn );
	virtual ~abstract_c2s_cmd_handler(void);

public:
	virtual void handle_io_complete(asyn_io_operation *operation_ptr);

	bool is_session_connection() { return _is_session_conn; }
    void close_connection();

    // 发起连接(如果是UDP则发起DNS查询)
    virtual void connect() = 0;
    void receive(); // 尝试接收数据

	virtual int connect_type() = 0;
protected:
	virtual void before_exit_io_complete(asyn_io_operation *operation_ptr, bool has_more_cmd) { }

	// cmd_ptr的拥有权归调用者
	void execute_cmd( IGameCommand* cmd_ptr );
	vdt_io_operation* create_cmd_operation( IGameCommand* cmd_ptr );
	
	// 发送仍在队列中的命令
	bool send_queued_command();
	
	// 连接成功后(或DNS解析成功后)的事件处理
	virtual void handle_connect_result( asyn_io_operation* result );
	virtual int get_recv_operation_num() const { return 1; }

	// 发送_operation_ptr的缓冲区到连接对端
	void send(vdt_io_operation* sending_operation_ptr);
	// 在发送一个命令前的回调，用于派生类对命令的修改（例如设置本机、对方IP字段）
	virtual bool before_send( asyn_io_operation*  opt_ptr, unsigned long & encode_length );

	// 因为有多处调用socket recv，异常的处理代码冗余代码太多，所以总结到一个函数中
	void socket_receive( asyn_io_operation *operation_ptr, unsigned long expected_bytes,
		unsigned long buffer_pos = 0, bool must_receive_expected = true ); // 最后一个参数是制定必须循环接收完指定的字节数	

	void handle_received( asyn_io_operation *result, unsigned long received_bytes);					// 处理recv的异步操作
	void decode_response( char *buffer_ptr, unsigned long buffer_len );// recv了完整的命令,decode并且通知上层

	virtual int init_header_io_opeation(int header_len);
	virtual void init_body_io_operation(int header_len, int body_len);

	std::string get_socket_address(); // 由派生类调用,获取SOCKET地址

protected:
	// response_ptr的拥有权归调用者
	virtual bool handle_response( IGameCommand *response_ptr ) = 0;

protected:
    void init_operation_pool();
    void uninit_operation_pool();
    void close_asyn_operation_ptr(asyn_io_operation* operation_ptr);

public:
	void close();

protected:
//	IGameCommand*			_cmd_ptr_received;	// 从server接收到的命令
//	unsigned __int32        _cmd_sequence;      // 请求命令的序列号

	enum tag_status
	{
		status_idle,		// 空闲
		status_connecting,	// 正在连接
		status_sending,		// 正在发送
		status_receiving,	// 正在接收
	};
	
	bool					_is_connected;
	bool					_allow_receive;  // 至少向server发送了一个包后才允许接受
	bool					_is_receiving;

	// unsigned int					_retry_times;		// tcp发送失败后的重试次数
	// asyn_socks_socket_device*	_sock5_socket_ptr;	// 使用sock5代理时，sock5 socket 对象指针
	asyn_io_device*		_socket_ptr;	// 执行网络操作的异步socket对象指针


	pooled_operation_manager* _pooled_send_operation_mgr;
	std::vector<vdt_io_operation*> _all_sending_operation; // 所有的异步operation对象池：用于发送

	pooled_operation_manager* _pooled_recv_operation_mgr;
	std::vector<vdt_io_operation*> _all_recving_operation; // 所有的异步operation对象池：用于接收

//	vdt_io_operation*		_recv_operation_ptr; // 异步操作对应的异步操作对象指针: 接收

	std::list<IGameCommand *> _command_queue; // 命令队列
	bool _using_udp_protocol;
protected:
	std::string				_host; // 服务器域名(可能有多个)
	std::string				_curr_host; // 当前服务器域名
	unsigned short			_port; // 服务器端口
	unsigned int	_host_ip;  // 使用UDP需要自己进行域名解析
    bool _connection_finished;   
	int _request_send_times;
	int _response_recv_times;

	int m_conn_id;
	bool	_is_session_conn;

	bool _is_tracer_enabled;
	bool _proxy_connected;
	bool _sending_http_connect;
public:
	enum svr_type
	{
		portal_server=0, // 0:portal_server, 1 session_server , 2 stat_server
		session_server,
		stat_server,
	};
	int get_server_type() { return _server_type; };
	void set_server_type(short server_type) { _server_type=server_type; };

protected:
	short _server_type;

private:
	DECL_LOGGER;
};

#endif // #ifndef __ABSTRACT_C2S_CMD_HANDLER_H_
