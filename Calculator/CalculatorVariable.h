//
//  CalculatorVariable.h
//  Calculator
//
//  Created by Łukasz Przytuła on 10.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorVariable : NSObject;

@property (nonatomic, strong) NSString *variableName;

- initWithVariableName:(NSString *)name;

@end
