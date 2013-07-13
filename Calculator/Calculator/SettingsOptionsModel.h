//
//  SettingsOptionsModel.h
//  Calculator
//
//  Created by Александр Коровкин on 08.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsOptionsModel : NSObject


//создание переменных контакты пользователя
@property (nonatomic, weak) NSString * userName;
@property (nonatomic, weak) NSString * userPhone;
@property (nonatomic, weak) NSString * userEmail;

//создание переменных контакты менеджера
@property (nonatomic, weak) NSString * managerName;
@property (nonatomic, weak) NSString * managerPhone;
@property (nonatomic, weak) NSString * managerEmail;

//создание переменных контакты цеха
@property (nonatomic, weak) NSString * manufactoryPhone;
@property (nonatomic, weak) NSString * manufactoryEmail;


@end
