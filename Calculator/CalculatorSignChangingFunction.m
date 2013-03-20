//
//  CalculatorSignChangingFunction.m
//  Calculator
//
//  Created by Łukasz Przytuła on 14.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorSignChangingFunction.h"

@implementation CalculatorSignChangingFunction

- (double)value
{
  CalculatorProgramObject *operand1 = self.operands[0];
  return -[operand1 value];
}

- (NSString *)description
{
  CalculatorProgramObject *operand1 = self.operands[0];
  NSString *operandDescription = [operand1 description];
  if ([operandDescription rangeOfString:@"-"].location == 0) {
    operandDescription = [operandDescription substringFromIndex:1];
  } else {
    operandDescription = [@"-" stringByAppendingString:operandDescription];
  }
  return operandDescription;
}

@end
