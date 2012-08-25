// onfigure1.h: interface for the Configure class.
//must support multi-thread
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ONFIGURE1_H__C98615AD_6DF5_4F69_92AE_BE46B4D3DDFF__INCLUDED_)
#define AFX_ONFIGURE1_H__C98615AD_6DF5_4F69_92AE_BE46B4D3DDFF__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#pragma warning(disable:4786)
#include <map>
#include <string>
#include "common.h"
#include "mutex.h"

typedef std::map<std::string, std::string> setting_map;

class setting  
{
public:
	static setting * get_instance();
	static void close();
	static void set_setting_filename(const std::string& filename);
	
	std::string get_string(const std::string& section, 
		const std::string& entry, const std::string& default_str = "" );
	void set_string(const std::string& section, const std::string& entry, 
		const std::string& value);

	int get_int(const std::string& section, const std::string& entry,
		int default_int = 0);
	void set_int(const std::string& section, const std::string& entry,
		int value );

	BOOL get_bool(const std::string& section, const std::string& entry, 
		BOOL default_bool = FALSE);
	void set_bool(const std::string& section, const std::string& entry, 
		BOOL value);
	
	virtual ~setting();

public:
//	bool is_ping_force_start();

	std::string get_ysh_version();
	void set_ysh_version( const std::string &ysh_version );

	unsigned long get_product_flag();
	bool set_product_flag( unsigned long product_flag );

	unsigned long get_product_release_id();

	std::string get_partner_id();
	void set_partner_id( const std::string &partner_id);

	std::map<std::string, std::string> get_plugin_list();
	void set_plugin_id(const std::string &plugin_id, const std::string &plugin_version);
	
    static bool	_is_show_output_to_gui;
    static bool _is_ignore_user_set_speed; // 在速度低的时候不管是不是用户限制了速度
	static bool	_is_diagnose_mode;

private:
	static void init();
	setting();	

	static setting *   _instance;
	static std::string _setting_filename;

	mutex         _mutex;
	unsigned long _product_flag;
	unsigned long _product_release_id;
	std::string   _ysh_version;
	std::string   _partner_id;

	std::map<std::string, std::string> _plugin_list;
	
	static setting_map _download_cfg;
};

#endif // !defined(AFX_ONFIGURE1_H__C98615AD_6DF5_4F69_92AE_BE46B4D3DDFF__INCLUDED_)
