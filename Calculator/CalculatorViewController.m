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
  NSString *digit;
  if (sender.tag == 10) {
    digit = @".";
    if (self.numberIsFloatingPoint) {
      return;
    }
    self.userIsInTheMiddleOfEnteringANumber = YES;
    self.numberIsFloatingPoint = YES;
  } else {
    digit = [NSString stringWithFormat:@"%i", sender.tag];
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
  if (self.userIsInTheMiddleOfEnteringANumber) {
    if (sender.tag == 4) {
      if ([[self.display.text substringToIndex:1] isEqualToString:@"-"]) {
        self.display.text = [self.display.text substringFromIndex:1];
      } else {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
      }
      return;
    }
    [self enterPressed];    
  }
  switch (sender.tag) {
    case 0:
      [self.brain addOperation:CalculatorOperationTypeMultiplying];
      break;
    case 1:
      [self.brain addOperation:CalculatorOperationTypeDividing];
      break;
    case 2:
      [self.brain addOperation:CalculatorOperationTypeAdding];
      break;
    case 3:
      [self.brain addOperation:CalculatorOperationTypeSubstracting];
      break;
    case 4:
      [self.brain addOperation:CalculatorOperationTypeSignChanging];
      break;
    case 5:
      [self.brain addOperation:CalculatorOperationTypePi];
      break;
    case 6:
      [self.brain addOperation:CalculatorOperationTypeEulerNumber];
      break;
    case 7:
      [self.brain addOperation:CalculatorOperationTypeSinus];
      break;
    case 8:
      [self.brain addOperation:CalculatorOperationTypeCosinus];
      break;
    case 9:
      [self.brain addOperation:CalculatorOperationTypeSquareRoot];
      break;
    case 10:
      [self.brain addOperation:CalculatorOperationTypeLogarithm];
      break;
      
    default:
      break;
  }
  [self updateDisplay];
}

- (IBAction)variablePressed:(UIButton *)sender
{
  if (self.userIsInTheMiddleOfEnteringANumber) {
    [self enterPressed];
  }
  [self.brain addVariable:@"x"];
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
