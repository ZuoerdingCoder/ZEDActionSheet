//
//  ZEDActionSheet.m
//  Pods-ZEDActionSheetSheet_Example
//
//  Created by 超李 on 2017/11/29.
//

#import "ZEDActionSheet.h"

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define LCColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]

static const CGFloat buttonHeight = 44;
static const CGFloat titleMargin_H = 30;
static const CGFloat titleMargin_V = 10;
static const CGFloat lineViewH = 1;
static const CGFloat cancelTopMargin = 5;

static const CGFloat buttonTitleFont = 18;
static const CGFloat titleFont = 16;
static const CGFloat duration = 0.3;
static const CGFloat backgroundAlpha = 0.5;

@interface ZEDActionSheet ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *buttonTitlesArray;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) UIColor *destructiveColor;
@property (nonatomic, assign) NSInteger destructiveButtonIndex;

@property (nonatomic, weak) id<ZEDActionSheetDelegate>delegate;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *darkView;

@property (nonatomic, strong) UIView *titleBgView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *destructiveButton;
@property (nonatomic, strong) UIImageView *cancelTopImageView;

@property (nonatomic, assign) CGSize titleSize;
@property (nonatomic, assign) CGFloat contentHight;

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *lineArray;

@end

@implementation ZEDActionSheet

#pragma mark - Life cycle
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<ZEDActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
       destructiveButtonIndex:(NSInteger)index
       destructiveButtonColor:(UIColor *)color {
    
    self = [super init];
    if (self) {
        self.title = title;
        self.delegate = delegate;
        self.buttonTitlesArray = otherButtonTitles;
        self.cancelButtonTitle = cancelButtonTitle ? : @"取消";
        self.destructiveColor = color;
        self.destructiveButtonIndex = index;
        
        [self commonInit];
        [self setup];
        [self configureFrames];
        [self subViewsLayout];
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ZEDActionSheet销毁了");
}


#pragma mark - Setup
- (void)commonInit {
    
    self.backgroundColor = [UIColor clearColor];
    self.buttonArray = [NSMutableArray array];
    self.lineArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}


- (void)setup {
    
    [self addSubview:self.contentView];
    [self addSubview:self.darkView];
    
    NSInteger buttonIndex = 0;
    
    if (self.cancelButtonTitle) {
        self.cancelButton = [self defaultButtonWithTitle:self.cancelButtonTitle tag:buttonIndex];
        self.cancelTopImageView = [self lineImageView];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.cancelTopImageView];
        buttonIndex ++;
    }
    
    if (self.buttonTitlesArray) {
        
        for (NSInteger i = self.buttonTitlesArray.count-1; i >= 0; i--) {
            
            NSString *title = [self.buttonTitlesArray objectAtIndex:i];
            UIButton *button = [self defaultButtonWithTitle:title tag:i+1];
            if (self.destructiveButtonIndex == i) {
                [button setTitleColor:(self.destructiveColor ? : LCColor(255, 10, 10)) forState:UIControlStateNormal];
            }
            [self.contentView addSubview:button];
            
            [self.buttonArray addObject:button];
            
            UIImageView *lineView = [self lineImageView];
            lineView.tag = i;
            [self.contentView addSubview:lineView];
            
            [self.lineArray addObject:lineView];
            
            buttonIndex++;
        }
    }
    
    if (self.title) {
        
        self.titleSize = [self.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-titleMargin_H*2, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:titleFont] forKey:NSFontAttributeName] context:nil].size;
        
        self.titleBgView = [[UIView alloc] init];
        self.titleBgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleBgView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = self.title;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        [self.titleBgView addSubview:self.titleLabel];
    } else {
        [self.lineArray removeLastObject];
    }
}

