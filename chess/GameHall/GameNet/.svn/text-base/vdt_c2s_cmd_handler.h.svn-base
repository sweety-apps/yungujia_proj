#ifndef __VDT_C2S_CMD_HANDLER_H_
#define __VDT_C2S_CMD_HANDLER_H_

#include "abstract_c2s_cmd_handler.h"
#include "common/SDLogger.h"
#include "common/GameNetInf.h"
#include "asynio/asyn_io_device.h"
#include "asynio/asyn_message_sender.h"
#include "NetworkMonitor.h"
#include <list>
#include <string>
#include <deque>

typedef std::deque<IGameCommand*> QueryDirCmdVec;

class vdt_c2s_cmd_handler :	
	public abstract_c2s_cmd_handler,
	public ISessionConnectionEx,
	public asyn_message_sender
{
public:
	enum ASYN_MSG_ID
	{
		MSG_CLOSE_CONN = 1,
		MSG_ADD_COMMAND = 2
	};

	enum ASYN_TIMER_ID
	{
		TIMER_ID_PING = 1,
		TIMER_ID_RESP_TIMEOUT = 2,
        TIMER_ID_CHECK_NETWORK = 3,
        TIMER_ID_RECONNECT = 4,
        TIMER_ID_REPLAY = 5,
	};
	enum { MIN_PING_INTERVAL = 60, DEFAULT_PING_INTERVAL = 60, MAX_PING_INTERVAL = 600, RESP_TIMEOUT_MAX = 45000, CHECK_NETWORK_INTERVAL = 1000, RECONNECT_INVERVAL = 1000, };

public:
	vdt_c2s_cmd_handler(const std::string &host, unsigned short port , bool is_session_conn);
	virtual ~vdt_c2s_cmd_handler(void);

public:
    virtual void handle_timeout(unsigned long timer_type);
	virtual void handle_message(ULONG lMessageId, ULONG lParam1, ULONG lParam2);

	// interface of ISessionConnection
	virtual int GetConnectionID() { return m_conn_id; }
	virtual bool SendCommand(IGameCommand* cmd);
	virtual void Close();
	virtual void EnterRoom(const GAMEROOM& roomInfo, const XLUSERINFOEX& userInfo);
	virtual void ExitRoom(const GAMEROOM& roomInfo);
	virtual void Chat(const GAMETABLE& tableInfo, const string& chatMsg, int nChatSeqNo);
	virtual void EnterGame(const GAMESEAT& seatInfo, GAME_USER_STATUS userStatus, const string& initalTableKey, const string& followPasswd);
	virtual void GameReady(const GAMESEAT& seatInfo);
	virtual void SubmitGameAction(const GAMEROOM& roomInfo, const char* pszGameData, int nDataLen);
	virtual void QuitGame(const GAMETABLE& tableInfo);
	virtual void Replay(const GAMESEAT& seatInfo);
	virtual void SendGenericCmd(const char* cmdName, const GAMEROOM& roomInfo, IDataXNet* pCmdParams);
    virtual void handle_connect_result( asyn_io_operation* result );

	void handle_close_conn_message(ULONG lParam1, ULONG lParam2);
	void handle_add_command_message(ULONG lParam1, ULONG lParam2);

	void SetConnectionID(int nConnID) { m_conn_id = nConnID; }    

	virtual void add_command( IGameCommand * cmd_ptr );
    void send_ping_cmd();
    virtual void handle_network_error( bool recv_error = false ,unsigned long error_code=20000,unsigned char type = -1);

protected:
    virtual void before_exit_io_complete(asyn_io_operation *operation_ptr, bool has_more_cmd);

	// response_ptr的拥有权归调用者
	virtual bool handle_response( IGameCommand *response_ptr );

private:
	void handle_get_dir_response(IGameCommand* get_dir_resp);
	void handle_get_userinfo_response(IGameCommand* pCmdUserInfoResp);
	void handle_nonsession_datax_response(IGameCommand* pCmdUserInfoResp);
	void handle_userstatussvr_datax_response(IGameCommand* pResp);
    void handle_balancesvr_datax_response(IGameCommand* pResp);
	void handle_session_cmd_response(IGameCommand* pResp);
	void handle_timed_match_datax_response(IGameCommand* pResp);
	void handle_userguidesvr_datax_response(IGameCommand* pCmdUserInfoResp);
	void handle_tab_status_datax_response(IGameCommand* pResp);
	void handle_chipsvr_datax_response(IGameCommand* pResp);
	void handle_flex_datax_response(IGameCommand* pResp);
	void handle_check_network_timeout();
	void handle_resp_timeout();

    void handle_reconnect_timeout();
	void handle_ping_response(IGameCommand* pResp);
	void on_recv_enterroom_resp(IGameCommand* pResp);

	bool IsCommandHasResp(IGameCommand* pCmd);
    void CheckQueryDirCmdPool();

//    unsigned short get_udp_listen_port();
protected:
 
	GAMEROOM _cur_game_room;
	bool _is_in_room;
	int _cur_ping_interval;
    bool _is_valid;
    bool _is_network_valid;
    bool _is_use_network_monitor;
	bool _is_kicked_out;

    NetworkMonitor _network_monitor;

    QueryDirCmdVec m_query_dir_cmds;
    int _wait_dir_count;
	int _resp_timeout;
    

private:
	DECL_LOGGER; //LOG4CPLUS_CLASS_DECLARE(_s_logger);
};

#endif // #ifndef __VDT_C2S_CMD_HANDLER_H_
