//
//  CalculatorSinusFunction.m
//  Calculator
//
//  Created by Łukasz Przytuła on 14.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorSinusFunction.h"

@implementation CalculatorSinusFunction

- (double)value
{
  CalculatorProgramObject *operand1 = self.operands[0];
  return sin([operand1 value]);
}

- (NSString *)operationName
{
  return @"sin";
}

@end
