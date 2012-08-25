#include "common/utility.h"

#include "GameCmdBase.h"
#include "common/MyTea.h"
#include "common/md5.h"
#include <stdio.h>
#include <stdlib.h>
#include "common/SDEnCryZip.h"

bool GameCmdBase::m_bHallVersionAvailable = false;
unsigned int GameCmdBase::m_nHallVersion = 0;

int GameCmdBase::MAGIC_NUM = 0x5C732E94;
short GameCmdBase::CUR_PROTOCOL_VERSION = 10; // 初始版本

extern int g_nMajorVersion;
extern int g_nMinorVersion;
extern int g_nBuildNum;

IMPL_LOGGER_EX(GameCmdBase, GN);

GameCmdBase::GameCmdBase()
{
    init_base_header_value();
	m_userid = g_nUserID;
}

GameCmdBase::~GameCmdBase()
{}

void GameCmdBase::init_base_header_value()
{
    m_package_header.MagicNum = MAGIC_NUM;
    m_package_header.CipherFlag = 1;
    m_package_header.ProtocolVer = CUR_PROTOCOL_VERSION;
    m_package_header.xReleaseVer = get_hall_version();

    m_package_header.BodyLen = 0;
//    p2p_transfer_layer *instance  = p2p_transfer_layer::get_instance();
    m_package_header.ConnectIP = 0; //instance->get_local_ip();;
    m_package_header.EncryptLen = 0;
}


int GameCmdBase::get_header_length()
{
    static int header_len = 0;

	if(header_len == 0)
	{
		header_len += sizeof(unsigned int); // magic number
		header_len += sizeof(unsigned short); // protocol version
		header_len += sizeof(unsigned int); // xReleaseVer
		header_len += sizeof(unsigned int); // ConnectIP
		header_len += sizeof(unsigned char); // CipherFlag
		header_len += sizeof(unsigned int); // EncryptLen
		header_len += sizeof(unsigned int); // BodyLen
	}

    return header_len;
}

void GameCmdBase::Encode(void * buff, unsigned long &buff_size)
{
    unsigned long header_len = get_header_length() ;
    unsigned char* pBufferBody = (unsigned char*)buff + header_len;
    if ( buff_size < header_len )
    {
        ysh_assert( false );
    }

    unsigned long body_len = buff_size - header_len;
    encode_parameters( pBufferBody, body_len ); 

    m_package_header.BodyLen = (unsigned short)body_len;

    unsigned int t_body = body_len;
    switch(m_package_header.CipherFlag)
    {
    case 0:
        // 明文
        {            
            m_package_header.EncryptLen = body_len;
        }
        break;

    case 1:
        // 加密
        {            
            int encryp_body_len = body_len;

            unsigned char* pTmpBodyBuffer = new unsigned char[body_len];
            memcpy(pTmpBodyBuffer,pBufferBody,body_len);
            encryp_body_len = encryp_body(pTmpBodyBuffer,body_len,pBufferBody,buff_size - header_len);

            delete[] pTmpBodyBuffer;
            
            m_package_header.EncryptLen = encryp_body_len;//加密长度
            t_body = (unsigned int)encryp_body_len;
        }
        break;

    case 2:
        // 压缩
        {          
            LOG_DEBUG("Encode zip, body size=" << body_len);

            _u64 zip_body_len = body_len;
            if(!SDZip::compress((char*)pBufferBody, &zip_body_len))
            {
                LOG_ERROR("zip failed!");                
                return;
            }
            
            m_package_header.EncryptLen = (unsigned int)zip_body_len; //压缩长度
            t_body = (unsigned int)zip_body_len;

            LOG_DEBUG("Encode zip, zip body size=" << t_body);
        }
        break;

    default:
        // 不支持
        {
            LOG_ERROR("GameCmdBase::Encode - not supported cipher flag=" << m_package_header.CipherFlag);
            return;
        }
        break;
    }

    write_header((unsigned char*)buff);
    buff_size = header_len + t_body;
}

