//
//  emailViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 21.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import "CalcAppDelegate.h"
#import "Projects.h"
#import "Plot.h"

@interface emailViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
    
    __weak IBOutlet UILabel *nameOfProject;
    __weak IBOutlet UILabel *adresslabel;
    __weak IBOutlet UILabel *phoneLabel;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) Projects *project;
@property (nonatomic, strong) Plot *plotForImage;
- (IBAction)sendEmailAction:(id)sender;

@end
