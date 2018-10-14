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
    [_delegate release];
    @autoreleasepool {
        _delegate = self;
    }
}
//Delegate gettret
-(id<ThemesViewControllerDelegate>)getDelegate {
    [_delegate retain];
    return _delegate;
}

//conversationsDelegate setter
-(void)setConversationsDelegate:(id <ThemesViewControllerDelegate>)conversationsDelegate{
    [_delegate release];
    @autoreleasepool {
        _conversationsDelegate = ConversationVC;
    }
}

//conversationsDelegate gettet
-(id<ThemesViewControllerDelegate>)getConversationsDelegate {
    [_conversationsDelegate retain];
    return _conversationsDelegate;
}

- (void)setModel:(Themes *)model {
    [_model release];
    @autoreleasepool {
        _model = model;
    }
}

-(Themes*)getThemes {
    [_model retain];
    return _model;
}

ConversationsListViewController *ConversationVC;
UIButton *themeButton1;
UIButton *themeButton2;
UIButton *themeButton3;

- (void)themesViewController:(nonnull ThemesViewController *)controller didSelectTheme:(nonnull UIColor *)selectedTheme {
    controller.view.backgroundColor = selectedTheme;
}

- (void)closeVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)themeOneAction:(id)sender {
    [self.delegate themesViewController:self didSelectTheme:_model.theme1];
    [self.conversationsDelegate themesViewController:self didSelectTheme:_model.theme1];
}
- (void)themeTwoAction:(id)sender {
    [self.delegate themesViewController:self didSelectTheme:_model.theme2];
    [self.conversationsDelegate themesViewController:self didSelectTheme:_model.theme2];
}
- (void)themeThreeAction:(id)sender {
    [self.delegate themesViewController:self didSelectTheme:_model.theme3];
    [self.conversationsDelegate themesViewController:self didSelectTheme:_model.theme3];
}

-(void)setBtn:(nonnull UIButton*)btn buttonTitle:(nonnull NSString*)title positionFromOneToEight:(int)position selector:(SEL)selector {
    double doublePosition = (double)position;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.75f];
    btn.bounds = CGRectMake(0, 0, 144, 44);
    [btn addTarget:self
                     action:selector
           forControlEvents:UIControlEventTouchUpInside];
    btn.center = CGPointMake(self.view.center.x, (self.view.frame.size.height/8)*doublePosition);
    [self.view addSubview:btn];
}

-(void)setupUI {
    
    UIBarButtonItem *navigationItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeVC:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = navigationItem;
    [navigationItem retain];
    navigationItem.enabled=TRUE;
    [navigationItem release];
    
    themeButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBtn:themeButton1 buttonTitle:@"Тема 1" positionFromOneToEight:3 selector:@selector(themeOneAction:)];
    
    themeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBtn:themeButton2 buttonTitle:@"Тема 2" positionFromOneToEight:4 selector:@selector(themeTwoAction:)];
    
    themeButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setBtn:themeButton3 buttonTitle:@"Тема 3" positionFromOneToEight:5 selector:@selector(themeThreeAction:)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    ConversationVC = [[ConversationsListViewController alloc] init];
    
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
    [_model release];
    [_delegate release];
    [themeButton1 release];
    [themeButton2 release];
    [themeButton3 release];
    ConversationVC = nil;
    [ConversationVC release];
    [super dealloc];
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
