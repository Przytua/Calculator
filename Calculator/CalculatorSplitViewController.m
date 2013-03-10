//
//  CalculatorSplitViewController.m
//  Calculator
//
//  Created by Łukasz Przytuła on 08.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorSplitViewController.h"
#import "CalculatorViewController.h"

@interface CalculatorSplitViewController ()

@end

@implementation CalculatorSplitViewController

-(BOOL)shouldAutorotate
{
  return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  return UIInterfaceOrientationPortrait;
}

@end
