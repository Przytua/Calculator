//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Łukasz Przytuła on 06.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorBrain.h"
#import "ProgramOperand.h"
#import "CalculatorVariable.h"
#import "CalculatorNumber.h"

static NSMutableArray *lastProgram;
static NSSet *variablesInLastProgram;

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

+ (NSSet *)operationsSet
{
  static NSSet *operationsSet;
  if (!operationsSet) {
    operationsSet = [NSSet setWithObjects:@"*", @"/", @"+", @"-", @"π", @"sin", @"cos", @"sqrt", @"+/-", @"e", @"log", nil];
  }
  return operationsSet;
}

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
  NSMutableString *description = [[NSMutableString alloc] init];
  if ([program isKindOfClass:[NSArray class]]) {
    stack = [program mutableCopy];
    while ([stack count] > 0) {
      NSString *operationDescription = [[[ProgramOperand alloc] initWithStack:stack andOperationsTypes:self.operationsSet] description];
      if ([operationDescription rangeOfString:@"("].location == 0) {
        operationDescription = [operationDescription substringWithRange:NSMakeRange(1, [operationDescription length] - 2)];
      }
      [description appendFormat:@"%@, ", operationDescription];
    }
    if ([description length] > 2) {
      return [description substringToIndex:[description length] - 2];
    }
  }
  return @"";
}

#pragma mark - stack management

- (void)pushOperand:(id)operand
{
  if ([operand isKindOfClass:[NSString class]]) {
    if (![[[self class] operationsSet] containsObject:operand]) {
      [self.programStack addObject:[[CalculatorVariable alloc] initWithVariableName:operand]];
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
    [self.programStack removeLastObject];
  }
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
    for (CalculatorVariable *variable in [self variablesUsedInProgram:program]) {
      id variableValue = [variableValues objectForKey:variable.variableName];
      if (!variableValue || ![variableValue isKindOfClass:[NSNumber class]]) {
        variableValue = [NSNumber numberWithDouble:0.0f];
      }
      [stack replaceObjectAtIndex:[stack indexOfObject:variable] withObject:variableValue];
    }
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
  NSMutableSet *result = [[NSMutableSet alloc] init];
  if ([program isKindOfClass:[NSArray class]]) {
    stack = program;
    lastProgram = program;
    for (id item in stack) {
      if ([item isKindOfClass:[CalculatorVariable class]]) {
        [result addObject:item];
      }
    }
  }
  variablesInLastProgram = result;
  return result;
}

+ (id)popAndComputeOperandOffProgramStack:(NSMutableArray *)stack
{
  double result = 0;
  
  id topOfStack = [stack lastObject];
  if (topOfStack) {
    [stack removeLastObject];
  } else {
    return [NSDecimalNumber notANumber];
  }
  
  if ([topOfStack isKindOfClass:[NSString class]])
  {
    NSString *operation = topOfStack;
    if ([operation isEqualToString:@"π"]) {
      result = M_PI;
    } else if ([operation isEqualToString:@"e"]) {
      result = M_E;
    } else {
      id operand1 = [self popAndComputeOperandOffProgramStack:stack];
      if ([operand1 isKindOfClass:[NSString class]]) {
        return operand1;
      }
      if ([operation isEqualToString:@"sin"]) {
        result = sin([operand1 doubleValue]);
      } else if ([operation isEqualToString:@"cos"]) {
        result = cos([operand1 doubleValue]);
      } else if ([operation isEqualToString:@"sqrt"]) {
        double operand = [operand1 doubleValue];
        if (operand < 0) return @"Sqrt of negative";
        result = sqrt(operand);
      } else if ([operation isEqualToString:@"+/-"]) {
        result = -[operand1 doubleValue];
      } else if ([operation isEqualToString:@"log"]) {
        result = log([operand1 doubleValue]);
      } else {
        id operand2 = [self popAndComputeOperandOffProgramStack:stack];
        if ([operand2 isKindOfClass:[NSString class]]) {
          return operand2;
        }
        if ([operation isEqualToString:@"+"]) {
          result = [operand1 doubleValue] + [operand2 doubleValue];
        } else if ([operation isEqualToString:@"*"]) {
          result = [operand1 doubleValue] * [operand2 doubleValue];
        } else if ([operation isEqualToString:@"-"]) {
//          double subtrahend = [[self popAndComputeOperandOffProgramStack:stack] doubleValue];
          result = [operand2 doubleValue] - [operand1 doubleValue];
        } else if ([operation isEqualToString:@"/"]) {
//          double divisor = [[self popAndComputeOperandOffProgramStack:stack] doubleValue];
          if ([operand1 doubleValue] == 0) {
            return @"Division by zero";
          }
          result = [operand2 doubleValue] / [operand1 doubleValue];
        }
      }
    }
  } else {
    result = [topOfStack doubleValue];
  }
  
  if (isnan(result)) {
    return @"Insuff. operands";
  }
  return [[CalculatorNumber alloc] initWithValue:result];
}

@end
