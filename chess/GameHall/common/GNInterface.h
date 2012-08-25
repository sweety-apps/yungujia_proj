/********************************************************************************************************
*
* GameNet是游戏客户端和服务器进行交互的通讯组件
*
* 客户端的基本使用场景是：用户先进入游戏大厅，选择一款游戏（选择房间和桌子）后才进入具体的游戏。
* 由于客户端同时有两个进程（大厅、具体的某游戏）运行，为了更有效和服务端通讯，同时也为了减少服务端的压力，
* 我们使用单连接的方式：只有大厅和服务器建立通讯连接，游戏进程和服务端的通讯，是通过COM代理的方式进行的。
*
* GameNet封装了和服务端的基本交互，也封装了COM代理的实现细节
* （也就是说在大厅和在游戏进程，使用GameNet的方式基本一致）。
*
* GameNet与服务端的交互是异步方式：向服务端发送一个请求后，马上返回；当收到了服务端发送的完整响应数据
* （或其它通知），GameNet会通过调用事件通知接口(IGameNetEvent或ISessionCallback)来通知调用方；
* 事件回调接口，是在界面线程中执行的；因此调用方不用做线程互斥(或线程切换)的处理。
*
*********************************************************************************************************/



#ifndef __GN_INTERFACE_H_20090216_24
#define __GN_INTERFACE_H_20090216_24

class IGameNet;
class IGameCommand;
class IGameNetCallback;
class ISessionConnection;
class ISessionCallbackCore;
class ISessionCallback;
class IGameNetEvent;
class IGameUtility;
class IDataXNet;

#include <string>
#include <map>
#include <vector>
#include <jni.h>
#include "GameNetTypes.h"

using std::string;
using std::map;
using std::vector;

enum GN_INSTANCE_TYPE
{
	GN_INSTANCE_REAL = 13,
	GN_INSTANCE_AGENT = 29
};

enum GN_CONN_TYPE
{
	GN_CONN_UNKNOWN = 0,
	GN_CONN_USER_STATE = 1,
	GN_CONN_BALANCE = 2,
	GN_CONN_USER_GUIDE = 3,
	GN_CONN_TAB_STATE = 4,
	GN_CONN_STAT = 5,
	GN_CONN_USER = 6,
	GN_CONN_CHIP = 20,

	GN_CONN_DIR = 100,
	GN_CONN_ONLINE_DIR = 101,
	GN_CONN_QUERY_ROOM = 102,
};

// 功能：创建IGameNet实例
// 参数：instanceType: 大厅应该传GN_INSTANCE_REAL, 游戏进程应该传GN_INSTANCE_AGENT
//       pvParam:      保留参数，目前应传NULL
IGameNet* GetGameNetInstance(GN_INSTANCE_TYPE instanceType, void* pvParam);

// 设置用户信息(主要是UserID)
//   由于所有的命令都含有UserID字段，因此通过此接口设置一次即可；
//   注意：在第一次交互前应调用此接口!!
void SetUserInfo(XLUSERID nUserID, const char* pszUsername);

// 功能：创建IGameUtility实例
IGameUtility* GetGameUtilityInstance();

// 返回GameNet组件内部版本号(便于调用方进行版本兼容处理)
BOOL GetGameNetVersion(UINT16* pnMajorVer, UINT16* pnMinerVer);


// 数据通讯抽象类
// （通过GetGameNetInstance()得到实际的实例）
class IGameNet
{
public:
	virtual ~IGameNet() { }

	// 设置事件回调接口(短连接的通讯)
	virtual BOOL InitEvent(IGameNetEvent* pCallback) = 0;

	// 查询用户积分等游戏相关的信息
	virtual BOOL QueryUserGameInfo(const char* server_addr, unsigned short server_port, XLUSERID nUserID) = 0;

	// 为某个session连接(根据nConnID)上注册事件回调接口； 游戏进程可调用此接口，大厅进程不能调用
	// (大厅应该通过某种机制，将当前房间的session连接ID，传给游戏进程)
	virtual ISessionConnection* RegisterSessionEvent(int nConnID,ISessionCallback* pCallback) = 0;

	// 关闭(当不再使用通讯功能时，一般在进程退出前，可调用此接口)
	virtual void Close() = 0;

