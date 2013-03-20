//
//  CalculatorProgramObject.h
//  Calculator
//
//  Created by Łukasz Przytuła on 14.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorProgramObject : NSObject

@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSArray *variables;

- (double)value;
- (void)setVariableValues:(NSDictionary *)variableValues;
- (void)addSubobjectsToStack:(NSMutableArray *)stack;

@end
