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
* Client通过事件接口回调调用方，是在界面线程中进行的；因此调用方不用做线程互斥(或线程切换)的处理。
*
*********************************************************************************************************/



#ifndef __GAME_NET_INTERFACE_H_20090216_24
#define __GAME_NET_INTERFACE_H_20090216_24

#include "GNInterface.h"

class ISessionConnectionEx;
class ISessionCallbackEx;


// 数据通讯抽象类
// （通过GetGameNetInstance()得到实际的实例）
class IGameNetEx : public IGameNet
{
public:
	// 向目录server查询目录信息(strMethodName, mapParams参数参见<dir_server消息体定义.xml>)
	virtual BOOL QueryDirInfo(const char* server_addr, unsigned short server_port, const string& strMethodName,const map<string, string>& mapParams) = 0;


	// 创建session连接（每个房间要创建一个单独的sesssion连接）；大厅进程可调用此接口，游戏进程不能调用
	virtual ISessionConnection* CreateSessionConnection(const char* server_addr, unsigned short server_port, ISessionCallback* pCallback) = 0;

	// 跳过人满房间查询
	virtual BOOL QueryDirInfoWithSkipRooms(const char* server_addr, unsigned short server_port, const string& strMethodName,IDataXNet* pParams) = 0;
};

class IGameNetEx2 : public IGameNetEx
{
public:
    // config
    virtual void SetConfig(const char* key, int value) = 0;
    virtual int GetConfig(const char* key, int default_value) = 0;
    virtual int SetProxy(int proxyType, const char* server_addr, unsigned short server_port, const char* username, const char* pwd) = 0;

   // virtual void SetProxy(const char* server_addr, unsigned short server_port, const char* username, const char* pwd) = 0;
};

class IGameNetEx3 : public IGameNetEx2
{
public:
    virtual BOOL QueryDirInfoWithSkipRooms(const char* server_addr, unsigned short server_port, const string& strMethodName,IDataXNet* pParams) = 0;
	//virtual BOOL SimulateQuitTable(int connID, const __int64 userID) = 0;
	virtual BOOL SubmitTimedMatchDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSrcID = CMD_FROM_GAMEHALL) = 0;
};


// 数据通讯的回调接口(只对短连接的通讯；Session连接的回调通过ISessionCallback)
class IGameNetEventEx : public IGameNetEvent
{
public:	
	virtual ~IGameNetEventEx() { }

	// 目录信息查询成功后的响应
	virtual void OnQueryDirResp(const string& response) = 0;

	// 新的错误通知
	virtual void OnNetworkErrorWithConnID(int nConnID, int nErrorCode, int nExtraCode) { }
};

// Session连接抽象类
class ISessionConnectionEx : public ISessionConnection
{
public:
	// 进入房间
	virtual void EnterRoom(const GAMEROOM& roomInfo, const XLUSERINFOEX& userInfo) = 0;
	// 退出房间
	virtual void ExitRoom(const GAMEROOM& roomInfo) = 0;
};



/**********************************************************************
* 说明： 引入ISessionCallback的目的是使以前的代码能顺利移植到新框架下；
*        新引入的命令的回调将通过 ISessionCallbackCore::OnRecvCmd()执行，
*        不再通过本接口转换
***********************************************************************/
class ISessionCallbackEx : public ISessionCallback
{
public:
	// 进入房间的响应信息
	virtual void OnEnterRoomResp( int nResult, const vector<XLPLAYERINFO>& roomPlayers) = 0;	

	// 通知消息：同房间有其它人进入
	virtual void OnEnterRoomNotify(const XLPLAYERINFO& enterPlayer) = 0;	
	// 通知消息：用户资料（属性）被修改
	virtual void OnUserInfoModified(const XLPLAYERINFO& enterPlayer) = 0;	

	// 响应消息：退出房间(关闭session连接的较好时机)
	virtual void OnExitRoomResp(int nResult) = 0;
};


#endif // #ifndef __GAME_NET_INTERFACE_H_20090216_24