	// 提交基于IDataX的通用命令请求到指定的服务器 (注意: pDataX由GameNet来释放!)
	virtual BOOL SubmitDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSrcID = CMD_FROM_GAMEHALL) = 0;

    // 提交基于IDataX的通用命令请求到雷豆服务器
    virtual BOOL SubmitBalanceDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSrcID = CMD_FROM_GAMEHALL) = 0;

	// 提交基于IDataX的通用命令请求到指定服务器
	virtual BOOL SubmitDataXReqSpec(int nSvrType, const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSrcID = CMD_FROM_GAMEHALL) = 0;

	// 提交基于IDataX的通用命令请求到指定服务器
	virtual BOOL SubmitFlexDataXReq(const char* server_addr, unsigned short server_port, const LONG nCmdReqID, const char* cmdReqName, const LONG nCmdRespID, const char* cmdRespName, IDataXNet* pDataX, int nCmdSrcID = CMD_FROM_GAMEHALL) = 0;
};

// 工具类
class IGameUtility
{
public:
	virtual ~IGameUtility() { }

	// 对二进制数据进行解码，反序列化为一个IGameCommand对象
	// 如果解码失败，则返回NULL; 
	// 注意：返回成功的IGameCommand指针，由调用者负责释放!!
	virtual IGameCommand* DecodeCmd(const char* pDataBuf, int nDataLen) = 0;

	// 判断pCmd是否为nTableID对应游戏桌感兴趣的命令
	// (大厅根据此结果来决定是否需要向游戏桌转发该命令)
	virtual BOOL IsGameTableAcceptCmd(IGameCommand* pCmd, int nTableID) = 0;

	// 结构转换
	//virtual BOOL PlayerInfo2Rec(const XLPLAYERINFO * pInfo, XLPLAYERREC * pRec) = 0;
	//virtual BOOL PlayerRec2Info(const XLPLAYERREC * pRec, XLPLAYERINFO * pInfo) = 0;

    //virtual BOOL PlayerInfo2RecEx(const XLPLAYERINFOEX * pInfo, XLPLAYERREC * pRec) = 0;
    //virtual BOOL PlayerRec2InfoEx(const XLPLAYERREC * pRec, XLPLAYERINFOEX * pInfo) = 0;

	// IDataX转换的相关接口
	// --------------------------
	// 创建一个空的IDataXNet对象
	virtual IDataXNet* CreateDataX() = 0;
	// 释放IDataXNet对象
	virtual void DeleteDataX(IDataXNet* pDataX) = 0;

	virtual IDataXNet* DecodeDataX(const char* pDataBuf, int nDataLen) = 0;
	//virtual BOOL DataXToVariant(IDataXNet* pDataX, VARIANT& vData) = 0;

	virtual IDataXNet* QueryCommandStatus(IGameCommand* pCmd, const char* pszQueryStr) = 0;

	virtual string GetPeerID() = 0;
	virtual IGameCommand* CreateNonSessionDataXCmd(const char* cmdName, IDataXNet* pDataX, int nCmdSrcID) = 0;
	virtual BOOL GetPeerID2(char* pszBuffer, int& nBufferLen) = 0;

	//virtual BOOL StartLocalHttpServer() = 0;
	//virtual BOOL GetLocalHttpServerURL(char* pszBuffer, int& nBufferLen) = 0;
	//virtual void CloseLocalHttpServer() = 0;
};

// 数据通讯的回调接口(只对短连接的通讯；Session连接的回调通过ISessionCallback)
class IGameNetEvent
{
public:
	virtual ~IGameNetEvent() { }

	// 用户信息查询成功后的响应(nResult=0表明成功)
	virtual void OnQueryUserInfoResp(int nResult, XLUSERID nUserID, const vector<XLUSERGAMEINFO>& userGamesInfo) = 0;

	// 查询过程中发生了网络错误
	virtual void OnNetworkError(int nErrorCode) = 0;

	// 接收到基于IDataX通用命令的回复包
	virtual void OnRecvDataXResp(int /*nResult*/, const char* /*cmdName*/, IDataXNet* /*pDataX*/) { }
};

// Session连接抽象类
class ISessionConnection
{
public:
	virtual ~ISessionConnection() { }

	// 得到session连接的编号
	virtual int GetConnectionID() = 0;

	// 发送命令到服务器
	// !!注意：pCmd应该是在堆(heap)上创建的动态内存，调用后由ClientNet组件负责释放(delete)
	virtual bool SendCommand(IGameCommand* pCmd) = 0;
	// 关闭连接
	virtual void Close() = 0;

