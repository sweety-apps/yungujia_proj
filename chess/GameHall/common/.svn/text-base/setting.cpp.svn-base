// onfigure1.cpp: implementation of the Configure class.
//
//////////////////////////////////////////////////////////////////////


#include "setting.h"

#include<iostream>
#include "utility.h"
using namespace std;

const DWORD buf_len = 256*1024;

setting *setting::_instance = NULL;

setting_map setting::_download_cfg;
std::string setting::_setting_filename = "configure.ini";

bool setting::_is_show_output_to_gui = false;
bool setting::_is_ignore_user_set_speed = false;
bool setting::_is_diagnose_mode = false;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

setting::setting() 
	: _ysh_version("5.0.0.72"), _product_flag(4), _partner_id("0000"), 
	  _product_release_id(0)
{

}

setting::~setting()
{
}

void setting::set_setting_filename(const string &filename)
{
	_setting_filename = filename;
	 init();
	 setting * sets = get_instance();
#ifdef _DEBUG
	_is_show_output_to_gui = TRUE;
#else
	_is_show_output_to_gui = (sets->get_bool("debug", "show_output_to_gui", FALSE) == FALSE);
#endif
    _is_ignore_user_set_speed = (sets->get_bool("debug", "ignore_user_set_speed", FALSE) == FALSE);

#ifdef RECORD_LOG
	_is_diagnose_mode = (sets->get_bool("debug", "is_diagnose_mode", FALSE) == FALSE);
#else
	_is_diagnose_mode = false;
#endif
}

setting *setting::get_instance()
{
	if( _instance == NULL )
	{
		_instance = new setting();
	}
	return _instance;
}

void setting::close()
{
	if( _instance != NULL )
	{
		delete _instance;
		_instance = NULL;
	}
}

void setting::init()
{
	/*
	char section_buf[buf_len];	
	char item_buf[buf_len];
	char *section_ptr = section_buf;
	char *item_ptr;
	std::string key;
	std::string item;
	std::string value;
	unsigned pos;
	DWORD len;
    len = ::GetPrivateProfileSectionNames( section_buf, buf_len, _setting_filename.c_str() );	
	while ( *section_ptr != '\0' )
	{
        len = ::GetPrivateProfileSection( section_ptr, item_buf, buf_len, _setting_filename.c_str() );
		item_ptr = item_buf;
		while ( *item_ptr != '\0' )
		{
			key = section_ptr;
			item = item_ptr;
			pos = (unsigned)item.find('=');
			key.append(item, 0, pos);
			value.assign(item, pos+1, item.size()-pos);
			_download_cfg.insert( std::pair<std::string, std::string>(key, value) );
			item_ptr += strlen(item_ptr)+1;
		}
		section_ptr += strlen(section_ptr)+1;
	}
	*/
}

std::string setting::get_string(const std::string& section, 
		const std::string& entry, const std::string& default_str )
{
    scoped_lock scoped_lock(_mutex);
	setting_map::iterator it = _download_cfg.find(section+entry);
	if ( it == _download_cfg.end() )
	{
		return default_str;
	}
	else
	{
		return (*it).second;
	}
}

void setting::set_string(const std::string& section, const std::string& entry, 
		const std::string& value)
{
    scoped_lock scoped_lock(_mutex);
	_download_cfg[section+entry] = value;

	// TODO
	//BOOL resutl = ::WritePrivateProfileString( section.c_str(), entry.c_str(),
	//	value.c_str(), _setting_filename.c_str() );
}

int setting::get_int(const std::string& section, const std::string& entry,
		int default_int )
{
    scoped_lock scoped_lock(_mutex);
	setting_map::iterator it = _download_cfg.find(section+entry);
	if ( it == _download_cfg.end() )
	{
		return default_int;
	}
	else
	{
        return utility::str2long((*it).second);
	}
}

void setting::set_int(const std::string& section, const std::string& entry,
		int value )
{
    std::string value_str = utility::long2str( value );
    scoped_lock scoped_lock(_mutex);
    _download_cfg[section+entry] = value_str;
    // TODO
	//BOOL resutl = ::WritePrivateProfileString( section.c_str(), entry.c_str(),
	//	value_str.c_str(), _setting_filename.c_str() );
}

BOOL setting::get_bool(const std::string& section, const std::string& entry, 
		BOOL default_bool )
{
    scoped_lock scoped_lock(_mutex);
	setting_map::iterator it = _download_cfg.find(section+entry);
	if ( it == _download_cfg.end() )
	{
		return default_bool;
	}
	else
	{
        if (utility::str2long((*it).second) == 0)
            return FALSE;
        else
            return TRUE;
	}
}

void setting::set_bool(const std::string& section, const std::string& entry, 
		BOOL value)
{
    string value_str = utility::long2str( value );
	scoped_lock scoped_lock(_mutex);
    _download_cfg[section+entry] = value_str;

    // TODO
	//BOOL resutl = ::WritePrivateProfileString( section.c_str(), entry.c_str(),
	//	value_str.c_str(), _setting_filename.c_str() );
}

std::string setting::get_ysh_version()
{
	return _ysh_version;
}

void setting::set_ysh_version( const std::string& ysh_version )
{
	_ysh_version = ysh_version;
}

std::string setting::get_partner_id()
{
	return _partner_id;
}

void setting::set_partner_id( const std::string& partner_id )
{
	_partner_id = partner_id;
}

// 0x0004 ysh 0x0002 mini 0x0008 yahoo_mini
unsigned long setting::get_product_flag()
{
	return _product_flag;
}

bool setting::set_product_flag( unsigned long product_flag )
{
	if(-1 != product_flag)
	{
		_product_flag = product_flag;
		return true;
	}
	else
	{
		return false;
	}
}

unsigned long setting::get_product_release_id()
{
	return _product_release_id;
}

std::map<std::string, std::string> setting::get_plugin_list()
{
	return _plugin_list;
}

void setting::set_plugin_id(const std::string &plugin_id, const std::string &plugin_version)
{
	_plugin_list[plugin_id] = plugin_version;
}
