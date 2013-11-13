//
//  NewProjectDetailViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 23.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "NewProjectDetailViewController.h"

@interface NewProjectDetailViewController (){
    NSMutableArray *mutableArray;
    NSArray *plotArray;
    UITextField *namePlot;
    int numberOfButton;
}

@end

@implementation NewProjectDetailViewController
@synthesize managedObjectContext;
@synthesize project;

@synthesize nameClient;
@synthesize adressClient;
@synthesize phoneClient;

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
    [phoneClient setDelegate:self];

    
    //поле для названия чертежа
    UIImage *additionalButtomBackground = [[UIImage imageNamed:@"project_additionalPlot2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    namePlot = [[UITextField alloc] initWithFrame:CGRectMake(0, 201, 160, 40)];
    namePlot.delegate = self;
    namePlot.borderStyle = UITextBorderStyleBezel;
    namePlot.background = additionalButtomBackground;
    namePlot.placeholder = @"Название";
    namePlot.autocapitalizationType = UITextAutocapitalizationTypeWords;
    namePlot.tag = 2;
    namePlot.keyboardType = UIKeyboardTypeDefault;
    
    //добвляем кнопки для NumPad
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Отмена" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"FuturisCyrillic" size:14.0f];
    [button.layer setCornerRadius:4.0f];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor: [[UIColor grayColor] CGColor]];
    button.frame=CGRectMake(0.0, 100.0, 70.0, 30.0);
    [button addTarget:self action:@selector(cancelNamePlot)  forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *saveButtonToolbar = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButtonToolbar setTitle:@"Сохранить" forState:UIControlStateNormal];
    saveButtonToolbar.titleLabel.font = [UIFont fontWithName:@"FuturisCyrillic" size:14.0f];
    [saveButtonToolbar.layer setCornerRadius:4.0f];
    [saveButtonToolbar.layer setMasksToBounds:YES];
    [saveButtonToolbar.layer setBorderWidth:1.0f];
    [saveButtonToolbar.layer setBorderColor: [[UIColor grayColor] CGColor]];
    saveButtonToolbar.frame=CGRectMake(0.0, 100.0, 100.0, 30.0);
    [saveButtonToolbar addTarget:self action:@selector(doneNamePlot)  forControlEvents:UIControlEventTouchUpInside];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc] initWithCustomView:button],
//                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNamePlot)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                           [[UIBarButtonItem alloc]initWithTitle:@"Сохранить" style:UIBarButtonItemStyleDone target:self action:@selector(doneNamePlot)],
                           [[UIBarButtonItem alloc] initWithCustomView:saveButtonToolbar],
                           nil];
    [numberToolbar sizeToFit];
    
    namePlot.inputAccessoryView = numberToolbar;
    
    //добавляем кнопку редактирования
    UIImage *rightButtonImage = [[UIImage imageNamed:@"rightBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 23, 0, 6)];
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStyleBordered target:self action:@selector(saveData)];
    [addButton setBackgroundImage:rightButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [addButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor blackColor], UITextAttributeTextColor,
                                       [UIFont fontWithName:@"FuturisCyrillic" size:15],UITextAttributeFont,
                                       [UIColor clearColor], UITextAttributeTextShadowColor,
                                       nil]
                             forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = addButton;

    [self reloadData];
    
}


-(void)reloadData {
    nameClient.text = project.projectName;
    adressClient.text = project.projectAdress;
    phoneClient.text = project.projectPhone;
    
    [self reloadPlotTable];

}


-(void)saveData {
    project.projectName = nameClient.text;
    project.projectAdress = adressClient.text;
    project.projectPhone = phoneClient.text;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
    }
    
    [self reloadPlotTable];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Сохранено" message:@"Проект сохранен, при необходимости, Вы можете внести изменения и сохранить его вновь." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
//    [self.navigationController popViewControllerAnimated:YES];
}


//передаем данные по segue в CostViewController для расчета стоимости
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqual: @"NewCost"]) {
        CostViewController *costViewController = segue.destinationViewController;
        costViewController.project = project;
    }
    if ([segue.identifier isEqual: @"projectPlotSegue"]) {
        NewPlotViewController *newPlotViewController = segue.destinationViewController;
        newPlotViewController.plotFromProject = [plotArray objectAtIndex:PlotTableView.indexPathForSelectedRow.row];
    }
    if ([segue.identifier isEqual:@"NewMailSegue"]) {
        emailViewController *emailViewController = segue.destinationViewController;
        emailViewController.project = project;
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
    [phoneClient resignFirstResponder];
}


