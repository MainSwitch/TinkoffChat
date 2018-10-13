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

- (void)viewDidLoad {
    [super viewDidLoad];
    @autoreleasepool {
        ConversationVC = [ConversationsListViewController new];
    }
    
    [self setConversationsDelegate:ConversationVC];
    [self setDelegate:self];
    [self setModel:[[Themes alloc] init]];
    
    _model.theme1 = UIColor.yellowColor;
    _model.theme2 = UIColor.darkGrayColor;
    _model.theme3 = UIColor.purpleColor;
    // Do any additional setup after loading the view.
    
    
}

- (void)dealloc
{
    _delegate = nil;
    _model = nil;
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
