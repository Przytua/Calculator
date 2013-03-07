//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Łukasz Przytuła on 06.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

static const NSString *space = @"  ";

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL numberIsFloatingPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (strong, nonatomic) IBOutlet UILabel *history;

@end

@implementation CalculatorViewController

- (CalculatorBrain *)brain
{
  if (!_brain) {
    _brain = [[CalculatorBrain alloc] init];
  }
  return _brain;
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
    [self removeEqualSignFromHistory];
    self.display.text = digit;
    self.userIsInTheMiddleOfEnteringANumber = YES;
  }
}

- (IBAction)enterPressed {
  [self.brain pushOperand:[self.display.text doubleValue]];
  [self removeEqualSignFromHistory];
  self.history.text = [self.history.text stringByAppendingFormat:@"%g%@", [self.display.text doubleValue], space];
  self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)clearPressed {
  self.history.text = @"";
  self.display.text = @"0";
  self.userIsInTheMiddleOfEnteringANumber = NO;
  self.numberIsFloatingPoint = NO;
}

- (IBAction)backspacePressed {
  if (self.userIsInTheMiddleOfEnteringANumber) {
    self.display.text = [self.display.text substringToIndex:self.display.text.length - 1];
    if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
      self.numberIsFloatingPoint = NO;
    }
    if (self.display.text.length == 0) {
      self.userIsInTheMiddleOfEnteringANumber = NO;
      self.display.text = @"0";
    }
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
  double result = [self.brain performOperation:operation];
  if (!isnan(result)) {
    [self removeEqualSignFromHistory];
    self.history.text = [self.history.text stringByAppendingFormat:@"%@%@=%@", operation, space, space];
    self.display.text = [NSString stringWithFormat:@"%g", result];
  }
}

- (void)removeEqualSignFromHistory {
  if ([self.history.text rangeOfString:@"="].location != NSNotFound) {
    self.history.text = [self.history.text substringToIndex:self.history.text.length - (1 + space.length)];
  }
}

@end
