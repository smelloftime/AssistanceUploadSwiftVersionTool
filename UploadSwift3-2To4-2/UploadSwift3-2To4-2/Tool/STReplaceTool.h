//
//  STReplaceTool.h
//  UploadSwift3-2To4-2
//
//  Created by IMAC on 2019/4/11.
//  Copyright © 2019年 SmellTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STReplaceTool : NSObject

- (void)autoReplaceObjcPaths:(NSString*)execPath fileNames:(NSArray<NSString*>*)fileNames replaceTargetWords:(NSArray<NSString *>*)targetWords toWords:(NSArray<NSString *> *)toWords;

@end

NS_ASSUME_NONNULL_END
