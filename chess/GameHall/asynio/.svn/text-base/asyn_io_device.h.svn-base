// asyn_io_device.h: interface for the asyn_io_device class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ASYN_IO_DEVICE_H__D3445107_E469_4399_9066_8A250003E573__INCLUDED_)
#define AFX_ASYN_IO_DEVICE_H__D3445107_E469_4399_9066_8A250003E573__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class asyn_io_operation;
//////////////////////////////////////////////////////////////////////
class asyn_io_device  
{
public:
	asyn_io_device();
	virtual ~asyn_io_device();

public:
	virtual bool read(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos = 0) = 0;
	virtual bool read_all(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos = 0) = 0;

	virtual bool write(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos = 0) = 0;
	virtual bool write_all(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos = 0) = 0;
	virtual void close() = 0;

	virtual void do_operation(int events) = 0;

public:
};

typedef struct
{
	asyn_io_device *device_ptr;
	asyn_io_operation *operation_ptr;
	unsigned expected_bytes;
	unsigned buffer_pos;
} operation_node;

#endif // !defined(AFX_ASYN_IO_DEVICE_H__D3445107_E469_4399_9066_8A250003E573__INCLUDED_)