void GameCmdBase::Decode(const void * buff, unsigned long buff_size)
{
    LOG_DEBUG("Decode - begin decode len=" << buff_size);

    unsigned int header_len = get_header_length() ;
    unsigned char* pBufferBody = (unsigned char*)buff + header_len;

    if ( buff_size < header_len )
    {
        ysh_assert( false );
    }

    unsigned long body_len = buff_size - header_len;

    LOG_DEBUG("Decode - read header");
    read_header((const unsigned char*) buff, m_package_header);
    LOG_DEBUG("Decode - read header cipherflag=" << (int)m_package_header.CipherFlag);

	{
        switch(m_package_header.CipherFlag)
        {
        case 0:
            // 明文
            {
                decode_parameters(pBufferBody, body_len);
            }
            break;

        case 1:
            // 加密
            {
                unsigned char* pTmpBodyBuffer = new unsigned char[m_package_header.BodyLen + 8];
                memset(pTmpBodyBuffer, 0, m_package_header.BodyLen);

                LOG_DEBUG("Decode - decryp_body");
                int decryp_len = decryp_body(pBufferBody, m_package_header.EncryptLen, pTmpBodyBuffer, m_package_header.BodyLen + 8, m_package_header);
                //ysh_assert(decryp_len == m_package_header.BodyLen);

                LOG_DEBUG("Decode - decode_parameters");
                decode_parameters(pTmpBodyBuffer, decryp_len);
                delete [] pTmpBodyBuffer;
            }
            break;

        case 2:
            // 压缩
            { 
                LOG_DEBUG("begin to unzip, origin size=" << m_package_header.EncryptLen);

                char* pDest = NULL;
                int nUnZipLen = 0;
                int unzipRet = SDZip::inflate_read((char*)pBufferBody, m_package_header.EncryptLen, &pDest, false, nUnZipLen);
                if(unzipRet != Z_OK)
                {
                    LOG_ERROR("unzip body failed! ret=" << unzipRet);
                    return;
                }

                LOG_DEBUG(" Unzip: zip len=" << m_package_header.EncryptLen << ", unzip len=" << nUnZipLen);
                decode_parameters(pDest, (unsigned int)nUnZipLen);    
                free(pDest);
            }
            break;

        default:
            {
                LOG_ERROR("GameCmdBase::Decode - not supported cipher flag=" << m_package_header.CipherFlag);
            }
            break;
        }
	}
}

void GameCmdBase::SetEncryptHint(BOOL bShouldEncrypt)
{
	if(bShouldEncrypt)
	{
		m_package_header.CipherFlag = 1;
	}
	else
	{
		m_package_header.CipherFlag = 0;
	}
}

int GameCmdBase::encryp_body(const unsigned char* pBodyBuffer,int bodyLen,unsigned char* pBuffer,int bufferLen)
{
//	MD5 myMD5;
	ctx_md5 myMD5;
	myMD5.update((byte*)(&m_package_header), sizeof(GameCmdHeader) - sizeof(int) - sizeof(int));
	myMD5.update((byte*)(&m_package_header.BodyLen), sizeof(m_package_header.BodyLen));

	byte md5_result[16];
	myMD5.finish(md5_result);

	static int dump_times = 0;
	if(dump_times < 10)
	{
		LOG_DEBUG( "Encrypt Key is: " << utility::ch2str(md5_result, 16));
	}
	dump_times++;
	

    mytea theTea(md5_result,32);

    return theTea.encrypt_buf(pBodyBuffer,bodyLen,pBuffer,bufferLen);
}

int GameCmdBase::decryp_body(const unsigned char* pBodyBuffer,int bodyLen,unsigned char* pBuffer,int bufferLen, GameCmdHeader& header)
{
//	MD5 myMD5;
	ctx_md5 myMD5;
	myMD5.update((byte*)(&header), sizeof(GameCmdHeader) - sizeof(int) - sizeof(int));
	myMD5.update((byte*)(&header.BodyLen), sizeof(header.BodyLen));
	byte md5_result[16];
	myMD5.finish(md5_result);
	mytea theTea(md5_result,32);

	static int dump_times = 0;
	if(dump_times < 10)
	{
		LOG_DEBUG( "Decrypt Key is: " << utility::ch2str((unsigned char*)md5_result, 16));
	}
	dump_times++;
	

    return theTea.decrypt_buf(pBodyBuffer,bodyLen,pBuffer,bufferLen);
}

