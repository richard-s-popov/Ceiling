//
//  AddPrice.h
//  Calculator
//
//  Created by Александр Коровкин on 12.11.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AddPrice : NSManagedObject

@property (nonatomic, retain) NSNumber * bypassPrice;
@property (nonatomic, retain) NSNumber * lusterPrice;
@property (nonatomic, retain) NSNumber * spotPrice;
@property (nonatomic, retain) NSNumber * kantPrice;

@end
