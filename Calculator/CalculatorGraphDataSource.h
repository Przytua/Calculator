//
//  CalculatorGraphDataSource.h
//  Calculator
//
//  Created by Łukasz Przytuła on 18.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CalculatorGraphView;

@protocol CalculatorGraphDataSource <NSObject>

- (CGFloat)graph:(CalculatorGraphView *)graph yValueForX:(CGFloat)xValue;

@end
