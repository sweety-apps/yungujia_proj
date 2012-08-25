#include "DataXImpl.h"
#include <strstream>
#include <assert.h>
#include "common/utility.h"

using namespace std;

DataIDToKeyMap DataXImpl::m_sMapDataIDToKey;

#define ysh_assert assert

IMPL_LOGGER(DataXImpl);

DataXImpl::DataXImpl(void)
{
}

DataXImpl::~DataXImpl(void)
{
	Clear();
}

void DataXImpl::InitDataIDMap()
{
	m_sMapDataIDToKey.clear();

	m_sMapDataIDToKey[-9999] = "Error";
	m_sMapDataIDToKey[-9998] = "State";
	m_sMapDataIDToKey[-9997] = "RespResult";
	m_sMapDataIDToKey[-9996] = "LoginInfo";
	m_sMapDataIDToKey[-9995] = "Param1";
	m_sMapDataIDToKey[-9994] = "Param2";
	m_sMapDataIDToKey[-9993] = "GameDir";
	m_sMapDataIDToKey[-9992] = "CmdSrcID";
	m_sMapDataIDToKey[-9989] = "UserID";
	m_sMapDataIDToKey[-9988] = "Username";
	m_sMapDataIDToKey[-9987] = "Nickname";
	m_sMapDataIDToKey[-9986] = "Password";
	m_sMapDataIDToKey[-9985] = "ImageIndex";
	m_sMapDataIDToKey[-9984] = "UserIsVip";
	m_sMapDataIDToKey[-9983] = "UserIP";
	m_sMapDataIDToKey[-9982] = "UserStatus";
	m_sMapDataIDToKey[-9981] = "UserLevel";
	m_sMapDataIDToKey[-9980] = "UserPoints";
	m_sMapDataIDToKey[-9979] = "UserWinNum";
	m_sMapDataIDToKey[-9978] = "UserLoseNum";
	m_sMapDataIDToKey[-9977] = "UserEqualNum";
	m_sMapDataIDToKey[-9976] = "UserEscapeNum";
	m_sMapDataIDToKey[-9975] = "UserOrgID";
	m_sMapDataIDToKey[-9974] = "UserOrgPos";
	m_sMapDataIDToKey[-9973] = "UserIsMale";
	m_sMapDataIDToKey[-9972] = "JumpKey";
	m_sMapDataIDToKey[-9971] = "UserScore";
	m_sMapDataIDToKey[-9970] = "UserRankName";
	m_sMapDataIDToKey[-9969] = "UserRank";
	m_sMapDataIDToKey[-9968] = "UserIsXLVip";
	m_sMapDataIDToKey[-9967] = "UpgradePercent";

	m_sMapDataIDToKey[-9961] = "IconID";
	m_sMapDataIDToKey[-9960] = "OnlineUsers";

	m_sMapDataIDToKey[-9959] = "GameClassID";
	m_sMapDataIDToKey[-9958] = "GameClassName";
	m_sMapDataIDToKey[-9957] = "GameClassStatus";
	m_sMapDataIDToKey[-9955] = "GameClassGames";

	m_sMapDataIDToKey[-9949] = "GameID";
	m_sMapDataIDToKey[-9948] = "GameName";
	m_sMapDataIDToKey[-9947] = "GameStatus";
	m_sMapDataIDToKey[-9946] = "GameRoomTables";
	m_sMapDataIDToKey[-9945] = "GameMinVer";
	m_sMapDataIDToKey[-9944] = "GameMaxVer";
	m_sMapDataIDToKey[-9943] = "GameMinMembers";
	m_sMapDataIDToKey[-9942] = "GameMaxMembers";
	m_sMapDataIDToKey[-9941] = "GameDownPath";
	m_sMapDataIDToKey[-9940] = "GameExePath";
	m_sMapDataIDToKey[-9939] = "GameZones";
	m_sMapDataIDToKey[-9938] = "IconPath";
	m_sMapDataIDToKey[-9937] = "ConfigFile";
	m_sMapDataIDToKey[-9936] = "ExitType";
	m_sMapDataIDToKey[-9935] = "EnterType";
	m_sMapDataIDToKey[-9934] = "XLScorePerWin";
	m_sMapDataIDToKey[-9933] = "MaxLeiDou";
	m_sMapDataIDToKey[-9932] = "MinLeiDou";

	m_sMapDataIDToKey[-9929] = "ZoneID";
	m_sMapDataIDToKey[-9928] = "ZoneName";
	m_sMapDataIDToKey[-9927] = "ZoneStatus";
	m_sMapDataIDToKey[-9926] = "ZoneRooms";

	m_sMapDataIDToKey[-9919] = "RoomID";
	m_sMapDataIDToKey[-9918] = "RoomName";
	m_sMapDataIDToKey[-9917] = "RoomStatus";
	m_sMapDataIDToKey[-9916] = "RoomServer";
	m_sMapDataIDToKey[-9915] = "RoomPort";
	m_sMapDataIDToKey[-9914] = "RoomTables";
	m_sMapDataIDToKey[-9913] = "RoomBkServer";

	m_sMapDataIDToKey[-9909] = "TableID";
	m_sMapDataIDToKey[-9908] = "SeatID";
	m_sMapDataIDToKey[-9907] = "TablePwd";

	m_sMapDataIDToKey[-9899] = "ChatSeqNo";
	m_sMapDataIDToKey[-9898] = "ChatMsg";

	m_sMapDataIDToKey[-9889] = "SavedLogin";
	m_sMapDataIDToKey[-9888] = "UserList";
	m_sMapDataIDToKey[-9887] = "SavePwdFlag";

	m_sMapDataIDToKey[-9879] = "BossKey";
	m_sMapDataIDToKey[-9878] = "ServerAddr";
	m_sMapDataIDToKey[-9877] = "ServerPort";
	m_sMapDataIDToKey[-9876] = "CmdName";
	m_sMapDataIDToKey[-9875] = "CmdRespID";
	m_sMapDataIDToKey[-9874] = "CmdRespName";
	m_sMapDataIDToKey[-9873] = "CmdReqID";

	m_sMapDataIDToKey[-9869] = "HelpUrl";

	//gamesvr后台通用接口key
	m_sMapDataIDToKey[-9499] = "ToolClassID";
	m_sMapDataIDToKey[-9498] = "ToolBatchID";
	m_sMapDataIDToKey[-9497] = "ToolClassName";
	m_sMapDataIDToKey[-9496] = "ValidBeginTime";
	m_sMapDataIDToKey[-9495] = "ValidEndTime";
	m_sMapDataIDToKey[-9494] = "UsedTime";
	m_sMapDataIDToKey[-9493] = "Duration";
	m_sMapDataIDToKey[-9492] = "ChangeType";
	m_sMapDataIDToKey[-9491] = "ChangeValue";
	m_sMapDataIDToKey[-9490] = "Remains";
	m_sMapDataIDToKey[-9489] = "Amount";
	m_sMapDataIDToKey[-9488] = "Result";
	m_sMapDataIDToKey[-9487] = "Rate";
	m_sMapDataIDToKey[-9486] = "ToolsList";
	m_sMapDataIDToKey[-9485] = "MaxOfflineRate";
	m_sMapDataIDToKey[-9484] = "MaxNetspeed";
	m_sMapDataIDToKey[-9483] = "MinScoreThreshold";
	m_sMapDataIDToKey[-9482] = "MaxScoreGap";
	m_sMapDataIDToKey[-9481] = "IPBytesMax";
	m_sMapDataIDToKey[-9478] = "PeerID";
	m_sMapDataIDToKey[-9477] = "NewPoints";
	m_sMapDataIDToKey[-9476] = "UserDropNum";
	m_sMapDataIDToKey[-9475] = "TableKey";
	m_sMapDataIDToKey[-9474] = "CheckKey";
	m_sMapDataIDToKey[-9472] = "ActionData";
	m_sMapDataIDToKey[-9471] = "KickReason";
	m_sMapDataIDToKey[-9470] = "NextPingInterval";
	m_sMapDataIDToKey[-9469] = "IsExpired";
	m_sMapDataIDToKey[-9468] = "RemainTimeList";
	m_sMapDataIDToKey[-9467] = "RemainTime";
	m_sMapDataIDToKey[-9466] = "LevelName";
	m_sMapDataIDToKey[-9465] = "EmptySeatNum";
	m_sMapDataIDToKey[-9464] = "ActionType";
	m_sMapDataIDToKey[-9463] = "SeqNo";
	m_sMapDataIDToKey[-9462] = "RejectInvitation";
	m_sMapDataIDToKey[-9461] = "ExpChangeValue";
	m_sMapDataIDToKey[-9460] = "STAT";
	m_sMapDataIDToKey[-9459] = "NAME";
	m_sMapDataIDToKey[-9458] = "VALUE";
	m_sMapDataIDToKey[-9457] = "yshBean";

	m_sMapDataIDToKey[-9399] = "GameSvrIP";
	m_sMapDataIDToKey[-9398] = "GameSvrPort";

	m_sMapDataIDToKey[-9299] = "MagicToolIDList";
	m_sMapDataIDToKey[-9298] = "MagicToolInfoList";
	m_sMapDataIDToKey[-9297] = "FailReason";
	m_sMapDataIDToKey[-9296] = "CorpId";

	m_sMapDataIDToKey[-9289] = "PlayTime";
	m_sMapDataIDToKey[-9288] = "RowOffset";
	m_sMapDataIDToKey[-9287] = "RowCount";
	m_sMapDataIDToKey[-9286] = "PageSize";
	m_sMapDataIDToKey[-9285] = "PlayRecList";
	m_sMapDataIDToKey[-9284] = "MaxUsers";
	m_sMapDataIDToKey[-9283] = "GameDesc";
	m_sMapDataIDToKey[-9282] = "DeskMaxUsers";

	m_sMapDataIDToKey[-9269] = "GameIDList";
	m_sMapDataIDToKey[-9268] = "ToolName";
	m_sMapDataIDToKey[-9267] = "ToolDesc";
	m_sMapDataIDToKey[-9266] = "ToolType";
	m_sMapDataIDToKey[-9265] = "NormalPicUrl";
	m_sMapDataIDToKey[-9264] = "InvalidPicUrl";
	m_sMapDataIDToKey[-9263] = "ShowOnlineNum";
	m_sMapDataIDToKey[-9262] = "SpecialSkinUrl";
	m_sMapDataIDToKey[-9261] = "NormalPicUrlTiny";
	m_sMapDataIDToKey[-9260] = "InvalidPicUrlTiny";

	m_sMapDataIDToKey[-9258] = "StartType";
	m_sMapDataIDToKey[-9257] = "Channel";

	m_sMapDataIDToKey[-9249] = "Balance";
	m_sMapDataIDToKey[-9246] = "OldBalance";
	m_sMapDataIDToKey[-9245] = "NewBalance";
	m_sMapDataIDToKey[-9244] = "GlobalRank";
	m_sMapDataIDToKey[-9243] = "GlobalRankChg";
	m_sMapDataIDToKey[-9242] = "AreaRank";
	m_sMapDataIDToKey[-9241] = "AreaRankChg";
	m_sMapDataIDToKey[-9240] = "CityRank";

	m_sMapDataIDToKey[-9239] = "CityRankChg";
	m_sMapDataIDToKey[-9238] = "AcceptUserType";
	m_sMapDataIDToKey[-9237] = "AreaName";
	m_sMapDataIDToKey[-9236] = "CityName";
	m_sMapDataIDToKey[-9235] = "GameVer";
	m_sMapDataIDToKey[-9234] = "PingGap";
	m_sMapDataIDToKey[-9233] = "ValidTime";
	m_sMapDataIDToKey[-9232] = "XLVIPVipExpiredYear";
	m_sMapDataIDToKey[-9231] = "XLVIPVipExpiredMonth";
	m_sMapDataIDToKey[-9230] = "XLVIPVipExpiredDay";
	m_sMapDataIDToKey[-9229] = "yshMoney";
	m_sMapDataIDToKey[-9228] = "TotalUsers";
	m_sMapDataIDToKey[-9225] = "AchieveType";
	m_sMapDataIDToKey[-9226] = "AchieveValue";
	m_sMapDataIDToKey[-9227] = "AchieveRank";
	m_sMapDataIDToKey[-9224] = "AchieveDesc";

	m_sMapDataIDToKey[-9199] = "NetworkMonitor";
	m_sMapDataIDToKey[-9198] = "LimitType";

	m_sMapDataIDToKey[-9099] = "DirEncode";
	m_sMapDataIDToKey[-9098] = "ChooseType";
	m_sMapDataIDToKey[-9097] = "UserType";
	m_sMapDataIDToKey[-9096] = "FromWhere";
	m_sMapDataIDToKey[-9095] = "SkipRooms";
	m_sMapDataIDToKey[-9094] = "LeiDouLimit";
	m_sMapDataIDToKey[-9050] = "MatchID";
	m_sMapDataIDToKey[-9049] = "NewOrder";
	m_sMapDataIDToKey[-9048] = "ThisPoints";
	m_sMapDataIDToKey[-9047] = "NewMatchID";
	m_sMapDataIDToKey[-9046] = "BeginTime";
	m_sMapDataIDToKey[-9045] = "PlayStatus";
	m_sMapDataIDToKey[-9044] = "JoinNum";
	m_sMapDataIDToKey[-9043] = "LimitNum";
	m_sMapDataIDToKey[-9042] = "PlayingNum";
	m_sMapDataIDToKey[-9041] = "FeeNum";
	m_sMapDataIDToKey[-9040] = "UserOrder";
	m_sMapDataIDToKey[-9039] = "GameBase";
	m_sMapDataIDToKey[-9038] = "MatchStatus";
	m_sMapDataIDToKey[-9037] = "MatchTurn";
	m_sMapDataIDToKey[-9036] = "GameRound";
	m_sMapDataIDToKey[-9035] = "CompID";
	m_sMapDataIDToKey[-9034] = "MatchName";
	m_sMapDataIDToKey[-9033] = "FeeTool";
	m_sMapDataIDToKey[-9032] = "CompLevel";
	m_sMapDataIDToKey[-9031] = "InvateKey";
	m_sMapDataIDToKey[-9030] = "InvateResult";
	m_sMapDataIDToKey[-9025] = "MinNum";
	m_sMapDataIDToKey[-9024] = "MaxNum";
	m_sMapDataIDToKey[-9023] = "ExtraStatus";

	m_sMapDataIDToKey[-8950] = "ExampleID";
	m_sMapDataIDToKey[-8949] = "PreGameID";
	m_sMapDataIDToKey[-8948] = "PreZoneID";
	m_sMapDataIDToKey[-8947] = "PreRoomID";
	m_sMapDataIDToKey[-8946] = "PreMatchID";
	m_sMapDataIDToKey[-8945] = "MatchType";
	m_sMapDataIDToKey[-8944] = "WinNum";
	m_sMapDataIDToKey[-8943] = "NextInterval";
	m_sMapDataIDToKey[-8942] = "MatchNum";
	m_sMapDataIDToKey[-8941] = "ServerIP";
	m_sMapDataIDToKey[-8938] = "CheckSum";
	m_sMapDataIDToKey[-8937] = "OnlineNum";

	m_sMapDataIDToKey[-8899] = "CallBack";
	m_sMapDataIDToKey[-8898] = "BusinessNo";
	m_sMapDataIDToKey[-8897] = "BusinessSubNO";
	m_sMapDataIDToKey[-8896] = "BinData";
	m_sMapDataIDToKey[-8895] = "LastBinData";

	m_sMapDataIDToKey[-8879] = "ProID";
	m_sMapDataIDToKey[-8878] = "CurChip";
	m_sMapDataIDToKey[-8877] = "PlayedTurn";
	m_sMapDataIDToKey[-8876] = "LeftTurn";
	m_sMapDataIDToKey[-8875] = "Uploaded";
	m_sMapDataIDToKey[-8874] = "LeftUpload";
	m_sMapDataIDToKey[-8873] = "QueryType";
	m_sMapDataIDToKey[-8872] = "SumChip";
	m_sMapDataIDToKey[-8871] = "UploadTime";
}

