//
//  PlotVisualController.m
//  Calculator
//
//  Created by Ричард Попов on 19.10.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "PlotVisualController.h"

@interface PlotVisualController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIStepper *scaleButton;

- (IBAction)scaleImage:(UIPinchGestureRecognizer *)sender;
- (IBAction)dragImage:(UIPanGestureRecognizer *)sender;
- (IBAction)changeScale:(UIStepper *)sender;

@end

@implementation PlotVisualController
@synthesize plot;

CGFloat __scale;
CGFloat __previousScale;
CGFloat __previousScaleForButton;

CGSize size;
float scaleFactor;
char alphabet2[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

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
    
    __scale = 1.0;
    __previousScaleForButton = 1.0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self drawPlot];
    
    self.imageView.userInteractionEnabled = YES;
}

- (void)drawPlot
{
    NSMutableArray *coordsArray = [[NSMutableArray alloc] init];
    
    CalculationService *calcService = [[CalculationService alloc] init];
    coordsArray = [calcService getCoords:plot];
    
    for (int i = 0; i < coordsArray.count; i++) {
        CoordModel *coord = [coordsArray objectAtIndex:i];
        
        coord.x = coord.x * 30;
        coord.y = coord.y * 30;
        
        [coordsArray replaceObjectAtIndex:i withObject:coord];
    }
    
    scaleFactor = [[UIScreen mainScreen] scale];
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat widthInPixel = screen.size.width * scaleFactor;
    CGFloat heightInPixel = screen.size.height * scaleFactor;
    
    // Сохраняем размеры области рисования
    size = CGSizeMake(widthInPixel, heightInPixel);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    
    CGContextSetLineWidth(context, 5.0f * scaleFactor);
    
    for (int i = 0; i < [coordsArray count] - 1; i++) {
        CoordModel *coord = [coordsArray objectAtIndex:i];
        CoordModel *coord2 = [coordsArray objectAtIndex:i + 1];
        
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
        
        CGContextMoveToPoint(context, coord.x, coord.y);
        CGContextAddLineToPoint(context, coord2.x, coord2.y);
        
        CGContextStrokePath(context);
    }
    
    // зарисовка точек
    for (int i = 0; i < [coordsArray count]; i++) {
        CoordModel *coord = [coordsArray objectAtIndex:i];
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
        
        CGContextAddArc(context, coord.x, coord.y, 10 * scaleFactor, 0, 2*M_PI, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
    
    // рисуем буквы
    for (int i = 0; i < [coordsArray count]; i++) {
        CoordModel *coord = [coordsArray objectAtIndex:i];
        
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
        
        // Если периметр завершен, то букву к последней точке не ставим
        if (i != [coordsArray count] - 1)
        {
            CGContextSetLineWidth(context, 2.0f * scaleFactor);
            CGContextSelectFont(context, "Helvetica", 20.f, kCGEncodingMacRoman);
            CGContextSetTextDrawingMode(context, kCGTextFillStroke);
            CGContextShowTextAtPoint(context, coord.x - 20, coord.y - 25, &alphabet2[i], 1);
        }
        
        CGContextDrawPath(context, kCGPathFill);
    }
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = result;
    [self.imageView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scaleImage:(UIPinchGestureRecognizer *)sender {
    if ([sender state] == UIGestureRecognizerStateBegan) {
        __previousScale = __scale;
    }
    
    CGFloat currentScale = MAX(MIN([sender scale] * __scale, 3), 1);
    CGFloat scaleStep = currentScale / __previousScale;
    
    [self.view setTransform: CGAffineTransformScale(self.view.transform, scaleStep, scaleStep)];
    
    if (sender.state == UIGestureRecognizerStateEnded && currentScale == 1)
    {
        [UIView
         animateWithDuration:0.2
         delay:0
         options:UIViewAnimationOptionCurveEaseOut
         animations:^{
             sender.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
         }
         completion:nil];
    }
    
    __previousScale = currentScale;
    
    if ([sender state] == UIGestureRecognizerStateEnded ||
        [sender state] == UIGestureRecognizerStateCancelled ||
        [sender state] == UIGestureRecognizerStateFailed) {
        // Gesture can fail (or cancelled?) when the notification and the object is dragged simultaneously
        __scale = currentScale;
    }
}

- (IBAction)dragImage:(UIPanGestureRecognizer *)sender {
    if (__scale > 1.0)
    {
        CGPoint translation = [sender translationInView:self.view];
        sender.view.center = CGPointMake(sender.view.center.x + translation.x,
                                         sender.view.center.y + translation.y);

        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            CGPoint velocity = [sender velocityInView:self.view];
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
            CGFloat slideMult = magnitude / 200;
            
            float slideFactor = 0.1 * slideMult; // Increase for more of a slide
            CGPoint finalPoint = CGPointMake(sender.view.center.x + (velocity.x * slideFactor), sender.view.center.y + (velocity.y * slideFactor));
            
            finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
            finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
            
            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{ sender.view.center = finalPoint; } completion:nil];
        }
    }
}

- (IBAction)changeScale:(UIStepper *)sender {
    double value = [sender value];
    
    [UIView
     animateWithDuration:0.5
     delay:0.0
     options:UIViewAnimationOptionCurveEaseOut
     animations:
     ^{
         self.view.transform = CGAffineTransformScale(self.view.transform, 1, 1);
     }
     completion:^(BOOL finished)
     {
         
     }
    ];
}

@end
