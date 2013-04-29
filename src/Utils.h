//
//  Utils.h
//  bonjourServer
//
//  Created by Brett Renfer on 7/1/12.
//  Copyright (c) 2012 Robotconscience. All rights reserved.
//

#pragma once

#include <cstdlib>
#include <string>
#include <cstring>

#if defined( __APPLE_CC__)
#include <TargetConditionals.h>

#if (TARGET_OS_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE) || (TARGET_IPHONE)
#else

#import <Cocoa/Cocoa.h>
#endif
#endif
static NSString * toNSString( std::string s ){
    return  [NSString stringWithCString:s.c_str()];
};

namespace ofxBonjour {
    struct Service {
        NSNetService *      ref;
        std::string         ipAddress;
        int                 port;
        std::string         name;
    };
}