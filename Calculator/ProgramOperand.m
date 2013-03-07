//
//  CalculatorOperation.m
//  Calculator
//
//  Created by Łukasz Przytuła on 07.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

static NSString * const kNotAnOperation = @"NAO";

#import "ProgramOperand.h"

@implementation ProgramOperand

- initWithStack:(NSMutableArray *)stack andOperationsTypes:(NSSet *)operations
{
  self = [super init];
  if (self) {
    id item = [stack lastObject];
    if (item) {
      [stack removeLastObject];
    } else { // insufficient operands
      self.operation = kNotAnOperation;
      self.operands = [NSArray arrayWithObject:@"?"];
      return self;
    }
    if ([self item:item isAnOperation:operations]) { //item is an operation
      _operation = item;
      if ([self isNonOperand]) { // pi or e
        self.operands = [NSArray arrayWithObject:self.operation];
        self.operation = kNotAnOperation;
        return self;
      }
      ProgramOperand *operand1 = [[ProgramOperand alloc] initWithStack:stack andOperationsTypes:operations];
      if ([self isSingleOperandOperation]) {
        self.operands = [NSArray arrayWithObject:operand1];
      } else {
        ProgramOperand *operand2 = [[ProgramOperand alloc] initWithStack:stack andOperationsTypes:operations];
        self.operands = [NSArray arrayWithObjects:operand2, operand1, nil];
      }
    } else { // item is a number
      self.operation = kNotAnOperation;
      if ([item isKindOfClass:[NSString class]]) {
        self.operands = [NSArray arrayWithObject:item];
      } else {
        self.operands = [NSArray arrayWithObject:[NSString stringWithFormat:@"%g", [item doubleValue]]];
      }
    }
  }
  return self;
}

- (BOOL)item:(id)item isAnOperation:(NSSet *)operations
{
  return [item isKindOfClass:[NSString class]] && [operations containsObject:item];
}

- (BOOL)isSingleOperandOperation
{
  return [[NSSet setWithObjects:@"sin", @"cos", @"sqrt", @"log", @"+/-", nil] containsObject:self.operation];
}

- (BOOL)isNonOperand
{
  return [[NSSet setWithObjects:@"π", @"e", nil] containsObject:self.operation];
}

- (NSString *)description
{
  if ([self.operation isEqualToString:kNotAnOperation]) {
    return [self.operands objectAtIndex:0];
  } else if ([self isSingleOperandOperation]) {
    if ([self.operation isEqualToString:@"+/-"]) {
      NSString *operandDescription = [self operandDescription:0];
      if ([operandDescription rangeOfString:@"-"].location == 0) {
        operandDescription = [operandDescription substringFromIndex:1];
      } else {
        operandDescription = [@"-" stringByAppendingString:operandDescription];
      }
      return operandDescription;
    }
    return [NSString stringWithFormat:@"%@(%@)", self.operation, [self operandDescription:0]];
  } else {
    return [NSString stringWithFormat:@"(%@ %@ %@)", [self operandDescription:0], self.operation, [self operandDescription:1]];
  }
}

- (NSString *)operandDescription:(int)operandIndex
{
  assert(operandIndex < [self.operands count]);
  id operand = [self.operands objectAtIndex:operandIndex];
  if ([self.operation isEqualToString:@"+/-"]) {
    return [((ProgramOperand *)operand) description];
  } else {
    NSSet *similarOperations = [NSSet setWithObjects:@"*", @"/", nil];
    if (![similarOperations containsObject:self.operation]) {
      similarOperations = [NSSet setWithObjects:@"*", @"/", @"+", @"-", nil];
    }
    NSString *description = [((ProgramOperand *)operand) description];
    if ([similarOperations containsObject:((ProgramOperand *)operand).operation]) {
      description = [description substringWithRange:NSMakeRange(1, [description length] - 2)];
    }
    return description;
  }
}

@end
