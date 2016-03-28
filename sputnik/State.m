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


#import "State.h"

@interface State ()

@property (strong, nonatomic) NSTimer* simulTimer;
@property (strong, nonatomic) NSTimer* levelTimer;

@end


@implementation State

#pragma - simulate UI

-(void)simulateCall
{
  [self.simulTimer invalidate];
  self.simulTimer = nil;
  [self.levelTimer invalidate];
  self.levelTimer = nil;
  self.inLevel = 0;
  self.outLevel = 0;
  self.recordingPossible = NO;
  self.statusText = @"Not connected";
  self.isRecording = NO;

  switch(_callState) {
  case 0:
    self.callState = 1;
    self.statusText = @"Connecting…";
    self.simulTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(simulateConnect:) userInfo:nil repeats:NO];
    break;
  case 1:
  case 2:
    self.callState = 0;
    break;
  default:
    break;
  }
}

-(void) simulateConnect:(id)_timer
{
  self.callState = 2;
  self.statusText = @"Connected";
  self.recordingPossible = YES;
  [self.simulTimer invalidate];
  self.simulTimer = nil;
  self.levelTimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(simulateLevel:) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:self.levelTimer forMode:NSRunLoopCommonModes];
}

-(void) simulateLevel:(id)_timer
{
  if (self.muted) {
    self.inLevel = 0.0;
  } else {
    self.inLevel = self.inLevel - 0.01;
    if(self.inLevel < 0.0) self.inLevel = 1.0;
  }
  self.outLevel = self.outLevel - 0.009;
  if(self.outLevel < 0.0) self.outLevel = 1.0;
}



@end
