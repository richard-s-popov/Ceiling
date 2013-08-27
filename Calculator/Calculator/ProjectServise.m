//
//  ProjectServise.m
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "ProjectServise.h"

@implementation ProjectServise


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
@end
