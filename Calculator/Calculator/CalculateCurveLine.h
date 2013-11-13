//
//  CalculateCurveLine.h
//  Calculator
//
//  Created by Александр Коровкин on 13.11.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewPlotViewController.h"
#import "CalcAppDelegate.h"
#import "Plot.h"
#import "PlotSide.h"
#import "CurveLineModel.h"

@interface CalculateCurveLine : NSObject
@property (nonatomic, strong) Plot *plot;

-(void)SaveCurve:(CurveLineModel*)curve;

@end
