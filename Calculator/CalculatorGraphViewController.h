//
//  GraphViewController.h
//  Calculator
//
//  Created by Łukasz Przytuła on 08.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorGraphViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *program;

@end
