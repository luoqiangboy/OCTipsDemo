//
//  OCLabel.h
//  OCTipsDemo
//
//  Created by Mini-LuoQiang on 2018/12/28.
//  Copyright © 2018年 Sniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCLabel : UILabel

/**
 通过CoreText获取多行label的每行详细信息
 
 @param label 获取的label
 @return 返回结果数组
 */
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label;

@end

NS_ASSUME_NONNULL_END
