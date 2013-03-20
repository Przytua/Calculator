//
//  CalculatorVariable.h
//  Calculator
//
//  Created by Łukasz Przytuła on 10.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorProgramObject.h"

@interface CalculatorVariable : CalculatorProgramObject;

@property (nonatomic, strong) NSString *variableName;
@property (nonatomic) double variableValue;

- initWithVariableName:(NSString *)name;

@end
