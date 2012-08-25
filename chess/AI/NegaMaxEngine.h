// NegaMaxEngine.h: interface for the CNegaMaxEngine class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_NEGAMAXENGINE_H__A34B36C1_E7A6_4353_86D4_199592A72698__INCLUDED_)
#define AFX_NEGAMAXENGINE_H__A34B36C1_E7A6_4353_86D4_199592A72698__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "SearchEngine.h"

//搜索引擎. 使用负极大值方法 由CSearchEngine派生来
class CNegaMaxEngine : public CSearchEngine
{
public:
	CNegaMaxEngine();
	virtual ~CNegaMaxEngine();
	//用以找出给定局面的下一步走法
	virtual void SearchAGoodMove(BYTE position[10][9]);

protected:
	int NegaMax(int depth);	//负极大值搜索引擎

};

#endif // !defined(AFX_NEGAMAXENGINE_H__A34B36C1_E7A6_4353_86D4_199592A72698__INCLUDED_)
