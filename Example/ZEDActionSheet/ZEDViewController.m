//
//  ZEDViewController.m
//  ZEDActionSheet
//
//  Created by 李超 on 11/29/2017.
//  Copyright (c) 2017 李超. All rights reserved.
//

#import "ZEDViewController.h"
#import <ZEDActionSheet/ZEDActionSheet.h>

@interface ZEDViewController ()<ZEDActionSheetDelegate>

@end

@implementation ZEDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}


- (IBAction)showAction:(UIBarButtonItem *)sender {
    ZEDActionSheet *actionSheet = [[ZEDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@[@"发送给朋友",@"收藏",@"保存图片",@"编辑",@"定位到聊天位置"] destructiveButtonIndex:3 destructiveButtonColor:[UIColor redColor]];
    [actionSheet show];
}

#pragma mark - ZEDActionSheetDelegate
- (void)actionSheet:(ZEDActionSheet *)sheet clickedButtonAtIndex:(NSInteger)index {
    
    switch (index) {
            case 1:
            {
                NSLog(@"发送给朋友");
            }
            break;
            case 2:
            {
                NSLog(@"收藏");
            }
            break;
            case 3:
            {
                NSLog(@"保存图片");
            }
            break;
            case 4:
            {
                NSLog(@"编辑");
            }
            break;
            case 5:
            {
                NSLog(@"定位到聊天位置");
            }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
