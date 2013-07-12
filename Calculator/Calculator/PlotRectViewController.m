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

@interface PlotRectViewController ()

@end

@implementation PlotRectViewController

CGSize size;

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
    
    // Сохраняем размеры области рисования
    size = _imageView.frame.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.height, size.width));
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
    CGFloat k = size.height / (size.height - 45);
    location.y = location.y * k;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
    CGContextSetLineWidth(context, 5.0f);
    CGContextMoveToPoint(context, 100.0f, 100.0f);
    CGContextAddLineToPoint(context, location.x, location.y);
    CGContextStrokePath(context);
    
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

@end
