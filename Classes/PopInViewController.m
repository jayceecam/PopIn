//
//  PopInViewController.m
//  PopIn
//
//  Created by Joe Cerra on 3/10/14.
//  Copyright (c) 2014 Joe Cerra. All rights reserved.
//

#import "PopInViewController.h"

@interface PopInViewController () <UIScrollViewDelegate>

@property(strong,nonatomic) UIImageView* backgroundView;
@property(strong,nonatomic) UIButton* backgroundShade;
@property(strong,nonatomic) UIScrollView* scrollView;

@property(assign,nonatomic) BOOL entering;
@property(assign,nonatomic) BOOL dismissing;

// strong ref to window to retain until dismissed
@property(strong,nonatomic) UIWindow* parentWindow;
@property(weak,nonatomic) UIWindow* previousWindow;

@end



@implementation PopInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _entering = YES;
        _dismissing = NO;
    }
    return self;
}

- (CGPoint)maxContentOffset {
    return CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width - _scrollView.contentInset.left + _scrollView.contentInset.right,
                       _scrollView.contentSize.height - _scrollView.frame.size.height - _scrollView.contentInset.top + _scrollView.contentInset.bottom);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backgroundView = [[UIImageView alloc] initWithImage:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2);
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _backgroundShade = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height)];
    _backgroundShade.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65f];
    [_backgroundShade addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    CGRect cvFrame = _contentView.frame;
    cvFrame.origin.x = (self.scrollView.frame.size.width - _contentView.frame.size.width) / 2;
    cvFrame.origin.y = (self.scrollView.frame.size.height - _contentView.frame.size.height) / 2;
    _contentView.frame = cvFrame;
    
    [self.view addSubview:_backgroundView];
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_backgroundShade];
    [_scrollView addSubview:_contentView];
    
    _backgroundShade.alpha = 0;
    
    // set scrollView.contentOffset to allow for swiping content down to dismiss and return offset.y to 0
    _scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundShade.alpha = 1;
        
        // animate contentView in from above
        CGRect cvFrame = _contentView.frame;
        cvFrame.origin.y += self.scrollView.frame.size.height;
        _contentView.frame = cvFrame;
    } completion:^(BOOL finished) {
        _entering = NO;
    }];
}

+ (PopInViewController*)presentPopIn:(UIView*)view fromWindow:(UIWindow*)window withDelegate:(id<PopInViewControllerDelegate>)delegate {
    
    PopInViewController* pivc = [[PopInViewController alloc] init];
    pivc.delegate = delegate;
    pivc.contentView = view;
    pivc.previousWindow = window;
    pivc.parentWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    pivc.parentWindow.windowLevel = UIWindowLevelAlert;
    
    pivc.parentWindow.screen = [UIScreen mainScreen];
    pivc.parentWindow.rootViewController = pivc;
    [pivc.parentWindow addSubview:pivc.view];
    [pivc.parentWindow makeKeyAndVisible];
    
    return pivc;
}


#pragma mark - View Dismissal

- (void)dismiss:(BOOL)animated finished:(void(^)(void))finishedBlock {
    _dismissing = YES;
    
    if (animated) {
        [UIView animateWithDuration:0.35 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [self finished:finishedBlock];
        }];
    }
    else {
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [self finished:finishedBlock];
    }
}

- (void)dismiss {
    [self dismiss:YES finished:nil];
}

- (void)finished:(void(^)(void))finishedBlock {
    [self.previousWindow makeKeyAndVisible];
    if (finishedBlock) finishedBlock();
    [self.delegate popInViewControllerDidFinish:self];
    self.parentWindow = nil;
}


#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    // anchor share to top of contentOffset.y
    CGRect frame = self.backgroundShade.frame;
    frame.origin.y = self.scrollView.contentOffset.y;
    self.backgroundShade.frame = frame;
    
    if (!_entering) {
        CGFloat yOffsetMax = self.maxContentOffset.y;
        if (_scrollView.contentOffset.y == 0 && !_dismissing) {
            [self dismiss:NO finished:nil];
        }
        _backgroundShade.alpha = MAX(0, _scrollView.contentOffset.y / yOffsetMax);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}


@end
