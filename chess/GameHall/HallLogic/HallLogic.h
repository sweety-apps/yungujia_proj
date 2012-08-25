#ifndef _HALLLOGIC_H_
#define _HALLLOGIC_H_

#include <string>
#include "GameNet/command/DataID.h"
#include "common/common.h"
#include "HallContext.h"

using std::string;

class CHallLogic
{
private:
	CHallLogic();

public:
	static CHallLogic* GetInstance();
	~CHallLogic();

public:
	void 		Init(const char* szIMEIID);
	void 		LoginAsGuest();
	bool 		GetDirInfo(int nGameClassID = -1, int nGameID = -1, int nZoneID = -1);
	bool 		AutoChooseRoom(int nGameClassID, int nGameID);
	bool 		TryEnterRoom(int nGameID, int nZoneID, int nRoomID);
	bool 		AutoEnterGame(int nGameID);
	bool 		QuitGame(int nGameID, int nTableID);
	bool 		ExitRoom(int nGameID);
	bool 		GameReady(int nGameID, int nTableID, int nSeatID);
	bool 		SubmitGameAction(int nGameID, const char* pBuf, int nLen);
	bool 		Replay(int nGameID);

private:
	void 		QueryBlueDiamondInfo(XLUSERID nUserID);

private:
	string 		m_sLastError;

private:
	DECL_LOGGER;
};

#define g_pHallLogic (CHallLogic::GetInstance())

#endif // _HALLLOGIC_H_
