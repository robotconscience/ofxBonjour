//
//  Server.h
//  bonjourServer
//
//  Created by Brett Renfer on 7/1/12.
//  Copyright (c) 2012 Robotconscience. All rights reserved.
//

#pragma once
#import <Cocoa/Cocoa.h>

@interface ServerController : NSObject  {
    NSNetService *netService;
}

-(void)startService:(NSString*)type name:(NSString*)name port:(int)port domain:(NSString*)domain;
-(void)stopService;

@end

#include "Utils.h"

namespace ofxBonjour {
    using namespace std;

    class Server {
        public:
        
            Server();
            ~Server();
        
            void startService( string type, string name, int port, string domain = "" );
            void stopService();
        
        protected:
            ServerController * controller;
        
        private:
            bool bServiceRunning;
        
    };
};