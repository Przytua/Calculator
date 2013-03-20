//
//  CalculatorNumber.h
//  Calculator
//
//  Created by Łukasz Przytuła on 10.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorProgramObject.h"

@interface CalculatorNumber : CalculatorProgramObject

@property (nonatomic) double doubleValue;

- (CalculatorNumber *)initWithValue:(double)value;

@end
