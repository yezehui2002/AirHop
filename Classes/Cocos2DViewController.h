//
//  Cocos2DViewController.h
//  AirHop
//
//  Created by Mario Gonzalez on 3/18/11.
//  Copyright 2011 Ogilvy & Mather. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelloWorldLayer.h"

@protocol CocosViewControllerDelegateProtocol <NSObject>
-(void) toggleControls;
@optional
-(BOOL) canChangeToolbarButtons;
-(BOOL) shouldChangeToolbarButtonsTo:(NSMutableArray*)arrayOfBarButtonItems;
@end

@interface Cocos2DViewController : UIViewController 
{
	// DATA
	CGRect				_cocosFrame;
	// Objects
	HelloWorldLayer*	_currentLayer;
	id<CocosViewControllerDelegateProtocol> delegate_;
}

@property(nonatomic, retain) HelloWorldLayer* _currentLayer;
@property(nonatomic, assign) id<CocosViewControllerDelegateProtocol> delegate;

-(void) initCocos2DWithFrame:(CGRect)aFrame;
@end
