//
//  Materials.h
//  Calculator
//
//  Created by Александр Коровкин on 17.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Materials : NSManagedObject

@property (nonatomic, retain) NSString * matName;
@property (nonatomic, retain) NSNumber * matWidth;
@property (nonatomic, retain) NSNumber * matPrice;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * matId;

@end
