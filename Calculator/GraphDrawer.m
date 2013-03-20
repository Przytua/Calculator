//
//  CalculatorDrawer.m
//  Calculator
//
//  Created by Łukasz Przytuła on 15.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "GraphDrawer.h"
#import "GraphDiscreteDrawer.h"
#import "GraphLinearDrawer.h"

@implementation GraphDrawer

+ (GraphDrawer *)drawerOfType:(CalculatorDrawerType)type;
{
  switch (type) {
    case 0:
      return [[GraphDiscreteDrawer alloc] init];
      break;
    case 1:
      return [[GraphLinearDrawer alloc] init];
      break;
      
    default:
      break;
  }
  return [[GraphDiscreteDrawer alloc] init];
}

- (void)drawInRect:(CGRect)bounds originAtPoint:(CGPoint)axisOrigin scale:(CGFloat)scale onGraph:(CalculatorGraphView *)graph;
{
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

@end
