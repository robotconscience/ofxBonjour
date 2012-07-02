//
//  Client.h
//  bonjourServer
//
//  Created by Brett Renfer on 7/2/12.
//  Copyright (c) 2012 Robotconscience. All rights reserved.
//

#pragma once

#import <Cocoa/Cocoa.h>
#include "Utils.h"

namespace ofxBonjour{
    class Client;
}

using namespace ofxBonjour;

@interface ClientController : NSObject {
    BOOL isConnected;
    NSNetServiceBrowser *browser;
    NSNetService *connectedService;
    NSMutableArray *services;
    Client * clientRef;
}

@property (readonly, retain) NSMutableArray *services;
@property (readonly, assign) BOOL isConnected;

-(void)setup:(Client*) client;
-(void)search:(NSString *)type domain:(NSString *)domain;
-(void)connect:(NSNetService*) remoteService;

@end

namespace ofxBonjour {
    using namespace std;
    
    class Client {
    public:
        
        Client();
        ~Client();
        
        void discover( string type, string domain = "" );
        
        void _onServicesDiscovered();
        void _onServiceDiscovered( NSNetService * service );
        void _onServiceRemoved( NSNetService * service );
        
        vector <NSNetService *> getServices(){
            return services;
        }
        
    protected:
        ClientController * controller;
        bool bDiscovering;
        vector <NSNetService *> services;
    };
}