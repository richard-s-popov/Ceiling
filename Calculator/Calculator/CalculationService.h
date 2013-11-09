//
//  CalculationService.h
//  Calculator
//
//  Created by Ричард Попов on 19.10.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plot.h"
#import "PlotDiagonal.h"
#import "PlotSide.h"
#include <math.h>
#include "CoordModel.h"

@interface CalculationService : NSObject

-(NSMutableArray*)getCoords:(Plot *)plot;
-(NSMutableArray*)getDiagonalCoords:(Plot *)plot;

-(double)getSpaceValue:(NSMutableArray *)coordsArray;
-(double)getPerimetr:(Plot *)plot;

@end
