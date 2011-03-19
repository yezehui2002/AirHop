//
//  HelloWorldLayer.h
//  AirHop
//
//  Created by Mario Gonzalez on 3/17/11.
//  Copyright Ogilvy & Mather 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "SKMathPerlin.h"

#define cMapWidth 480
#define cMapHeight 320

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	b2World*			world;
	GLESDebugDraw*		m_debugDraw;
	
	SKMathPerlin*		_noise;
	CGFloat				map[cMapWidth][cMapHeight];
}

#pragma mark Properties
@property(nonatomic, retain) SKMathPerlin* _noise;

#pragma mark Methods
-(void) initializeWorldWithFrame:(CGRect)aFrame;
-(void) setupNoise;
-(void) setupBox2DWithFrame:(CGRect)aFrame;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

@end