int DataXImpl::EncodedLength()
{
//	LOG_DEBUG("Enter EncodedLength().");

	unsigned int nLength = sizeof(short) + sizeof(int); // magic_num + total_remain_bytes

	for(map<short, int>::iterator it = m_mapIndexes.begin(); it != m_mapIndexes.end(); it++)
	{
		unsigned short nKey = it->first;
		int nIndex = it->second;

		int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
		int nPos = GET_POS_FROM_DX_INDEX(nIndex);

		nLength += (sizeof(byte) + sizeof(short));  // nKey + nType
		
		switch(nType)
		{
		case DX_TYPE_SHORT:
			nLength += sizeof(short);

			break;
		case DX_TYPE_INT:
			nLength += sizeof(int);

			break;
		case DX_TYPE_INT64:
			nLength += sizeof(__int64);

			break;
		case DX_TYPE_BYTES:
		case DX_TYPE_UTF8STRING:
			nLength += CalcBytesItemLen(nPos);

			break;
		case DX_TYPE_WSTRING:
			nLength += CalcWStringItemLen(nPos);

			break;
		case DX_TYPE_DATAX:
			nLength += CalcDataXItemLen(nPos);

			break;
		case DX_TYPE_INTARRAY:
			nLength += CalcIntArrayItemLen(nPos);

			break;
		case DX_TYPE_DATAXARRAY:
			nLength += CalcDataXArrayItemLen(nPos);

			break;
		default:
			ysh_assert("Unknown DataX type" && false);
		}
	}

//	LOG_DEBUG("Exit EncodedLength().");

	return nLength;
}

