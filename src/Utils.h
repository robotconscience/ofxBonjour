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

#import <Cocoa/Cocoa.h>

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