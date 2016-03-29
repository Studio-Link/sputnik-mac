//  Copyright (c) 2013 - 2016, Sebastian Reimers, Andi Pieper - studio-link.de
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "AppDelegate.h"

#import "State.h"
#import "StudioLink.h"
#import "EnumBuiltInDevices.h"
#import "NSWindow+Flipping.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) State *state;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  
  _window.titlebarAppearsTransparent = YES;
  _window.movableByWindowBackground  = YES;
  _window.backgroundColor = [NSColor colorWithCalibratedRed:1 green:1 blue:1 alpha:1.00];
  _window.title = @"";
  
  // we want layers
  [[_window contentView] setWantsLayer:YES];
  
  // create our state object
  self.state = [[State alloc] init];
  // assign state to state controller for bindig ui elements
  [_stateController setContent:_state];

  // bind the level meters to the state levels
  [_inMeter bind:@"avgValue" toObject:_stateController withKeyPath:@"selection.inLevel" options:nil];
  [_outMeter bind:@"avgValue" toObject:_stateController withKeyPath:@"selection.outLevel" options:nil];
  
  // set some call state and other defaults
  self.state.callState = 0;
  self.state.myID = @"ultraschall@studio-link.de";
  self.state.remoteID = @"123456@studio-link.de";
  // set levels (0.0 ... 1.0)
  self.state.inLevel = 0.0;
  self.state.outLevel = 0.0;
  
  // bind the call button to the state
  [_callButton bind:@"callState" toObject:_stateController withKeyPath:@"selection.callState" options:nil];
  
  // set the window background on the layer
  //[[_window contentView] layer].backgroundColor = [NSColor whiteColor].CGColor;
  [[_window contentView] layer].contents = [NSImage imageNamed:@"window-background.pdf"];
  [[_window contentView] layer].contentsGravity = kCAGravityResizeAspectFill;
  
  // enumerate device lists
  self.outputDevicesArrayController.content = [self deviceList:HEADPHONE];
  self.inputDevicesArrayController.content = [self deviceList:MICROPHONE];
  
  // subscribe to the prefs comitted messages
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePrefs:) name:@"commitPrefs" object:nil];
}

-(NSArray*)deviceList:(STUDIO_LINK_DEVICE_TYPE)deviceType
{
  NSMutableArray* ret = [NSMutableArray arrayWithCapacity:64];
  STUDIO_LINK_DEVICE_LIST devices = {0};
  devices.version = 1;
  const bool result = StudioLinkEnumBuiltinDevices(deviceType, &devices);
  if(result == true)
  {
    for(size_t i = 0; i < devices.deviceCount; i++)
    {
      [ret addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithUTF8String:devices.devices[i].name], @"name",
                               [NSNumber numberWithLong:i], @"index",
                               nil]];
    }    
  }
  return ret;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

- (IBAction)prefsClicked:(id)sender
{
  self.prefsController = [[PrefsController alloc] initWithWindowNibName:@"PrefsController"];
  [self.window flipToShowWindow:self.prefsController.window forward:YES];
}

- (IBAction)closePrefs:(id)_notification;
{
  [self.prefsController.window flipToShowWindow:self.window forward:NO];
  self.prefsController = nil;
}

- (IBAction)callButtonClicked:(id)sender {
  [self.state simulateCall];
}

@end