int GameCmdBase::parse_cmd_type(const unsigned char* pBuffer)
{
    GameCmdHeader header;
    read_header(pBuffer, header);
    unsigned short cmd_typeid = 0;

    switch(header.CipherFlag)
    {
    case 0:
        {
            FixedBuffer fixed_buffer((char*)(pBuffer + get_header_length() + sizeof(__int64)), sizeof(short), true); // skip UserID
            cmd_typeid = fixed_buffer.get_short(); //  *(unsigned short*)(buffer);
        }
        break;

    case 1:
        {
            unsigned char buffer[20];
            decryp_body(pBuffer + get_header_length(), 16, buffer, 16, header);
            FixedBuffer fixed_buffer((char*)(buffer + sizeof(__int64)), sizeof(short), true);  // skip UserID
            cmd_typeid = fixed_buffer.get_short(); //  *(unsigned short*)(buffer);
        }
        break;

    case 2:
        {
            GameCmdHeader cmd_header;
            GameCmdBase::read_header((byte*)pBuffer, cmd_header);

            unsigned char unzip_buffer[20];
            int unzipRet = SDZip::inflate_read_part((char*)(pBuffer + get_header_length()), cmd_header.EncryptLen, false, (char*)unzip_buffer, 16);
            if(Z_OK == unzipRet)
            {
                FixedBuffer fixed_buffer((char*)(unzip_buffer + sizeof(__int64)), sizeof(short), true);
                cmd_typeid = fixed_buffer.get_short();
            }
            else
            {
                LOG_ERROR("parse_cmd_type - unzip err=" << unzipRet);
            }
        }
        break;
    }

    return cmd_typeid;
}


int GameCmdBase::write_header(unsigned char* pBuffer)
{
    GameCmdHeader* pHeader = (GameCmdHeader*) pBuffer;
	FixedBuffer fixed_buffer((char*)pBuffer, sizeof(GameCmdHeader), true);
	fixed_buffer.put_int(m_package_header.MagicNum);
	fixed_buffer.put_short(m_package_header.ProtocolVer);
	fixed_buffer.put_int(m_package_header.xReleaseVer);
	fixed_buffer.put_int(m_package_header.ConnectIP);
	fixed_buffer.put_byte(m_package_header.CipherFlag);
	fixed_buffer.put_int(m_package_header.EncryptLen);
	fixed_buffer.put_int(m_package_header.BodyLen);

//    *pHeader = m_package_header;
    return sizeof(GameCmdHeader);
}

void GameCmdBase::read_header(const unsigned char* pBuffer, GameCmdHeader& header)
{
	FixedBuffer fixed_buffer((char*)pBuffer, sizeof(GameCmdHeader), true);
	header.MagicNum = fixed_buffer.get_int();
	header.ProtocolVer = fixed_buffer.get_short();
	header.xReleaseVer = fixed_buffer.get_int();
	header.ConnectIP = fixed_buffer.get_int();
	header.CipherFlag = fixed_buffer.get_byte();
	header.EncryptLen = fixed_buffer.get_int();
	header.BodyLen = fixed_buffer.get_int();

//    GameCmdHeader* pHeader = (GameCmdHeader*) pBuffer;
//    header = *pHeader;
}

unsigned int GameCmdBase::Length()
{
    return get_header_length() + length_parameters();
}

string GameCmdBase::Description()
{
    string str;

    std::string params_desc;
    desc_parameters(params_desc);

	char header_desc[512];

	snprintf(header_desc, sizeof(header_desc), "[%s, xVer=%s, cmdID=%d, userID=%lld]",
		CmdName(), 
		get_hall_version_string(m_package_header.xReleaseVer).c_str(),
		(int)GetCmdType(),
		m_userid);

	str = header_desc;
	str += params_desc;
    return str;
}

int GameCmdBase::calc_xluserinfo_length(const XLUSERINFO& userInfo)
{
	int nLen = sizeof(int) + userInfo.Username.length();
	nLen += int(sizeof(int) + userInfo.Nickname.length());
	nLen += int(sizeof(userInfo.ImageIndex));
	nLen += int(sizeof(byte)); // IsVip

	return nLen;
}

int GameCmdBase::calc_xlplayerinfo_length(const XLPLAYERINFO& playerInfo)
{
	int nLen = sizeof(__int64); // UserID
	nLen += calc_xluserinfo_length(playerInfo.UserBasicInfo);
	nLen += int(sizeof(int) + playerInfo.UserIP.length());
	nLen += sizeof(short); // TableID
	nLen += sizeof(char) * 3; // SeatID, UserStatus, Level
	nLen += sizeof(int) * 8; // Points, Win, Lose, Equal, Escape, OrgID, OrgPos, DropNum
	nLen += int(sizeof(int) + playerInfo.LevelName.length()); // LevelName
	nLen += sizeof(byte); // IsMale
	
	return nLen;
}