/***********************************************************************************
* 将命令编码为buffer所指向内存上的二进制流
* buffer_size: [IN/OUT] 调用前为缓冲区的初始大小，调用后设置为编码后二进制流的长度
/**********************************************************************************/
void DataXImpl::Encode(byte* buffer, int &buffer_size)
{
//	LOG_DEBUG("Enter Encode().");

	FixedBuffer fixed_buffer((char*)buffer, buffer_size, true);

	fixed_buffer.put_short(DX_MAGIC_NUM);

	// remain bytes
	int nRemainBytesPos = fixed_buffer.position();
	fixed_buffer.skip(sizeof(int));

	int nStartPos = fixed_buffer.position();
	for(map<short, int>::iterator it = m_mapIndexes.begin(); it != m_mapIndexes.end(); it++)
	{
		short nKey = it->first;
		int nIndex = it->second;

		int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
		int nPos = GET_POS_FROM_DX_INDEX(nIndex);

		fixed_buffer.put_short(nKey);
		fixed_buffer.put_byte((byte)nType);
//		LOG_DEBUG("Key=" << nKey << ", Type=" << nType << ", remain_len=" << fixed_buffer.remain_len());

		switch(nType)
		{
		case DX_TYPE_SHORT:
			fixed_buffer.put_short((short)m_vecIntItems[nPos]);
			break;

		case DX_TYPE_INT:
			fixed_buffer.put_int(m_vecIntItems[nPos]);
			break;

		case DX_TYPE_INT64:
			fixed_buffer.put_int64(m_vecInt64Items[nPos]);
			break;

		case DX_TYPE_BYTES:
		case DX_TYPE_UTF8STRING:
			EncodeBytesItem(fixed_buffer, nPos);
			break;

		case DX_TYPE_WSTRING:
			EncodeWStringItem(fixed_buffer, nPos);
			break;

		case DX_TYPE_DATAX:
			EncodeDataXItem(fixed_buffer, nPos);
			break;

		case DX_TYPE_INTARRAY:
			EncodeIntArrayItem(fixed_buffer, nPos);
			break;

		case DX_TYPE_DATAXARRAY:
			EncodeDataXArrayItem(fixed_buffer, nPos);
			break;

		default:
			ysh_assert("Unknown DataX type" && false);
			
		}
	}

	int nEndPos = fixed_buffer.position();
	int nTotalBytes = nEndPos - nStartPos;
	fixed_buffer.set_position(nRemainBytesPos);
	fixed_buffer.put_int(nTotalBytes);

	fixed_buffer.set_position(nEndPos);

	buffer_size = nTotalBytes + sizeof(short) + sizeof(int);

//	LOG_DEBUG("Exit Encode().");
}

