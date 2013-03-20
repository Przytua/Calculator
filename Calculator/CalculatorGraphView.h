//
//  CalculatorGraphView.h
//  Calculator
//
//  Created by Łukasz Przytuła on 08.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorGraphDataSource.h"
#import "CalculatorDrawerType.h"

@interface CalculatorGraphView : UIView

@property (nonatomic, weak) id<CalculatorGraphDataSource>dataSource;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CalculatorDrawerType drawingType;

- (void)loadProperties;
- (void)saveProperties;

@end
