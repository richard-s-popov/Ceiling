//
//  Contacts.h
//  Calculator
//
//  Created by Александр Коровкин on 14.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contacts : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userMail;
@property (nonatomic, retain) NSString * userPhone;
@property (nonatomic, retain) NSString * managerName;
@property (nonatomic, retain) NSString * managerMail;
@property (nonatomic, retain) NSString * managerPhone;
@property (nonatomic, retain) NSString * manufactoryPhone;
@property (nonatomic, retain) NSString * manufactoryMail;

@end
