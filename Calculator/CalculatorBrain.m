//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Łukasz Przytuła on 06.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *operandStack;

@end

@implementation CalculatorBrain

- (NSMutableArray *)operandStack
{
  if (!_operandStack) {
    _operandStack = [[NSMutableArray alloc] init];
  }
  return _operandStack;
}

- (void)pushOperand:(double)operand
{
  [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand
{
  NSNumber *operandObject = [self.operandStack lastObject];
  if (operandObject) [self.operandStack removeLastObject];
  return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation
{
  double result = 0;
  
  if ([operation isEqualToString:@"+"]) {
    result = [self popOperand] + [self popOperand];
  } else if ([operation isEqualToString:@"*"]) {
    result = [self popOperand] * [self popOperand];
  } else if ([operation isEqualToString:@"-"]) {
    double subtrahend = [self popOperand];
    result = [self popOperand] - subtrahend;
  } else if ([operation isEqualToString:@"/"]) {
    double divisor = [self popOperand];
    if (divisor == 0) {
      [self pushOperand:divisor];
      return NAN;
    }
    result = [self popOperand] / divisor;
  } else if ([operation isEqualToString:@"π"]) {
    result = M_PI;
  } else if ([operation isEqualToString:@"sin"]) {
    result = sin([self popOperand]);
  } else if ([operation isEqualToString:@"cos"]) {
    result = cos([self popOperand]);
  } else if ([operation isEqualToString:@"sqrt"]) {
    result = sqrt([self popOperand]);
  } else if ([operation isEqualToString:@"+/-"]) {
    result = -[self popOperand];
  } else if ([operation isEqualToString:@"e"]) {
    result = M_E;
  } else if ([operation isEqualToString:@"log"]) {
    result = log([self popOperand]);
  }
  
  [self pushOperand:result];
  
  return result;
}

- (void)clear
{
  [self.operandStack removeAllObjects];
}

@end
