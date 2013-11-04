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

CGFloat __scale;
CGFloat __previousScale;
CGFloat __previousScaleForButton;

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
    UIImage *image = [UIImage imageNamed:@"icon.png"];
    self.imageView.image = image;
    self.imageView.userInteractionEnabled = YES;
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
