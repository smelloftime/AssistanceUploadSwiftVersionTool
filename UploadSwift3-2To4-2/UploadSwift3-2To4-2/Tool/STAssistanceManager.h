//
//  AssistanceManager.h
//  UploadSwift3-2To4-2
//
//  Created by SmellTime on 2019/4/16.
//  Copyright © 2019 SmellTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STAssistanceManager : NSObject
/// 工程完整路径
@property (nonatomic, copy) NSString* projectPath;
/// 需要处理的文件路径数组
@property (nonatomic, strong) NSMutableArray* enablePaths;
/// 排除的文件路径
@property (nonatomic, strong) NSMutableArray* excludePaths;
/// 需要替换的API名称数组
@property (nonatomic, strong) NSMutableArray* targetWords;
/// 替换后的API名称数组
@property (nonatomic, strong) NSMutableArray* replaceWords;

/// 不指定enablePaths即为当前路径下全部文件
- (void)startWork;

@end

NS_ASSUME_NONNULL_END
