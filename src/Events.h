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

#import <Cocoa/Cocoa.h>

namespace ofxBonjour {
    class ofxBonjourEvents {
    public:
        ofEvent<Service> onServiceDiscovered;
        ofEvent<NSNetService*> onServiceRemoved;
        ofEvent<vector<NSNetService*> > onServicesDiscovered;
    };
    
    ofxBonjourEvents & Events();
}
