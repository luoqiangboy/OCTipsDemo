# OCTipsDemo
记录一些开发设计中搜集到的一些小技巧

```ruby
/**
通过CoreText获取多行label的每行详细信息

@param label 获取的label
@return 返回结果数组
*/
+ (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label {
NSString *text = [label text];
UIFont *font = [label font];
CGRect rect = [label frame];

CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
[attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
CFRelease(myFont);
CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
CGMutablePathRef path = CGPathCreateMutable();
CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
NSMutableArray *linesArray = [[NSMutableArray alloc]init];
for (id line in lines) {
CTLineRef lineRef = (__bridge  CTLineRef )line;
CFRange lineRange = CTLineGetStringRange(lineRef);
NSRange range = NSMakeRange(lineRange.location, lineRange.length);
NSString *lineString = [text substringWithRange:range];
CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
NSLog(@"''''''''''''''''''%@",lineString);
[linesArray addObject:lineString];
}

CGPathRelease(path);
CFRelease( frame );
CFRelease(frameSetter);
return (NSArray *)linesArray;
}

```
