//
//  CalculatorNoOperandOperation.m
//  Calculator
//
//  Created by Łukasz Przytuła on 15.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorNoOperandOperation.h"

@implementation CalculatorNoOperandOperation

- (id)initWithStack:(NSMutableArray *)stack
{
  self = [super init];
  if (self) {
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
  @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                               userInfo:nil];
}

- (NSArray *)variables
{
  return [NSArray array];
}

- (void)setVariableValues:(NSDictionary *)variableValues
{
}

- (NSString *)error
{
  return nil;
}

- (void)addSubobjectsToStack:(NSMutableArray *)stack;
{
}

@end
