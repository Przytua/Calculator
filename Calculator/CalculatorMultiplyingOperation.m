//
//  CalculatorMultiplyingOperation.m
//  Calculator
//
//  Created by Łukasz Przytuła on 14.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorMultiplyingOperation.h"
#import "CalculatorDividingOperation.h"

@implementation CalculatorMultiplyingOperation

- (double)value
{
  CalculatorProgramObject *operand1 = self.operands[0];
  CalculatorProgramObject *operand2 = self.operands[1];
  return ([operand1 value] * [operand2 value]);
}

- (NSString *)description
{
  CalculatorProgramObject *operand1 = self.operands[0];
  CalculatorProgramObject *operand2 = self.operands[1];
  NSString *description1 = [operand1 description];
  NSString *description2 = [operand2 description];
  if ([operand1 isKindOfClass:[self class]] || [operand1 isKindOfClass:[CalculatorDividingOperation class]]) {
    description1 = [description1 substringWithRange:NSMakeRange(1, [description1 length] - 2)];
  }
  if ([operand2 isKindOfClass:[self class]] || [operand1 isKindOfClass:[CalculatorDividingOperation class]]) {
    description2 = [description1 substringWithRange:NSMakeRange(1, [description2 length] - 2)];
  }
  return [NSString stringWithFormat:@"(%@ * %@)", description1, description2];
}

@end
