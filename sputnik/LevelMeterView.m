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

#import "LevelMeterView.h"


@implementation LevelMeterView

@synthesize peakValue;
@synthesize avgValue;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self initialize];
  }
  return self;
}

-(void) initialize
{
  self.peakValue = 0;
  self.avgValue = 0;
}

- (void)setPeakValue:(Float32)value
{
  [self willChangeValueForKey:@"peakValue"];
  if (peakValue != value) {
    peakValue = value;
    self.needsDisplay = YES;
  }
  [self didChangeValueForKey:@"peakValue"];
}

- (void)setAvgValue:(Float32)value
{
  [self willChangeValueForKey:@"peakValue"];
  if (avgValue != value) {
    avgValue = value;
    self.needsDisplay = YES;
  }
  [self didChangeValueForKey:@"peakValue"];
}

- (void)drawRect:(NSRect)dirtyRect
{
  [super drawRect:dirtyRect];

  NSColor* borderColor = [NSColor blackColor];
  NSBezierPath *border = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.bounds, 0, 0)
                                                         xRadius:0
                                                         yRadius:0];
  [border setLineWidth:0.5];
  [borderColor set];
  [border stroke];
  
  NSColor* fillColor = [NSColor colorWithCalibratedRed:0.214 green:0.770 blue:0.186 alpha:1.00];
  [fillColor setFill];
  CGFloat w;
  if (self.avgValue > 0.0) {
    w = self.bounds.size.width * avgValue;
    NSRect avgRect = NSMakeRect(1, self.bounds.origin.y+1, w-1, self.bounds.size.height-2);
    NSRectFill(avgRect);
  }
  
  fillColor = [NSColor redColor];
  [fillColor setFill];
  if (self.peakValue > 0.0) {
    w = self.bounds.size.width * peakValue;
    NSRect peakRect = NSMakeRect(w-4+1, self.bounds.origin.y+1, 4-1, self.bounds.size.height-2);
    NSRectFill(peakRect);
  }
}

@end
