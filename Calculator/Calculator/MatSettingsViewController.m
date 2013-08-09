//
//  MatSettingsViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 14.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MatSettingsViewController.h"

enum {

    CATIGORY = 601,
    MATERIAL = 602

};

@interface MatSettingsViewController ()
{

    NSMutableArray * sectionsArray;
    NSMutableArray * rowsInSectionsArray;
    NSMutableArray *items;

}

@end

@implementation MatSettingsViewController

@synthesize sectionTitle,rowTitle, myTableView;


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
    [sectionTitle resignFirstResponder];
    [rowTitle resignFirstResponder];
    
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // скрываем клавиатуру по нажатию кнопки
    sectionTitle.delegate = self;
    rowTitle.delegate = self;
    
    
    sectionTitle.text = nil;
    rowTitle.text = nil;
    
    sectionsArray = [[NSMutableArray alloc] init];
    rowsInSectionsArray = [[NSMutableArray alloc] init];
    
    [[self myTableView] setDelegate:self]; //равнозначно self.myTableView.delegate = self
    [[self myTableView] setDataSource:self]; //равнозначно self.myTableView.dataSource = self
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addSelectionBtn:(id)sender {
    
    if (sectionTitle.text.length > 0) {
        [sectionsArray addObject:[NSString stringWithFormat:@"%@", sectionTitle.text]];
        [[self myTableView]reloadData];
        sectionTitle.text = nil;
    }
    
}

- (IBAction)addRowBtn:(id)sender {
    
    if (rowTitle.text.length > 0) {
        [rowsInSectionsArray addObject:[NSString stringWithFormat:@"%@", rowTitle.text]];
        [[self myTableView] reloadData];
        rowTitle.text = nil;
    }
    
}


#pragma методы datasource и delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [sectionsArray count];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [rowsInSectionsArray count];

}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return [sectionsArray objectAtIndex:section];

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * cellIdentifire = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
    }
    
    cell.textLabel.text = [rowsInSectionsArray objectAtIndex:indexPath.row];
    
    return cell;

}

#pragma поднимаем клавиатуру

//поднимаем View для видимости поля ввода
// Portrait Keyboard height 216 pts
// Landscape Keyboard height 162 pts
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == CATIGORY || textField.tag == MATERIAL) {
        
        float moveSpeed = 0.2f;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:moveSpeed];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        self.view.frame = CGRectMake(0, -210.0f, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    float moveSpeed = 0.2f;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:moveSpeed];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}



@end