bool GameCmdBase::encode_xlplayerinfo(FixedBuffer& fixed_buffer, const XLPLAYERINFO& playerInfo)
{
	int struct_len_pos = fixed_buffer.position();
	fixed_buffer.skip(sizeof(int));

	int start_pos = fixed_buffer.position();

	fixed_buffer.put_int64(playerInfo.UserID);

	fixed_buffer.put_string(playerInfo.UserBasicInfo.Username);
	fixed_buffer.put_string(playerInfo.UserBasicInfo.Nickname);
	fixed_buffer.put_short(playerInfo.UserBasicInfo.ImageIndex);
	fixed_buffer.put_byte(playerInfo.UserBasicInfo.IsVIPUser ? 1:0);

	fixed_buffer.put_int(0); // ExternalIP
	//	playerInfo.m_user_ip = inet_ntoa();

	fixed_buffer.put_short(playerInfo.TableID);
	fixed_buffer.put_byte(playerInfo.SeatID);
	fixed_buffer.put_byte(playerInfo.UserStatus);
	fixed_buffer.put_byte(playerInfo.Level);

	fixed_buffer.put_int(playerInfo.Points);
	fixed_buffer.put_int(playerInfo.WinNum);
	fixed_buffer.put_int(playerInfo.LoseNum);
	fixed_buffer.put_int(playerInfo.EqualNum);
	fixed_buffer.put_int(playerInfo.EscapeNum);

	fixed_buffer.put_int(playerInfo.OrgID);
	fixed_buffer.put_int(playerInfo.OrgPos);

	fixed_buffer.put_int(playerInfo.DropNum);
	fixed_buffer.put_string(playerInfo.LevelName);
	fixed_buffer.put_byte(playerInfo.IsMale ? 1:0);

	int end_pos = fixed_buffer.position();
	int struct_len = end_pos - start_pos;

	fixed_buffer.set_position(struct_len_pos);
	fixed_buffer.put_int(struct_len);

	fixed_buffer.set_position(end_pos);

	return true;
}

bool GameCmdBase::decode_xlplayerinfo(FixedBuffer& fixed_buffer, XLPLAYERINFO& playerInfo)
{
	int struct_len = fixed_buffer.get_int();
	ysh_assert(fixed_buffer.remain_len() >= struct_len);

	int start_pos = fixed_buffer.position();

	playerInfo.UserID = fixed_buffer.get_int64();

	playerInfo.UserBasicInfo.Username = fixed_buffer.get_string();
	playerInfo.UserBasicInfo.Nickname = fixed_buffer.get_string();
	playerInfo.UserBasicInfo.ImageIndex = fixed_buffer.get_short();
	playerInfo.UserBasicInfo.IsVIPUser = fixed_buffer.get_byte() != 0 ? true: false;

	int nExternalIP	= fixed_buffer.get_int();
//	playerInfo.m_user_ip = inet_ntoa();

	playerInfo.TableID = fixed_buffer.get_short();
	playerInfo.SeatID = fixed_buffer.get_byte();
	playerInfo.UserStatus = fixed_buffer.get_byte();
	playerInfo.Level = fixed_buffer.get_byte();

	playerInfo.Points = fixed_buffer.get_int();
	playerInfo.WinNum = fixed_buffer.get_int();
	playerInfo.LoseNum = fixed_buffer.get_int();
	playerInfo.EqualNum = fixed_buffer.get_int();
	playerInfo.EscapeNum = fixed_buffer.get_int();

	playerInfo.OrgID = fixed_buffer.get_int();
	playerInfo.OrgPos = fixed_buffer.get_int();

	if(struct_len >= (fixed_buffer.position() - start_pos) + int(sizeof(int)))
	{
		playerInfo.DropNum = fixed_buffer.get_int();
	}
	if(struct_len >= (fixed_buffer.position() - start_pos) + int(sizeof(int)))
	{
		playerInfo.LevelName = fixed_buffer.get_string();
	}
	if(struct_len >= (fixed_buffer.position() - start_pos) + int(sizeof(byte)))
	{
		playerInfo.IsMale = (fixed_buffer.get_byte() > 0 ? true:false);
	}

	int end_pos = fixed_buffer.position();
	int real_struct_len = end_pos - start_pos;

	ysh_assert(struct_len >= real_struct_len);

	if(struct_len > real_struct_len)
	{
		fixed_buffer.skip(struct_len - real_struct_len);
	}

	return true;
}

