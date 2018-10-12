//
//  ThemesViewControllerDelegate.h
//  tinkoffChat
//
//  Created by Anton on 11/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//
#import <UIKit/UIKit.h>
//#import "ThemesViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class ThemesViewController;

@protocol ThemesViewControllerDelegate <NSObject>

- (void)themesViewController: (ThemesViewController *)controller
didSelectTheme:(UIColor *)selectedTheme;


@end

NS_ASSUME_NONNULL_END
