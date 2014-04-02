//
//  HomeController.m
//  PopIn
//
//  Created by Joe Cerra on 3/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "HomeController.h"

#import <PopIn/PopIn.h>


@interface HomeController () <PopInViewControllerDelegate>

@end



@implementation HomeController


- (IBAction)showInterstitial:(id)sender {
    UIView* redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)];
    redView.backgroundColor = UIColor.redColor;
    redView.layer.cornerRadius = 5;
    redView.layer.masksToBounds = YES;
    
    [PopInViewController presentPopIn:redView fromWindow:self.view.window withDelegate:self];
}

#pragma mark - PopInControllerDelegate

- (void)popInViewControllerDidFinish:(PopInViewController *)c {
    NSLog(@"popInViewControllerDidFinish");
}

@end
