//
//  STAddObjcTool.m
//  UploadSwift3-2To4-2
//
//  Created by SmellTime on 2019/4/11.
//  Copyright © 2019年 SmellTime. All rights reserved.

// 1、自动在selector绑定的方法前添加@objc
// 2、在dynamic变量声明前添加@objc (主要是处理Realm数据库中的变量)

#import "STAddObjcTool.h"
#import "STReplaceTool.h"

@implementation STAddObjcTool

/// 不指定enablePaths即为当前路径下全部文件
- (void)autoAddObjcPaths:(NSString*)execPath fileNames:(NSArray<NSString*>*)fileNames {
    if (self.projectPath == nil) {
        return;
    }
    /// 开始逐个处理
    for (NSString *fileName in fileNames) {
        NSLog(@"%@", [NSString stringWithFormat:@"查找: %@", fileName]);
        [self addObjcToFile:execPath fileName:fileName];
    }
}

// MARK: -- 添加@objc 到指定selector绑定的API前
- (void)addObjcToFile:(NSString *)shortFilePath fileName:(NSString *)fileName {

    NSString *filePath;
    if ([filePath hasPrefix:@"/"]) {
        filePath = [NSString stringWithFormat:@"%@%@", shortFilePath, fileName];
    } else {
        filePath = [NSString stringWithFormat:@"%@/%@", shortFilePath, fileName];
    }
    NSString *swiftFileString = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *funcNames = [[NSMutableArray alloc]init];
    if (swiftFileString != nil) {
        /// 找到所有绑定方法的方法名,只保留name，不要参数名称
        NSArray *comArr = [swiftFileString componentsSeparatedByString:@"#selector("];
        if (comArr.count > 1) {
            for (int i = 0; i < comArr.count; i ++) {
                if (i > 0) {
                    NSArray *temps = [comArr[i] componentsSeparatedByString:@")"];
                    if (temps != nil) {
                        if (temps.count > 0) {
                            NSString *fName = temps[0];
                            if ([fName containsString:@"("]) {
                                fName = [fName componentsSeparatedByString:@"("][0];
                            }
                            if ([fName containsString:@"self."]) {
                                fName = [fName componentsSeparatedByString:@"self."][1];
                            }
                            [funcNames addObject:fName];
                        }
                    }
                }
            }
        } else {
//            NSLog(@"%@ 文件内没有找到#selector引用的方法", fileName);
        }
    } else {
        NSLog(@"error - 没有找到swiftFileString");
        return;
    }
    if (funcNames != nil && swiftFileString != nil) {
        /// 找到了方法名，替换
        NSString *souldFixString = [[NSString alloc]initWithString:swiftFileString];
        for (int i = 0; i < funcNames.count; i ++) {
            souldFixString = [self insertObjcToSelectorFuncNameContent:souldFixString funcName:funcNames[i]];
        }
        /// 插入属性中的objc
        NSString *fixedDynamicString = [self insertObjcToDynamicVar:souldFixString];
        if ([fixedDynamicString isEqualToString:souldFixString] == NO) {
            NSLog(@"已添加@objc到dynamic变量前: %@", fileName);
            souldFixString = fixedDynamicString;
        }
        /// 更新xxx.swift文件内容
        if ([souldFixString isEqualToString:swiftFileString] == false) {
            NSError *error;
            BOOL result = [souldFixString writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
            if (error != nil) {
                NSLog(@"error - %@", error);
            }
            if (result) {
                NSLog(@"已更新: %@\n", fileName);
            }
        }
    }
}

// MARK: -- 在方法前添加@objc
- (NSString *)insertObjcToSelectorFuncNameContent:(NSString *)contentString funcName:(NSString*)funcName {
    /// 所有换行符号的位置
    NSString *aParten = @"\n";
    NSRegularExpression *aReg = [NSRegularExpression regularExpressionWithPattern:aParten options:NSRegularExpressionCaseInsensitive error: nil];
    NSArray *aMatches = [aReg matchesInString:contentString options:NSMatchingReportCompletion range:NSMakeRange(0, contentString.length)];
    
    NSString *enableParten = [NSString stringWithFormat:@"func %@", funcName];
    NSRegularExpression *enableReg = [NSRegularExpression regularExpressionWithPattern:enableParten options:NSRegularExpressionCaseInsensitive error: nil];
    NSArray *enableMatches = [enableReg matchesInString:contentString options:NSMatchingReportCompletion range:NSMakeRange(0, contentString.length)];
    if (enableMatches != nil && enableMatches.count > 0) {
        for (int i = 0; i < enableMatches.count; i ++) {
            /// 从文件尾部向前逐行查找是否是该方法名的实现
            NSTextCheckingResult *match = enableMatches[i];
            for (unsigned long j = aMatches.count - 1; j > 0; j --) {
                NSTextCheckingResult *aMatch = aMatches[j];
                NSString *nextNLeftWord = @"";
                if (j < aMatches.count - 1) {
                    NSTextCheckingResult *nextAMatch = aMatches[j + 1];
                    nextNLeftWord = [contentString substringWithRange:NSMakeRange(nextAMatch.range.location - 1, 1)];
                }
                if (aMatch.range.location < match.range.location && [nextNLeftWord isEqualToString:@"{"] == false) {
                    NSLog(@"小于 但是不符合");
                    break;
                }
                if (aMatch.range.location < match.range.location && [nextNLeftWord isEqualToString:@"{"]) {
                    NSRange shouldReplaceRange = NSMakeRange(aMatch.range.location + 1, match.range.location - aMatch.range.location - 2);
                    NSString *subString = [contentString substringWithRange: shouldReplaceRange];
                    NSMutableArray *subs = [[NSMutableArray alloc]initWithArray:[subString componentsSeparatedByString:@" "]];
                    /// 目前不管修饰词，都直接添加
                    NSInteger firstWordIndex = -1;
                    BOOL didhaveObjc = NO;
                    BOOL isEnable = YES;
                    for (int k = 0; k < subs.count; k ++) {
                        NSString *subStringWord = subs[k];
                        if ([subStringWord hasPrefix:@"//"]) {
                            isEnable = NO;
                            break;
                        }
                        if ([subStringWord isEqualToString:@""] == NO) {
                            firstWordIndex = k;
                            if ([subStringWord isEqualToString:@"@objc"]) {
                                didhaveObjc = YES;
                            }
                            break;
                        }
                    }
                    /// 比如是注释行等
                    if (isEnable == NO) {
                        NSLog(@"warring - 不可用的方法名 %@", funcName);
                        return contentString;
                    }
                    if (didhaveObjc == NO) {
                        /// 找到了该方法名的实现的内容，并确定没有@objc的修饰，需要添加
                        /// 采用的方式是把整块都替换掉并补齐之前的空格，把持对齐方式不变
                        if (firstWordIndex == -1) {
                            [subs addObject:@"@objc "];
                        } else {
                            [subs insertObject:@"@objc" atIndex:firstWordIndex];
                        }
                        NSString *fixdSubString = @"";
                        for (NSString *item in subs) {
                            if ([item isEqualToString:@""]) {
                                fixdSubString = [NSString stringWithFormat:@"%@ ",fixdSubString];
                            } else {
                                if ([fixdSubString hasSuffix:@" "]) {
                                    fixdSubString = [NSString stringWithFormat:@"%@%@",fixdSubString, item];
                                } else {
                                    fixdSubString = [NSString stringWithFormat:@"%@ %@",fixdSubString, item];
                                }
                            }
                        }
                        if (firstWordIndex != -1) {
                            fixdSubString = [NSString stringWithFormat:@"%@ ", fixdSubString];
                        }
                        NSLog(@"- 添加@objc: %@", funcName);
                        contentString = [contentString stringByReplacingCharactersInRange:NSMakeRange(aMatch.range.location + 1, match.range.location - aMatch.range.location - 1) withString:fixdSubString];
                    }
                    break;
                }
            }
        }
    } else {
        NSLog(@"warring - 没有找到 %@，可能该方法的实现不在本文件中", funcName);
    }
    return contentString;
}

//MARK: -- 在dynamic前自动添加@objc
- (NSString*)insertObjcToDynamicVar:(NSString *)contentString {
    NSString *fixString = [[NSString alloc]initWithString:contentString];
    /// 正则匹配
    /// 先匹配出不需要添加objc的情况
    NSString *disableParten = @"@objc dynamic var";
    NSRegularExpression *disableReg = [NSRegularExpression regularExpressionWithPattern:disableParten options:NSRegularExpressionCaseInsensitive error: nil];
    NSArray *disableMatches = [disableReg matchesInString:fixString options:NSMatchingReportCompletion range:NSMakeRange(0, fixString.length)];
    
    NSString *enableParten = @"dynamic var";
    NSRegularExpression *enableReg = [NSRegularExpression regularExpressionWithPattern:enableParten options:NSRegularExpressionCaseInsensitive error: nil];
    NSArray *enableMatches = [enableReg matchesInString:fixString options:NSMatchingReportCompletion range:NSMakeRange(0, fixString.length)];
    NSInteger addRangeLength = 0;
    for (NSTextCheckingResult *match in enableMatches) {
        BOOL matchEnable = YES;
        for (NSTextCheckingResult *disableMatch in disableMatches) {
            if ((match.range.location >= disableMatch.range.location && match.range.location < disableMatch.range.location + disableMatch.range.length) && match.range.length <= disableMatch.range.length ) {
                /// 这个是不可用的
                //                NSLog(@"这个不可用 %d-%d", match.range.location, match.range.length);
                matchEnable = NO;
                break;
            }
        }
        if (matchEnable == NO) {
            continue;
        }
        fixString = [fixString stringByReplacingCharactersInRange:NSMakeRange(match.range.location + addRangeLength, match.range.length) withString:@"@objc dynamic var"];
        addRangeLength += 6;
    }
    return fixString;
}

@end
