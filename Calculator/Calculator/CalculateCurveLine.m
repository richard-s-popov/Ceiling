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
@synthesize currentSideWidth;
@synthesize arrayOfSides;

-(void)SaveCurve:(CurveLineModel *)curve {

//    NSArray *alphabet = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
//                         componentsSeparatedByString:@" "];
    
    
    float curveWidth = 0;
    int countOfCurveAngle = 0;
    BOOL isCurve = NO;
    //создаем цыкл для пересчета криволинейности
    while (countOfCurveAngle != arrayOfSides.count) {
        
        
        
        if ([curve.angleFirstCurve isEqual:[[arrayOfSides objectAtIndex:countOfCurveAngle] angleFirst]]) {
            isCurve = YES;
        }
        if ([curve.angleSecondCurve isEqual:[[arrayOfSides objectAtIndex:countOfCurveAngle] angleFirst]]) {
            isCurve = NO;
        }
        if (isCurve == YES) {
            currentSideWidth = [[[arrayOfSides objectAtIndex:countOfCurveAngle] sideWidth] intValue];
            curveWidth = curveWidth + currentSideWidth;
        }
        
        
        countOfCurveAngle++;
    }
    float resumeCurveWidth = curveWidth/100 + [plot.plotCurve floatValue];
    NSLog(@"длинна криволинейности = %1.2f", resumeCurveWidth);
    plot.plotCurve = [NSNumber numberWithFloat:resumeCurveWidth];

}

@end

