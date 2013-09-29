//
//  PlotDataViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 29.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "PlotDataViewController.h"

@interface PlotDataViewController ()

@end

@implementation PlotDataViewController
@synthesize tableOfSides;
@synthesize managedObjectContext;
@synthesize angleCountOutlet;
@synthesize countOfAngle;
@synthesize alphabet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


// скрываем клавиатуру по нажатию кнопки
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //пользовательские поля
    [angleCountOutlet resignFirstResponder];

    
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    angleCountOutlet.delegate = self;
    
    
//    alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    alphabet = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                        componentsSeparatedByString:@" "];
    
    [tableOfSides reloadData];
    
    
    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dismissKeyboard)
                                              ];
    
    [self.view addGestureRecognizer:tapOnScrolView];
}


#pragma mark - table method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [countOfAngle intValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const CellId = @"PlotCell";
    PlotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[PlotCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    
    if (indexPath.row<25) {
        cell.sideName.text = [NSString stringWithFormat:@"%@%@", alphabet[indexPath.row], alphabet[indexPath.row+1]];
        NSLog(@"0 секция");

    }
    else if ((indexPath.row>=25) && (indexPath.row<50)) {
        cell.sideName.text = [NSString stringWithFormat:@"%@%@1", alphabet[indexPath.row-25], alphabet[indexPath.row-24]];
        NSLog(@"1 секция");
    }
    else if ((indexPath.row>=50) && (indexPath.row<75)) {
        cell.sideName.text = [NSString stringWithFormat:@"%@%@2", alphabet[indexPath.row-50], alphabet[indexPath.row-49]];
        NSLog(@"2 секция");

    }
    else if ((indexPath.row>=75) && (indexPath.row<100)) {
        cell.sideName.text = [NSString stringWithFormat:@"%@%@3", alphabet[indexPath.row-75], alphabet[indexPath.row-74]];
        NSLog(@"3 секция");
    }
    else {
        cell.sideName.text = @"че, сдурел?";
    }
    cell.sideWidth.text = @"";
    
    NSLog(@"строка %d - %@: %@",indexPath.row, cell.sideName.text, cell.sideWidth.text);
    return cell;
}


//- (void)tableView:(UITableView *)tableView
//didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [self findAndResignFirstResonder: self.view];
//}


- (BOOL)findAndResignFirstResonder:(UIView *)stView {
    if (stView.isFirstResponder) {
        [stView resignFirstResponder];
        return YES;
    }
    
    for (UIView *subView in stView.subviews) {
        if ([self findAndResignFirstResonder:subView]) {
            return YES;
        }
    }
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sideWidthField:(id)sender {
    NSLog(@"DONE");
}

- (IBAction)angleCount:(id)sender {
    countOfAngle = angleCountOutlet.text;
    [tableOfSides reloadData];
}


- (void)dismissKeyboard {
    
    [angleCountOutlet resignFirstResponder];
    [self findAndResignFirstResonder: self.view];
    
}

@end
