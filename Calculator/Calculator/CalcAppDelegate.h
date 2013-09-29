//
//  CalcAppDelegate.h
//  Calculator
//
//  Created by Александр Коровкин on 30.06.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#define blackText [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,[UIFont fontWithName:@"FuturisCyrillic" size:15],UITextAttributeFont,[UIColor clearColor], UITextAttributeTextShadowColor,nil]

#define redText [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],UITextAttributeTextColor,[UIFont fontWithName:@"FuturisCyrillic" size:15],UITextAttributeFont,[UIColor clearColor], UITextAttributeTextShadowColor,nil]

@interface CalcAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
