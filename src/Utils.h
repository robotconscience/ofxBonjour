//
//  Utils.h
//  bonjourServer
//
//  Created by Brett Renfer on 7/1/12.
//  Copyright (c) 2012 Robotconscience. All rights reserved.
//

#include <cstdlib>
#include <string>
#include <cstring>

#pragma once
#import <Cocoa/Cocoa.h>

static NSString * toNSString( std::string s ){
    return  [NSString stringWithCString:s.c_str()];
};