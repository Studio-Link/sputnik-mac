//
//  CallButton.m
//  sputnik
//
//  Created by andi on 27.03.16.
//  Copyright © 2016 Studiolink. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "CallButton.h"

@implementation CallButton

- (id) initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    self.wantsLayer = YES;
  }
  return self;
}

-(void)setCallState:(NSInteger)value
{
  [self willChangeValueForKey:@"callState"];
  if (_callState != value) {
    _callState = value;
    [self.layer removeAllAnimations];
    switch(_callState) {
      case 0: // ready
        self.image = [NSImage imageNamed:@"phone-pickup.pdf"];
        self.alternateImage = [NSImage imageNamed:@"phone-pickup-alternative.pdf"];
        break;
      case 1: // calling
        self.image = [NSImage imageNamed:@"phone-pickup.pdf"];
        self.alternateImage = [NSImage imageNamed:@"phone-pickup-alternative.pdf"];
        [self setAnimation];
        break;
      case 2: // call connected
        self.
        self.image = [NSImage imageNamed:@"phone-hangup.pdf"];
        self.alternateImage = [NSImage imageNamed:@"phone-hangup-alternative.pdf"];
        break;
      default:
        break;
    }
    self.needsDisplay = YES;
  }
  [self didChangeValueForKey:@"callState"];
}

- (void)setAnimation
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  [animation setFromValue:@1.0];
  [animation setToValue:@0.5];
  [animation setDuration:0.8f];
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [animation setAutoreverses:NO];
  [animation setRepeatCount:HUGE_VALF];
  [self.layer addAnimation:animation forKey:@"opacity"];

  animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  [animation setFromValue:@1.0];
  [animation setToValue:@1.1];
  [animation setDuration:0.5f];
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [animation setAutoreverses:NO];
  [animation setRepeatCount:HUGE_VALF];
  [self.layer addAnimation:animation forKey:@"scale"];

  [self.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
  [self.layer setAffineTransform:CGAffineTransformMakeTranslation(self.frame.size.width / 2, self.frame.size.height / 2)];

}

@end
