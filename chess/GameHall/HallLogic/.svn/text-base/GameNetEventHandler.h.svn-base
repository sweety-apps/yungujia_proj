
#ifndef __GAMENET_EVENT_HANDLER_H_20090409
#define __GAMENET_EVENT_HANDLER_H_20090409

#include "common/common.h"
#include "common/GameNetInf.h"

class CGameNetEventHandler : public IGameNetEventEx
{
	CGameNetEventHandler();
public:
	static CGameNetEventHandler* GetInstance();

	// interface of IGameNetEvent
	virtual void OnQueryDirResp(const string& response);
	virtual void OnQueryUserInfoResp(int nResult, XLUSERID nUserID, const vector<XLUSERGAMEINFO>& userGamesInfo);
	virtual void OnNetworkError(int nErrorCode);
	virtual void OnRecvDataXResp(int nResult , const char* cmdName, IDataXNet* pDataX);
	virtual void OnNetworkErrorWithConnID(int nConnID, int nErrorCode, int nExtraCode);

public:
	void OnGetRoomLevel(int nGameID, int nZoneID);

private:
	//void NotifyGameClientDataXResp(CHallInterface* pHallInf, int nResult , const char* cmdName, IDataXNet* pDataX);
	void HandlerUserInfoResp(int nResult , const char* cmdName, IDataXNet* pDataX);
    void HandlerTransferGuestAllScoresResp(int nResult, const char* cmdName, IDataXNet* pDataX);
    void HandlerUserPositionResp(int nResult , const char* cmdName, IDataXNet* pDataX);
	void OnQueryUserPositionResp(int nResult, const char* cmdName, IDataXNet* pDataX);
    void HandlerQueryBalanceResp(int nResult , const char* cmdName, IDataXNet* pDataX);
    void HandleDirInfoResp();
	void HandlerReportOnlineResp(int nResult , const char* cmdName, IDataXNet* pDataX);	

private:
    DECL_LOGGER;
};

#endif // #ifndef __GAMENET_EVENT_HANDLER_H_20090409
