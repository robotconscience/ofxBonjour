//
//  Client.mm
//  bonjourServer
//
//  Created by Brett Renfer on 7/2/12.
//  Copyright (c) 2012 Robotconscience. All rights reserved.
//

#include "ofMain.h"
#include "Events.h"

#import "Client.h"

using namespace ofxBonjour;

@interface ClientController ()

@property (readwrite, retain) NSNetServiceBrowser *browser;
@property (readwrite, retain) NSMutableArray *services;
@property (readwrite) Client * clientRef;

@end

@implementation ClientController

@synthesize browser;
@synthesize services;
@synthesize clientRef;


-(void)dealloc {
    self.browser = nil;
    [services release];
    [super dealloc];
}


-(void)setup:(Client*) client {
    services = [NSMutableArray new];
    self.browser = [[NSNetServiceBrowser new] autorelease];
    self.browser.delegate = self;
    
    self.clientRef = client;
}

-(void)search:(NSString*) type domain:(NSString *) domain {
    NSLog(@"Searching %@", type);
    [self.browser searchForServicesOfType:type inDomain:domain];
}

//---resolve the IP address of a service---
-(void) resolveIPAddress:(NSNetService *)service {    
    NSNetService *remoteService = service;
    remoteService.delegate = self;
    [remoteService resolveWithTimeout:0];
}

#pragma mark Net Service Browser Delegate Methods
-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more {
    [services addObject:aService];
    [self resolveIPAddress:aService];
    
    if ( self.clientRef != NULL ){
        self.clientRef->_onServiceDiscovered(aService);
        if ( more == NO ){
            self.clientRef->_onServicesDiscovered();
        }
    }
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more {
    [services removeObject:aService];
    if ( self.clientRef != NULL ){
        self.clientRef->_onServiceRemoved(aService);
    }
}

-(void)netServiceDidResolveAddress:(NSNetService *)service {
    NSString *name = [service name];
    NSData  *address = nil;
    struct sockaddr_in *socketAddress = nil;
    memset(&socketAddress, 0, sizeof(socketAddress));
    
    NSString *ipString = nil;
    int port;
    
    for(int i=0;i < [[service addresses] count]; i++ ){
        address = [[service addresses] objectAtIndex: i];
        socketAddress = (struct sockaddr_in *) [address
                                                bytes];
        ipString = [NSString stringWithFormat: @"%s", inet_ntoa(socketAddress->sin_addr)];
        port = socketAddress->sin_port;
        //debug.text = [debug.text stringByAppendingFormat:@"Resolved:%@-->%@:%hu\n", [service hostName], ipString, port];
        
        if ( self.clientRef != NULL ){ 
            self.clientRef->_onServiceData(service, [ipString cStringUsingEncoding:NSUTF8StringEncoding], port);
        }
    }
}

-(void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"Could not resolve: %@", errorDict);
}

@end

namespace ofxBonjour {
    
    
    //--------------------------------------------------------------
    Client::Client(){
        controller = [[ClientController alloc] init];
        [controller setup:this];
        bDiscovering = false;
    }
    
    //--------------------------------------------------------------
    Client::~Client(){
        [controller dealloc];
        bDiscovering = false;
    }
    
    //--------------------------------------------------------------
    void Client::discover( string type, string domain ){
        if ( bDiscovering ){
            ofLog(OF_LOG_ERROR, "Still discovering, please wait");
            return;
        }
        bDiscovering = true;
        [controller search:toNSString(type) domain:toNSString(domain)];
    }
    
    //--------------------------------------------------------------
    // called when finished discovering
    void Client::_onServicesDiscovered(){
        bDiscovering = false;
        services.clear();
        
        for (NSNetService * service in controller.services ){
            services.push_back(service);
        }
        ofNotifyEvent( Events().onServicesDiscovered, services, this);
    }
    
    
    //--------------------------------------------------------------
    // called each time we get a service
    void Client::_onServiceDiscovered( NSNetService * service ){
        //ofNotifyEvent( Events().onServiceDiscovered, service, this); 
    }
    
    //--------------------------------------------------------------
    void Client::_onServiceRemoved( NSNetService * service ){
        // this is stupid.
        services.clear();
        
        for (NSNetService * aService in controller.services ){
            services.push_back(aService);
        }
        
        for ( int i=0; i<resolvedServices.size(); i++){
            if ( resolvedServices[i].ref == service ){
                resolvedServices.erase( resolvedServices.begin() + i );
            }
        }
        
        ofNotifyEvent( Events().onServiceRemoved, service, this);
    }
    
    //--------------------------------------------------------------
    // called when we have IP + port info for a service
    void Client::_onServiceData( NSNetService * service, string ipAddress, int port ){
        Service serviceStruct;
        serviceStruct.ref       = service;
        serviceStruct.ipAddress = ipAddress;
        serviceStruct.port      = port;
        serviceStruct.name      = [service.name cStringUsingEncoding:NSUTF8StringEncoding];
        
        resolvedServices.push_back( serviceStruct );
        
        ofNotifyEvent( Events().onServiceDiscovered, serviceStruct, this); 
    }
    
}
