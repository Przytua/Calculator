//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Łukasz Przytuła on 06.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "CalculatorGraphViewController.h"

@interface CalculatorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *description;

@property (nonatomic, strong) CalculatorGraphViewController *graphViewController;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL numberIsFloatingPoint;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

- (void)viewDidLoad
{
  self.graphViewController = (CalculatorGraphViewController *)[self.splitViewController.viewControllers lastObject];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - properties

- (CalculatorBrain *)brain
{
  if (!_brain) {
    _brain = [[CalculatorBrain alloc] init];
  }
  return _brain;
}

#pragma mark - IBActions

- (IBAction)digitPressed:(UIButton *)sender
{
  NSString *digit = [sender currentTitle];
  if ([digit isEqualToString:@"."]) {
    if (self.numberIsFloatingPoint) {
      return;
    }
    self.userIsInTheMiddleOfEnteringANumber = YES;
    self.numberIsFloatingPoint = YES;
  }
  if (self.userIsInTheMiddleOfEnteringANumber) {
    if (! ([digit isEqualToString:@"0"] && [self.display.text isEqualToString:@"0"])) {
      self.display.text = [self.display.text stringByAppendingString:digit];
    }
  } else {
    self.display.text = digit;
    self.userIsInTheMiddleOfEnteringANumber = YES;
  }
}

- (IBAction)enterPressed
{
  [self.brain pushOperand:[NSNumber numberWithDouble:[self.display.text doubleValue]]];
  self.description.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
  self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)clearPressed
{
  [self.brain clear];
  self.display.text = @"0";
  self.description.text = @"";
  self.userIsInTheMiddleOfEnteringANumber = NO;
  self.numberIsFloatingPoint = NO;
}

- (IBAction)backspacePressed
{
  if (self.userIsInTheMiddleOfEnteringANumber) {
    self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
    if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
      self.numberIsFloatingPoint = NO;
    }
    if (self.display.text.length == 0) {
      self.userIsInTheMiddleOfEnteringANumber = NO;
      self.display.text = @"0";
    }
  } else {
    [self.brain popOperand];
    [self updateDisplay];
  }
}

- (IBAction)operationPressed:(UIButton *)sender
{
  NSString *operation = [sender currentTitle];
  if (self.userIsInTheMiddleOfEnteringANumber) {
    if ([operation isEqualToString:@"+/-"]) {
      if ([[self.display.text substringToIndex:1] isEqualToString:@"-"]) {
        self.display.text = [self.display.text substringFromIndex:1];
      } else {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
      }
      return;
    }
    [self enterPressed];
  }
  [self.brain pushOperand:operation];
  [self updateDisplay];
}

- (IBAction)variablePressed:(UIButton *)sender
{
  NSString *variable = [sender currentTitle];
  if (self.userIsInTheMiddleOfEnteringANumber) {
    [self enterPressed];
  }
  [self.brain pushOperand:variable];
  [self updateDisplay];
}

- (void)updateDisplay
{
  self.display.text = [NSString stringWithFormat:@"%@", [CalculatorBrain runProgram:self.brain.program usingVariableValues:nil]];
  self.description.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

#pragma mark - showing graph of current program

- (IBAction)graphPressed
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [self performSegueWithIdentifier:@"graph" sender:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  } else {
    self.graphViewController.program = self.brain.program;
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"graph"]) {
    CalculatorGraphViewController *graphViewController = [segue destinationViewController];
    graphViewController.program = self.brain.program;
  }
}

@end