	// 以下接口可以认为是对SendCommand()的一个简单封装

	// 发送聊天信息(nChatSeqNo为聊天消息序列号，服务端返回响应时会带上此字段，用于唯一标识一条消息)
	virtual void Chat(const GAMETABLE& tableInfo, const string& chatMsg, int nChatSeqNo) = 0;
	// 进入游戏桌(游戏进程)
	virtual void EnterGame(const GAMESEAT& seatInfo, GAME_USER_STATUS userStatus, const string& initialTableKey, const string& followPasswd) = 0;
	// 用户已准备好(点击了"开始")
	virtual void GameReady(const GAMESEAT& seatInfo) = 0;
	// 提交游戏动作（下一步棋，出牌，...)
	virtual void SubmitGameAction(const GAMEROOM& roomInfo, const char* pszGameData, int nDataLen) = 0;
	// 退出游戏（或游戏桌）
	virtual void QuitGame(const GAMETABLE& tableInfo) = 0;
	// 调用大厅Call接口
	//TODO
	//virtual HRESULT Call(BSTR method, VARIANT param1=VARIANT_OPTIONAL, VARIANT param2=VARIANT_OPTIONAL, VARIANT* result=NULL) = 0;

	// 断线重连(如果从EnterGameResp的包中，发现自己的状态是Playing，则应该调用此接口函数)
	virtual void Replay(const GAMESEAT& seatInfo) = 0;

	// 发送通用命令 (注意： pCmdParams参数由GameNet来释放!)
	virtual void SendGenericCmd(const char* cmdName, const GAMEROOM& roomInfo, IDataXNet* pCmdParams) = 0;

};

// Session连接的回调通知接口
class ISessionCallbackCore
{
public:
	virtual ~ISessionCallbackCore() { }

	// 接收到命令(注意: pCmd对象在调用完后由ClientNet负责释放)
	// 注意: 如果是普通命令(如EnterRoomNotify，则既会调用OnEnterRoomNotify这样的包装函数，也会调用OnRecvCmd）
	virtual void OnRecvCmd( IGameCommand* pCmd) = 0;

	// 发生网络错误通知
	virtual void OnNetworkError(int iErrorCode) = 0;

	// 大厅通知
	virtual unsigned int OnNotify(const char* szEvent) = 0;
};



/**********************************************************************
* 说明： 引入ISessionCallback的目的是使以前的代码能顺利移植到新框架下；
*        新引入的命令的回调将通过 ISessionCallbackCore::OnRecvCmd()执行，
*        不再通过本接口转换
***********************************************************************/
class ISessionCallback : public ISessionCallbackCore
{
public:

	// 自己进入游戏（游戏桌）的响应信息
	virtual void OnEnterGameResp(int nResult, const vector<XLPLAYERINFO>& tablePlayers)=0;
	// 通知消息：同桌有其它人进入
	virtual void OnEnterGameNotify(XLUSERID nEnterUserID, int nTableID, byte nSeatID, bool isLookOnUser) = 0 ;	

	// 通知消息：某用户游戏已准备好（点了"开始"）
	virtual void OnGameReadyNotify(XLUSERID nReadyUserID) = 0 ;	

	// 通知消息：游戏开始（同桌的所有玩家都点了开始）
	virtual void OnGameStartNotify(int nTableID) = 0;	
	// 游戏一局结束
	virtual void OnEndGameNotify(int nTableID) = 0; 

	// 自己退出游戏桌的响应信息
	virtual void OnQuitGameResp(int nResult) = 0;
	// 通知消息：同桌的某玩家退出
	virtual void OnQuitGameNotify(XLUSERID nQuitUserID) = 0 ;	

	// 通知消息：同房间的某玩家退出
	virtual void OnExitRoomNotify(XLUSERID nExitUserID) = 0;	

	// 响应消息：自己发送聊天的响应结果(nResult: 0->成功，其它值->错误)
	virtual void OnChatResp(int nChatSeqNo, int nResult) = 0 ;	
	// 通知消息：同桌的某玩家发送聊天消息
	virtual void OnChatNotify(const GAMETABLE& tableInfo, XLUSERID nChatUserID, const string& chatMsg) = 0 ;	

