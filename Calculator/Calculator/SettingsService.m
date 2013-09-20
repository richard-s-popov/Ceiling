//
//  SettingsService.m
//  Calculator
//
//  Created by Александр Коровкин on 08.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "SettingsService.h"


@implementation SettingsService
//@synthesize contacts;

- (void)Save:(SettingsOptionsModel *)model {
    
    //core data method
//    CalcAppDelegate *calcAppDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *_managedObjectContext = [calcAppDelegate managedObjectContext];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:_managedObjectContext];
//    NSLog(@"name: %@", model.userName);
//    contacts = [NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:_managedObjectContext];
//    [contacts setUserName:model.userName];
//    [contacts setUserMail:model.userMail];
//    [contacts setUserPhone:model.userPhone];
//    
//    [contacts setManagerName:model.managerName];
//    [contacts setManagerMail:model.managerMail];
//    [contacts setManagerPhone:model.managerPhone];
//    
//    [contacts setManufactoryMail:model.manufactoryMail];
//    [contacts setManufactoryPhone:model.manufactoryPhone];
//    
//    
//    NSError *error = nil;
//    if (![_managedObjectContext save:&error]) {
//    }
    
    //old method
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[model userName] forKey:@"savedUserName"];
    [defaults setObject:[model userPhone] forKey:@"savedUserPhone"];
    [defaults setObject:[model userMail] forKey:@"savedUserEmail"];
    
    [defaults setObject:[model managerName] forKey:@"savedManagerName"];
    [defaults setObject:[model managerPhone] forKey:@"savedManagerPhone"];
    [defaults setObject:[model managerMail] forKey:@"savedManagerEmail"];
    
    [defaults setObject:[model manufactoryPhone] forKey:@"savedManufactoryPhone"];
    [defaults setObject:[model manufactoryMail] forKey:@"savedManufactoryEmail"];
    
    [defaults synchronize];
}

- (SettingsOptionsModel *)Read {
    
    //core data method
    
//    CalcAppDelegate *calcAppDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *_managedObjectContext = [calcAppDelegate managedObjectContext];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:_managedObjectContext];
    
//    Contacts *contacts = [[Contacts alloc] initWithEntity:entity insertIntoManagedObjectContext:_managedObjectContext];
    
//    [fetchRequest setEntity:entity];
//    
//    NSError *error = nil;
//    
//    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    for (NSManagedObject *managedObject in fetchedObjects) {
    
//        [_managedObjectContext deleteObject:managedObject];         //удаление всех объектов
//    }
//        if (![_managedObjectContext save:&error]) {                 //сохранение после удаления
//    }
//        NSLog(@"Name: %@", [managedObject valueForKey:@"userName"]);
//        NSManagedObject *adress = [managedObject valueForKey:@"userMail"];
//        NSLog(@"Adress: %@", adress);
//        
//        contacts.userName = [managedObject valueForKey:@"userName"];
//        contacts.userMail = [managedObject valueForKey:@"userMail"];
//        contacts.userPhone = [managedObject valueForKey:@"userPhone"];
//        
//        contacts.managerName = [managedObject valueForKey:@"managerName"];
//        contacts.managerMail = [managedObject valueForKey:@"managerMail"];
//        contacts.managerPhone = [managedObject valueForKey:@"managerPhone"];
//        
//        contacts.manufactoryMail = [managedObject valueForKey:@"manufactoryMail"];
//        contacts.manufactoryPhone = [managedObject valueForKey:@"manufactoryPhone"];
//    
//    }
    
    
    //тест
//    contacts.userName = @"name";
//    contacts.userMail = @"";
//    contacts.userPhone = @"";
//    
//    contacts.managerName = @"";
//    contacts.managerMail = @"";
//    contacts.managerPhone = @"";
//    
//    contacts.manufactoryMail = @"";
//    contacts.manufactoryPhone = @"";
    
    
    //old method
    SettingsOptionsModel *contacts = [[SettingsOptionsModel alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [contacts setUserName:[defaults objectForKey:@"savedUserName"]];
    [contacts setUserPhone:[defaults objectForKey:@"savedUserPhone"]];
    [contacts setUserMail:[defaults objectForKey:@"savedUserEmail"]];
    
    [contacts setManagerName:[defaults objectForKey:@"savedManagerName"]];
    [contacts setManagerPhone:[defaults objectForKey:@"savedManagerPhone"]];
    [contacts setManagerMail:[defaults objectForKey:@"savedManagerEmail"]];
    
    [contacts setManufactoryPhone:[defaults objectForKey:@"savedManufactoryPhone"]];
    [contacts setManufactoryMail:[defaults objectForKey:@"savedManufactoryEmail"]];
    
    
    return contacts;
}

@end
