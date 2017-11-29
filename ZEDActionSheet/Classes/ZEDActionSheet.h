//
//  ZEDActionSheet.h
//  Pods-ZEDActionSheetSheet_Example
//
//  Created by 超李 on 2017/11/29.
//

#import <UIKit/UIKit.h>

@class ZEDActionSheet;

@protocol ZEDActionSheetDelegate <NSObject>

- (void)actionSheet:(ZEDActionSheet *)sheet clickedButtonAtIndex:(NSInteger)index;

@end

@interface ZEDActionSheet : UIView

/**
 *  创建一个弹出视图 index为-1时，无destructiveButton
 */
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<ZEDActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
       destructiveButtonIndex:(NSInteger)index
       destructiveButtonColor:(UIColor *)color;

- (void)show;
- (void)dismiss;

@end

