//
//  STReplaceTool.m
//  UploadSwift3-2To4-2
//
//  Created by SmellTime on 2019/4/11.
//  Copyright © 2019年 SmellTime. All rights reserved.
// 替换关键词e为指定内容
// 已经处理了( 以及 . 这三个符号在正则中的转译，如果其他替换内容报错可以排查是否是需要替换的文本中含正则的关键词但是没有转译
//
#import "STReplaceTool.h"

@implementation STReplaceTool

- (void)autoReplaceObjcPaths:(NSString*)execPath fileNames:(NSArray<NSString*>*)fileNames replaceTargetWords:(NSArray<NSString *>*)targetWords toWords:(NSArray<NSString *> *)toWords {
    for (NSString *fileName in fileNames) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", execPath, fileName];
        NSString *swiftFileString = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSString *fixedContent = [self content:swiftFileString ReplaceTargetWords:targetWords toWords:toWords];
        if (fixedContent != nil && fixedContent.length > 0) {
            /// 更新xxx.swift文件内容
            if ([fixedContent isEqualToString:swiftFileString] == false) {
                [fixedContent writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
            }
        }
    }
}

- (NSString *)content:(NSString *)content ReplaceTargetWords:(NSArray<NSString *>*)targetWords toWords:(NSArray<NSString *> *)toWords {
    if (targetWords.count == 0) {
        NSLog(@"warring - targetWords为空");
        return content;
    }
    if (targetWords.count != toWords.count) {
        NSLog(@"error - targetWords和toWords数量不匹配");
        return content;
    }
    for (int i = 0; i < targetWords.count; i ++) {
        NSString *aParten = targetWords[i];
        NSString *toWord = toWords[i];
        if ([aParten containsString:@"("]) {
            aParten = [aParten stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
        }
        if ([aParten containsString:@"."]) {
            aParten = [aParten stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
        }
        NSRegularExpression *aReg = [NSRegularExpression regularExpressionWithPattern:aParten options:NSRegularExpressionCaseInsensitive error: nil];
        
        content = [aReg stringByReplacingMatchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length) withTemplate: toWord];
    }
    return content;
}

@end
