//
//  ThemesViewController.h
//  tinkoffChat
//
//  Created by Anton on 11/10/2018.
//  Copyright © 2018 Switch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"
#import "ThemesViewControllerDelegate.h"

//@class ThemesViewControllerDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface ThemesViewController : UIViewController <ThemesViewControllerDelegate>

@property (nonatomic, weak) id <ThemesViewControllerDelegate> delegate;
@property (nonatomic, weak) id <ThemesViewControllerDelegate> conversationsDelegate;
@property Themes* model;

@end

NS_ASSUME_NONNULL_END