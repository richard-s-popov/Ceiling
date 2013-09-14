//
//  ProjectServise.m
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "ProjectServise.h"

@implementation ProjectServise

@synthesize countDetailProject;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (void)SaveProject:(NSMutableArray *)projectsArray {
    int n = 0;
    NSNumber *projectsCount = [NSNumber numberWithInt:projectsArray.count];
    
    NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
    [projects setObject:projectsCount forKey:@"porjectsCount"];
    
    ProjectModel *projectExemplar;
    
    while (n!=[projectsCount intValue]) {
        
        projectExemplar = [projectsArray objectAtIndex:n];
        [projects setObject:projectExemplar.clientName forKey:[NSString stringWithFormat:@"clientName%d",n]];
        [projects setObject:projectExemplar.clientAdress forKey:[NSString stringWithFormat:@"clientAdress%d",n]];
        [projects setObject:projectExemplar.clientExplane.text forKey:[NSString stringWithFormat:@"clientExplane%d",n]];
        [projects setObject:projectExemplar.clientLuster forKey:[NSString stringWithFormat:@"clientLuster%d",n]];
        [projects setObject:projectExemplar.clientBypass forKey:[NSString stringWithFormat:@"clientBypass%d",n]];
        [projects setObject:projectExemplar.clientSpot forKey:[NSString stringWithFormat:@"clientSpot%d",n]];

        [projects setObject:[NSString stringWithFormat:@"%d",n] forKey:[NSString stringWithFormat:@"clientId%d",n]];
        
        n++;
    }
    
    [projects synchronize];
}


+ (NSMutableArray *)Read {
    
    NSMutableArray *resultProjects = [[NSMutableArray alloc] init];
    ProjectModel *savedProject;
    
    NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
    NSNumber *projectsCount = [projects objectForKey:@"porjectsCount"];
    int n = 0;
    while (n!=[projectsCount intValue]) {
        
        savedProject = [[ProjectModel alloc] init];
        [savedProject setClientName:[projects objectForKey:[NSString stringWithFormat:@"clientName%d",n]]];
        [savedProject setClientAdress:[projects objectForKey:[NSString stringWithFormat:@"clientAdress%d",n]]];
        [savedProject setClientLuster:[projects objectForKey:[NSString stringWithFormat:@"clientLuster%d",n]]];
        [savedProject setClientBypass:[projects objectForKey:[NSString stringWithFormat:@"clientBypass%d",n]]];
        [savedProject setClientSpot:[projects objectForKey:[NSString stringWithFormat:@"clientSpot%d",n]]];

        UITextView *explaneText = [[UITextView alloc] init];
        explaneText.text = [projects objectForKey:[NSString stringWithFormat:@"clientExplane%d",n]];
        [savedProject setClientExplane:explaneText];
        
        [savedProject setClientId:[projects objectForKey:[NSString stringWithFormat:@"clientId%d",n]]];
        
        [resultProjects addObject:savedProject];
        n++;
    }
    
    [projects synchronize];
    
    return resultProjects;
}


+ (void)ClearProject {
    
    NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
    NSNumber *projectCount = [projects objectForKey:@"porjectsCount"];
    
    int n = 50;
    while (n >= [projectCount intValue]) {
        
        NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
        //удаляем настройки из plist
        [projects removeObjectForKey:[NSString stringWithFormat:@"clientName%d", n]];
        [projects removeObjectForKey:[NSString stringWithFormat:@"clientAdress%d", n]];
        [projects removeObjectForKey:[NSString stringWithFormat:@"clientLuster%d",n]];
        [projects removeObjectForKey:[NSString stringWithFormat:@"clientBypass%d",n]];
        [projects removeObjectForKey:[NSString stringWithFormat:@"clientSpot%d",n]];
        [projects removeObjectForKey:[NSString stringWithFormat:@"clientExplane%d", n]];
        [projects removeObjectForKey:[NSString stringWithFormat:@"clientId%d", n]];
        
        n--;
    }
}


+ (ProjectModel *)ZeroProject {

    ProjectModel *exemplarProject = [[ProjectModel alloc] init];
    
    
    exemplarProject.clientName = @"Имя клиента";
    exemplarProject.clientAdress = @"Адресс клиента";
    exemplarProject.clientLuster = @"0";
    exemplarProject.clientBypass = @"0";
    exemplarProject.clientSpot = @"0";
    
    UITextView *explaneText = [[UITextView alloc] init];
    explaneText.text = @"Описание проекта";
    exemplarProject.clientExplane = explaneText;
    exemplarProject.clientId = @"0";
    
    return exemplarProject;
}


//          ОБРАБОТКА DETAIL


- (void)SaveDetail:(ProjectModel *)newDetail {

    NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
    
    [projects setObject:newDetail.clientName forKey:[NSString stringWithFormat:@"clientName%@",newDetail.clientId]];
    [projects setObject:newDetail.clientAdress forKey:[NSString stringWithFormat:@"clientAdress%@",newDetail.clientId]];
    [projects setObject:newDetail.clientExplane.text forKey:[NSString stringWithFormat:@"clientExplane%@", newDetail.clientId]];
    [projects setObject:newDetail.clientLuster forKey:[NSString stringWithFormat:@"clientLuster%@",newDetail.clientId]];
    [projects setObject:newDetail.clientBypass forKey:[NSString stringWithFormat:@"clientBypass%@",newDetail.clientId]];
    [projects setObject:newDetail.clientSpot forKey:[NSString stringWithFormat:@"clientSpot%@",newDetail.clientId]];
    [projects setObject:newDetail.clientId forKey:[NSString stringWithFormat:@"clientId%@",newDetail.clientId]];
    
    countDetailProject = newDetail.clientId;
    [projects synchronize];
}


- (ProjectModel *)changeDetailProject {
    
    NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
    countDetailProject = [projects objectForKey:@"lustProject"];
    
    ProjectModel *changedProject = [[ProjectModel alloc] init];

    [changedProject setClientName:[projects objectForKey:[NSString stringWithFormat:@"clientName%@",countDetailProject]]];
    [changedProject setClientAdress:[projects objectForKey:[NSString stringWithFormat:@"clientAdress%@",countDetailProject]]];
    [changedProject setClientLuster:[projects objectForKey:[NSString stringWithFormat:@"clientLuster%@",countDetailProject]]];
    [changedProject setClientBypass:[projects objectForKey:[NSString stringWithFormat:@"clientBypass%@",countDetailProject]]];
    [changedProject setClientSpot:[projects objectForKey:[NSString stringWithFormat:@"clientSpot%@",countDetailProject]]];
    
    UITextView *explaneText = [[UITextView alloc] init];
    explaneText.text = [projects objectForKey:[NSString stringWithFormat:@"clientExplane%@",countDetailProject]];
    [changedProject setClientExplane:explaneText];
    
    [changedProject setClientId:[projects objectForKey:[NSString stringWithFormat:@"clientId%@",countDetailProject]]];


    return changedProject;
}

@end
