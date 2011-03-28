//
//  UntitledViewController.m
//  Untitled
//
//  Created by Mario Gonzalez on 3/17/11.
//  Copyright 2011 Ogilvy & Mather. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController
@synthesize _toolbar, _cocosViewController;


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 
	 Cocos2DViewController* aCocosViewController = [[Cocos2DViewController alloc] initWithNibName:nil bundle:nil];
	 self._cocosViewController = aCocosViewController;
	 [aCocosViewController release];
	 
	 [self.view addSubview: aCocosViewController.view];
	 [aCocosViewController initCocos2DWithFrame: aCocosViewController.view.frame ];
 }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"TouchesBegan %@", [touches anyObject] );
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touchesMoved %@", [touches anyObject] );
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touchesEnded %@", [touches anyObject] );
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touchesCancelled %@", [touches anyObject] );
}


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	 
	 BOOL shouldRotate = (interfaceOrientation == UIInterfaceOrientationPortrait);
	 NSLog(@"ShouldRotate %i | %i", shouldRotate, interfaceOrientation);
	 
	 return shouldRotate;
 }

-(IBAction) redrawGrid {
	[self._cocosViewController._currentLayer debugCreatePerlinGrid];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