jobject DataXImpl::EncodeToBundle(JNIEnv *env)
{
	jclass clsBundle = env->FindClass("android/os/Bundle");
	jmethodID construct_method=env->GetMethodID(clsBundle, "<init>","()V");
	jobject objRet = env->NewObject( clsBundle, construct_method, "");

	jmethodID _putShort 	= env->GetMethodID(clsBundle, "putShort", "(Ljava/lang/String;S)V");
	jmethodID _putInt 		= env->GetMethodID(clsBundle, "putInt", "(Ljava/lang/String;I)V");
	jmethodID _putLong 		= env->GetMethodID(clsBundle, "putLong", "(Ljava/lang/String;J)V");
	jmethodID _putString 	= env->GetMethodID(clsBundle, "putString", "(Ljava/lang/String;Ljava/lang/String;)V");
	jmethodID _putBundle 	= env->GetMethodID(clsBundle, "putBundle", "(Ljava/lang/String;Landroid/os/Bundle;)V");
	jmethodID _putByteArray	= env->GetMethodID(clsBundle, "putByteArray", "(Ljava/lang/String;[B)V");

	for(map<short, int>::iterator it = m_mapIndexes.begin(); it != m_mapIndexes.end(); it++)
	{
		short nKey = it->first;
		int nIndex = it->second;

		int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
		int nPos = GET_POS_FROM_DX_INDEX(nIndex);

		string sKey = m_sMapDataIDToKey[nKey];
		string sTmp;
		IDataXNet* pDataX = NULL;
		jbyteArray bytes = NULL;

		switch(nType)
		{
		case DX_TYPE_SHORT:
			env->CallVoidMethod(objRet, _putShort,
					env->NewStringUTF(sKey.c_str()), (short)m_vecIntItems[nPos]);
			break;

		case DX_TYPE_INT:
			env->CallVoidMethod(objRet, _putInt,
					env->NewStringUTF(sKey.c_str()), m_vecIntItems[nPos]);
			break;

		case DX_TYPE_INT64:
			env->CallVoidMethod(objRet, _putLong,
					env->NewStringUTF(sKey.c_str()), (__int64)m_vecIntItems[nPos]);
			break;

		case DX_TYPE_BYTES:
		case DX_TYPE_UTF8STRING:
			sTmp = m_vecBytesItems[nPos];
			bytes = env->NewByteArray(sTmp.length()+1);
			env->SetByteArrayRegion(bytes, 0, sTmp.length()+1, (jbyte*)sTmp.c_str());
			env->CallVoidMethod(objRet, _putByteArray,
					env->NewStringUTF(sKey.c_str()), bytes);
			break;

		case DX_TYPE_WSTRING:
			sTmp = m_vecBytesItems[nPos];
			env->CallVoidMethod(objRet, _putString,
					env->NewStringUTF(sKey.c_str()), env->NewStringUTF(sTmp.c_str()));
			break;

		case DX_TYPE_DATAX:
			pDataX = m_vecDataXItems[nPos];
			if(pDataX != NULL)
			{
				jobject objSub = pDataX->EncodeToBundle(env);
				if(objSub)
				{
					env->CallVoidMethod(objRet, _putBundle,
							env->NewStringUTF(sKey.c_str()), objSub);
				}
			}
			break;

		case DX_TYPE_INTARRAY:
			// not support
			break;

		case DX_TYPE_DATAXARRAY:
			{
				vector<IDataXNet*>& vecTemp = m_vecDataXArrayItems[nPos];

				if(vecTemp.empty())
				{
					break;
				}

				jobject objArray = env->NewObject( clsBundle, construct_method, "");

				int nIdx = 0;
				for(vector<IDataXNet*>::iterator it = vecTemp.begin(); it != vecTemp.end(); it++, nIdx++)
				{
					IDataXNet* pDataXSub = *it;
					if(pDataXSub)
					{
						jobject objSub = pDataXSub->EncodeToBundle(env);
						if(objSub)
						{
							char szSubKey[32] = "";
							sprintf(szSubKey, "%d", nIdx);
							env->CallVoidMethod(objArray, _putBundle,
									env->NewStringUTF(szSubKey), objSub);
						}
					}
				}

				env->CallVoidMethod(objRet, _putBundle,
						env->NewStringUTF(sKey.c_str()), objArray);
			}
			break;

		default:
			ysh_assert("Unknown DataX type" && false);

		}
	}

	return objRet;
}

DataXImpl* DataXImpl::DecodeFrom(byte* pbBuffer, int& nBufferLen)
{
	if(nBufferLen < sizeof(short) + sizeof(int))
		return NULL;
	
	FixedBuffer fixed_buf_1((char*)pbBuffer, nBufferLen, true);
	short nMagicNum = fixed_buf_1.get_short();
	if(nMagicNum != DataXImpl::DX_MAGIC_NUM)
	{
		LOG_WARN("DataX magic number not match: " << nMagicNum);
		return NULL;
	}

	int nRemainBytes = fixed_buf_1.get_int();
	if(fixed_buf_1.remain_len() < nRemainBytes)
	{
		LOG_WARN("!! DataX bytes is " << nRemainBytes << ", but buffer remain bytes is " << fixed_buf_1.remain_len());
		return NULL;
	}

	DataXImpl* pDataX = new DataXImpl();
	FixedBuffer fixed_buffer((char*)(pbBuffer + sizeof(short) + sizeof(int)), nRemainBytes, true);

	const int MIN_ITEM_LENGTH = sizeof(short) + sizeof(byte) + sizeof(short);
	BOOL bDecodeOK = TRUE;
	while(fixed_buffer.remain_len() >= MIN_ITEM_LENGTH && bDecodeOK)
	{
		unsigned short nKey = (unsigned short)fixed_buffer.get_short();
		int nType = fixed_buffer.get_byte();

		BOOL bRet = TRUE;
		switch(nType)
		{
		case DX_TYPE_SHORT:
			pDataX->PutShort(nKey, fixed_buffer.get_short());

			break;
		case DX_TYPE_INT:
			pDataX->PutInt(nKey, fixed_buffer.get_int());

			break;
		case DX_TYPE_INT64:
			pDataX->PutInt64(nKey, fixed_buffer.get_int64());

			break;
		case DX_TYPE_BYTES:
			pDataX->PutBytesItem(nKey, fixed_buffer);

			break;

		case DX_TYPE_UTF8STRING:
			pDataX->PutUTF8BytesItem(nKey, fixed_buffer);

			break;
		case DX_TYPE_WSTRING:
			pDataX->PutWStringItem(nKey, fixed_buffer);

			break;
		case DX_TYPE_DATAX:
			bRet = pDataX->PutDataXItem(nKey, fixed_buffer);
			if(bRet == -2)
				bDecodeOK = FALSE;

			break;
		case DX_TYPE_INTARRAY:
			pDataX->PutIntArrayItem(nKey, fixed_buffer);

			break;
		case DX_TYPE_DATAXARRAY:
			bRet = pDataX->PutDataXArrayItem(nKey, fixed_buffer);
			if(bRet == -2)
				bDecodeOK = FALSE;

			break;
		default:
			ysh_assert("Unknown DataX type" && false);

		}

	}

	nBufferLen = nRemainBytes + sizeof(short) + sizeof(int);

	return pDataX;
}

