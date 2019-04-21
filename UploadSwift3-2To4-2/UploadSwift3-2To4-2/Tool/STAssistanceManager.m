//
//  AssistanceManager.m
//  UploadSwift3-2To4-2
//
//  Created by SmellTime on 2019/4/16.
//  Copyright © 2019 SmellTime. All rights reserved.
//
// 1、自动在selector绑定的方法前添加@objc
// 2、在dynamic变量声明前添加@objc (主要是处理Realm数据库中的变量)
// 3、替换旧的API
// 欢迎提问和补充
// https://github.com/smelloftime/AssistanceUploadSwiftVersionTool

#import "STAssistanceManager.h"
#import "STAddObjcTool.h"
#import "STReplaceTool.h"

@implementation STAssistanceManager

- (void)startWork {    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *findFileNames = [[NSMutableArray alloc]init];
    NSMutableArray *enableFileNames = [[NSMutableArray alloc]init];
    if ([fileManager isExecutableFileAtPath:self.projectPath] == NO) {
        NSLog(@"error - 选择的文件路径不可用");
        return;
    }
    NSString *execPath = self.projectPath;
    /// 获取有效目录下的文件名称
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:execPath];
    for (NSString *fileName in enumerator) {
        if (self.enablePaths.count == 0) {
            if ([fileName hasSuffix:@".swift"]) {
                [findFileNames addObject:fileName];
            }
        } else {
            //  fileName 就是遍历到的每一个文件文件名
            for (int j = 0; j < self.enablePaths.count; j ++) {
                NSString *enablePatch = self.enablePaths[j];
                if ([fileName hasPrefix: enablePatch] && [fileName hasSuffix:@".swift"]) {
                    [findFileNames addObject:fileName];
                    break;
                }
            }
        }
    }
    /// 查找是否是需要排除的文件
    for (NSString *fileName in findFileNames) {
        BOOL didFind = NO;
        for (NSString *excludePatch in self.excludePaths) {
            if ([fileName hasPrefix: excludePatch]) {
                didFind = YES;
                break;
            }
        }
        if (didFind == NO) {
            [enableFileNames addObject:fileName];
        }
    }
    ///MARK: - 在#selector引用的方法名前添加@objc
    STAddObjcTool *addObjcTool = [[STAddObjcTool alloc]init];
    addObjcTool.projectPath = self.projectPath;
    [addObjcTool autoAddObjcPaths:execPath fileNames: enableFileNames];
    ///MARK: - 替换API
    /// 替换API
    [[STReplaceTool alloc] autoReplaceObjcPaths:execPath fileNames:enableFileNames replaceTargetWords:self.targetWords toWords:self.replaceWords];
}

@end
