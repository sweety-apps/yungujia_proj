#pragma once

#include "common/GameNetInf.h"
#include "common/FixedBuffer.h"

#include <map>
#include <vector>
#include <string>

using std::map;
using std::vector;
using std::string;

typedef map<short, string> DataIDToKeyMap;

#define MAKE_DATAX_INDEX(xType, pos)	((xType << 16) + pos)
#define GET_TYPE_FROM_DX_INDEX(nIndex)	(nIndex >> 16)
#define GET_POS_FROM_DX_INDEX(nIndex)	(nIndex & 0xFFFF)

class DataXImpl : public IDataXNet
{
	enum { DX_MAGIC_NUM = 0x385A };

	enum DataX_Types_Enum
	{
		DX_TYPE_MIN_VALUE = 1,
		DX_TYPE_SHORT = 1,
		DX_TYPE_INT	 = 2,
		DX_TYPE_INT64 = 3,
		DX_TYPE_BYTES = 4,
		DX_TYPE_WSTRING = 5,
		DX_TYPE_DATAX = 6,
		DX_TYPE_INTARRAY = 7,
		DX_TYPE_DATAXARRAY	= 8,
		DX_TYPE_UTF8STRING = 9,
		DX_TYPE_MAX_VALUE = 9
	};

	static DataIDToKeyMap m_sMapDataIDToKey;

public:
	DataXImpl(void);
	~DataXImpl(void);

	static void InitDataIDMap();

	static DataXImpl* DecodeFrom(byte* pbBuffer, int& nBufferLen);

	// 返回该命令编码为二进制流的流长度(单位：字节数)
	int EncodedLength();

	/***********************************************************************************
	* 将命令编码为buffer所指向内存上的二进制流
	* buffer_size: [IN/OUT] 调用前为缓冲区的初始大小，调用后设置为编码后二进制流的长度
	/**********************************************************************************/
	void Encode(byte* pbBuffer, int &nBufferSize);

	// 将自己的内容完全复制一份
	IDataXNet* Clone();
	// 将已有的数据清空
	void Clear();
	// 返回元素数量
	int GetSize();

	// 添加数据操作接口
	// --------------------
	// 添加Short类型数据
	bool PutShort(short nKeyID, short nData);
	// 添加Int类型数据
	bool PutInt(short nKeyID, int nData);
	// 添加64位整型数据
	bool PutInt64(short nKeyID, __int64 nData);
	// 添加字节数组的内容
	bool PutBytes(short nKeyID, const byte* pbData, int nDataLen);
	// 添加宽字节字符串
	bool PutWString(short nKeyID, LPCWSTR pwszData, int nStringLen);
	// 嵌入IDataXNet内容
	bool PutDataX(short nKeyID, IDataXNet* pDataCmd);
	// 添加Int数组的内容
	bool PutIntArray(short nKeyID, int* pnData, int nElements);
	// 添加IDataXNet数组
	bool PutDataXArray(short nKeyID, IDataXNet** ppDataCmd, int nElements);
	// 添加UTF-8编码的字符串
	bool PutUTF8String(short nKeyID, const byte* pbData, int nDataLen);

