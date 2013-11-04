//
//  NewProjectDetailViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 23.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "NewProjectDetailViewController.h"

@interface NewProjectDetailViewController ()

@end

@implementation NewProjectDetailViewController
@synthesize managedObjectContext;
@synthesize project;

@synthesize nameClient;
@synthesize adressClient;
@synthesize lusterClient;
@synthesize bypassClient;
@synthesize spotClient;
@synthesize explaneClient;

@synthesize PlotTableView;
@synthesize plot;

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(NSManagedObjectContext *)managedObjectContext {
    return [(CalcAppDelegate *)[[UIApplication sharedApplication] delegate]managedObjectContext];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 900)];
    [nameClient setDelegate:self];
    [adressClient setDelegate:self];
    [lusterClient setDelegate:self];
    [bypassClient setDelegate:self];
    [spotClient setDelegate:self];
    [explaneClient setDelegate:self];
    
    
    //сокрытие клавиатуры по нажатию на фон
    UITapGestureRecognizer *tapOnScrollView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapOnScrollView];
    
    //добавляем кнопку редактирования
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveData)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [self reloadData];
    
}


-(void)reloadData {
    nameClient.text = project.projectName;
    adressClient.text = project.projectAdress;
    lusterClient.text = [project.projectLuster stringValue];
    bypassClient.text = [project.projectBypass stringValue];
    spotClient.text = [project.projectSpot stringValue];
    explaneClient.text = project.projectExplane;
    
    
}


-(void)saveData {
    project.projectName = nameClient.text;
    project.projectAdress = adressClient.text;
    project.projectLuster = [NSNumber numberWithInt:[lusterClient.text intValue]];
    project.projectBypass = [NSNumber numberWithInt:[bypassClient.text intValue]];
    project.projectSpot = [NSNumber numberWithInt:[spotClient.text intValue]];
    project.projectExplane = explaneClient.text;
    
    
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


//передаем данные по segue в CostViewController для расчета стоимости
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual: @"NewCost"]) {
        
        CostViewController *costViewController = segue.destinationViewController;
        costViewController.project = project;
    }
}


#pragma mark - dismiss keyboard
//dismiss keyboard
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    return YES;
}


-(void)dismissKeyboard {

    [nameClient resignFirstResponder];
    [adressClient resignFirstResponder];
    [lusterClient resignFirstResponder];
    [bypassClient resignFirstResponder];
    [spotClient resignFirstResponder];
    [explaneClient resignFirstResponder];
}


#pragma mark - plot tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int count = 0;
    if (project.projectPlot.count == 0) {
        count = 1;
    }
    else {
        count = project.projectPlot.count;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = @"text";
    cell.detailTextLabel.text = @"detail";
    return cell;
}


- (IBAction)addPlot:(id)sender {
    
    plot = [NSEntityDescription insertNewObjectForEntityForName:@"Plot" inManagedObjectContext:self.managedObjectContext];
    
    [project addProjectPlotObject:plot];
    [PlotTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
