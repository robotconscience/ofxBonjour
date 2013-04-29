//
//  Client.h
//  bonjourServer
//
//  Created by Brett Renfer on 7/2/12.
//  Copyright (c) 2012 Robotconscience. All rights reserved.
//

#pragma once

#if defined( __APPLE_CC__)
    #include <TargetConditionals.h>

    #if (TARGET_OS_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE) || (TARGET_IPHONE)
    #else

        #import <Cocoa/Cocoa.h>
    #endif
#endif
#import <netinet/in.h>
#import <arpa/inet.h>
#include "Utils.h"

namespace ofxBonjour{
    class Client;
}

using namespace ofxBonjour;

@interface ClientController : NSObject {
    NSNetServiceBrowser *browser;
    NSMutableArray *services;
    Client * clientRef;
}

@property (readonly, retain) NSMutableArray *services;

-(void)setup:(Client*) client;
-(void)search:(NSString *)type domain:(NSString *)domain;
-(void)connect:(NSNetService*) remoteService;
-(void) resolveIPAddress:(NSNetService *)service;

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
        
        void _onServiceData(NSNetService * service, string ipAddress, int port);
        
        vector <NSNetService *> getServices(){
            return services;
        }
        
        vector <Service> getResolvedServices(){
            return resolvedServices;
        }
        
    protected:
        ClientController * controller;
        bool bDiscovering;
        vector <NSNetService *> services;
        vector <Service>       resolvedServices;
    };
}