//
//  CalculatorAppDelegate.m
//  Calculator
//
//  Created by Łukasz Przytuła on 06.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorAppDelegate.h"

@implementation CalculatorAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UIViewController *graphViewController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)graphViewController;
    splitViewController.presentsWithGesture = NO;
  }
  return YES;
}

@end
