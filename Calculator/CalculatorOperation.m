//
//  CalculatorOperation.m
//  Calculator
//
//  Created by Łukasz Przytuła on 07.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

static NSString * const kNotAnOperation = @"NAO";

#import "CalculatorOperation.h"
#import "CalculatorNumber.h"
#import "CalculatorVariable.h"
#import "CalculatorAddingOperation.h"
#import "CalculatorSubstractingOperation.h"
#import "CalculatorMultiplyingOperation.h"
#import "CalculatorDividingOperation.h"
#import "CalculatorSinusFunction.h"
#import "CalculatorCosinusFunction.h"
#import "CalculatorSquareRootFunction.h"
#import "CalculatorLogarithmFunction.h"
#import "CalculatorSignChangingFunction.h"
#import "CalculatorPiNumber.h"
#import "CalculatorEulerNumber.h"

@implementation CalculatorOperation

+ (CalculatorOperation *)operationWithType:(CalculatorOperationType)type andProgramStack:(NSMutableArray *)programStack;
{
  switch (type) {
    case 0:
      return [[CalculatorAddingOperation alloc] initWithStack:programStack];
      break;
    case 1:
      return [[CalculatorSubstractingOperation alloc] initWithStack:programStack];
      break;
    case 2:
      return [[CalculatorMultiplyingOperation alloc] initWithStack:programStack];
      break;
    case 3:
      return [[CalculatorDividingOperation alloc] initWithStack:programStack];
      break;
    case 4:
      return [[CalculatorSinusFunction alloc] initWithStack:programStack];
      break;
    case 5:return [[CalculatorCosinusFunction alloc] initWithStack:programStack];
      break;
    case 6:
      return [[CalculatorSquareRootFunction alloc] initWithStack:programStack];
      break;
    case 7:
      return [[CalculatorLogarithmFunction alloc] initWithStack:programStack];
      break;
    case 8:
      return [[CalculatorPiNumber alloc] initWithStack:programStack];
      break;
    case 9:
      return [[CalculatorEulerNumber alloc] initWithStack:programStack];
      break;
    case 10:
      return [[CalculatorSignChangingFunction alloc] initWithStack:programStack];
      break;
      
    default:
      break;
  }
  return nil;
}

- (id)initWithStack:(NSMutableArray *)stack
{
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

- (CalculatorProgramObject *)popFromStack:(NSMutableArray *)stack
{
  if ([stack count] > 0) {
    CalculatorProgramObject *object = [stack lastObject];
    [stack removeLastObject];
    return object;
  }
  CalculatorNumber *num = [[CalculatorNumber alloc] initWithValue:NAN];
  num.error = @"insufficient operands";
  return num;
}

- (double)value
{
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

- (NSString *)description
{
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

- (NSArray *)variables
{
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

- (void)setVariableValues:(NSDictionary *)variableValues
{
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

- (void)addSubobjectsToStack:(NSMutableArray *)stack;
{
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

@end
