//
//  INStickyView.m
//  🎉
//
//  Created by Julian Weiss on 6/13/14.
//  Copyright (c) 2014 insanj. All rights reserved.
//

#import "INStickyView.h"

@implementation INStickyView

// Random UIColor generation thanks to kylefox (https://gist.github.com/kylefox/1689973)
+ (UIColor *)randomColor {
	CGFloat hue = (arc4random() % 256 / 256.0);  //  0.0 to 1.0
	CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;  //  0.5 to 1.0, away from white
	CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;  //  0.5 to 1.0, away from black
	
	return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

CGPoint currentTouchLocation, lastTouchLocation;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
   
	if (self) {
        self.backgroundColor = [self.class randomColor]; //[UIColor colorWithWhite:0.123456789 alpha:0.99];
		self.layer.cornerRadius = frame.size.width / 4.0;
		self.layer.shadowColor = [self.class randomColor].CGColor;
		self.layer.shadowOpacity = 0.75;
		self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    }
	
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
	lastTouchLocation = [touch locationInView:self];
	
	CGFloat dampingRatio = self.frame.size.width;
	dampingRatio /= fmax(100.0 * [@(self.frame.size.width) stringValue].length, 1.0);
	NSLog(@"%f", dampingRatio);
	
	[UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:dampingRatio initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
		self.backgroundColor = [self.class randomColor];
	} completion:nil];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
	currentTouchLocation = [touch locationInView:self];
	
	CGPoint touchDelta = CGPointMake(lastTouchLocation.x - currentTouchLocation.x, lastTouchLocation.y - currentTouchLocation.y);
	self.center = CGPointMake(self.center.x - touchDelta.x, self.center.y - touchDelta.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touchDelta = CGPointMake(lastTouchLocation.x - currentTouchLocation.x, lastTouchLocation.y - currentTouchLocation.y);

	[UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.1 initialSpringVelocity:fmax(touchDelta.x, touchDelta.y) options:UIViewAnimationOptionCurveEaseOut animations:^(void){
		self.center = CGPointMake(self.center.x - touchDelta.x, self.center.y - touchDelta.y);
	} completion:^(BOOL finished) {
		if (self.center.x > self.superview.frame.size.width || self.center.x < self.superview.frame.origin.x || self.center.y > self.superview.frame.size.height || self.center.y < self.superview.frame.origin.y) {
			[UIView animateWithDuration:0.5 animations:^(void) {
				self.alpha = 0.0;
			} completion:^(BOOL finished) {
				[self removeFromSuperview];
			}];
		}
	}];
}

@end
