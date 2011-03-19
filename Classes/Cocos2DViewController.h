//
//  Cocos2DViewController.h
//  AirHop
//
//  Created by Mario Gonzalez on 3/18/11.
//  Copyright 2011 Ogilvy & Mather. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelloWorldLayer.h"

@interface Cocos2DViewController : UIViewController {
	HelloWorldLayer*	_currentLayer;
}
@property(nonatomic, retain) HelloWorldLayer* _currentLayer;

-(void) initCocos2DWithFrame:(CGRect)aFrame;
@end
