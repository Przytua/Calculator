//
//  CalculatorOperation.h
//  Calculator
//
//  Created by Łukasz Przytuła on 07.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorProgramObject.h"
#import "CalculatorOperationType.h"

@interface CalculatorOperation : CalculatorProgramObject

@property (nonatomic, copy) NSString *operation;
@property (nonatomic, strong) NSMutableArray *operands;
@property (nonatomic, readonly) NSString *operationName;

- (id)initWithStack:(NSMutableArray *)stack;
- (CalculatorProgramObject *)popFromStack:(NSMutableArray *)stack;
+ (CalculatorOperation *)operationWithType:(CalculatorOperationType)type andProgramStack:(NSMutableArray *)programStack;

@end
