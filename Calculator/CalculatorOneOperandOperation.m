//
//  CalculatorOneOperandOperation.m
//  Calculator
//
//  Created by Łukasz Przytuła on 15.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorOneOperandOperation.h"
#import "CalculatorTwoOperandOperation.h"

@implementation CalculatorOneOperandOperation

@synthesize error = _error;

- (id)initWithStack:(NSMutableArray *)stack
{
  self = [super init];
  if (self) {
    self.operands = [[NSMutableArray alloc] init];
    id cos = [self popFromStack:stack];
    [self.operands addObject:cos];
  }
  return self;
}

- (double)value
{
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

- (NSString *)description
{
  CalculatorProgramObject *operand1 = self.operands[0];
  NSString *description = operand1.description;
  if ([operand1 isKindOfClass:[CalculatorTwoOperandOperation class]]) {
    description = [description substringWithRange:NSMakeRange(1, [description length] - 2)];
  }
  return [NSString stringWithFormat:@"%@(%@)", self.operationName, description];
}

- (NSArray *)variables
{
  CalculatorProgramObject *operand1 = self.operands[0];
  return [operand1 variables];
}

- (void)setVariableValues:(NSDictionary *)variableValues
{
  CalculatorProgramObject *operand1 = self.operands[0];
  [operand1 setVariableValues:variableValues];
}

- (NSString *)error
{
  if (_error) {
    return _error;
  } else {
    CalculatorProgramObject *operand1 = self.operands[0];
    if (operand1.error) {
      return operand1.error;
    }
  }
  return nil;
}

- (void)addSubobjectsToStack:(NSMutableArray *)stack;
{
  CalculatorProgramObject *operand1 = self.operands[0];
  [stack addObject:operand1];
}

@end
