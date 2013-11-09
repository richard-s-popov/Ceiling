//
//  emailViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 21.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CalcAppDelegate.h"
#import "Projects.h"

@interface emailViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
    
    __weak IBOutlet UILabel *nameOfProject;
    __weak IBOutlet UILabel *adresslabel;
    __weak IBOutlet UILabel *phoneLabel;
}

@property (nonatomic, strong) Projects *project;
- (IBAction)sendEmailAction:(id)sender;

@end
