#ifndef __STUDIO_LINK_H_INCL__
#define __STUDIO_LINK_H_INCL__

#if defined _M_IX86
#error "unsupported target (x86)"
#endif

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#ifdef _WIN64
#pragma pack(push, 8)
#endif // #ifdef _WIN64 

extern "C" {

typedef enum _tagSTDUIO_LINK_CONNECTION_STATUS {
    CONNECTING,
    CONNECTED,
    DISCONNECTING,
    DISCONNECTED,
    INVALID_CONNECTION_STATUS,
    MAX_CONNECTION_STATUS = INVALID_CONNECTION_STATUS
} STUDIO_LINK_CONNECTION_STATUS;

typedef void(*STUDIO_LINK_STATUS_CALLBACK)(
    const char* device,
    const size_t deviceLength,
    const STUDIO_LINK_CONNECTION_STATUS status);

typedef void(*STUDIO_LINK_LEVEL_CALLBACK)(
    const char* device,
    const size_t deviceLength,
    const float level);

#define STUDIO_LINK_DEVICE_NAME_LENGTH 256

typedef struct _tagSTUDIO_LINK_DEVICE {
    int32_t version;
    char name[STUDIO_LINK_DEVICE_NAME_LENGTH];
    uint32_t channelCount;
    double sampleRate;
    bool mono;
} STUDIO_LINK_DEVICE;

#define STUDIO_LINK_REMOTE_ID_LENGTH 32
#define STUDIO_LINK_LOCAL_ID_LENGTH 32

typedef struct _tagSTUDIO_LINK_CONNECTION {
    int32_t version;
    STUDIO_LINK_DEVICE incoming; // speaker/headphone
    STUDIO_LINK_DEVICE outgoing; // microphone
    char localId[STUDIO_LINK_REMOTE_ID_LENGTH];
    char remoteId[STUDIO_LINK_LOCAL_ID_LENGTH];
    STUDIO_LINK_STATUS_CALLBACK statusCallback;
    STUDIO_LINK_LEVEL_CALLBACK levelCallback;
} STUDIO_LINK_CONNECTION;

bool StudioLinkConnect(const STUDIO_LINK_CONNECTION* connectionParameters);

bool StudioLinkGetLocalId(char* localId, const size_t localIdLength);

void StudioLinkDisconnect();

typedef enum _tagSTDUIO_LINK_DEVICE_TYPE {
    MICROPHONE,
    HEADPHONE,
    INVALID_DEVICE_TYPE,
    MAX_DEVICE_TYPE = INVALID_DEVICE_TYPE
} STUDIO_LINK_DEVICE_TYPE;
    
#define STUDIO_LINK_MAX_DEVICE_COUNT 32

typedef struct _tagSTUDIO_LINK_DEVICE_LIST {
    int32_t version;
    STUDIO_LINK_DEVICE devices[STUDIO_LINK_MAX_DEVICE_COUNT];
    size_t deviceCount;
} STUDIO_LINK_DEVICE_LIST;

bool StudioLinkEnumBuiltinDevices(const STUDIO_LINK_DEVICE_TYPE deviceType, STUDIO_LINK_DEVICE_LIST* devices);

} // extern "C"

#ifdef _WIN64
#pragma pack(pop)
#endif // #ifdef _WIN64 

#endif // #ifndef __STUDIO_LINK_H_INCL__
