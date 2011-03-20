//
//  RootViewController.h
//  AirHop
//
//  Created by Mario Gonzalez on 3/17/11.
//  Copyright Ogilvy & Mather 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cocos2DViewController.h"


@interface RootViewController : UIViewController <CocosViewControllerDelegateProtocol>
{
	UIToolbar*					_toolbar;
	Cocos2DViewController*		_cocosViewController;
	
	// State
	BOOL						_isShowingControls;
}
@property(nonatomic, retain) IBOutlet UIToolbar*		_toolbar;
@property(nonatomic, retain) Cocos2DViewController*		_cocosViewController;

// Show or hide the controls - should call toggle and internal mechanism will call either of the accompanying functions
-(void) toggleControls;
-(void) showControls;
-(void) hideControls;

// DEBUG
-(IBAction) redrawGrid;
@end
