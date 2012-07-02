#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    ofAddListener(ofxBonjour::Events().onServicesDiscovered, this, &testApp::discoveredServices);
    bonjourClient.discover("_ecs._tcp.");
}

//--------------------------------------------------------------
void testApp::update(){

}

//--------------------------------------------------------------
void testApp::draw(){

}

//--------------------------------------------------------------
void testApp::keyPressed(int key){}

//--------------------------------------------------------------
void testApp::keyReleased(int key){}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y){}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){}

//--------------------------------------------------------------
void testApp::discoveredServices( vector<NSNetService*> & services ){
    for (int i=0; i<services.size(); i++){
        cout<< [services[i].description cStringUsingEncoding:NSUTF8StringEncoding] << endl;
    }
}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){ }