// 将自己的内容完全复制一份
IDataXNet* DataXImpl::Clone()
{

	DataXImpl* pDataX = new DataXImpl();

	pDataX->m_mapIndexes = this->m_mapIndexes;

	pDataX->m_vecIntItems = this->m_vecIntItems;
	pDataX->m_vecInt64Items = this->m_vecInt64Items;
	pDataX->m_vecBytesItems = this->m_vecBytesItems;
	pDataX->m_vecWstrItems = this->m_vecWstrItems;

	for(int i = 0, size = m_vecDataXItems.size(); i < size; i++)
	{
		IDataXNet* pCopied = m_vecDataXItems[i]->Clone(); // NULL; 
		//HRESULT hr = m_vecDataXItems[i]->Clone(&pCopied); ysh_assert(SUCCEEDED(hr));
		pDataX->m_vecDataXItems.push_back(pCopied);
	}

	pDataX->m_vecIntArrayItems = this->m_vecIntArrayItems;

	for(int i = 0, size = m_vecDataXArrayItems.size(); i < size; i++)
	{
		vector<IDataXNet*> vecTemp;
		vector<IDataXNet*>& vecSrc = m_vecDataXArrayItems[i];
		for(int j = 0, nSize = vecSrc.size(); j < nSize; j++)
		{
			IDataXNet* pCopied = vecSrc[j]->Clone(); // NULL;
			//HRESULT hr = vecSrc[j]->Clone(&pCopied); ysh_assert(SUCCEEDED(hr));
			vecTemp.push_back(pCopied);
		}
		pDataX->m_vecDataXArrayItems.push_back(vecTemp);
	}


	return pDataX;
}

// 将已有的数据清空
void DataXImpl::Clear()
{
	m_mapIndexes.clear();

	m_vecIntItems.clear();
	m_vecInt64Items.clear();
	m_vecBytesItems.clear();
	m_vecWstrItems.clear();

	for(int i = 0; i < (int)m_vecDataXItems.size(); i++)
	{
		IDataXNet* pDataX = m_vecDataXItems[i];
		delete pDataX; // pDataX->Release();
	}
	m_vecDataXItems.clear();

	m_vecIntArrayItems.clear();

	for(int i = 0; i < (int)m_vecDataXArrayItems.size(); i++)
	{
		vector<IDataXNet*>& vecDataX = m_vecDataXArrayItems[i];
		for(int j = 0; j < (int)vecDataX.size(); j++)
		{
			IDataXNet* pDataX = vecDataX[j];
			delete pDataX; // pDataX->Release();
		}
		vecDataX.clear();
	}
	m_vecDataXArrayItems.clear();
}

// 返回元素数量
int DataXImpl::GetSize()
{
	return (int)m_mapIndexes.size();
}


// 添加Short类型数据
bool DataXImpl::PutShort(short nKeyID, short nData)
{
	if(m_mapIndexes.find(nKeyID) != m_mapIndexes.end())
	{
		return ModifyShort(nKeyID, nData);
	}

	m_vecIntItems.push_back(nData);
	int nSize = (int)m_vecIntItems.size();
	int nIndex = nSize - 1;

	m_mapIndexes[nKeyID] = MAKE_DATAX_INDEX(DX_TYPE_SHORT, nIndex);

	return true;
}

// 添加Int类型数据
bool DataXImpl::PutInt(short nKeyID, int nData)
{
	if(m_mapIndexes.find(nKeyID) != m_mapIndexes.end())
	{
		return ModifyInt(nKeyID, nData);
	}

	m_vecIntItems.push_back(nData);
	int nSize = (int)m_vecIntItems.size();
	int nIndex = nSize - 1;

	m_mapIndexes[nKeyID] = MAKE_DATAX_INDEX(DX_TYPE_INT, nIndex);

	return true;
}

// 添加64位整型数据
bool DataXImpl::PutInt64(short nKeyID, __int64 nData)
{
	if(m_mapIndexes.find(nKeyID) != m_mapIndexes.end())
	{
		return ModifyInt64(nKeyID, nData);
	}

	m_vecInt64Items.push_back(nData);
	int nSize = (int)m_vecInt64Items.size();
	int nIndex = nSize - 1;

	m_mapIndexes[nKeyID] = MAKE_DATAX_INDEX(DX_TYPE_INT64, nIndex);

	return true;
}