- (void)configureFrames {
    CGFloat contentHight = 0;
    if (self.cancelButtonTitle) {
        contentHight = buttonHeight+cancelTopMargin;
    }
    
    if (self.buttonTitlesArray) {
        for (NSInteger i = 0; i < self.buttonTitlesArray.count; i++) {
            contentHight = contentHight + buttonHeight + lineViewH;
        }
    }
    
    if (self.title) {
        self.titleSize = [self.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-titleMargin_H*2, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:titleFont] forKey:NSFontAttributeName] context:nil].size;
        contentHight = contentHight + self.titleSize.height + titleMargin_V*2;
    } else {
        contentHight = contentHight - lineViewH;
    }
    self.contentHight = contentHight;
}


#pragma mark - LayoutsubView
- (void)subViewsLayout {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT-self.contentHight, SCREEN_WIDTH, self.contentHight);
    self.darkView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.contentHight);
    
    self.cancelButton.frame = CGRectMake(0, self.contentHight-buttonHeight, SCREEN_WIDTH, buttonHeight);
    self.cancelTopImageView.frame = CGRectMake(0, self.contentHight-buttonHeight-cancelTopMargin, SCREEN_WIDTH, cancelTopMargin);
    
    if (self.buttonArray) {
        for (NSInteger i = 0; i < self.buttonArray.count ; i++) {
            UIButton *button = [self.buttonArray objectAtIndex:i];
            button.frame = CGRectMake(0, self.contentHight-(buttonHeight+cancelTopMargin+(i+1)*buttonHeight+i*lineViewH), SCREEN_WIDTH, buttonHeight);
        }
    }
    
    if (self.lineArray) {
        for (NSInteger i = 0; i < self.lineArray.count; i++) {
            UIImageView *imageView = [self.lineArray objectAtIndex:i];
            imageView.frame = CGRectMake(0, self.contentHight-(cancelTopMargin+buttonHeight+(i+1)*buttonHeight+(i+1)*lineViewH), SCREEN_WIDTH, lineViewH);
        }
    }
    
    if (self.title) {
        self.titleLabel.frame = CGRectMake(titleMargin_H, titleMargin_V, SCREEN_WIDTH-2*titleMargin_H,self.titleSize.height);
        self.titleBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.contentHight-(cancelTopMargin+buttonHeight+(self.buttonArray.count*buttonHeight+self.lineArray.count)));
    }
}

#pragma mark - Show/Dismiss
- (void)show {
    UIViewController *controller = [self p_topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    [(controller.navigationController ? controller.navigationController.view : controller.view) addSubview:self];
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        self.darkView.alpha = backgroundAlpha;
        self.darkView.userInteractionEnabled = YES;
    }];
    
    
}

- (void)dismiss {
    self.darkView.alpha = 0;
    self.darkView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Actions
- (void)buttonCliekd:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:sender.tag];
    }
    
    [self dismiss];
}


- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
    [self dismiss];
}

#pragma mark - Notification
- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    UIInterfaceOrientation nowOrientation = [[notification.userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey] integerValue];
    if (nowOrientation == UIInterfaceOrientationLandscapeLeft || nowOrientation == UIInterfaceOrientationLandscapeRight) {
    }
    
    if (nowOrientation == UIInterfaceOrientationPortrait || nowOrientation == UIInterfaceOrientationPortraitUpsideDown) {
    }
    
    [self configureFrames];
    [self subViewsLayout];
}

#pragma mark - Private
- (UIViewController*)p_topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self p_topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self p_topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self p_topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


#pragma mark - Getter
- (UIButton *)defaultButtonWithTitle:(NSString *)title tag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:buttonTitleFont];
    [button setBackgroundImage:[UIImage imageNamed:@"bgImage_HL"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonCliekd:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIImageView *)lineImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"cellLine"];
    [imageView setContentMode:UIViewContentModeTop];
    return imageView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = LCColor(223, 233, 238);
    }
    return _contentView;
}

- (UIView *)darkView {
    if (!_darkView) {
        _darkView = [[UIView alloc] init];
        _darkView.backgroundColor = LCColor(46, 49, 50);
        _darkView.alpha = 0;
        _darkView.userInteractionEnabled = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [_darkView addGestureRecognizer:tap];
    }
    return _darkView;
}

@end