	// 响应消息：自己提交游戏动作后，服务端的响应；服务端只在非法动作时才发送此回应消息
	virtual void OnGameActionResp(int nResult) = 0;
	// 通知消息：同桌的某玩家提交了游戏动作（发牌，或下了一步棋...)
	virtual void OnGameActionNotify(XLUSERID nSubmitUserID, const char* szGameDataBuf,int nDataLen ) = 0;

	// 通知消息：某玩家的积分有变化
	virtual void OnUserScoreChanged(XLUSERID nChangeUserID, const XLGAMESCORE& scoreInfo) = 0;

	// 响应消息：服务端只返回一个整型结果值(nResult)的响应消息, nRespCmdID为响应命令ID
	virtual void OnCmdSimpeleResp(SIMPLE_RESP_CMD_ID nRespCmdID, int nResult) = 0 ;	
	// 通知消息：某玩家的状态发生改变
	virtual void OnPlayerStatusChanged(XLUSERID /*nPlayerID*/, PLAYER_STATUS_ACTION_ENUM /*nStatusAction*/) {}
	// 通知消息：自己被踢出(重复登陆或其它原因)；
	// 游戏客户端处理此事件，只需要直接退出进程，不需要弹出消息提示
	virtual void OnKickout(KICKOUT_REASON_ENUM /*kickReason*/, XLUSERID /*nWhoKickMe*/) { }
	// 基于IDataX通用命令的服务端响应
	virtual void OnGenericResp(const string& /*cmdName*/, int /*nResult*/, IDataXNet* /*pDataX*/) { }
	// 基于IDataX通用命令的服务端通知
	virtual void OnGenericNotify(const string& /*cmdName*/, const GAMEROOM& /*roomInfo*/, IDataXNet* /*pDataX*/) { }
};

// 竞赛session连接抽象类
class IMatchSessionConnection
{
public:
    virtual ~IMatchSessionConnection() { }

public:
    // 得到session连接的编号
    virtual int GetMatchID() = 0;

    // 关闭连接
    virtual void Close() = 0;

    // 发送命令到服务器
    // !!注意：pCmd应该是在堆(heap)上创建的动态内存，调用后由ClientNet组件负责释放(delete)
    virtual bool SendCommand(IGameCommand* pCmd) = 0;

    // 发送通用命令 (注意： pCmdParams参数由GameNet来释放!)
    virtual void SendGenericCmd(const char* cmdName, IDataXNet* pCmdParams) = 0;
};

// 竞赛session回调
class IMatchCallback : public ISessionCallbackCore
{
public:
    // 基于IDataX通用命令的服务端响应
    virtual void OnGenericResp(const string& /*cmdName*/, int /*nResult*/, IDataXNet* /*pDataX*/) { }

    // 基于IDataX通用命令的服务端通知
    virtual void OnGenericNotify(const string& /*cmdName*/, const GAMEROOM& /*roomInfo*/, IDataXNet* /*pDataX*/) { }
};

// 命令抽象类(所有收发的命令,应该从此类继承)
// (对于基本命令，如进入房间、退出房间、游戏动作等，ClientNet已实现了相关的命令，不用再实现这些命令的继承类；
//  对于新加的命令，才需要实现继承自IGameCommand的命令)
class IGameCommand
{
public:
	virtual ~IGameCommand() { }

	// 返回该命令编码为二进制流的流长度(单位：字节数)
	virtual unsigned int Length() = 0;

	/***********************************************************************************
	* 将命令编码为buffer所指向内存上的二进制流
	* buffer_size: [IN/OUT] 调用前为缓冲区的初始大小，调用后设置为编码后二进制流的长度
	/**********************************************************************************/
	virtual void Encode(void * buffer, unsigned long &buffer_size) = 0;

	/***********************************************************************************
	* 将二进制流解码为命令里面的各字段值
	* buffer_size: [IN] 缓冲区的大小
	/**********************************************************************************/
	virtual void Decode(const void * buffer, unsigned long buffer_size) = 0;

	// 返回该命令名称，方便进行 日志/调试 跟踪
	virtual const char* CmdName() = 0;
	// 返回该命令内部状态(关键字段)的描述
	virtual string Description() = 0;

	// 返回该命令的类型标识(ID)
	virtual unsigned short GetCmdType() = 0;

	// 建议命令是否需要加密
	virtual void SetEncryptHint(BOOL bShouldEncrypt) = 0;
};

// 命令抽象类-2
// 增加对重连机制的支持
class IGameCommand2 : public IGameCommand
{
public:
    virtual ~IGameCommand2() { }

