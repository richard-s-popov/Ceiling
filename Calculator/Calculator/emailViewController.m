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
@property (nonatomic, strong) NSArray *plots;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@end

@implementation emailViewController
@synthesize project;
@synthesize plots;
@synthesize plotForImage;
@synthesize imagesArray;

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
    
    Projects *tmpProject = project;
    
    nameOfProject.text = [NSString stringWithFormat:@"%@", tmpProject.projectName];
    adresslabel.text = [NSString stringWithFormat:@"%@", tmpProject.projectAdress];
    phoneLabel.text = [NSString stringWithFormat:@"%@", tmpProject.projectPhone];
    
    [self loadImage];
    
//    // Создади кноку типа отправить
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setTitle:@"Send e-mail" forState:UIControlStateNormal];
//    [button sizeToFit];
//    button.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//    [button addTarget:self action:@selector(onButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MFMailComposeViewController Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Отправлено" message:@"Ваше письмо успешно отправлено, спасибо что пользуетесь нашем приложением!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Произошла непредвиденая ошибка, если она будет повторяться, пожалуйста обратитесь в службу поддержки" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    switch (result) {
        case MFMailComposeResultSent:
            // TODO: Успешно отправлено
            [alertSuccess show];
            break;
        case MFMailComposeResultCancelled:
            // TODO: Отменено пользователем
            break;
        case MFMailComposeResultFailed:
            // TODO: Произошла ошибка
            [alertError show];
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

-(void)loadImage {
    
    plots = [[NSArray alloc] init];
    plots =(NSArray*)[project.projectPlot allObjects];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSLog(@"колличество чертежей %i", plots.count);
    imagesArray = [[NSMutableArray alloc] init];
    
    int i = 0;
    while (i != plots.count) {
        plotForImage = [plots objectAtIndex:i];
        
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.png", project.projectName , plotForImage.plotName ]];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        //создаем массив чертежей
        [imagesArray addObject:image];
        
        self.imageView.image = image;
        [self.imageView setNeedsDisplay];
        i++;
    }
    
}

- (IBAction)sendEmailAction:(id)sender {
    
    //подключаем сохраненные данные настроек
    
    SettingsOptionsModel *contacts = [[SettingsOptionsModel alloc] init];
    SettingsService *settingsService = [[SettingsService alloc] init];
    
    contacts = settingsService.Read;
    
    //создаем временный объект проекта
    Projects *tmpProject = project;
    NSArray *tmpArrayPlots = [project.projectPlot allObjects];
    
    NSString *message = [NSString stringWithFormat:@"имя: %@ \n адрес:%@ \n колличество потолков:%d", tmpProject.projectName, tmpProject.projectAdress, tmpArrayPlots.count];
    
    // Проверяем, настроен ли почтовый клиент на отправку почту
    if (([MFMailComposeViewController canSendMail]) & (contacts.managerMail != nil) & (![contacts.managerMail isEqual:@""]) ) {
        
        // Создаем контроллер
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        // Делегатом будем мы
        mailController.mailComposeDelegate = self;
        
        // Задаем адрес на который отправлять почту
        [mailController setToRecipients:@[contacts.managerMail]];
        // Тема письма
        [mailController setSubject:@"Приложение"];

        //прикрепляем файлы с чертежами к письму
        UIImage *plotImage = [imagesArray objectAtIndex:0];
        NSData *imageData = UIImagePNGRepresentation(plotImage);
        [mailController addAttachmentData:imageData mimeType:@"image/png" fileName:@"image.png"];
        
        // Текст письма
        [mailController setMessageBody:message isHTML:NO];
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
@end
