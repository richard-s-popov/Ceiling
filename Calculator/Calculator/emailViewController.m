//
//  emailViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 21.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "emailViewController.h"
#import "SettingsOptionsModel.h"
#import "SettingsService.h"

@interface emailViewController ()

@end

@implementation emailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // Создади кноку типа UIButtonTypeRoundedRect
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // Надпись кнопки
    [button setTitle:@"Send e-mail" forState:UIControlStateNormal];
    // Автоматические размеры кнопки под надпись
    [button sizeToFit];
    // Отцентруем кнопку по окну
    button.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    // Обработчик нажатия
    [button addTarget:self action:@selector(onButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    // Добавим в окно
    [self.view addSubview:button];
    

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onButtonPressed
{
    //подключаем сохраненные данные настроек
    
    SettingsOptionsModel *contacts = [[SettingsOptionsModel alloc] init];
    SettingsService *settingsService = [[SettingsService alloc] init];
    
    contacts = settingsService.Read;
    
    // Проверяем, настроен ли почтовый клиент на отправку почту
    if (([MFMailComposeViewController canSendMail]) & (contacts.managerEmail != nil) & (![contacts.managerEmail isEqual:@""]) ) {
        
        // Создаем контроллер
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        // Делегатом будем мы
        mailController.mailComposeDelegate = self;
        // Задаем адрес на который отправлять почту
        [mailController setToRecipients:@[contacts.managerEmail]];
        // Тема письма
        [mailController setSubject:@"Приложение"];
        // Текст письма
        [mailController setMessageBody:@"Успешная отправка!!!" isHTML:NO];
        // Если объект создан
        if (mailController) {
            // Показываем контроллер
            [self presentViewController:mailController animated:YES completion:nil];
        }
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Пожалуста, внесите данные в настройки контактов" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        NSLog(@"пожалуйста введите данные в настройках");
        // TODO: Обработка ошибки
    }
}


#pragma mark - MFMailComposeViewController Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            // TODO: Успешно отправлено
            break;
        case MFMailComposeResultCancelled:
            // TODO: Отменено пользователем
            break;
        case MFMailComposeResultFailed:
            // TODO: Произошла ошибка
            break;
        case MFMailComposeResultSaved:
            // TODO: Сохранено как черновик
            break;
        default:
            break;
    }
    // Убираем окно
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
