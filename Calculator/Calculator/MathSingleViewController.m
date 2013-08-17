//
//  MathSingleViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 15.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MathSingleViewController.h"

@interface MathSingleViewController ()

@end

@implementation MathSingleViewController

@synthesize nameMaterialInDetail;
@synthesize priceMaterialInDetail;

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
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setDetail:(MathModel *)detail {

    _detail = detail;
    NSLog(@"%@", _detail.widthMaterial);
}

- (void) reloadData {
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", _detail.nameMaterial, _detail.widthMaterial];
    
    nameMaterialInDetail.text = [NSString stringWithFormat:@"%@ %@", _detail.nameMaterial, _detail.widthMaterial];
    
    priceMaterialInDetail.text =[NSString stringWithFormat:@"%@ руб/м2", _detail.priceMaterial];
    
    
    
}

- (IBAction)saveMaterialSingle:(id)sender {
    
    
}
@end
