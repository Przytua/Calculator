//
//  CalculatorLinearDrawer.m
//  Calculator
//
//  Created by Łukasz Przytuła on 18.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "GraphLinearDrawer.h"

@implementation GraphLinearDrawer

@synthesize dataSource;

- (void)drawInRect:(CGRect)bounds originAtPoint:(CGPoint)axisOrigin scale:(CGFloat)scale onGraph:(CalculatorGraphView *)graph
{
	CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGFloat contentScaleFactor = [[[UIApplication sharedApplication] keyWindow] contentScaleFactor];
  CGFloat incrementationValue = (bounds.size.width / scale) / (bounds.size.width * contentScaleFactor);
  
  CGFloat x = -axisOrigin.x / scale;
  CGFloat y = [self.dataSource graph:graph yValueForX:x];
  CGContextMoveToPoint(context,
                       x * scale + axisOrigin.x,
                       axisOrigin.y - y * scale);
  
  for (x += incrementationValue;
       x < (bounds.size.width - axisOrigin.x) / scale;
       x += incrementationValue) {
    y = [self.dataSource graph:graph yValueForX:x];
    CGContextAddLineToPoint(context,
                            x * scale + axisOrigin.x,
                            axisOrigin.y - y * scale);
  }
  CGContextStrokePath(context);
  
	UIGraphicsPopContext();
}

@end
