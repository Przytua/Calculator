//
//  CalculatorVariable.m
//  Calculator
//
//  Created by Łukasz Przytuła on 10.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorVariable.h"

@implementation CalculatorVariable

- initWithVariableName:(NSString *)name
{
  self = [super init];
  if (self) {
    self.variableName = name;
  }
  return self;
}

- (NSUInteger)length
{
  return self.variableName.length;
}

- (unichar)characterAtIndex:(NSUInteger)index
{
  return [self.variableName characterAtIndex:index];
}

@end
