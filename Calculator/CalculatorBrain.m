//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Łukasz Przytuła on 06.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorBrain.h"
#import "CalculatorOperation.h"
#import "CalculatorVariable.h"
#import "CalculatorNumber.h"

static NSMutableArray *lastProgram;
static NSSet *variablesInLastProgram;

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

- (NSMutableArray *)programStack
{
  if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
  return _programStack;
}

- (id)program
{
  return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
  NSMutableArray *stack;
  if ([program isKindOfClass:[NSArray class]]) {
    stack = [program mutableCopy];
    if ([stack count] > 0) {
      NSMutableString *programDescription = [[NSMutableString alloc] init];
      while ([stack count] > 0) {
        CalculatorProgramObject *cpo = stack.lastObject;
        [stack removeLastObject];
        NSString *description = cpo.description;
        if ([description rangeOfString:@"("].location == 0) {
          description = [description substringWithRange:NSMakeRange(1, [description length] - 2)];
        }
        [programDescription appendFormat:@"%@, ", description];
      }
      return [programDescription substringToIndex:[programDescription length] - 2];
    }
  }
  return @"";
}

#pragma mark - stack management

- (void)pushOperand:(id)operand
{
  if ([operand isKindOfClass:[NSString class]]) {
    id operation = [[CalculatorVariable alloc] initWithVariableName:operand];
    if (operation) {
      [self.programStack addObject:operation];
    } else {
      [self.programStack addObject:operand];
    }
  } else {
    [self.programStack addObject:[[CalculatorNumber alloc] initWithValue:[operand doubleValue]]];
  }
}

- (void)popOperand
{
  if ([self.programStack count] > 0) {
    CalculatorProgramObject *lastObject = [self.programStack lastObject];
    [self.programStack removeLastObject];
    [lastObject addSubobjectsToStack:self.programStack];
  }
}

- (void)addOperation:(CalculatorOperationType)type
{
  [self.programStack addObject:[CalculatorOperation operationWithType:type andProgramStack:self.programStack]];
}

- (void)addVariable:(NSString *)name
{
  [self.programStack addObject:[[CalculatorVariable alloc] initWithVariableName:name]];
}

- (id)performOperation:(NSString *)operation
{
  [self.programStack addObject:operation];
  return [[self class] runProgram:self.program];
}

- (void)clear
{
  [self.programStack removeAllObjects];
}

#pragma mark - program execution

+ (id)runProgram:(id)program
{
  return [self runProgram:program usingVariableValues:nil];
}

+ (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
  if (variableValues == nil) variableValues = [NSDictionary dictionary];
  NSMutableArray *stack;
  if ([program isKindOfClass:[NSArray class]]) {
    stack = [program mutableCopy];
    [((CalculatorProgramObject *)stack.lastObject) setVariableValues:variableValues];
  }
  id result = [self popAndComputeOperandOffProgramStack:stack];
  if ([result isKindOfClass:[NSString class]]) {
    return result;
  }
  if (isnan([result doubleValue])) {
    return [NSNumber numberWithInt:0];
  }
  return [NSNumber numberWithDouble:[result doubleValue]];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
  if (lastProgram == program) {
    return variablesInLastProgram;
  }
  NSArray *stack;
  NSSet *result;
  if ([program isKindOfClass:[NSArray class]]) {
    stack = program;
    lastProgram = program;
    CalculatorProgramObject *stackItem = stack.lastObject;
    result = [NSSet setWithArray:stackItem.variables];
  }
  variablesInLastProgram = result;
  return result;
}

+ (id)popAndComputeOperandOffProgramStack:(NSMutableArray *)stack
{
  double result = 0;
  
  CalculatorProgramObject *topOfStack = [stack lastObject];
  if (topOfStack) {
    [stack removeLastObject];
    result = [topOfStack value];
    if (!isnan(result)) {
      return [[CalculatorNumber alloc] initWithValue:result];
    } else {
      return [topOfStack error];
    }
  }
  return @"0";
}

@end
