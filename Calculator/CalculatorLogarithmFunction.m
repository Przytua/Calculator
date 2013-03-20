//
//  CalculatorLogarithmFunction.m
//  Calculator
//
//  Created by Łukasz Przytuła on 14.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorLogarithmFunction.h"

@implementation CalculatorLogarithmFunction

- (double)value
{
  CalculatorProgramObject *operand1 = self.operands[0];
  if ([operand1 value] < 0) self.error = @"log of negative";
  return log([operand1 value]);
}

- (NSString *)operationName
{
  return @"log";
}

@end
