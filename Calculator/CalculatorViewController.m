//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Łukasz Przytuła on 06.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *variableValues;

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL numberIsFloatingPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;

@end

@implementation CalculatorViewController

- (CalculatorBrain *)brain
{
  if (!_brain) {
    _brain = [[CalculatorBrain alloc] init];
  }
  return _brain;
}

- (NSDictionary *)testVariableValues
{
  return _testVariableValues;
}

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

- (IBAction)testPressed:(UIButton *)sender
{
  switch (sender.tag) {
    case 0:
      _testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:@215, @"x", @742, @"a", @584.9, @"b", nil];
      break;
    case 1:
      _testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:@15.84, @"x", @2, @"a", @-582.9, @"b", nil];
      break;
    case 2:
      _testVariableValues = nil;
      break;
      
    default:
      break;
  }
  [self updateDisplay];
}

- (void)updateVariablesValuesLabel
{
  self.variableValues.text = @"";
  for (NSString *variable in [CalculatorBrain variablesUsedInProgram:self.brain.program]) {
    self.variableValues.text = [self.variableValues.text stringByAppendingString:[NSString stringWithFormat:@"%@ = %@   ", variable, ZERO_IF_NIL([self.testVariableValues objectForKey:variable])]];
  }
}

- (void)updateDisplay
{
  self.display.text = [NSString stringWithFormat:@"%@", [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues]];
  self.description.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
  [self updateVariablesValuesLabel];
}

@end
