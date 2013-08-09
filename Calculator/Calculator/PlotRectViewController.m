//
//  PlotRectViewController.m
//  Calculator
//
//  Created by Ричард Попов on 06.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "PlotRectViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#include <math.h>

@interface PlotRectViewController ()

@end

@implementation PlotRectViewController

CGSize size;
float scaleFactor;
NSMutableArray *points;
bool perimeterFinished;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    points = [NSMutableArray array];
    
    perimeterFinished = false;
    
    scaleFactor = [[UIScreen mainScreen] scale];
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat widthInPixel = screen.size.width * scaleFactor;
    CGFloat heightInPixel = screen.size.height * scaleFactor;
    
    // Сохраняем размеры области рисования
    size = CGSizeMake(widthInPixel, heightInPixel);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    CGContextStrokePath(context);
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _imageView.image = result;
    [_imageView setNeedsDisplay];
    
    //добавляем меню
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    //NSLog(@"Image creation finished");
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:_imageView];
    
    // Находим этот адов коэффицент
    location.y = location.y * scaleFactor;
    location.x = location.x * scaleFactor;
    
    // если периметр закончен, то больше не строим точки
    if (perimeterFinished) {
        return;
    }
    
    // если точка была нажата рядом с последней, то не учитываем
    if ([points count] > 0 && [self isOwnedCircle:location.x andY:location.y circleX:[[points objectAtIndex:[points count] - 1] CGPointValue].x circleY:[[points objectAtIndex:[points count] - 1] CGPointValue].y circleRadius:40]) {
        return;
    }
    
    // если кол-во точек достаточно для построения фигуры и касание в окресности начала построения, то завершаем построение
    if ([points count] >= 3 && [self isOwnedCircle:location.x andY:location.y circleX:[[points objectAtIndex:0] CGPointValue].x circleY:[[points objectAtIndex:0] CGPointValue].y circleRadius:40]) {
        perimeterFinished = true;
        
        location.x = [[points objectAtIndex:0] CGPointValue].x;
        location.y = [[points objectAtIndex:0] CGPointValue].y;
    }

    [points addObject:[NSValue valueWithCGPoint:location]];
    NSLog(@"%i", [points count]);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
    CGContextSetLineWidth(context, 5.0f);
    
    if ([points count] == 1)
    {
        CGContextMoveToPoint(context, [[points objectAtIndex:0] CGPointValue].x, [[points objectAtIndex:0] CGPointValue].y);
    }
    else
    {
        for (int i = 0; i < [points count] - 1; i++) {
            CGContextMoveToPoint(context, [[points objectAtIndex:i] CGPointValue].x, [[points objectAtIndex:i] CGPointValue].y);
            CGContextAddLineToPoint(context, [[points objectAtIndex:i + 1] CGPointValue].x, [[points objectAtIndex:i + 1] CGPointValue].y);
        }
    }
    
    CGContextStrokePath(context);
    
    // зарисовка точек
    for (int i = 0; i < [points count]; i++) {
        CGContextAddArc(context, [[points objectAtIndex:i] CGPointValue].x, [[points objectAtIndex:i] CGPointValue].y, 10, 0, 2*M_PI, YES);
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
        CGContextDrawPath(context, kCGPathFill);
    }
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _imageView.image = result;
    [_imageView setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Получим context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect); // Очистим context
    
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
    CGContextFillRect(context, CGRectMake(20, 20, 100, 100));
}

- (bool)isOwnedCircle:(float)xPoint andY:(float)yPoint circleX:(float)xCircle circleY:(float)yCircle circleRadius:(int)radius {
    if (powf((xPoint - xCircle), 2.0) + powf((yPoint - yCircle), 2.0) <= powf(radius, 2.0)) {
        return true;
    }
    
    return false;
}

- (IBAction)menuBtn:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}
@end