#pragma mark - plot tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = 0;
    if (plotArray.count == 0) {
        count = 0;
    }
    else {
        count = plotArray.count;
    }
    NSLog(@"массив с чертежами = %d", count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlotListCell";
    ProjectPlotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    PlotModel *tmpPlotModel = [[PlotModel alloc] init];
    tmpPlotModel.plotName = [[plotArray objectAtIndex:indexPath.row] plotName];
    tmpPlotModel.plotPrice = [[plotArray objectAtIndex:indexPath.row] plotPrice];
    
    cell.namePlot.text = [NSString stringWithFormat:@"%@", tmpPlotModel.plotName];
    cell.namePlot.frame = CGRectMake(20, 20, 150, 30);
    [cell.namePlot setFont:[UIFont fontWithName:@"FuturisCyrillic" size:22]];
    cell.pricePlot.text = [NSString stringWithFormat:@"%1.2f руб.", [tmpPlotModel.plotPrice floatValue]];
    cell.pricePlot.frame = CGRectMake(200, 20, 110, 30);
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //кнопка добавить дополнительные настройки чертежа
    UIImage *additionalButtomBackground = [[UIImage imageNamed:@"project_additionalPlot2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIButton *additionalPlotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    additionalPlotButton.frame = CGRectMake(0, 50, 320, 50);
    [additionalPlotButton setTitle:@"Посчитать стоимость" forState:UIControlStateNormal];
    [[additionalPlotButton titleLabel] setFont:[UIFont fontWithName:@"FuturisCyrillic" size:16]];
    [additionalPlotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    [additionalPlotButton setBackgroundImage:additionalButtomBackground forState:UIControlStateNormal];
    [additionalPlotButton addTarget:self action:@selector(additionalPlotAction:) forControlEvents:UIControlEventTouchUpInside];
    additionalPlotButton.tag = indexPath.row+1;
    [cell.contentView addSubview:additionalPlotButton];
    
    //кнопка просмотреть
    UIImage *viewButtomBackground = [[UIImage imageNamed:@"project_viewPlot.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIButton *viewPlotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    viewPlotButton.frame = CGRectMake(0, 100, 220, 50);
    [viewPlotButton setTitle:@"Построить" forState:UIControlStateNormal];
    [viewPlotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [viewPlotButton setBackgroundImage:viewButtomBackground forState:UIControlStateNormal];
    [viewPlotButton addTarget:self action:@selector(viewPlotAction:) forControlEvents:UIControlEventTouchUpInside];
    viewPlotButton.tag = indexPath.row+1;
    [cell.contentView addSubview:viewPlotButton];
    
    //кнопка удалить
    UIImage *deleteButtomBackground = [[UIImage imageNamed:@"project_deletePlot.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIButton *deletePlotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deletePlotButton.frame = CGRectMake(220, 100, 100, 50);
    [deletePlotButton setTitle:@"Удалить" forState:UIControlStateNormal];
    [deletePlotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [deletePlotButton setBackgroundImage:deleteButtomBackground forState:UIControlStateNormal];
    [deletePlotButton addTarget:self action:@selector(deletePlotAction:) forControlEvents:UIControlEventTouchUpInside];
    deletePlotButton.tag = indexPath.row+1;
    [cell.contentView addSubview:deletePlotButton];
    
    return cell;
    
}


-(void)additionalPlotAction:(UIButton*)additionalPlotButton {
    CostViewController *costViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CostStoryboardId"];
    costViewController.plot = [plotArray objectAtIndex:[additionalPlotButton tag]-1];
    
    [self.navigationController pushViewController:costViewController animated:YES];
}


//метод для перехода на чертеж
-(void)viewPlotAction:(UIButton*)viewPlotButton {
    
    NewPlotViewController *newPlotViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlotSidesStoryboardId"];
    newPlotViewController.plotFromProject = [plotArray objectAtIndex:[viewPlotButton tag]-1];
    newPlotViewController.project = project;
    
    [self.navigationController pushViewController: newPlotViewController animated:YES];
}

//метод для удаления чертежа
-(void)deletePlotAction:(UIButton*)deletePlotButton {
    numberOfButton = [deletePlotButton tag]-1;
    [self alertOKCancelAction];
}

//метод подтверждения удаления чертежа
- (void)alertOKCancelAction {
    // open a alert with an OK and cancel button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Удаление чертежа" message:@"Вы уверены, что хотите удалить этот чертеж?" delegate:self cancelButtonTitle:@"Удалить" otherButtonTitles:@"Отмена", nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        [project removeProjectPlotObject:[plotArray objectAtIndex:numberOfButton]];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
        }
        
        [self reloadPlotTable];
    }
}


- (IBAction)addPlot:(id)sender {
    [scrollView addSubview:namePlot];
    [namePlot becomeFirstResponder];
    namePlot.text = @"";
}

- (IBAction)pushToEmail:(id)sender {
}

//метод для button newPlot
- (void)doneNamePlot {
    plot = [NSEntityDescription insertNewObjectForEntityForName:@"Plot" inManagedObjectContext:self.managedObjectContext];
    plot.plotName = [NSString stringWithFormat:@"%@", namePlot.text];
    
    [project addProjectPlotObject:plot];
    
    [namePlot removeFromSuperview];
    [namePlot resignFirstResponder];
    
    [self reloadPlotTable];
}

-(void)reloadPlotTable {
    //создаем массив с чертежами проекта которые есть в core Data
    plotArray = [[NSArray alloc] init];
    plotArray = [project.projectPlot allObjects];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"plotName" ascending:YES];
    NSArray *sordDescriptors = [NSArray arrayWithObject:sortDescriptor];
    plotArray = [plotArray sortedArrayUsingDescriptors:sordDescriptors];
    
    [PlotTableView reloadData];
    
    //устанавливаем высоту балички в зависимости от колличества ячеек
    CGRect frame = PlotTableView.frame;
    if (plotArray.count == 1) {
        
        frame.size.height = 400; //какая конструкция из за того что count бывает равен 0
    }
    else {
        frame.size.height = ((plotArray.count+1) * 155); //какая конструкция из за того что count бывает равен 0
    }
    PlotTableView.frame = frame;
    
    //scrollView соответственный таблице
    [scrollView setContentSize:CGSizeMake(320, frame.size.height + 400)];
    
}

//метод для button newPlot
-(void)cancelNamePlot {
    [namePlot resignFirstResponder];
    [namePlot removeFromSuperview];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadPlotTable];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
