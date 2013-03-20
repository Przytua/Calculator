//
//  CalculatorNumber.m
//  Calculator
//
//  Created by Łukasz Przytuła on 10.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorNumber.h"

@implementation CalculatorNumber

- (CalculatorNumber *)initWithValue:(double)value
{
  self = [super init];
  if (self) {
    _doubleValue = value;
  }
  return self;
}

- (double)value
{
  return _doubleValue;
}

- (double)doubleValue
{
  return _doubleValue;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%g", _doubleValue];
}

- (NSArray *)variables
{
  return [NSArray arrayWithObject:self];
}

- (void)setVariableValues:(NSDictionary *)variableValues
{
}

- (void)addSubobjectsToStack:(NSMutableArray *)stack;
{
}

@end
