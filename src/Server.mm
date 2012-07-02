//
//  Server.mm
//  bonjourServer
//
//  Created by Brett Renfer on 7/1/12.
//  Copyright (c) 2012 Robotconscience. All rights reserved.
//

#include "Server.h"

@implementation ServerController

-(void)startService:(NSString*)type name:(NSString*)name port:(int)port domain:(NSString*)domain {
    NSLog(@"type is %@", type);
    NSLog(@"name is %@", name);
    NSLog(@"domain is %@", domain);
    NSLog(@"port is %d", port);
    netService = [[NSNetService alloc] initWithDomain:@"" type:type name:@"" port:port];
    netService.delegate = self;
    [netService publish];
}

-(void)stopService {
    [netService stop];
    [netService release]; 
    netService = nil;
}

-(void)dealloc {
    [self stopService];
    [super dealloc];
}

#pragma mark Net Service Delegate Methods
-(void)netService:(NSNetService *)aNetService didNotPublish:(NSDictionary *)dict {
    NSLog(@"Failed to publish: %@", dict);
}

- (void)netServiceDidPublish:(NSNetService *)sender {
    NSLog(@"Successful publish");
}

@end

namespace ofxBonjour {
    
    Server::Server(){
        bServiceRunning = false;
        controller = [[ServerController alloc] init];
    }
    
    Server::~Server(){
        [controller dealloc];
    }
    
    
    void Server::startService( string type, string name, int port, string domain ){
        if ( bServiceRunning ){
            stopService();
        }
        bServiceRunning = true;
        [controller startService:toNSString(type) name:toNSString(name) port:port domain:toNSString(domain)];
    }
    
    
    void Server::stopService(){
        if ( bServiceRunning ){
            [controller stopService];
            bServiceRunning = false;
        }
    }
};