	// 获取数据操作接口
	// ------------------------
	// 获取Short类型数据
	bool GetShort(short nKeyID, short& nData);
	// 获取Int类型数据
	bool GetInt(short nKeyID, int& nData);
	// 获取64位整型数据
	bool GetInt64(short nKeyID, __int64& nData) ;
	// 获取字节数组(如果pbDataBuf为NULL, 则会在nBufferLen设置该字节数组内容的实际长度)
	bool GetBytes(short nKeyID, byte* pbDataBuf, int& nBufferLen);
	// 获取宽字节字符串(如果pwszDataBuf为NULL, 则会在nStringLen设置该字符串的实际长度)
	bool GetWString(short nKeyID, LPWSTR pwszDataBuf, int& nStringLen) ;
	// 获取嵌入在里面的IDataXNet
	bool GetDataX(short nKeyID, IDataXNet** ppDataCmd);
	// 获取整型数组的元素数量
	bool GetIntArraySize(short nKeyID, int& nSize);
	// 获取整型数组的某个元素（根据索引编号）
	bool GetIntArrayElement(short nKeyID, int nIndex, int& nData);
	// 获取IDataXNet数组的元素数量
	bool GetDataXArraySize(short nKeyID, int& nSize);
	// 获取IDataXNet数组的某个元素（根据索引编号）
	bool GetDataXArrayElement(short nKeyID, int nIndex, IDataXNet** ppDataCmd);
	// 获取UTF8编码的字节数组(如果pbDataBuf为NULL, 则会在nBufferLen设置该字节数组内容的实际长度)
	bool GetUTF8String(short nKeyID, byte* pbDataBuf, int& nBufferLen);

	virtual string ToString();
	virtual jobject EncodeToBundle(JNIEnv *env);

private:
	void EncodeBytesItem(FixedBuffer& fixed_buffer, int nPos);
	void EncodeWStringItem(FixedBuffer& fixed_buffer, int nPos);
	void EncodeDataXItem(FixedBuffer& fixed_buffer, int nPos);
	void EncodeIntArrayItem(FixedBuffer& fixed_buffer, int nPos);
	void EncodeDataXArrayItem(FixedBuffer& fixed_buffer, int nPos);

	bool ModifyShort(short nKeyID, short nData);
	bool ModifyInt(short nKeyID, int nData);
	bool ModifyInt64(short nKeyID, __int64 nData);
	bool ModifyBytes(short nKeyID, const byte* pbData, int nDataLen);
	bool ModifyWString(short nKeyID, LPCWSTR pwszData, int nStringLen);
	bool ModifyUTF8String(short nKeyID, const byte* pbData, int nDataLen);

	unsigned CalcBytesItemLen(int nPos) { return sizeof(int) + m_vecBytesItems[nPos].length(); }
	unsigned CalcWStringItemLen(int nPos) { return sizeof(int) + m_vecWstrItems[nPos].length() * sizeof(WCHAR); }
	unsigned CalcDataXItemLen( int nPos) 
	{ 
		long nEncodedLen = m_vecDataXItems[nPos]->EncodedLength();
		//HRESULT hr = m_vecDataXItems[nPos]->EncodedLength(&nEncodedLen);
		return (unsigned)nEncodedLen;
	}
	unsigned CalcIntArrayItemLen(int nPos);
	unsigned CalcDataXArrayItemLen( int nPos);

	BOOL PutBytesItem(unsigned short nKeyID, FixedBuffer& fixed_buffer);
	BOOL PutUTF8BytesItem(unsigned short nKeyID, FixedBuffer& fixed_buffer);
	BOOL PutWStringItem(unsigned short nKeyID, FixedBuffer& fixed_buffer);
	BOOL PutDataXItem(unsigned short nKeyID, FixedBuffer& fixed_buffer);
	BOOL PutIntArrayItem(unsigned short nKeyID, FixedBuffer& fixed_buffer);
	BOOL PutDataXArrayItem(unsigned short nKeyID, FixedBuffer& fixed_buffer);

	bool PutDataXArray_Impl(short nKeyID, IDataXNet** ppDataCmd, int nElements, bool bGiveupDxOwnership = false);


private:
	map<short, int> m_mapIndexes;

	vector<int> m_vecIntItems;
	vector<__int64> m_vecInt64Items;
	vector<string> m_vecBytesItems;
	vector<std::wstring> m_vecWstrItems;
	vector<IDataXNet*> m_vecDataXItems;
	vector< vector<int> > m_vecIntArrayItems;
	vector< vector<IDataXNet*> > m_vecDataXArrayItems;

private:
	DECL_LOGGER;
};
