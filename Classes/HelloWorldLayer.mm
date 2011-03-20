//
//  HelloWorldLayer.mm
//  AirHop
//
//  Created by Mario Gonzalez on 3/17/11.
//  Copyright Ogilvy & Mather 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize _batch;
@synthesize _noise;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;

		cPerlinOctaves		= 4;
		cPerlinFrequency	= 0.05f;
		cPerlinPersistence	= 0.2f;
		
		
		
//		[self setupNoise];
	}
	return self;
}

-(void) setupNoise
{
	_msaNoise = new MSA::Perlin( 4, 2, 0.5, 1 ); 
//	_msaNoise->setup( );
//				void setup(int octaves = 4, float freq = 2, float amp = 0.5f, int seed = 1);
	// Initialize SKMathPerlin instance
	SKMathPerlin *perlin = [[SKMathPerlin alloc] init];
	[perlin setOctaves:cPerlinOctaves];
	[perlin setFrequency:cPerlinFrequency];
	[perlin setPersistence:cPerlinPersistence];
	
	self._noise = perlin;
	[perlin release];
	
	// Generate 2D noise map
	NSUInteger x, z;
	for (x = 0; x < cMapWidth; x++) 
	{
		for (z = 0; z < cMapHeight; z++) 
		{
			map[x][z] = [perlin perlinNoise2DX:x Y:z];
			
//			if(x == 100) {
//				NSLog(@"z: %f", map[x][z]);
//			}
		}
	}
}

-(void) setupBox2DWithFrame:(CGRect)aFrame
{
	// Define the gravity vector.
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	
	// Do we want to let bodies sleep?
	// This will speed up the physics simulation
	bool doSleep = true;
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	world = new b2World(gravity, doSleep);
	
	world->SetContinuousPhysics(true);
	
	// Debug Draw functions
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
	//		flags += b2DebugDraw::e_jointBit;
	//		flags += b2DebugDraw::e_aabbBit;
	//		flags += b2DebugDraw::e_pairBit;
	//		flags += b2DebugDraw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2PolygonShape groundBox;		
	
	// bottom
	groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(aFrame.size.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.SetAsEdge(b2Vec2(0,aFrame.size.height/PTM_RATIO), b2Vec2(aFrame.size.width/PTM_RATIO,aFrame.size.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.SetAsEdge(b2Vec2(0,aFrame.size.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.SetAsEdge(b2Vec2(aFrame.size.width/PTM_RATIO,aFrame.size.height/PTM_RATIO), b2Vec2(aFrame.size.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) initializeWorldWithFrame:(CGRect)aFrame
{
	CCLOG(@"Screen width %0.2f screen height %0.2f",aFrame.size.width, aFrame.size.height);
	[self setupBox2DWithFrame:aFrame];
	[self debugCreatePerlinGrid];
	[self schedule: @selector(tick:)];
}

-(void) debugCreatePerlinGrid
{
//	self._sheet = [CCSpriteSheet spriteSheetWithFile:@"boid.png" capacity:201];
////	self.isTouchEnabled = YES;
////	self._currentTouch = CGPointZero;
//	[self addChild:_sheet z:0 tag:0];
	
	cPerlinFrequency += 0.001f;
	[self setupNoise];
	[self removeAllChildrenWithCleanup:YES];
	
	//Set up sprite
	CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:150];
	[self addChild:batch z:0 tag:kTagBatchNode];
	[_batch setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE}];
	self._batch = batch;
	
	// Create a grid, scale each sprite based on noise
	NSUInteger x,z;
	NSUInteger spacing = 20;
	NSUInteger anIterator = 0;
	
	/*
	 _msaNoise->get(0.4f);
	 */
	for (x = 0; x < cMapWidth; x+=spacing) 
	{
		for (z = 0; z < cMapHeight; z+=spacing) 
		{
			// Create a new sprite
			CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
			
			// We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is just randomly picking one of the images
			int idx =  0;//(CCRANDOM_0_1() > .5 ? 0:1);
			int idy = 0;//(CCRANDOM_0_1() > .5 ? 0:1);
			CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
			[batch addChild:sprite];
			[sprite setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE}];

			
//			CCSprite *sprite = [CCSprite spriteWithFile:@"balloon.png"];
//			[self addChild:sprite];
			
			// Position at X,Y + a magic number buffer
			sprite.position = ccp( x+sprite.contentSize.width*0.5, z );
			sprite.tag = anIterator;
			
//			CGFloat noiseAtPosition = map[x][z];
			//CGFloat noiseAtPosition = [_noise perlinNoise2DX:x Y:z];
			float noiseAtPosition = _msaNoise->get(x, z, 0.1f);
			noiseAtPosition = (noiseAtPosition + _msaNoise->mAmplitude*0.5) / _msaNoise->mAmplitude;	// Normalize noise
			
			//if(x == 0) {
			//	NSLog(@"z: %f", noiseAtPosition);
			//}
			
			sprite.color = ccc3( cos(noiseAtPosition * M_PI) * 255, sin(noiseAtPosition * M_PI) * 255, noiseAtPosition * 255 );
			sprite.scale = noiseAtPosition;
			anIterator++;
		}
	}
}


-(void) draw
{
	glBlendFunc(GL_ONE, GL_ONE);
	// Default GL sbttates: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}

-(void) addNewSpriteWithCoords:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	
//	CCSprite* aSprite = [CCSprite spriteWithFile:@"balloon.png"];
//	[self addChild: aSprite];
//	
//	return;
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[batch addChild:sprite];
	
	sprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;

	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
}



-(void) tick: (ccTime) dt
{
	
	
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
	
	
	// UPDATE PERLIN
	static float zVar = 0.0;
	static float zprimeVar = 0.0f;
	zVar += 0.02;
	
	
	
	NSUInteger x,z;
	NSUInteger spacing = 20;
	NSUInteger anIterator = 0;
	for (x = 0; x < cMapWidth; x+=spacing) 
	{
		for (z = 0; z < cMapHeight; z+=spacing) 
		{
			zprimeVar += 0.00007;
			//			// Create a new sprite
			//			CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
			
			//			// We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is just randomly picking one of the images
			//			int idx = (CCRANDOM_0_1() > .5 ? 0:1);
			//			int idy = (CCRANDOM_0_1() > .5 ? 0:1);
			CCSprite *sprite = (CCSprite*) [_batch getChildByTag:anIterator];
			//			[batch addChild:sprite];
			//			
			// Position at X,Y + a magic number buffer
//			sprite.position = ccp( x, z );
//			sprite.tag = anIterator;
			
			float downScale = 0.002f;
			float noiseAtPosition = _msaNoise->get(x*downScale + zVar, z*downScale, zprimeVar);
			noiseAtPosition = (noiseAtPosition + _msaNoise->mAmplitude*0.5) / _msaNoise->mAmplitude;	// Normalize noise
			
//			if(x == 0) {
//				NSLog(@"z: %f", noiseAtPosition);
//			}
			
			sprite.scale = 0.1 + noiseAtPosition * 2.5;
			
			noiseAtPosition *= 3;
			//sin( position.x * position.y + time / 3.0 
			float blue = sin(x*downScale + z*downScale * zVar / 2);
			if(blue < 0) blue *= -1;
			
			
			sprite.color = ccc3( fabs(cos(noiseAtPosition)) * 255, fabs(sin(noiseAtPosition)) * 255,  blue * 255);
			anIterator++;
		}
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		[self addNewSpriteWithCoords: location];
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	world->SetGravity( gravity );
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	self._noise = nil;
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
