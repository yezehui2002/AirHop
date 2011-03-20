//
//  ToggleControlsCocosButton.h
//  AirHop
//
//  Created by Mario Gonzalez on 3/20/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

#import "cocos2d.h"

@interface ToggleControlsCocosButton : CCSprite <CCTargetedTouchDelegate>
{

}

#pragma mark Methods
// Handle touch events
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;

@end
