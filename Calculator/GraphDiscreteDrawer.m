//
//  CalculatorDiscreteDrawer.m
//  Calculator
//
//  Created by Łukasz Przytuła on 18.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "GraphDiscreteDrawer.h"

@implementation GraphDiscreteDrawer

@synthesize dataSource;

- (void)drawInRect:(CGRect)bounds originAtPoint:(CGPoint)axisOrigin scale:(CGFloat)scale onGraph:(CalculatorGraphView *)graph
{
	CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGFloat contentScaleFactor = [[[UIApplication sharedApplication] keyWindow] contentScaleFactor];
  CGFloat pixelSize = 1.0f / contentScaleFactor;
  CGFloat incrementationValue = (bounds.size.width / scale) / (bounds.size.width * contentScaleFactor);
  for (CGFloat x = -axisOrigin.x / scale;
       x < (bounds.size.width - axisOrigin.x) / scale;
       x += incrementationValue) {
    CGFloat y = [self.dataSource graph:graph yValueForX:x];
    CGContextFillRect(context, CGRectMake(x * scale + axisOrigin.x,
                                                 axisOrigin.y - y * scale,
                                                 pixelSize, pixelSize));
  }
  
	UIGraphicsPopContext();
}

@end
