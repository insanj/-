//
//  INViewController.m
//  🎉
//
//  Created by Julian Weiss on 6/13/14.
//  Copyright (c) 2014 insanj. All rights reserved.
//

#import "INViewController.h"
#import "INStickyView.h"

@implementation INViewController

#pragma mark - data

- (NSInteger)savedStickyViewAmount {
	NSNumber *lastSavedStickyViewAmount = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"🎉.views"];
	NSInteger currentSavedStickyViewAmount;
	
	if (lastSavedStickyViewAmount) {
		currentSavedStickyViewAmount = [lastSavedStickyViewAmount integerValue];
	}
	
	else {
		currentSavedStickyViewAmount = 10;
	}
	
	NSLog(@"Retrieved saved number of stick views (%i)...", currentSavedStickyViewAmount);
	return currentSavedStickyViewAmount;
}

- (void)saveStickyViewAmount {
	NSInteger currentStickViewAmount = self.view.subviews.count;
	NSLog(@"Saving number of present sticky views (%i)...", currentStickViewAmount);
	[[NSUserDefaults standardUserDefaults] setObject:@(currentStickViewAmount) forKey:@"🎉.views"];
}

#pragma mark - view

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createAndPlaceStickyViewRandomly) name:@"🎉" object:nil];
	
	[self performSelector:@selector(regenerateColors) withObject:nil afterDelay:floorf(((CGFloat)arc4random() / 0x100000000) * 30.0)];
	[self performSelector:@selector(regenerateSizes) withObject:nil afterDelay:floorf(((CGFloat)arc4random() / 0x100000000) * 10.0)];

	NSInteger stickyViewsToCreate = [self savedStickyViewAmount];
	for (int i = 0; i < stickyViewsToCreate; i++) {
		[self createAndPlaceStickyViewRandomly];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	CGSize touchSize = CGSizeMake(50.0, 50.0);
	[self createAndPlaceStickyViewWithRect:(CGRect){[touch locationInView:touch.view], touchSize}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:YES];
	[self regenerateColors];
}

- (void)viewDidDisappear:(BOOL)animated {
	[self saveStickyViewAmount];
	[super viewDidDisappear:animated];
}

#pragma mark - life

- (void)createAndPlaceStickyViewRandomly {
	CGFloat desiredDimensionSize = arc4random_uniform(55.0) + 25.0;
	
	CGFloat randomX = arc4random_uniform(self.view.frame.size.width) - desiredDimensionSize;
	CGFloat randomY = arc4random_uniform(self.view.frame.size.height) - desiredDimensionSize;
	[self createAndPlaceStickyViewWithRect:CGRectMake(randomX, randomY, desiredDimensionSize, desiredDimensionSize)];
}

- (void)createAndPlaceStickyViewWithRect:(CGRect)frame {
	INStickyView *stickyView = [[INStickyView alloc] initWithFrame:frame];
	
	stickyView.center = frame.origin;
	[self.view addSubview:stickyView];
}

- (void)createAndPlaceStickyViewWithRect:(CGRect)frame color:(UIColor *)color {
	INStickyView *stickyView = [[INStickyView alloc] initWithFrame:frame];
	stickyView.backgroundColor = color;
	
	stickyView.center = frame.origin;
	[self.view addSubview:stickyView];
}

- (void)regenerateColors {
	NSLog(@"Regenerating colors...");

	UIView *lastView;
	for (UIView *view in self.view.subviews) {
		if ([view isKindOfClass:[INStickyView class]]) {
			[UIView animateWithDuration:0.25 animations:^(void) {
				view.backgroundColor = [INStickyView randomColor];
			}];
						
			lastView = view;
		}
	}
	
	[UIView animateWithDuration:0.25 animations:^(void) {
		self.view.backgroundColor = lastView.backgroundColor;
	} completion:^(BOOL finished){
		[self performSelector:@selector(regenerateColors) withObject:nil afterDelay:floorf(((CGFloat)arc4random() / 0x100000000) * 30.0)];
	}];
}

- (void)regenerateSizes {
	NSLog(@"Regenerating sizes...");
	
	for (UIView *view in self.view.subviews) {
		if ([view isKindOfClass:[INStickyView class]]) {
			CGFloat desiredDimensionSize = arc4random_uniform(55.0) + 25.0;
			[self createAndPlaceStickyViewWithRect:(CGRect){view.center, CGSizeMake(desiredDimensionSize, desiredDimensionSize)} color:view.backgroundColor];

			[UIView animateWithDuration:0.25 animations:^(void) {
				view.alpha = 0.0;
			} completion:^(BOOL finished) {
				[view removeFromSuperview];
			}];
		}
	}
	
	[self performSelector:@selector(regenerateSizes) withObject:nil afterDelay:floorf(((CGFloat)arc4random() / 0x100000000) * 10.0)];
}

/* - (void)startDequeing {
	if ([queuedAnimationBlocks count] == 0) {
		return;
	}
			
	[UIView animateWithDuration:0.15 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:[queuedAnimationBlocks lastObject] completion:^(BOOL finished) {
		[queuedAnimationBlocks removeLastObject];
		[self startDequeing];
	}];
} */

@end
