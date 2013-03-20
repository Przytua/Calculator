//
//  CalculatorSquareRootFunction.m
//  Calculator
//
//  Created by Łukasz Przytuła on 14.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorSquareRootFunction.h"

@implementation CalculatorSquareRootFunction

- (double)value
{
  CalculatorProgramObject *operand1 = self.operands[0];
  if (operand1 < 0) self.error = @"sqrt of negative";
  return sqrt([operand1 value]);
}

- (NSString *)operationName
{
  return @"sqrt";
}

@end