    virtual bool Clone(IGameCommand2* pResultCmd) = 0;
    virtual bool IsCoupleRespCmd(IGameCommand* pCmd) = 0;
};

/*******************************************************************
**  "万能"数据交换接口，客户端和大厅交换数据可通过此接口
**
**  使用方法：将数据通过 PutXXX设置好后，调用Encode()方法将命令序列化,
**            将序列化的二进制数据放入VARIANT里面作为SafeArray传递给对方
**********************************************************************/
class IDataXNet
{
public:
	virtual ~IDataXNet() { }

	// 返回该命令编码为二进制流的流长度(单位：字节数)
	virtual int EncodedLength() = 0;

	/***********************************************************************************
	* 将命令编码为buffer所指向内存上的二进制流
	* buffer_size: [IN/OUT] 调用前为缓冲区的初始大小，调用后设置为编码后二进制流的长度
	/**********************************************************************************/
	virtual void Encode(byte* pbBuffer, int &nBufferSize) = 0;

	// 将自己的内容完全复制一份
	virtual IDataXNet* Clone() = 0;
	// 将已有的数据清空
	virtual void Clear() = 0;
	// 返回元素数量
	virtual int GetSize() = 0;

	// 添加数据操作接口
	// --------------------
	// 添加Short类型数据
	virtual bool PutShort(short nKeyID, short nData) = 0;
	// 添加Int类型数据
	virtual bool PutInt( short nKeyID, int nData) = 0;
	// 添加64位整型数据
	virtual bool PutInt64(short nKeyID, __int64 nData) = 0;
	// 添加字节数组的内容
	virtual bool PutBytes(short nKeyID, const byte* pbData, int nDataLen) = 0;
	// 添加宽字节字符串
	virtual bool PutWString(short nKeyID, LPCWSTR pwszData, int nStringLen) = 0;
	// 嵌入IDataX内容
	virtual bool PutDataX(short nKeyID, IDataXNet* pDataCmd) = 0;
	// 添加Int数组的内容
	virtual bool PutIntArray(short nKeyID, int* pnData, int nElements) = 0;
	// 添加IDataX数组
	virtual bool PutDataXArray(short nKeyID, IDataXNet** ppDataCmd, int nElements) = 0;
	// 添加UTF-8编码的字符串
	virtual bool PutUTF8String(short nKeyID, const byte* pbData, int nDataLen) = 0;

	// 获取数据操作接口
	// ------------------------
	// 获取Short类型数据
	virtual bool GetShort(short nKeyID, short& nData) = 0;
	// 获取Int类型数据
	virtual bool GetInt(short nKeyID, int& nData) = 0;
	// 获取64位整型数据
	virtual bool GetInt64(short nKeyID, __int64& nData) = 0;
	// 获取字节数组(如果pbDataBuf为NULL, 则会在nBufferLen设置该字节数组内容的实际长度)
	virtual bool GetBytes(short nKeyID, byte* pbDataBuf, int& nBufferLen) = 0;
	// 获取宽字节字符串(如果pwszDataBuf为NULL, 则会在nStringLen设置该字符串的实际长度)
	virtual bool GetWString(short nKeyID, LPWSTR pwszDataBuf, int& nStringLen) = 0;
	// 获取嵌入在里面的IDataX
	virtual bool GetDataX(short nKeyID, IDataXNet** ppDataCmd) = 0;
	// 获取整型数组的元素数量
	virtual bool GetIntArraySize(short nKeyID, int& nSize) = 0;
	// 获取整型数组的某个元素（根据索引编号）
	virtual bool GetIntArrayElement(short nKeyID, int nIndex, int& nData) = 0;
	// 获取IDataX数组的元素数量
	virtual bool GetDataXArraySize(short nKeyID, int& nSize) = 0;
	// 获取IDataX数组的某个元素（根据索引编号）
	virtual bool GetDataXArrayElement(short nKeyID, int nIndex, IDataXNet** ppDataCmd) = 0;
	// 获取UTF8编码的字节数组(如果pbDataBuf为NULL, 则会在nBufferLen设置该字节数组内容的实际长度)
	virtual bool GetUTF8String(short nKeyID, byte* pbDataBuf, int& nBufferLen) = 0;

	virtual string ToString() = 0;

	virtual jobject EncodeToBundle(JNIEnv *env) = 0;
};


#endif // #ifndef __GN_INTERFACE_H_20090216_24
