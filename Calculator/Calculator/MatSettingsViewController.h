//
//  MatSettingsViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 14.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *sectionTitle;
@property (weak, nonatomic) IBOutlet UITextField *rowTitle;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)addSelectionBtn:(id)sender;
- (IBAction)addRowBtn:(id)sender;




@end
