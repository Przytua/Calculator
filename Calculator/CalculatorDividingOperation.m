//
//  CalculatorDivisionOperation.m
//  Calculator
//
//  Created by Łukasz Przytuła on 14.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorDividingOperation.h"
#import "CalculatorMultiplyingOperation.h"

@implementation CalculatorDividingOperation

- (double)value
{
  CalculatorProgramObject *operand1 = self.operands[0];
  CalculatorProgramObject *operand2 = self.operands[1];
  if (operand2 == 0) self.error = @"division by zero)";
  return ([operand1 value] / [operand2 value]);
}

- (NSString *)description
{
  CalculatorProgramObject *operand1 = self.operands[0];
  CalculatorProgramObject *operand2 = self.operands[1];
  NSString *description1 = [operand1 description];
  if ([operand1 isKindOfClass:[self class]] || [operand1 isKindOfClass:[CalculatorMultiplyingOperation class]]) {
    description1 = [description1 substringWithRange:NSMakeRange(1, [description1 length] - 2)];
  }
  return [NSString stringWithFormat:@"(%@ / %@)", description1, [operand2 description]];
}

@end
