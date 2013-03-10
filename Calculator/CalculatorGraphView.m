//
//  CalculatorGraphView.m
//  Calculator
//
//  Created by Łukasz Przytuła on 08.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

static NSString *const kScaleKey = @"GraphViewScale";
static NSString *const kOriginKey = @"GraphViewOrigin";
static NSString *const kDrawingTypeKey = @"GraphViewDrawingType";

#import "CalculatorGraphView.h"
#import "AxesDrawer.h"

@interface CalculatorGraphView ()

@end

@implementation CalculatorGraphView

@synthesize origin = _origin;
@synthesize scale = _scale;

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self loadProperties];
  }
  return self;
}

#pragma mark - properties

- (NSString *)drawingTypeKey
{
  return [NSString stringWithFormat:@"%@%d", kDrawingTypeKey, self.tag];
}

- (CalculatorGraphDrawingType)drawingType
{
  return [[NSUserDefaults standardUserDefaults] integerForKey:[self drawingTypeKey]];
}

- (void)setDrawingType:(CalculatorGraphDrawingType)drawingType
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  if ([defaults integerForKey:[self drawingTypeKey]] == drawingType) {
    return;
  }
  [defaults setInteger:drawingType forKey:[self drawingTypeKey]];
  [self setNeedsDisplay];
}

- (NSString *)scaleKey
{
  return [NSString stringWithFormat:@"%@%d", kScaleKey, self.tag];
}

- (void)setScale:(CGFloat)scale
{
  if (_scale == scale) {
    return;
  }
  _scale = scale;
  [self setNeedsDisplay];
}

- (NSString *)originKey
{
  return [NSString stringWithFormat:@"%@%d", kOriginKey, self.tag];
}

- (void)setOrigin:(CGPoint)origin
{
  if (CGPointEqualToPoint(_origin, origin)) {
    return;
  }
  _origin = origin;
  [self setNeedsDisplay];
}

- (void)loadProperties
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  if (![defaults objectForKey:[self scaleKey]]) {
    _scale = 1.0f;
  } else {
    _scale = [[defaults objectForKey:[self scaleKey]] floatValue];
  }
  
  if (![defaults objectForKey:self.originKey]) {
    _origin = CGPointMake(0.5f, 0.5f);
  } else {
    CGPoint origin = CGPointFromString([defaults objectForKey:self.originKey]);
    _origin = CGPointMake(origin.x * self.frame.size.width,
                       origin.y * self.frame.size.height);
  }
}

- (void)saveProperties
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  [defaults setValue:[NSNumber numberWithFloat: self.scale] forKey:[NSString stringWithFormat:@"%@%d", kScaleKey, self.tag]];
  
  CGPoint origin = CGPointMake(self.origin.x / self.frame.size.width,
                               self.origin.y / self.frame.size.height);
  [defaults setValue:NSStringFromCGPoint(origin) forKey:self.originKey];
  
  [defaults synchronize];
}

#pragma mark - drawing graph

- (void)drawRect:(CGRect)rect
{
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
  CGFloat pixelSize = 1.0f / [self contentScaleFactor];
  CGFloat incrementationValue = (self.frame.size.width / self.scale) / (self.frame.size.width * [self contentScaleFactor]);
  if (self.drawingType == CalculatorGraphDrawingTypeDiscreet) {
    for (CGFloat x = -self.origin.x / self.scale;
         x < (self.frame.size.width - self.origin.x) / self.scale;
         x += incrementationValue) {
      CGFloat y = [self.dataSource graph:self yValueForX:x];
      CGContextFillRect(currentContext, CGRectMake(x * self.scale + self.origin.x,
                                                   self.origin.y - y * self.scale,
                                                   pixelSize, pixelSize));
    }
  } else {
    CGFloat x = -self.origin.x / self.scale;
    CGFloat y = [self.dataSource graph:self yValueForX:x];
    CGContextMoveToPoint(currentContext,
                         x * self.scale + self.origin.x,
                         self.origin.y - y * self.scale);
    
    for (x += incrementationValue;
         x < (self.frame.size.width - self.origin.x) / self.scale;
         x += incrementationValue) {
      y = [self.dataSource graph:self yValueForX:x];
      CGContextAddLineToPoint(currentContext,
                              x * self.scale + self.origin.x,
                              self.origin.y - y * self.scale);
    }
    CGContextStrokePath(currentContext);
  }
}

@end
