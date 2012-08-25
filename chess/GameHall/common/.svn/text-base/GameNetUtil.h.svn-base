#ifndef _GAME_NET_UTILITY_H_20090506
#define _GAME_NET_UTILITY_H_20090506

#include "DataX.h"
#include "DataID.h"
#include "GameNetTypes.h"

class GameNetUtil
{
	GameNetUtil() { }  // private ctor
public:
	static BOOL DataX2PlayerRec(PDataX dx, XLPLAYERREC& playerRec);

};

/*
ysh_assert( VT_I8	== sa[0].vt);		pRec->UserID = sa[0].llVal;
ysh_assert( VT_BSTR	== sa[1].vt);		pRec->UserRec.Username = ::SysAllocStringByteLen( (char*)sa[1].bstrVal, ::SysStringByteLen(sa[1].bstrVal) );
ysh_assert( VT_BSTR	== sa[2].vt);		pRec->UserRec.Nickname = ::SysAllocStringByteLen( (char*)sa[2].bstrVal, ::SysStringByteLen(sa[2].bstrVal) );
ysh_assert( VT_I2	== sa[3].vt);		pRec->UserRec.ImageIndex = sa[3].iVal;
ysh_assert( VT_BOOL	== sa[4].vt);		pRec->UserRec.IsVIPUser = sa[4].boolVal;
ysh_assert( VT_BSTR	== sa[5].vt);		pRec->UserIP	= ::SysAllocStringByteLen( (char*)sa[5].bstrVal, ::SysStringByteLen(sa[5].bstrVal) );
ysh_assert( VT_UI2	== sa[6].vt);		pRec->TableID	= sa[6].uiVal;
ysh_assert( VT_UI1	== sa[7].vt);		pRec->SeatID	= sa[7].bVal;
ysh_assert( VT_UI1	== sa[8].vt);		pRec->UserStatus= sa[8].bVal;
ysh_assert( VT_UI1	== sa[9].vt);		pRec->Level		= sa[9].bVal;
ysh_assert( VT_I4	== sa[10].vt);		pRec->Points	= sa[10].lVal;
ysh_assert( VT_I4	== sa[11].vt);		pRec->WinNum	= sa[11].lVal;
ysh_assert( VT_I4	== sa[12].vt);		pRec->LoseNum	= sa[12].lVal;
ysh_assert( VT_I4	== sa[13].vt);		pRec->EqualNum	= sa[13].lVal;
ysh_assert( VT_I4	== sa[14].vt);		pRec->EscapeNum	= sa[14].lVal;
ysh_assert( VT_I4	== sa[15].vt);		pRec->OrgID		= sa[15].lVal;
ysh_assert( VT_I4	== sa[16].vt);		pRec->OrgPos	= sa[16].lVal;
*/

inline BOOL GameNetUtil::DataX2PlayerRec(PDataX dx, XLPLAYERREC& playerRec)
{
	playerRec.UserID = dx[DataID_UserID];

	CComBSTR bstrTemp = dx[DataID_Username];
	playerRec.UserRec.Username = bstrTemp.Detach();

	bstrTemp = dx[DataID_Nickname];
	playerRec.UserRec.Nickname = bstrTemp.Detach();

	playerRec.UserRec.ImageIndex = dx[DataID_ImageIndex];
	
	bstrTemp = dx[DataID_UserIP];
	playerRec.UserIP = bstrTemp.Detach();

	playerRec.TableID = dx[DataID_TableID];
	playerRec.SeatID = dx[DataID_SeatID];
	playerRec.UserStatus = dx[DataID_UserStatus];
	playerRec.Level = dx[DataID_UserLevel];
	playerRec.Points = dx[DataID_UserPoints];
	playerRec.WinNum = dx[DataID_UserWinNum];
	playerRec.LoseNum = dx[DataID_UserLoseNum];
	playerRec.EqualNum = dx[DataID_UserEqualNum];
	playerRec.EscapeNum = dx[DataID_UserEscapeNum];
	playerRec.OrgID = dx[DataID_UserOrgID];
	playerRec.OrgPos = dx[DataID_UserOrgPos];
	
	bstrTemp = dx[DataID_LevelName];
	playerRec.LevelName = bstrTemp.Detach();

	playerRec.IsMale = dx[DataID_UserIsMale];

	return TRUE;
}

#endif // #ifndef _GAME_NET_UTILITY_H_20090506