
#ifndef _WIN64
#else
#define WIN32_LEAN_AND_MEAN
#define _WIN32_WINNT 0x0A00 
#define STRICT
#include <windows.h>
#endif // #ifndef _WIN64

#include <string.h>

#include "StudioLink.h"
#include "EnumBuiltinDevices.h"

#ifdef __APPLE__
#define UNREFERENCED_PARAMETER(p) ((p) = (p))
#endif // #ifdef __APPLE__

bool StudioLinkConnect(const STUDIO_LINK_CONNECTION* connectionParameters)
{
    UNREFERENCED_PARAMETER(connectionParameters);

    return 0;
}

void StudioLinkDisconnect()
{
}

bool StudioLinkGetLocalId(char* localId, const size_t localIdLength)
{
    bool result = false;

    if((localId != 0) && (localIdLength >= STUDIO_LINK_LOCAL_ID_LENGTH))
    {
        memset(localId, 0, STUDIO_LINK_LOCAL_ID_LENGTH * sizeof(char));
#ifdef _WIN64
        const errno_t status = strncpy_s(localId, STUDIO_LINK_LOCAL_ID_LENGTH, "be81029202", 10);
        if(status == 0)
        {
            result = true;
        }
#else
        strncpy(localId, "be81029202", 10);
        result = true;
#endif // #ifdef _WIN64
    }

    return result;
}

bool StudioLinkEnumBuiltinDevices(const STUDIO_LINK_DEVICE_TYPE deviceType, STUDIO_LINK_DEVICE_LIST* devices)
{
    return EnumBuiltinDevices(deviceType, devices);
}

