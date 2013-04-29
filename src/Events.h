//
//  Events.h
//  bonjourServer
//
//  Created by Brett Renfer on 7/2/12.
//  Copyright (c) 2012 Robotconscience. All rights reserved.
//

#pragma once

#include "ofEvents.h"
#include "Utils.h"

#if defined( __APPLE_CC__)
#include <TargetConditionals.h>

#if (TARGET_OS_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE) || (TARGET_IPHONE)
#else

#import <Cocoa/Cocoa.h>
#endif
#endif

namespace ofxBonjour {
    class ofxBonjourEvents {
    public:
        ofEvent<Service> onServiceDiscovered;
        ofEvent<NSNetService*> onServiceRemoved;
        ofEvent<vector<NSNetService*> > onServicesDiscovered;
    };
    
    ofxBonjourEvents & Events();
}
