//
//  CalculatorDrawer.h
//  Calculator
//
//  Created by Łukasz Przytuła on 15.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculatorGraphDataSource.h"
#import "CalculatorDrawerType.h"

@interface GraphDrawer : NSObject

@property (nonatomic, weak) id<CalculatorGraphDataSource>dataSource;

+ (GraphDrawer *)drawerOfType:(CalculatorDrawerType)type;
- (void)drawInRect:(CGRect)bounds originAtPoint:(CGPoint)axisOrigin scale:(CGFloat)scale onGraph:(CalculatorGraphView *)graph;

@end
