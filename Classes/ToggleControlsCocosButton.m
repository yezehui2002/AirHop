//
//  ToggleControlsCocosButton.m
//  AirHop
//
//  Created by Mario Gonzalez on 3/20/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

#import "ToggleControlsCocosButton.h"


@implementation ToggleControlsCocosButton

- (id) init
{
	self = [super init];
	if (self != nil) {
		//
	}
	return self;
}

- (void)onEnter
{
//	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
//	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}	



#pragma mark -
#pragma mark Touch Handling
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
	CGPoint point = [touch locationInView: [touch view]];
	point  = [[CCDirector sharedDirector] convertToGL:point];
	
	NSLog(@"NodeSpace: %@ | ViewSpace: %@ | ContainsPoint: %i", NSStringFromCGPoint(point), NSStringFromCGPoint([touch locationInView: [touch view]]), CGRectContainsPoint([self boundingBox], point) );
	
	if( CGRectContainsPoint([self boundingBox], point ) == NO ) {
		return NO;
	}
	
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{	
	CGPoint point = [touch locationInView: [touch view]];
	point  = [[CCDirector sharedDirector] convertToGL:point];
	
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSLog(@"Touch ended!");
//	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBaseObjectWasSelected object:self];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self ccTouchEnded:touch withEvent:event];
}


- (void) dealloc
{
	[super dealloc];
}

@end
