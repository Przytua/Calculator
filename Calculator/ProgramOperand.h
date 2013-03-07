//
//  CalculatorOperation.h
//  Calculator
//
//  Created by Łukasz Przytuła on 07.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgramOperand : NSObject

@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSArray *operands;

- initWithStack:(NSMutableArray *)stack andOperationsTypes:(NSSet *)operations;

@end
