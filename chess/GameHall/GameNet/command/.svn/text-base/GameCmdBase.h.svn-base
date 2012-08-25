#ifndef _GAME_CMD_BASE_H
#define _GAME_CMD_BASE_H

#include <string>
#include "common/GameNetInf.h"
#include "common/FixedBuffer.h"
#include "GameCmdFactory.h"

extern __int64 g_nUserID;

#pragma pack(push)
#pragma pack(1)
struct GameCmdHeader
{
    unsigned int MagicNum;
    unsigned short ProtocolVer;
    unsigned int xReleaseVer;
    unsigned int ConnectIP;
    unsigned char CipherFlag;
    unsigned int EncryptLen;
    unsigned int BodyLen;
};

#pragma pack(pop)

class GameCmdBase : public IGameCommand2
{
    static int MAGIC_NUM;
    static short CUR_PROTOCOL_VERSION;

	static bool m_bHallVersionAvailable;
	static unsigned int m_nHallVersion;

public:
    GameCmdBase();
    virtual ~GameCmdBase();

	enum { RESULT_OK = 0 };

public:
	// interface of IGameCommand2
    virtual unsigned int Length();
	virtual void Encode(void * buff, unsigned long &buff_size);
	virtual void Decode(const void * buff, unsigned long buff_size);
    virtual string Description();
	virtual unsigned short GetCmdType() { return m_cmd_typeid; }
	virtual void SetEncryptHint(BOOL bShouldEncrypt);
    virtual bool Clone(IGameCommand2* pResultCmd);
    virtual bool CloneBody(GameCmdBase* pResultCmd);
    virtual bool IsCoupleRespCmd(IGameCommand* pCmd);

    
	virtual void desc_parameters(std::string &str) = 0;
    virtual void encode_parameters(void * buff, unsigned long &buff_size) = 0;
    virtual void decode_parameters(const void * buff, unsigned long buff_size) = 0;
    virtual unsigned long length_parameters() = 0;
	virtual BOOL IsGameTableAcceptCmd(int nTableID) = 0;    

	__int64 GetUserID() { return m_userid; }
	void ChangeUserID(XLUSERID nUserID) { m_userid = nUserID; }

    static int parse_cmd_type(const unsigned char* pBuffer);
	static int get_hall_version();
	static string get_hall_version_string(unsigned int nVer);

public:
    static int get_header_length();
	static void read_header(const unsigned char* pBuffer, GameCmdHeader& header);

	// utility methods
	static int calc_xluserinfo_length(const XLUSERINFO& userInfo);
	static int calc_xlplayerinfo_length(const XLPLAYERINFO& playerInfo);
	static bool decode_xlplayerinfo(FixedBuffer& fixed_buffer, XLPLAYERINFO& playerInfo);
	static bool encode_xlplayerinfo(FixedBuffer& fixed_buffer, const XLPLAYERINFO& playerInfo);
	static bool encode_xlscoreinfo(FixedBuffer& fixed_buffer, const XLGAMESCOREEX& scoreInfo);
	static bool decode_xlscoreinfo(FixedBuffer& fixed_buffer, XLGAMESCOREEX& scoreInfo);
	static void copy_xluserinfo(XLUSERINFO& destUser, const XLUSERINFO& srcUser);

private:
    int encryp_body(const unsigned char* pBodyBuffer,int bodyLen,unsigned char* pBuffer,int bufferLen);
    static int decryp_body(const unsigned char* pBodyBuffer,int bodyLen,unsigned char* pBuffer,int bufferLen, GameCmdHeader& header);
    int write_header(unsigned char* pBuffer);
    
    void init_base_header_value();

protected:
    GameCmdHeader m_package_header;
	__int64 m_userid;
    unsigned short m_cmd_typeid;


private:
    DECL_LOGGER; // LOG4CPLUS_CLASS_DECLARE(s_logger);
};

#endif // _GAME_CMD_BASE_H
