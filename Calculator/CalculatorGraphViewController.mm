//
//  GraphViewController.m
//  Calculator
//
//  Created by Łukasz Przytuła on 08.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorGraphViewController.h"
#import "CalculatorGraphView.h"
#import "CalculatorBrain.h"
#import <stdlib.h>
#import <string>

using namespace std;

@interface CalculatorGraphViewController () <CalculatorGraphDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet CalculatorGraphView *graph;
@property (weak, nonatomic) IBOutlet UILabel *programDescription;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UISwitch *drawingModeSwitch;
@property (nonatomic, strong) UIPopoverController *calculatorPopover;
@property (nonatomic, strong) NSMutableDictionary *yValues;

@end

@implementation CalculatorGraphViewController

- (void)viewDidLoad
{
  self.graph.dataSource = self;
  
  UITapGestureRecognizer *tripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTapGesture:)];
  tripleTapGesture.numberOfTapsRequired = 3;
  UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
  panGesture.delegate = self;
  UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
  pinchGesture.delegate = self;
  
  [self.graph addGestureRecognizer:tripleTapGesture];
  [self.graph addGestureRecognizer:panGesture];
  [self.graph addGestureRecognizer:pinchGesture];
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
  }
  
  [self.drawingModeSwitch setOn:self.graph.drawingType == CalculatorDrawerTypeContinuous animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  }
}

- (NSMutableDictionary *)yValues
{
  if (!_yValues) {
    _yValues = [[NSMutableDictionary alloc] init];
  }
  return _yValues;
}

#pragma mark - gestures

- (void)handleTripleTapGesture:(UITapGestureRecognizer *)sender
{
  self.graph.origin = [sender locationInView:self.graph];
  [self.graph saveProperties];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
  if (sender.state == UIGestureRecognizerStateBegan) {
    [sender setTranslation:self.graph.origin inView:self.graph];
  } else {
    self.graph.origin = [sender translationInView:self.graph];
    if (sender.state == UIGestureRecognizerStateEnded) {
      [self.graph saveProperties];
    }
  }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender
{
  if (sender.state == UIGestureRecognizerStateBegan) {
    sender.scale = self.graph.scale;
  } else {
    self.graph.scale = sender.scale;
    if (sender.state == UIGestureRecognizerStateEnded) {
      [self.graph saveProperties];
    }
  }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  return YES;
}

#pragma mark - drawing new graph

- (void)viewWillAppear:(BOOL)animated
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [self updateGraph];
  }
}

- (void)setProgram:(NSMutableArray *)program
{
  _program = program;
  self.yValues = [[NSMutableDictionary alloc] init];
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    [self updateGraph];
  }
}

- (void)updateGraph
{
  self.programDescription.text = [CalculatorBrain descriptionOfProgram:self.program];
  
  [self.graph setNeedsDisplay];
  
  if (self.calculatorPopover != nil) {
    [self.calculatorPopover dismissPopoverAnimated:YES];
  }
}

#pragma mark - graph adaptation to rotated frame

- (void)deviceOrientationDidChange:(NSNotification *)notification {
  [self.graph loadProperties];
  [self.graph setNeedsDisplay];
}

#pragma mark - graph data source

- (CGFloat)graph:(CalculatorGraphView *)graph yValueForX:(CGFloat)xValue
{
  string stringFloat = to_string(xValue);
  NSNumber *y = [self.yValues objectForKey:[NSString stringWithUTF8String:stringFloat.c_str()]];
  if (!y) {
    y = [CalculatorBrain runProgram:self.program usingVariableValues:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:xValue] forKey:@"x"]]; 
    [self.yValues setValue:y forKey:[NSString stringWithUTF8String:stringFloat.c_str()]];
  }
  return [y doubleValue];
}

#pragma mark - IBActions

- (IBAction)drawingModeChanged:(UISwitch *)sender {
  if (sender.on) {
    self.graph.drawingType = CalculatorDrawerTypeContinuous;
  } else {
    self.graph.drawingType = CalculatorDrawerTypeDiscrete;
  }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
  barButtonItem.title = @"Calculator";
  [self.toolbar setItems:[NSArray arrayWithObject:barButtonItem] animated:YES];
  self.calculatorPopover = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
  [self.toolbar setItems:nil animated:YES];
  self.calculatorPopover = nil;
}

@end
