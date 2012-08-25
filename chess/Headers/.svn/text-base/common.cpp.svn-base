
#include <iostream>
#include <fstream>
#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h> 

using namespace std;

static FILE* g_log_file = NULL;
#define LOG_PATH "/sdcard/chesslog.txt"
void _my_log(const ostringstream &os)
{
	g_log_file = fopen(LOG_PATH, "a+");
	if(!g_log_file)
		g_log_file = stdout;

	struct   timeval   time; 
	gettimeofday(&time,0); 
	string str = os.str();
	const char* p  = str.c_str();
	fprintf(g_log_file,"[%d ms] -- %s",time.tv_usec/1000,p);
	fprintf(g_log_file, "\n");
	fclose(g_log_file);
}