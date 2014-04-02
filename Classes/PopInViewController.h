//
//  PopInViewController.h
//  PopIn
//
//  Created by Joe Cerra on 3/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PopInViewController;
@protocol PopInViewControllerDelegate <NSObject>

- (void)popInViewControllerDidFinish:(PopInViewController*)c;

@end



@interface PopInViewController : UIViewController

@property(weak,nonatomic) id<PopInViewControllerDelegate> delegate;

@property(strong,nonatomic) UIView* contentView;

- (void)dismiss:(BOOL)animated finished:(void(^)(void))finished;

+ (PopInViewController*)presentPopIn:(UIView*)view fromWindow:(UIWindow*)window withDelegate:(id<PopInViewControllerDelegate>)delegate;

@end
