#ifndef _DATAX_NET_WRAPPER_H_
#define _DATAX_NET_WRAPPER_H_

class DxNetWrapper
{
public:
	DxNetWrapper(IDataXNet* pDataX) : m_pDataX(pDataX) { }

	short GetShort(short nKeyID, short nDefault = 0);
	// 获取Int类型数据
	int GetInt(short nKeyID, int nDefault = 0);
	// 获取64位整型数据
	__int64 GetInt64(short nKeyID, __int64 nDefault = 0);
	// 获取字节数组(如果pbDataBuf为NULL, 则会在nBufferLen设置该字节数组内容的实际长度)
	string GetBytes(short nKeyID, const string& strDefault = "");
	// 获取宽字节字符串(如果pwszDataBuf为NULL, 则会在nStringLen设置该字符串的实际长度)
	std::wstring GetWString(short nKeyID, const std::wstring& strDefault= L"");
	// 获取嵌入在里面的IDataX
	IDataXNet* GetDataX(short nKeyID);
	// 获取整型数组的元素数量
	int GetIntArraySize(short /*nKeyID*/) { return 0;}
	// 获取整型数组的某个元素（根据索引编号）
	int GetIntArrayElement(short /*nKeyID*/, int /*nIndex*/) { return 0; }
	// 获取IDataX数组的元素数量
	int GetDataXArraySize(short /*nKeyID*/) { return 0; }
	// 获取IDataX数组的某个元素（根据索引编号）
	IDataXNet* GetDataXArrayElement(short /*nKeyID*/, int /*nIndex*/) { return NULL; }
	// 获取UTF8编码的字节数组(如果pbDataBuf为NULL, 则会在nBufferLen设置该字节数组内容的实际长度)
	string GetUTF8String(short nKeyID, const string& strDefault = "");

private:
	IDataXNet* m_pDataX;
};

inline short DxNetWrapper::GetShort(short nKeyID, short nDefault )
{
	if(m_pDataX == NULL)
		return nDefault;
	else
	{
		short nData = nDefault;
		bool bExists = m_pDataX->GetShort(nKeyID, nData);
		return bExists ? nData : nDefault;
	}
}

inline int DxNetWrapper::GetInt(short nKeyID, int nDefault )
{
	if(m_pDataX == NULL)
		return nDefault;
	else
	{
		int nData = nDefault;
		bool bExists = m_pDataX->GetInt(nKeyID, nData);
		return bExists ? nData : nDefault;
	}
}

inline __int64 DxNetWrapper::GetInt64(short nKeyID, __int64 nDefault)
{
	if(m_pDataX == NULL)
		return nDefault;
	else
	{
		__int64 nData = nDefault;
		bool bExists = m_pDataX->GetInt64(nKeyID, nData);
		return bExists ? nData : nDefault;
	}
}

inline string DxNetWrapper::GetBytes(short nKeyID, const string& strDefault)
{
	if(m_pDataX == NULL)
		return strDefault;
	else
	{
		int nBufferLen = 0;
		bool bExists = m_pDataX->GetBytes(nKeyID, NULL, nBufferLen);
		if(!bExists)
			return strDefault;

		string str(nBufferLen, 0);
		bExists = m_pDataX->GetBytes(nKeyID, (byte*)str.c_str(), nBufferLen);
		return str;
	}
}

inline std::wstring DxNetWrapper::GetWString(short nKeyID, const std::wstring& strDefault)
{
	if(m_pDataX == NULL)
		return strDefault;
	else
	{
		int nBufferLen = 0;
		bool bExists = m_pDataX->GetWString(nKeyID, NULL, nBufferLen);
		if(!bExists)
			return strDefault;

		std::wstring str(nBufferLen, 0);
		bExists = m_pDataX->GetWString(nKeyID, (LPWSTR)str.c_str(), nBufferLen);
		return str;
	}
}

inline	IDataXNet* DxNetWrapper::GetDataX(short nKeyID) 
{
	if(m_pDataX == NULL)
		return NULL;
	else
	{
		IDataXNet* pDx = NULL;
		bool bExists = m_pDataX->GetDataX(nKeyID, &pDx);
		return bExists ? pDx : NULL;
	}
}

inline string DxNetWrapper::GetUTF8String(short nKeyID, const string& strDefault) 
{
	if(m_pDataX == NULL)
		return strDefault;
	else
	{
		int nBufferLen = 0;
		bool bExists = m_pDataX->GetUTF8String(nKeyID, NULL, nBufferLen);
		if(!bExists)
			return strDefault;

		string str(nBufferLen, 0);
		bExists = m_pDataX->GetUTF8String(nKeyID, (byte*)str.c_str(), nBufferLen);
		return str;
	}
}

#endif // #ifndef _DATAX_NET_WRAPPER_H_