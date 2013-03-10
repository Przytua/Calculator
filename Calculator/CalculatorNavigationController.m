//
//  CalculatorNavigationController.m
//  Calculator
//
//  Created by Łukasz Przytuła on 08.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorNavigationController.h"

@interface CalculatorNavigationController ()

@end

@implementation CalculatorNavigationController

-(BOOL)shouldAutorotate
{
  return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
  return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  return UIInterfaceOrientationPortrait;
}

@end
