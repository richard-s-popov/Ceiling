//
//  PlotRectViewController.m
//  Calculator
//
//  Created by Ричард Попов on 06.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "PlotRectViewController.h"

@interface PlotRectViewController ()

@end

@implementation PlotRectViewController

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
    
    NSLog(@"Creating image");
    NSLog(@"%f %f", _imageView.frame.size.height, _imageView.frame.size.width);
    CGSize size = _imageView.frame.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, 240.0f, 240.0f));
    
    CGContextSetLineWidth(context, 5.0f);
    CGContextMoveToPoint(context, 100.0f, 100.0f);
    CGContextAddLineToPoint(context, 150.0f, 150.0f);
    CGContextStrokePath(context);
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _imageView.image = result;
    [_imageView setNeedsDisplay];
    
    NSLog(@"Image creation finished");
}

- (void)drawRect:(CGRect)rect {
    // Получим context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect); // Очистим context
    
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
    CGContextFillRect(context, CGRectMake(20, 20, 100, 100));
}

@end
