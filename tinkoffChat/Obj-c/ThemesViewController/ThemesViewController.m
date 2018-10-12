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
        _model = ([[Themes alloc] init]);
        ConversationVC = [ConversationsListViewController new];
        
        self.conversationsDelegate = ConversationVC;
        self.delegate = self;
    }
    _model.theme1 = UIColor.yellowColor;
    _model.theme2 = UIColor.blackColor;
    _model.theme3 = UIColor.darkGrayColor;
    // Do any additional setup after loading the view.
    
    
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
