//
//  Events.cpp
//  bonjourServer
//
//  Created by Brett Renfer on 7/2/12.
//  Copyright (c) 2012 Robotconscience. All rights reserved.
//

#include "Events.h"

namespace ofxBonjour {
    ofxBonjourEvents & Events (){
        static ofxBonjourEvents * events = new ofxBonjourEvents;
        return * events;
    }
}