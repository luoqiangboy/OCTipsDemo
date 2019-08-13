//
//  OCTextField.h
//  OCTipsDemo
//
//  Created by luoqiang on 2019/8/13.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCTextField : UITextField

@property (nonatomic, assign) BOOL edit;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *valueText;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, copy) void (^textFBlock)(UITextField *textF);
@property (nonatomic, copy) void (^endEditBlock)(NSString *key,NSString *value);

@end

NS_ASSUME_NONNULL_END
