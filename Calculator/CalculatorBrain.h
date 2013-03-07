//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Łukasz Przytuła on 06.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#define ZERO_IF_NIL(A)	({ __typeof__(A) __a = (A); __a == nil ? [NSNumber numberWithDouble:0.0] : __a; })

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(id)operand;
- (void)popOperand;
- (id)performOperation:(NSString *)operation;
- (void)clear;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (id)runProgram:(id)program;
+ (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
