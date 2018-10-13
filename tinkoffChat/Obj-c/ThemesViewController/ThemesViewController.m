//
//  ThemesViewController.m
//  tinkoffChat
//
//  Created by Anton on 11/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

#import "ThemesViewController.h"
#import "ThemesViewControllerDelegate.h"
#import "tinkoffChat-Swift.h"


@class Themes;

@implementation ThemesViewController

//Delegate Setter
- (void)setThemesVCDelegate:(id<ThemesViewControllerDelegate>)delegate{
    _delegate = nil;
    @autoreleasepool {
        _delegate = self;
    }
}
//Delegate gettret
-(id<ThemesViewControllerDelegate>)getDelegate {
    return _delegate;
}

//conversationsDelegate setter
-(void)setConversationsDelegate:(id <ThemesViewControllerDelegate>)conversationsDelegate{
    _conversationsDelegate = nil;
    @autoreleasepool {
        _conversationsDelegate = ConversationVC;
    }
}

//conversationsDelegate gettet
-(id<ThemesViewControllerDelegate>)getConversationsDelegate {
    return _conversationsDelegate;
}

- (void)setModel:(Themes *)model {
    _model = nil;
    @autoreleasepool {
        _model = model;
    }
}

-(Themes*)getThemes {
    return _model;
}

ConversationsListViewController *ConversationVC;
UIButton *themeButton1;
UIButton *themeButton2;
UIButton *themeButton3;

- (void)themesViewController:(nonnull ThemesViewController *)controller didSelectTheme:(nonnull UIColor *)selectedTheme {
    controller.view.backgroundColor = selectedTheme;
}

- (IBAction)closeVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)themeOneAction:(id)sender {
    [self.delegate themesViewController:self didSelectTheme:_model.theme1];
    [self.conversationsDelegate themesViewController:self didSelectTheme:_model.theme1];
}
- (IBAction)themeTwoAction:(id)sender {
    [self.delegate themesViewController:self didSelectTheme:_model.theme2];
    [self.conversationsDelegate themesViewController:self didSelectTheme:_model.theme2];
}
- (IBAction)themeThreeAction:(id)sender {
    [self.delegate themesViewController:self didSelectTheme:_model.theme3];
    [self.conversationsDelegate themesViewController:self didSelectTheme:_model.theme3];
}

-(void)setupUI {
    
    UIBarButtonItem *navigationItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeVC:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = navigationItem;
    navigationItem.enabled=TRUE;
    
    themeButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [themeButton1 addTarget:self
               action:@selector(themeOneAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [themeButton1 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [themeButton1 setTitle:@"Тема 1" forState:UIControlStateNormal];
    themeButton1.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.75f];
    //theme1.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    themeButton1.bounds = CGRectMake(0, 0, 144, 44);
    themeButton1.center = CGPointMake(self.view.center.x, (self.view.frame.size.height/8)*3);
    [self.view addSubview:themeButton1];
    
    themeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    themeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [themeButton2 addTarget:self
               action:@selector(themeTwoAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [themeButton2 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [themeButton2 setTitle:@"Тема 2" forState:UIControlStateNormal];
    themeButton2.titleLabel.textColor = UIColor.blueColor;
    themeButton2.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.75f];
    themeButton2.bounds = CGRectMake(0, 0, 144, 44);
    themeButton2.center = CGPointMake(self.view.center.x, (self.view.frame.size.height/8)*4);
    [self.view addSubview:themeButton2];
    
    themeButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    themeButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [themeButton3 addTarget:self
               action:@selector(themeThreeAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [themeButton3 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [themeButton3 setTitle:@"Тема 3" forState:UIControlStateNormal];
    themeButton3.titleLabel.textColor = UIColor.blueColor;
    themeButton3.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.75f];
    themeButton3.bounds = CGRectMake(0, 0, 144, 44);
    themeButton3.center = CGPointMake(self.view.center.x, (self.view.frame.size.height/8)*5);
    [self.view addSubview:themeButton3];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    @autoreleasepool {
        ConversationVC = [ConversationsListViewController new];
    }
    
    [self setConversationsDelegate:ConversationVC];
    [self setDelegate:self];
    [self setModel:[[Themes alloc] init]];
    
    _model.theme1 = UIColor.yellowColor;
    _model.theme2 = UIColor.darkGrayColor;
    _model.theme3 = UIColor.purpleColor;
    [self setupUI];
    
}

- (void)dealloc
{
    _delegate = nil;
    _model = nil;
    themeButton1 = nil;
    themeButton2 = nil;
    themeButton3 = nil;
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = nil;
    free((__bridge void *)(themeButton1));
    free((__bridge void *)(themeButton1));
    free((__bridge void *)(themeButton1));
    free((__bridge void *)(_delegate));
    free((__bridge void *)(_model));
    ConversationVC = nil;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
