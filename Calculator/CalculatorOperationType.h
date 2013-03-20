//
//  CalculatorOperationType.h
//  Calculator
//
//  Created by Łukasz Przytuła on 18.03.2013.
//  Copyright (c) 2013 Mildware. All rights reserved.
//

#ifndef Calculator_CalculatorOperationType_h
#define Calculator_CalculatorOperationType_h

typedef enum {
  CalculatorOperationTypeAdding = 0,
  CalculatorOperationTypeSubstracting = 1,
  CalculatorOperationTypeMultiplying = 2,
  CalculatorOperationTypeDividing = 3,
  CalculatorOperationTypeSinus = 4,
  CalculatorOperationTypeCosinus = 5,
  CalculatorOperationTypeSquareRoot = 6,
  CalculatorOperationTypeLogarithm = 7,
  CalculatorOperationTypePi = 8,
  CalculatorOperationTypeEulerNumber = 9,
  CalculatorOperationTypeSignChanging = 10
} CalculatorOperationType;

#endif
