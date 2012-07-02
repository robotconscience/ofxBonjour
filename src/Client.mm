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
@property (readwrite, assign) BOOL isConnected;
@property (readwrite, retain) NSNetService *connectedService;
@property (readwrite) Client * clientRef;

@end

@implementation ClientController

@synthesize browser;
@synthesize services;
@synthesize isConnected;
@synthesize connectedService;
@synthesize clientRef;


-(void)dealloc {
    self.connectedService = nil;
    self.browser = nil;
    [services release];
    [super dealloc];
}


-(void)setup:(Client*) client {
    services = [NSMutableArray new];
    self.browser = [[NSNetServiceBrowser new] autorelease];
    self.browser.delegate = self;
    self.isConnected = NO;
    self.clientRef = NULL;
    
    self.clientRef = client;
}

-(void)search:(NSString*) type domain:(NSString *) domain {
    NSLog(@"Searching %@", type);
    [self.browser searchForServicesOfType:type inDomain:domain];
}

-(void)connect:(NSNetService*) remoteService {
    remoteService.delegate = self;
    [remoteService resolveWithTimeout:0];
}

#pragma mark Net Service Browser Delegate Methods
-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more {
    [services addObject:aService];
    
    if ( self.clientRef != NULL ){
        self.clientRef->_onServiceDiscovered(aService);
        if ( more == NO ){
            self.clientRef->_onServicesDiscovered();
        }
    }
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more {
    [services removeObject:aService];
    if ( aService == self.connectedService ) self.isConnected = NO;
    if ( self.clientRef != NULL ){
        self.clientRef->_onServiceRemoved(aService);
    }
}

-(void)netServiceDidResolveAddress:(NSNetService *)service {
    self.isConnected = YES;
    self.connectedService = service;
    NSLog(@"Totally connected to service at %@", service.hostName);
}

-(void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"Could not resolve: %@", errorDict);
}

@end

namespace ofxBonjour {
    
    
    Client::Client(){
        cout<<"wot"<<endl;
        controller = [[ClientController alloc] init];
        [controller setup:this];
        bDiscovering = false;
    }
    
    Client::~Client(){
        [controller dealloc];
        bDiscovering = false;
    }
    
    void Client::discover( string type, string domain ){
        if ( bDiscovering ){
            ofLog(OF_LOG_ERROR, "Still discovering, please wait");
            return;
        }
        bDiscovering = true;
        [controller search:toNSString(type) domain:toNSString(domain)];
    }
    
    // called when finished discovering
    
    void Client::_onServicesDiscovered(){
        bDiscovering = false;
        services.clear();
        
        for (NSNetService * service in controller.services ){
            services.push_back(service);
        }
        ofNotifyEvent( Events().onServicesDiscovered, services, this);
    }
    
    // called each time we get a service
    
    void Client::_onServiceDiscovered( NSNetService * service ){
        ofNotifyEvent( Events().onServiceDiscovered, service, this); 
    }
    
    void Client::_onServiceRemoved( NSNetService * service ){
        // this is stupid.
        services.clear();
        
        for (NSNetService * aService in controller.services ){
            services.push_back(aService);
        }
        ofNotifyEvent( Events().onServiceRemoved, service, this);
    }
    
}
