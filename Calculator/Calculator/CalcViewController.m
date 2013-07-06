//
//  CalcViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 30.06.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "CalcViewController.h"

enum {
    
    OP_PLUS   = 1001,
    OP_MINUS    = 1002,
    OP_MULT     = 1003,
    OP_DIV      = 1004

};



@interface CalcViewController ()

@end



@implementation CalcViewController

@synthesize userName;
@synthesize userPhone;
@synthesize userEmail;

- (void)viewDidLoad
{
    // загружаем сохраненные данные в поля настроек из родительского класса
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userName = [defaults objectForKey:@"savedUserName"];
    userPhone = [defaults objectForKey:@"savedUserPhone"];
    userEmail = [defaults objectForKey:@"savedUserEmail"];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clear:(id)sender {

    x = 0;
    
    [self calcScreen];

}


- (IBAction)clearAll:(id)sender {
    
    x = 0;
    
    y = 0;
    
    enterFlag = NO;
    yFlag = NO;
    dotFlag = NO;
    
    [self calcScreen];
    
}

//метод по нажатию на точку
- (IBAction)dotDivider:(id)sender {

    if (!dotFlag && (x > 0)) {
        
        dotFlag = YES;
        
    }
    
}


- (IBAction)digit:(id)sender{
    
    //условие для работы с точкой
    if (dotFlag) {
        NSInteger numberUfterDot = [sender tag];
        NSString * xStr =[NSString stringWithFormat:@"%i.%i", (int)x, numberUfterDot];
        NSLog(@"число после нажатия точки = %@", xStr);
    }
    
    //условие для дописывания числа
    if (enterFlag) {
        
        y = x;
        
        x = 0;
        
        enterFlag = NO;
    }
    
    x = (10.0f * x) + [sender tag];
    
    [self calcScreen];
    
}


- (IBAction)operation:(id)sender{
    
    if (yFlag && !enterFlag) {
        
        switch (operation) {
            case OP_PLUS:
                x = y + x;
                break;
                
            case OP_MINUS:
                x = y - x;
                break;
                
            case OP_MULT:
                x = y * x;
                break;
                
            case OP_DIV:
                x = y / x;
                break;
                
            default:
                break;
        }
        
        
    }
    
    y = x;
    
    enterFlag = YES;
    yFlag = YES;
    
    operation = [sender tag];
    
    [self calcScreen];
}



- (IBAction)inverseSign:(id)sender{

    x = -x;
    
    [self calcScreen];

}


- (void)calcScreen {
    
    NSString *str = [NSString stringWithFormat:@"%g",x];
    [displayLabel setText:str];
    
    //тест переменных родительского класса
    NSLog(@"OK %@", userName);
}

@end