bool GameCmdBase::encode_xlscoreinfo(FixedBuffer& fixed_buffer, const XLGAMESCOREEX& scoreInfo)
{
	int struct_len_pos = fixed_buffer.position();
	fixed_buffer.skip(sizeof(int));

	int start_pos = fixed_buffer.position();

	fixed_buffer.put_byte(scoreInfo.Level);
	fixed_buffer.put_int(scoreInfo.Points);
	fixed_buffer.put_int(scoreInfo.WinNum);
	fixed_buffer.put_int(scoreInfo.LoseNum);
	fixed_buffer.put_int(scoreInfo.EqualNum);
	fixed_buffer.put_int(scoreInfo.EscapeNum);	
	fixed_buffer.put_int(scoreInfo.DropNum);
	fixed_buffer.put_int(scoreInfo.PointsDelta);
	fixed_buffer.put_string(scoreInfo.LevelName);

	int end_pos = fixed_buffer.position();
	int struct_len = end_pos - start_pos;

	fixed_buffer.set_position(struct_len_pos);
	fixed_buffer.put_int(struct_len);

	fixed_buffer.set_position(end_pos);

	return true;
}

bool GameCmdBase::decode_xlscoreinfo(FixedBuffer& fixed_buffer, XLGAMESCOREEX& scoreInfo)
{
	int struct_len = fixed_buffer.get_int();
	ysh_assert(fixed_buffer.remain_len() >= struct_len);

	int start_pos = fixed_buffer.position();

	scoreInfo.Level = fixed_buffer.get_byte();

	scoreInfo.Points = fixed_buffer.get_int();
	scoreInfo.WinNum = fixed_buffer.get_int();
	scoreInfo.LoseNum = fixed_buffer.get_int();
	scoreInfo.EqualNum = fixed_buffer.get_int();
	scoreInfo.EscapeNum = fixed_buffer.get_int();
	scoreInfo.DropNum = fixed_buffer.get_int();
	scoreInfo.PointsDelta = fixed_buffer.get_int();
	
	if(struct_len >= (fixed_buffer.position() - start_pos) + int(sizeof(int)))
	{
		scoreInfo.LevelName = fixed_buffer.get_string();
	}
	else
	{
		LOG_WARN("no LevelName field in XLGAMESCOREEX struct when decode!");
		scoreInfo.LevelName = "";
	}

	int end_pos = fixed_buffer.position();
	int real_struct_len = end_pos - start_pos;

	ysh_assert(struct_len >= real_struct_len);
	if(struct_len > real_struct_len)
	{
		fixed_buffer.skip(struct_len - real_struct_len);
	}

	return true;
}

void GameCmdBase::copy_xluserinfo(XLUSERINFO& destUser, const XLUSERINFO& srcUser)
{
	destUser.Username = srcUser.Username;
	destUser.Nickname = srcUser.Nickname;
	destUser.ImageIndex = srcUser.ImageIndex;
	destUser.IsVIPUser = srcUser.IsVIPUser;
}

int GameCmdBase::get_hall_version()
{
	unsigned x1 = g_nMajorVersion << 24;
	unsigned x2 = g_nMinorVersion << 16;
	unsigned x3 = g_nBuildNum;
	m_nHallVersion = x1 + x2 + x3;
	return m_nHallVersion;
}

string GameCmdBase::get_hall_version_string(unsigned int nVer)
{
	char buffer[64];

	unsigned short nMajor = (nVer >> 24) & 0xFF;
	unsigned short nMinor = (nVer >> 16) & 0xFF;
	unsigned short nBuildNum = nVer & 0xFFFF;

	sprintf(buffer, "%d.%d.*.%d", nMajor, nMinor, nBuildNum);

	return (string)buffer;
}

bool GameCmdBase::Clone( IGameCommand2* pResultCmd )
{
    if(NULL == pResultCmd)
    {
        return false;
    }

    GameCmdBase* pCmd = dynamic_cast<GameCmdBase*>(pResultCmd);
    if(NULL == pCmd)
    {
        return false;
    }

    pCmd->m_package_header = m_package_header;
    pCmd->m_userid = m_userid;
    pCmd->m_cmd_typeid = m_cmd_typeid;

    return CloneBody(pCmd);
}

bool GameCmdBase::IsCoupleRespCmd( IGameCommand* pCmd )
{
    ysh_assert(pCmd);
    return false;
}

bool GameCmdBase::CloneBody( GameCmdBase* pResultCmd )
{
    ysh_assert(pResultCmd);
    return false;
}

