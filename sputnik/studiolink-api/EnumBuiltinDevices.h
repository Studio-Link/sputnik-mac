#ifndef __STUDIO_LINK_ENUM_BUILTIN_DEVICES_H_INCL__
#define __STUDIO_LINK_ENUM_BUILTIN_DEVICES_H_INCL__

#include "StudioLink.h"

#ifdef _WIN64
bool EnumBuiltinDevices_w64(const uint32_t deviceType, STUDIO_LINK_DEVICE_LIST* devices);
#else
#ifdef __APPLE__
bool EnumBuiltinDevices_osx(const STUDIO_LINK_DEVICE_TYPE deviceType, STUDIO_LINK_DEVICE_LIST* devices);
#endif // #ifdef __APPLE__
#endif // #ifdef _WIN64

#ifdef _WIN64 
#define EnumBuiltinDevices EnumBuiltinDevices_w64
#else
#ifdef __APPLE__
#define EnumBuiltinDevices EnumBuiltinDevices_osx
#endif // #ifdef __APPLE__
#endif // #ifndef _WIN64

#endif // #ifndef __STUDIO_LINK_ENUM_BUILTIN_DEVICES_H_INCL__
