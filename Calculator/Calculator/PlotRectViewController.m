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
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Preset Saving..." message:@"Describe the Preset\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        UITextField *textField;
        textField = [[UITextField alloc] init];
        [textField setBackgroundColor:[UIColor whiteColor]];
        textField.delegate = self;
        textField.borderStyle = UITextBorderStyleLine;
        textField.frame = CGRectMake(15, 75, 255, 30);
        textField.font = [UIFont fontWithName:@"ArialMT" size:20];
        textField.placeholder = @"Preset Name";
        textField.textAlignment = UITextAlignmentCenter;
        textField.keyboardAppearance = UIKeyboardTypePhonePad;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [textField becomeFirstResponder];
        [alert addSubview:textField];
        [alert show];
        
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
    
    CGContextSetLineWidth(context, 5.0f * scaleFactor);
    
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
        CGContextAddArc(context, [[points objectAtIndex:i] CGPointValue].x, [[points objectAtIndex:i] CGPointValue].y, 10 * scaleFactor, 0, 2*M_PI, YES);
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

-(bool)lineCircleIntersection:(float)x0 circleY:(float)y0 circleRadius:(float)radius pointX1:(float)x1 pointY1:(float)y1 pointX2:(float)x2 pointY2:(float)y2 {
    double q = x0 * x0 + y0 * y0 - radius * radius;
    double k = -2.0 * x0;
    double l = -2.0 * y0;
    
    double z = x1 * y2 - x2 * y1;
    double p = y1 - y2;
    double s = x1 - x2;
    
    if (EqualDoubles(s, 0.0, 0.001))
    {
        s = 0.001;
    }
    
    double A = s*s+p*p;
    double B = s*s*k+2.0*z*p+s*l*p;
    double C = q*s*s+z*z+s*l*z;
    
    double D = B*B-4.0*A*C;
    
    if (D < 0.0)
    {
        return 0;
    }
    else if (D < 0.001)
    {
        xa = -B/(2.0*A);
        ya = (p*xa + z)/s;
        return 1;
    }
    else
    {
        xa = (-B + sqrt(D))/(2.0*A);
        ya = (p*xa + z)/s;
        
        xb = (-B - sqrt(D))/(2.0*A);
        yb = (p*xb + z)/s;
    }
    
    return true;
}

-(bool)equalDoubles:(double)n1 d2:(double)n2 prec(double)precision_
{
    return (fabs(n1-n2) <= precision_);
}

- (IBAction)menuBtn:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}
@end
