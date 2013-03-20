//
//  CalculatorVariable.m
//  Calculator
//
//  Created by Łukasz Przytuła on 10.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorVariable.h"

@implementation CalculatorVariable

- initWithVariableName:(NSString *)name;
{
  self = [super init];
  if (self) {
    _variableName = name;
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

- (double)value
{
  return self.variableValue;
}

- (NSString *)description
{
  return _variableName;
}

- (NSArray *)variables
{
  return [NSArray array];
}

- (void)setVariableValues:(NSDictionary *)variableValues
{
  self.variableValue = 0;
  if ([variableValues objectForKey:self.variableName]) {
    self.variableValue = [[variableValues objectForKey:self.variableName] doubleValue];
  }
}

- (void)addSubobjectsToStack:(NSMutableArray *)stack;
{
}

@end
