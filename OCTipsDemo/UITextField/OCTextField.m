//
//  OCTextField.m
//  OCTipsDemo
//
//  Created by luoqiang on 2019/8/13.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "OCTextField.h"

@interface OCTextField ()<UITextFieldDelegate>

@end

@implementation OCTextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(_maxLength <= 0){
        return YES;
    }
    if ([_key isEqualToString:@"abcd"]) {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range
                                                                       withString:string];
        if ([toBeString length] > _maxLength) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
        return YES;
    }else if ([_key isEqualToString:@"abc"]) {
        
        UITextRange *selectedRange = [textField markedTextRange];//高亮选择的字
        UITextPosition *startPos = [textField positionFromPosition:selectedRange.start offset:0];
        UITextPosition *endPos = [textField positionFromPosition:selectedRange.end offset:0];
        NSInteger markLength = [textField offsetFromPosition:startPos toPosition:endPos];
        
        NSInteger confirmlength =  textField.text.length - markLength - range.length;//已经确认输入的字符长度
        if(confirmlength >= _maxLength ){
            return NO;
        }
        
        NSInteger allowMaxMarkLength = [self allowMaxMarkLength:_maxLength - confirmlength];
        if(markLength > allowMaxMarkLength ){// && string.length > 0){
            return NO;
        }
    }
    return YES;
}

/**
 主要是用于中文输入的场景，可根据需要自定义
 剩余的允许输入的字数较少时，限制拼音字符的输入，提升体验
 */
- (NSInteger)allowMaxMarkLength:(NSInteger)remainLength
{
    NSInteger length = 0;
    if(remainLength > 2){
        length = NSIntegerMax;
    }else if(remainLength > 0){
        length = remainLength * 6;  //一个中文对应的拼音一般不超过6个
    }
    
    return length;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if(_maxLength <= 0){
        return;
    }
    
    NSString *text = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文/emoj被截断
    if (!position){
        if (text.length > _maxLength){
            NSRange rangeIndex = [text rangeOfComposedCharacterSequenceAtIndex:_maxLength];
            if (rangeIndex.length == 1){
                textField.text = [text substringToIndex:_maxLength];
            }else{
                if(_maxLength == 1){
                    textField.text = @"";
                }else{
                    NSRange rangeRange = [text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxLength - 1 )];
                    textField.text = [text substringWithRange:rangeRange];
                }
            }
            
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.endEditBlock) {
        self.endEditBlock(_key,textField.text);
    }
    return YES;
}

@end
