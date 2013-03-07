//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Łukasz Przytuła on 06.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorBrain.h"
#import "ProgramOperand.h"

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

+ (NSSet *)operationsSet
{
  return [NSSet setWithObjects:@"*", @"/", @"+", @"-", @"π", @"sin", @"cos", @"sqrt", @"+/-", @"e", @"log", nil];
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
    NSLog(@"stack: %@", stack);
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

- (void)pushOperand:(id)operand
{
  [self.programStack addObject:operand];
}

- (void)popOperand
{
  if ([self.programStack count] > 0) {
    [self.programStack removeLastObject];
  }
}

- (double)performOperation:(NSString *)operation
{
  [self.programStack addObject:operation];
  return [[self class] runProgram:self.program];
}

+ (double)popAndComputeOperandOffProgramStack:(NSMutableArray *)stack
{
  double result = 0;
  
  
  id topOfStack = [stack lastObject];
  if (topOfStack) [stack removeLastObject];
  
  if ([topOfStack isKindOfClass:[NSNumber class]])
  {
    result = [topOfStack doubleValue];
  }
  else if ([topOfStack isKindOfClass:[NSString class]])
  {
    NSString *operation = topOfStack;
    if ([operation isEqualToString:@"+"]) {
      result = [self popAndComputeOperandOffProgramStack:stack] + [self popAndComputeOperandOffProgramStack:stack];
    } else if ([operation isEqualToString:@"*"]) {
      result = [self popAndComputeOperandOffProgramStack:stack] * [self popAndComputeOperandOffProgramStack:stack];
    } else if ([operation isEqualToString:@"-"]) {
      double subtrahend = [self popAndComputeOperandOffProgramStack:stack];
      result = [self popAndComputeOperandOffProgramStack:stack] - subtrahend;
    } else if ([operation isEqualToString:@"/"]) {
      double divisor = [self popAndComputeOperandOffProgramStack:stack];
      if (divisor == 0) {
        [stack addObject:[NSNumber numberWithDouble:divisor]];
        return NAN;
      }
      result = [self popAndComputeOperandOffProgramStack:stack] / divisor;
    } else if ([operation isEqualToString:@"π"]) {
      result = M_PI;
    } else if ([operation isEqualToString:@"sin"]) {
      result = sin([self popAndComputeOperandOffProgramStack:stack]);
    } else if ([operation isEqualToString:@"cos"]) {
      result = cos([self popAndComputeOperandOffProgramStack:stack]);
    } else if ([operation isEqualToString:@"sqrt"]) {
      result = sqrt([self popAndComputeOperandOffProgramStack:stack]);
    } else if ([operation isEqualToString:@"+/-"]) {
      result = -[self popAndComputeOperandOffProgramStack:stack];
    } else if ([operation isEqualToString:@"e"]) {
      result = M_E;
    } else if ([operation isEqualToString:@"log"]) {
      result = log([self popAndComputeOperandOffProgramStack:stack]);
    }
  }
  
  return result;
}

+ (double)runProgram:(id)program
{
  return [self runProgram:program usingVariableValues:nil];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
  if (variableValues == nil) variableValues = [NSDictionary dictionary];
  NSMutableArray *stack;
  if ([program isKindOfClass:[NSArray class]]) {
    stack = [program mutableCopy];
    for (NSString *variable in [self variablesUsedInProgram:program]) {
      [stack replaceObjectAtIndex:[stack indexOfObject:variable] withObject:ZERO_IF_NIL([variableValues objectForKey:variable])];
    }
  }
  return [self popAndComputeOperandOffProgramStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
  NSMutableArray *stack;
  if ([program isKindOfClass:[NSArray class]]) {
    stack = [program mutableCopy];
  }
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
                            @"self isKindOfClass: %@",
                            [NSString class]];
  
  NSMutableSet *result = [[NSMutableSet alloc] initWithArray:[stack filteredArrayUsingPredicate:predicate]];
  [result minusSet:self.operationsSet];
  return result;
}

- (void)clear
{
  [self.programStack removeAllObjects];
}

@end
