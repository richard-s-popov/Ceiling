//
//  CalcAppDelegate.m
//  Calculator
//
//  Created by Александр Коровкин on 30.06.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "CalcAppDelegate.h"
#import "NewProjectDetailViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@implementation CalcAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navBar4.png"];
    UIImage *imageNavBarShadow = [UIImage imageNamed:@"navBarShadow.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:imageNavBarShadow];
    
    UIImage *tabBarBackground = [UIImage imageNamed:@"tbBackground_new.png"];
    UIImage *imageTabBarShadow = [UIImage imageNamed:@"tabBarShadow2.png"];
    //    UIImage *tbSelected = [UIImage imageNamed:@"tbSelected.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setShadowImage:imageTabBarShadow];
    
    NSDictionary *tabBarTitle = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIColor blackColor],UITextAttributeTextColor,
                                 [UIColor clearColor], UITextAttributeTextShadowColor,
                                 [UIFont fontWithName:@"PTSans-Narrow" size:10],UITextAttributeFont,
                                 [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
    [[UITabBarItem appearance] setTitleTextAttributes:tabBarTitle forState:UIControlStateNormal];
    //    [[UITabBar appearance] setSelectedImageTintColor:[UIColor grayColor]];
    
    //настраиваем цвет title в приложении
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor blackColor],UITextAttributeTextColor,
                                               [UIColor clearColor], UITextAttributeTextShadowColor,
                                               [UIFont fontWithName:@"PTSans-Narrow" size:25],UITextAttributeFont,
                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    
    
    //    UIImage *backButtonImage = [[UIImage imageNamed:@"backBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 23, 0, 6)];
    //    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor blackColor], UITextAttributeTextColor,
                                                          [UIFont fontWithName:@"FuturisCyrillic" size:15],UITextAttributeFont,
                                                          [UIColor clearColor], UITextAttributeTextShadowColor,
                                                          nil]
                                                forState:UIControlStateNormal];
    
    
    UIImage *barButtonImage = [[UIImage imageNamed:@"barBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UILabel appearance] setFont:[UIFont fontWithName:@"FuturisCyrillic" size:17]];
    
    
    
    
    //для MFMailComposeViewController убираем стили навигации что бы не глючила отправка писем
    [[UINavigationBar appearanceWhenContainedIn:[MFMailComposeViewController class], nil] setTitleTextAttributes:
     @{
       UITextAttributeFont : [UIFont boldSystemFontOfSize:10.0f],
       }];
    
//    [[UIBarButtonItem appearanceWhenContainedIn:[MFMailComposeViewController class], [NewProjectDetailViewController class], nil]
//     setTintColor:[UIColor whiteColor]];
    
//    UIImage *imageTest = [UIImage imageNamed:@"project_viewPlot.png"];
//    [[UINavigationBar appearanceWhenContainedIn:[MFMailComposeViewController class], nil] setBackgroundImage:imageTest forBarMetrics:UIBarMetricsDefault];
    
    
    
    
    
    //toolbar
//    [[UIToolbar appearance] setBackgroundImage:navBackgroundImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    
    //возвращает список шрифтов в лог
//    for (NSString *familyName in [UIFont familyNames]) {
//        
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            
//            NSLog(@"%@", fontName);
//            
//        }
//        
//    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL =  [[NSBundle mainBundle] URLForResource:@"Projects" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Projects.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
