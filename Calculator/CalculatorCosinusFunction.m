//
//  CalculatorCosinusFunction.m
//  Calculator
//
//  Created by Łukasz Przytuła on 14.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorCosinusFunction.h"

@implementation CalculatorCosinusFunction

- (double)value
{
  CalculatorProgramObject *operand1 = self.operands[0];
  return cos([operand1 value]);
}

- (NSString *)operationName
{
  return @"cos";
}

@end