// 添加字节数组的内容
bool DataXImpl::PutBytes(short nKeyID, const byte* pbData, int nDataLen)
{
	if(m_mapIndexes.find(nKeyID) != m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	if(pbData == NULL)
	{
		// TODO: add log
		return false;
	}
	if(nDataLen <= 0 || nDataLen > 65535)
	{
		// TODO: add log
		return false;
	}

	string strData;
	strData.assign((char*)pbData, nDataLen);

	m_vecBytesItems.push_back(strData);
	int nSize = (int)m_vecBytesItems.size();
	int nIndex = nSize - 1;

	m_mapIndexes[nKeyID] = MAKE_DATAX_INDEX(DX_TYPE_BYTES, nIndex);

	return true;
}

// 添加宽字节字符串
bool DataXImpl::PutWString(short nKeyID, LPCWSTR pwszData, int nStringLen)
{
	if(m_mapIndexes.find(nKeyID) != m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	if(pwszData == NULL)
	{
		// TODO: add log
		return false;
	}
	if(nStringLen <= 0 || nStringLen > 65535)
	{
		// TODO: add log
		return false;
	}

	std::wstring strData;
	strData.assign((wchar_t*)pwszData, nStringLen);

	m_vecWstrItems.push_back(strData);
	int nSize = (int)m_vecWstrItems.size();
	int nIndex = nSize - 1;

	m_mapIndexes[nKeyID] = MAKE_DATAX_INDEX(DX_TYPE_WSTRING, nIndex);

	return true;
}

// 嵌入IDataXNet内容
bool DataXImpl::PutDataX(short nKeyID, IDataXNet* pDataCmd)
{
	if(pDataCmd == NULL)
		return false;
	if(m_mapIndexes.find(nKeyID) != m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	if(pDataCmd == NULL)
	{
		// TODO: add log
		return false;
	}
	
	//pDataCmd->AddRef();
	IDataXNet* pCopied = pDataCmd->Clone();
	m_vecDataXItems.push_back(pCopied);
	int nSize = (int)m_vecDataXItems.size();
	int nIndex = nSize - 1;

	m_mapIndexes[nKeyID] = MAKE_DATAX_INDEX(DX_TYPE_DATAX, nIndex);

	return true;
}

// 添加Int数组的内容
bool DataXImpl::PutIntArray(short nKeyID, int* pnData, int nElements)
{
	if(m_mapIndexes.find(nKeyID) != m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	if(pnData == NULL)
	{
		// TODO: add log
		return false;
	}
	if(nElements <= 0 || nElements > 65535)
	{
		// TODO: add log
		return false;
	}

	vector<int> vecDatas;
	vecDatas.assign(pnData, pnData + nElements);

	m_vecIntArrayItems.push_back(vecDatas);
	int nSize = (int)m_vecIntArrayItems.size();
	int nIndex = nSize - 1;

	m_mapIndexes[nKeyID] = MAKE_DATAX_INDEX(DX_TYPE_INTARRAY, nIndex);

	return true;
}

// 添加IDataXNet数组
bool DataXImpl::PutDataXArray(short nKeyID, IDataXNet** ppDataCmd, int nElements)
{
	return PutDataXArray_Impl(nKeyID, ppDataCmd, nElements);
}

bool DataXImpl::PutDataXArray_Impl(short nKeyID, IDataXNet** ppDataCmd, int nElements, bool bGiveupDxOwnership)
{
	if(m_mapIndexes.find(nKeyID) != m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	if(ppDataCmd == NULL)
	{
		// TODO: add log
		return false;
	}
	if(nElements <= 0 || nElements > 65535)
	{
		// TODO: add log
		return false;
	}

	vector<IDataXNet*> vecDataXs;
	vecDataXs.reserve(nElements);
	for(int i = 0; i < nElements; i++)
	{
		IDataXNet* pCopied = bGiveupDxOwnership ? ppDataCmd[i] : ppDataCmd[i]->Clone(); // ppDataCmd[i]->AddRef();
		vecDataXs.push_back(pCopied);
	}

	m_vecDataXArrayItems.push_back(vecDataXs);
	int nSize = (int)m_vecDataXArrayItems.size();
	int nIndex = nSize - 1;

	m_mapIndexes[nKeyID] = MAKE_DATAX_INDEX(DX_TYPE_DATAXARRAY, nIndex);

	return true;
}

bool DataXImpl::PutUTF8String(short nKeyID, const byte* pbData, int nDataLen)
{
	if(m_mapIndexes.find(nKeyID) != m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	if(pbData == NULL)
	{
		// TODO: add log
		return false;
	}
	if(nDataLen <= 0 || nDataLen > 65535)
	{
		// TODO: add log
		return false;
	}

	string strData;
	strData.assign((char*)pbData, nDataLen);

	m_vecBytesItems.push_back(strData);
	int nSize = (int)m_vecBytesItems.size();
	int nIndex = nSize - 1;

	m_mapIndexes[nKeyID] = MAKE_DATAX_INDEX(DX_TYPE_UTF8STRING, nIndex);

	return true;
}


// 获取Short类型数据
bool DataXImpl::GetShort(short nKeyID, short& nData)
{
	nData = 0;
	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_SHORT || nType == DX_TYPE_INT))
	{
		LOG_WARN("Data type not match for Key(" << nKeyID << ") when GetShort() called, type=" << nType);
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecIntItems.size())
	{
		nData = (short)m_vecIntItems[nPos];
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

bool DataXImpl::ModifyShort(short nKeyID, short nData)
{
	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		return false;
	}
	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_SHORT || nType == DX_TYPE_INT))
	{
		LOG_WARN("Data type not match for Key(" << nKeyID << ") when ModifyShort() called");
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecIntItems.size())
	{
		m_vecIntItems[nPos] = nData;
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

bool DataXImpl::ModifyInt(short nKeyID, int nData)
{
	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		return false;
	}
	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_SHORT || nType == DX_TYPE_INT))
	{
		LOG_WARN("Data type not match for Key(" << nKeyID << ") when ModifyInt() called");
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecIntItems.size())
	{
		m_vecIntItems[nPos] = nData;
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

bool DataXImpl::ModifyInt64(short nKeyID, __int64 nData)
{
	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		return false;
	}
	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_INT64))
	{
		LOG_WARN("Data type not match for Key(" << nKeyID << ") when ModifyShort() called");
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecInt64Items.size())
	{
		m_vecInt64Items[nPos] = nData;
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

bool DataXImpl::ModifyBytes(short nKeyID, const byte* pbData, int nDataLen)
{
	ysh_assert("ModifyBytes() not implemented" && false);
	return false;
}

bool DataXImpl::ModifyUTF8String(short nKeyID, const byte* pbData, int nDataLen)
{
	ysh_assert("ModifyUTF8String() not implemented" && false);
	return false;
}


// 获取Int类型数据
bool DataXImpl::GetInt(short nKeyID, int& nData)
{
	nData = 0;
	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_SHORT || nType == DX_TYPE_INT))
	{
		// TODO: add log (type mismatch)
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecIntItems.size())
	{
		nData = m_vecIntItems[nPos];
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

// 获取64位整型数据
bool DataXImpl::GetInt64(short nKeyID, __int64& nData) 
{
	nData = 0;
	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_INT64))
	{
		// TODO: add log (type mismatch)
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecInt64Items.size())
	{
		nData = m_vecInt64Items[nPos];
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

// 获取字节数组(如果pbDataBuf为NULL, 则会在nBufferLen设置该字节数组内容的实际长度)
bool DataXImpl::GetBytes(short nKeyID, byte* pbDataBuf, int& nBufferLen)
{
	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_BYTES))
	{
		// TODO: add log (type mismatch)
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecBytesItems.size())
	{
		string& strData = m_vecBytesItems[nPos];
		if(pbDataBuf == NULL)
		{
			nBufferLen = (int)strData.length();
		}
		else
		{
			if(nBufferLen < (int)strData.length())
			{
				//TODO: add log (buffer not enough)
				return false;
			}
			memcpy(pbDataBuf, strData.c_str(), strData.length());
			nBufferLen = (int)strData.length();
		}
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

// 获取宽字节字符串(如果pwszDataBuf为NULL, 则会在nStringLen设置该字符串的实际长度)
bool DataXImpl::GetWString(short nKeyID, LPWSTR pwszDataBuf, int& nStringLen) 
{
	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_WSTRING))
	{
		// TODO: add log (type mismatch)
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecWstrItems.size())
	{
		std::wstring& strData = m_vecWstrItems[nPos];
		if(pwszDataBuf == NULL)
		{
			nStringLen = (int)strData.length();
		}
		else
		{
			if(nStringLen < (int)strData.length())
			{
				//TODO: add log (buffer not enough)
				return false;
			}
			memcpy(pwszDataBuf, strData.c_str(), strData.length() * sizeof(wchar_t));
			nStringLen = (int)strData.length();
		}
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

// 获取嵌入在里面的IDataXNet
bool DataXImpl::GetDataX(short nKeyID, IDataXNet** ppDataCmd)
{
	if(ppDataCmd == NULL)
	{
		return false;
	}

	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_DATAX))
	{
		// TODO: add log (type mismatch)
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecDataXItems.size())
	{
		*ppDataCmd = m_vecDataXItems[nPos]->Clone();;
		//(*ppDataCmd)->AddRef();
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

// 获取整型数组的元素数量
bool DataXImpl::GetIntArraySize(short nKeyID, int& nSize)
{
	nSize = 0;

	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_INTARRAY))
	{
		// TODO: add log (type mismatch)
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecIntArrayItems.size())
	{
		vector<int>& vecTemp = m_vecIntArrayItems[nPos];
		nSize = (int)vecTemp.size();
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

// 获取整型数组的某个元素（根据索引编号）
bool DataXImpl::GetIntArrayElement(short nKeyID, int nIndex, int& nData)
{
	nData = 0;

	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	int nMyIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nMyIndex);
	if(!(nType == DX_TYPE_INTARRAY))
	{
		// TODO: add log (type mismatch)
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nMyIndex);
	if(nPos >= 0 && nPos < (int)m_vecIntArrayItems.size())
	{
		vector<int>& vecTemp = m_vecIntArrayItems[nPos];
		if(nIndex >= 0 && nIndex < (int)vecTemp.size())
		{
			nData = vecTemp[nIndex];
		}
		else
		{
			return false;
		}
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

// 获取IDataXNet数组的元素数量
bool DataXImpl::GetDataXArraySize(short nKeyID, int& nSize)
{
	nSize = 0;

	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_DATAXARRAY))
	{
		// TODO: add log (type mismatch)
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecDataXArrayItems.size())
	{
		vector<IDataXNet*>& vecTemp = m_vecDataXArrayItems[nPos];
		nSize = (int)vecTemp.size();
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

// 获取IDataXNet数组的某个元素（根据索引编号）
bool DataXImpl::GetDataXArrayElement(short nKeyID, int nIndex, IDataXNet** ppDataCmd)
{
	if(ppDataCmd == NULL)
	{
		return false;
	}

	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		// TODO: add log
		return false;
	}

	int nMyIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nMyIndex);
	if(!(nType == DX_TYPE_DATAXARRAY))
	{
		// TODO: add log (type mismatch)
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nMyIndex);
	if(nPos >= 0 && nPos < (int)m_vecDataXArrayItems.size())
	{
		vector<IDataXNet*>& vecTemp = m_vecDataXArrayItems[nPos];
		if(nIndex >= 0 && nIndex < (int)vecTemp.size())
		{
			*ppDataCmd = vecTemp[nIndex]->Clone();
			//(*ppDataCmd)->AddRef();
		}
		else
		{
			return false;
		}
	}
	else
	{
		//TODO: add log (index out of range)
		return false;
	}

	return true;
}

bool DataXImpl::GetUTF8String(short nKeyID, byte* pbDataBuf, int& nBufferLen)
{
	LOG_DEBUG("GetUTF8String() called, nKeyID=" << nKeyID);

	map<short, int>::iterator it = m_mapIndexes.find(nKeyID);
	if(it == m_mapIndexes.end())
	{
		LOG_DEBUG("GetUTF8String(): can not find item by keyID=" << nKeyID);
		return false;
	}

	int nIndex = it->second;
	int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
	if(!(nType == DX_TYPE_UTF8STRING))
	{
		LOG_DEBUG("GetUTF8String(): matched item type not UTF8String:" << nType);
		return false;
	}
	int nPos = GET_POS_FROM_DX_INDEX(nIndex);
	if(nPos >= 0 && nPos < (int)m_vecBytesItems.size())
	{
		string& strData = m_vecBytesItems[nPos];
		if(pbDataBuf == NULL)
		{
			nBufferLen = (int)strData.length();
		}
		else
		{
			if(nBufferLen < (int)strData.length())
			{
				//TODO: add log (buffer not enough)
				return false;
			}
			memcpy(pbDataBuf, strData.c_str(), strData.length());
			nBufferLen = (int)strData.length();
		}
	}
	else
	{
		//TODO: add log (index out of range)
		LOG_DEBUG("GetUTF8String(): index of out of range.");
		return false;
	}

	return true;
}

void DataXImpl::EncodeBytesItem(FixedBuffer& fixed_buffer, int nPos)
{
	string& str = m_vecBytesItems[nPos];
	fixed_buffer.put_string(str);
}

void DataXImpl::EncodeWStringItem(FixedBuffer& fixed_buffer, int nPos)
{
	std::wstring& str = m_vecWstrItems[nPos];

	fixed_buffer.put_int((int)str.length());
	fixed_buffer.put_bytes((byte*)str.c_str(), (int)(str.length() * sizeof(WCHAR)));
}

void DataXImpl::EncodeDataXItem(FixedBuffer& fixed_buffer, int nPos)
{
	IDataXNet* pDataX = m_vecDataXItems[nPos];
	if(pDataX != NULL)
	{
		int nBufferPos = fixed_buffer.position();
		char* pBuffer = fixed_buffer.get_realbuffer() + nBufferPos;
		unsigned nBuffer = fixed_buffer.remain_len();
		int nBuffSize = (int)nBuffer;
		pDataX->Encode((byte*)pBuffer, nBuffSize);

		fixed_buffer.skip(nBuffer);
		int nBufferPos2 = fixed_buffer.position();
	}
}

void DataXImpl::EncodeIntArrayItem(FixedBuffer& fixed_buffer, int nPos)
{
	vector<int>& vecTemp = m_vecIntArrayItems[nPos];
	fixed_buffer.put_int((int)vecTemp.size());

	for(vector<int>::iterator it = vecTemp.begin(); it != vecTemp.end(); it++)
	{
		fixed_buffer.put_int(*it);
	}
}

void DataXImpl::EncodeDataXArrayItem(FixedBuffer& fixed_buffer, int nPos)
{

	vector<IDataXNet*>& vecTemp = m_vecDataXArrayItems[nPos];
	fixed_buffer.put_int((int)vecTemp.size());

	int nIdx = 0;
	for(vector<IDataXNet*>::iterator it = vecTemp.begin(); it != vecTemp.end(); it++, nIdx++)
	{
		IDataXNet* pDataX = *it;
		
		char* pBuffer = fixed_buffer.get_realbuffer() + fixed_buffer.position();
		unsigned nBuffer = fixed_buffer.remain_len();

		int nBuffSize = (int)nBuffer;
		pDataX->Encode((byte*)pBuffer, nBuffSize);

		fixed_buffer.skip(nBuffSize);
	}	
}

unsigned DataXImpl::CalcIntArrayItemLen(int nPos)
{
	unsigned nLen = 0;

	vector<int>& vecTemp = m_vecIntArrayItems[nPos];
	nLen += sizeof(int); // # of elements

	nLen += (sizeof(int) * vecTemp.size());

	return nLen;
}

unsigned DataXImpl::CalcDataXArrayItemLen( int nPos)
{
	vector<IDataXNet*>& vecTemp = m_vecDataXArrayItems[nPos];
	unsigned nLen = sizeof(int);

	for(vector<IDataXNet*>::iterator it = vecTemp.begin(); it != vecTemp.end(); it++)
	{
		IDataXNet* pDataX = *it;
		
		long nEncodedLen = pDataX->EncodedLength();
		//HRESULT hr = pDataX->EncodedLength(&nEncodedLen); ysh_assert(SUCCEEDED(hr));
		nLen += nEncodedLen;
	}	

	return nLen;
}

BOOL DataXImpl::PutBytesItem(unsigned short nKeyID, FixedBuffer& fixed_buffer)
{
	string str = fixed_buffer.get_string();
	return PutBytes(nKeyID, (byte*)str.c_str(), (int)str.length());
}

BOOL DataXImpl::PutUTF8BytesItem(unsigned short nKeyID, FixedBuffer& fixed_buffer)
{
	string str = fixed_buffer.get_string();
	return PutUTF8String(nKeyID, (byte*)str.c_str(), (int)str.length());
}

BOOL DataXImpl::PutWStringItem(unsigned short nKeyID, FixedBuffer& fixed_buffer)
{
	int nStringLen = fixed_buffer.get_int();
	WCHAR* pwszBuffer = new WCHAR[nStringLen];
	fixed_buffer.get_bytes((byte*)pwszBuffer, nStringLen * sizeof(WCHAR));

	bool bRet = PutWString(nKeyID, pwszBuffer, nStringLen);
	delete []pwszBuffer;

	return bRet;
}

BOOL DataXImpl::PutDataXItem(unsigned short nKeyID, FixedBuffer& fixed_buffer)
{
	char* pBuffer = fixed_buffer.get_realbuffer() + fixed_buffer.position();
	int nBufferLen = fixed_buffer.remain_len();

	DataXImpl* pDataImpl = DataXImpl::DecodeFrom((byte*)pBuffer, nBufferLen);

//	CComObject<CXLDataXFull>* pObject = NULL;
//	HRESULT hr = CComObject<CXLDataXFull>::CreateInstance(&pObject); ysh_assert(SUCCEEDED(hr));
//	pObject->AttachDataXImpl(pDataImpl);

//	CComPtr<IDataXNet> pDataX;
//	hr = pObject->QueryInterface( __uuidof(IDataXNet), (void**)&pDataX ); ysh_assert(SUCCEEDED(hr));  
//	pObject->Release();

	if(pDataImpl)
	{
		fixed_buffer.skip(nBufferLen);
		BOOL bRet = PutDataX(nKeyID, pDataImpl);
		delete pDataImpl;
		return bRet;
	}
	else
		return -2;  // Decode failure!!
}

BOOL DataXImpl::PutIntArrayItem(unsigned short nKeyID, FixedBuffer& fixed_buffer)
{
	int nElements = fixed_buffer.get_int();
	vector<int> vecTemp;
	vecTemp.reserve(nElements);
	for(int i = 0; i < nElements; i++)
	{
		int nTemp = fixed_buffer.get_int();
		vecTemp.push_back(nTemp);
	}

	return PutIntArray(nKeyID, &vecTemp[0], nElements);
}

BOOL DataXImpl::PutDataXArrayItem(unsigned short nKeyID, FixedBuffer& fixed_buffer)
{

	vector<IDataXNet*> vecTemp;
	int nElements = fixed_buffer.get_int();
	vecTemp.reserve(nElements);

	for(int i = 0; i < nElements; i++)
	{
		char* pBuffer = fixed_buffer.get_realbuffer() + fixed_buffer.position();
		int nBuffer = fixed_buffer.remain_len();

		DataXImpl* pDataImpl = DataXImpl::DecodeFrom((byte*)pBuffer, nBuffer);

//		CComObject<CXLDataXFull>* pObject = NULL;
//		HRESULT hr = CComObject<CXLDataXFull>::CreateInstance(&pObject); ysh_assert(SUCCEEDED(hr));
//		pObject->AttachDataXImpl(pDataImpl);

//		CComPtr<IDataXNet> pDataX;
//		hr = pObject->QueryInterface( __uuidof(IDataXNet), (void**)&pDataX ); ysh_assert(SUCCEEDED(hr));  
//		pObject->Release();

		if(pDataImpl == NULL)
			return -2;
		fixed_buffer.skip(nBuffer);

		vecTemp.push_back(pDataImpl);
//		delete pDataImpl;
	}	

	return PutDataXArray_Impl(nKeyID, &vecTemp[0], nElements, true);
}

string DataXImpl::ToString()
{
//	LOG_DEBUG("ToString() called.");

	std::strstream sTmp;
	sTmp << "[";
	for(map<short, int>::iterator it = m_mapIndexes.begin(); it != m_mapIndexes.end(); it++)
	{
		short nKey = it->first;
		int nIndex = it->second;

		int nType = GET_TYPE_FROM_DX_INDEX(nIndex);
		int nPos = GET_POS_FROM_DX_INDEX(nIndex);

		switch(nType)
		{
		case DX_TYPE_SHORT:
		case DX_TYPE_INT:
			{
				sTmp << "(" << nKey << "=" << (m_vecIntItems[nPos]) << ")";
				break;
			}

		case DX_TYPE_INT64:
			{
				sTmp << "(" << nKey << "=" << m_vecInt64Items[nPos] << ")";
				break;
			}
		case DX_TYPE_BYTES:
			{
				sTmp<<"(str:"<< nKey <<"="
					<< utility::ch2str((byte*)m_vecBytesItems[nPos].c_str(), m_vecBytesItems[nPos].length()) << ")";
				break;
			}
		case DX_TYPE_UTF8STRING:
			{
				sTmp<<"(UTF8:"<< nKey <<"="
					<< utility::ch2str((byte*)m_vecBytesItems[nPos].c_str(), m_vecBytesItems[nPos].length()) << ")";
				break;
			}

		case DX_TYPE_WSTRING:
			{
				sTmp<<"("<< nKey <<"="
					<< utility::ch2str((unsigned char*)(m_vecWstrItems[nPos].c_str()), m_vecWstrItems[nPos].length()*sizeof(WCHAR))<<")";
				break;
			}

		case DX_TYPE_DATAX:
			{
				sTmp << "(" << nKey << "=" << (m_vecDataXItems[nPos]->ToString()) << ")";
				break;
			}
		case DX_TYPE_INTARRAY:
			{
				sTmp<<"[Unknow Type]";
				break;
			}
		case DX_TYPE_DATAXARRAY:
			{
				sTmp<<"("<< nKey <<"=[";
				vector<IDataXNet*>& vTmpDataX =  m_vecDataXArrayItems[nPos];
				for (vector<IDataXNet*>::iterator it=vTmpDataX.begin(); it != vTmpDataX.end(); it++)
				{
					sTmp<<(*it)->ToString()<<",";
				}
				sTmp<<"])";
				break;
			}
		default:
			{
				LOG_WARN("Unknown DataX type: " << nType);
			}
		}
	}
	sTmp<<"]"<<'\0';

	return sTmp.str();
}
