//
//  STAddObjcTool.h
//  UploadSwift3-2To4-2
//
//  Created by IMAC on 2019/4/11.
//  Copyright © 2019年 SmellTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STAddObjcTool : NSObject
/// 工程完整路径
@property (nonatomic, copy) NSString* projectPath;

- (void)autoAddObjcPaths:(NSString*)execPath fileNames:(NSArray<NSString*>*)fileNames;

@end

NS_ASSUME_NONNULL_END
