//
//  CalculatorTwoOperandOperation.m
//  Calculator
//
//  Created by Łukasz Przytuła on 15.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorTwoOperandOperation.h"

@implementation CalculatorTwoOperandOperation

@synthesize error = _error;

- (id)initWithStack:(NSMutableArray *)stack
{
  self = [super init];
  if (self) {
    self.operands = [[NSMutableArray alloc] init];
    [self.operands addObject:[self popFromStack:stack]];
    [self.operands insertObject:[self popFromStack:stack] atIndex:0];
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
  CalculatorProgramObject *operand2 = self.operands[1];
  NSString *description1 = [operand1 description];
  NSString *description2 = [operand2 description];
  if ([operand1 isKindOfClass:[CalculatorTwoOperandOperation class]]) {
    description1 = [description1 substringWithRange:NSMakeRange(1, [description1 length] - 2)];
  }
  if ([operand2 isKindOfClass:[CalculatorTwoOperandOperation class]]) {
    description2 = [description1 substringWithRange:NSMakeRange(1, [description2 length] - 2)];
  }
  return [NSString stringWithFormat:@"(%@ %@ %@)", description1, self.operationName, description2];
}

- (NSArray *)variables
{
  CalculatorProgramObject *operand1 = self.operands[0];
  CalculatorProgramObject *operand2 = self.operands[1];
  return [[operand1 variables] arrayByAddingObjectsFromArray:[operand2 variables]];
}

- (void)setVariableValues:(NSDictionary *)variableValues
{
  CalculatorProgramObject *operand1 = self.operands[0];
  CalculatorProgramObject *operand2 = self.operands[1];
  [operand1 setVariableValues:variableValues];
  [operand2 setVariableValues:variableValues];
}

- (NSString *)error
{
  if (_error) {
    return _error;
  } else {
    CalculatorProgramObject *operand1 = self.operands[0];
    CalculatorProgramObject *operand2 = self.operands[1];
    if (operand1.error) {
      return operand1.error;
    } else if (operand2.error) {
      return operand2.error;
    }
  }
  return nil;
}

- (void)addSubobjectsToStack:(NSMutableArray *)stack;
{
  CalculatorProgramObject *operand1 = self.operands[0];
  CalculatorProgramObject *operand2 = self.operands[1];
  [stack addObject:operand1];
  [stack addObject:operand2];
}

@end
