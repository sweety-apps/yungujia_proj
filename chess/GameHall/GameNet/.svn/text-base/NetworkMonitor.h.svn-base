/*
**
** NetworkMonitor.h
** class NetworkMonitor response for auto reconnecting of network 
** and
** reporting network state to server
**
*/

#ifndef _NETWORK_MONITOR_H_
#define _NETWORK_MONITOR_H_

#include <list>
#include "common/SDLogger.h"
#include "common/GNInterface.h"

class vdt_c2s_cmd_handler;

class NetworkMonitor
{
public:
    NetworkMonitor(vdt_c2s_cmd_handler* pHandler);
    ~NetworkMonitor();

    enum { MAX_RESEND_INTERVAL = 30*1000 };

public:
    // when send command
    // put it into our list
    // and cache the command's content
    void OnSendCommand(IGameCommand* pCmd);

    // when recv command
    // try recognize it and find the matcher in out cache list
    // if found, delete the cache command from list
    // else do nothing but report a warning
    void OnRecvCommand(IGameCommand* pCmd);

	// when recv enter room resp
	void OnEnterRoomResp();

    // when network error
    // try to reconnect server
    void OnNetworkError(unsigned long error_code, unsigned char type, bool toRecon = true);

	// when network error and no session conn, try to reconnect in 3 times
	void OnNoSessionNetworkError(unsigned long error_code);

    // when connect succeeded
    void OnConnectOk();

    // get network status
    bool IsBreak() { return m_bBreak; }

	// set network status
	void SetBreak(bool value) { m_bBreak = value; }

	// set is need resend enter room req
	void SetNeedReEnterRoom(bool value) { m_bNeedReEnterRoom = value; }
	bool GetNeedReEnterRoom() const { return m_bNeedReEnterRoom; }

public:
    // when timeout
    // try to resend cuple of command in cache list
    void TryReSendCommand(int nMaxCommandToSend);

    // try reconnect
    void TryReconnect();

    // when timeout
    // try to clean cmd which is dead
    void CleanDeadCommand();
    
    // clean all cache command
    void CleanAllCache();

	// reset all cache command tick
	void ResetCacheCmdTick();

	// resend EnterRoomReq
	void ResendEnterRoomReq();

private:
    DWORD GetReSendInterval(DWORD dwSendTimes);   
    DWORD GetReconnectInterval(DWORD dwReconnectTimes);
	void  CleanEnterRoomCache();

private:
    static const DWORD m_dwsMaxReSendTimes;
    static const DWORD m_dwsMaxCacheCmdNum;
    static const DWORD m_dwsMaxReconnectTimes;

private:
    typedef struct stCommandNode
    {
        IGameCommand2* pCmd;   // command
        DWORD dwLastSendTick;  // last tickcount
        DWORD dwReSendTimes;   // total sended times
        DWORD dwFirstSendTick;

        bool operator == (const stCommandNode& rh) const
        {
            return (rh.pCmd == pCmd) && 
                (rh.dwLastSendTick == dwLastSendTick) && 
                (rh.dwReSendTimes == dwReSendTimes);
        }
    } CommandNode;

    typedef std::list<CommandNode> GameCommandList;
    GameCommandList      m_listCommand;
    DWORD                m_dwLastReSendTick;
    DWORD                m_dwReconnectTimes;
    DWORD                m_dwLastReconnectTick;
    bool                 m_bBreak;    
	bool				 m_bNeedReEnterRoom;
    vdt_c2s_cmd_handler* m_pHandler;
	IGameCommand2*       m_pEnterRoomCmd;

private:
    DECL_LOGGER;
};

#endif // _NETWORK_MONITOR_H_
