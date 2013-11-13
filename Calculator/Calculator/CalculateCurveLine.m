//
//  CalculateCurveLine.m
//  Calculator
//
//  Created by Александр Коровкин on 13.11.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "CalculateCurveLine.h"

@implementation CalculateCurveLine
@synthesize plot;

-(void)SaveCurve:(CurveLineModel *)curve {

    NSArray *alphabet = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                         componentsSeparatedByString:@" "];
    
    NSArray *plotSideArray = [plot.plotSide allObjects];
    
    NSLog(@"передана кривая - %@%@, длинна криволинейной = %@", curve.angleFirstCurve, curve.angleSecondCurve, plot.plotCurve);
}

@end

