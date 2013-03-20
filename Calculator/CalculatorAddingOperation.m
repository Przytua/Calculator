//
//  CalculatorAddingOperation.m
//  Calculator
//
//  Created by Łukasz Przytuła on 14.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorAddingOperation.h"

@implementation CalculatorAddingOperation

- (double)value
{
  CalculatorProgramObject *operand1 = self.operands[0];
  CalculatorProgramObject *operand2 = self.operands[1];
  return ([operand1 value] + [operand2 value]);
}

- (NSString *)operationName
{
  return @"+";
}

@end
