//
//  CalculatorGraphView.h
//  Calculator
//
//  Created by Łukasz Przytuła on 08.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  CalculatorGraphDrawingTypeDiscreet = 0,
  CalculatorGraphDrawingTypeContinuous = 1
} CalculatorGraphDrawingType;

@class CalculatorGraphView;

@protocol CalculatorGraphDataSource <NSObject>

- (CGFloat)graph:(CalculatorGraphView *)graph yValueForX:(CGFloat)xValue;

@end

@interface CalculatorGraphView : UIView

@property (nonatomic, weak) id<CalculatorGraphDataSource>dataSource;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CalculatorGraphDrawingType drawingType;

- (void)loadProperties;
- (void)saveProperties;

@end
