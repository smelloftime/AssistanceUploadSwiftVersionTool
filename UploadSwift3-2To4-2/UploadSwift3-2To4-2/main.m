//
//  main.m
//  UploadSwift3-2To4-2
//
//  Created by SmellTime on 2019/4/21.
//  Copyright © 2019 SmellTime. All rights reserved.
//
// 1、自动在selector绑定的方法前添加@objc
// 2、在dynamic变量声明前添加@objc (主要是处理Realm数据库中的变量)
// 3、替换旧的API
// 欢迎提问和补充
// https://github.com/smelloftime/AssistanceUploadSwiftVersionTool

#import <Foundation/Foundation.h>
#import "STAssistanceManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hi you!");

        STAssistanceManager * manager = [[STAssistanceManager alloc]init];
        manager.projectPath = @"/Users/smelltime/Desktop/TestDemo";

        //MARK: --- 批量替换清单
        NSArray *targetWords = @[@"childViewControllers",
                              @"addChildViewController",
                              @"didMove(toParentViewController",
                              @"UIViewAnimationOptions",
                              @"NSNotification.Name.UITextFieldTextDidChange",
                              @"NSNotification.Name.UITextFieldTextDidBeginEditing",
                              @"NSNotification.Name.UITextFieldTextDidEndEditing",
                              @"NSNotification.Name.UITextViewTextDidChange",
                              @"NSNotification.Name.UITextViewTextDidBeginEditing",
                              @"NSNotification.Name.UITextViewTextDidEndEditing",
                              @"bringSubview(toFront:",
                              @"UIControlState",
                              @"UIControlEvents",
                              @"UITableViewCellStyle",
                              @"removeFromParentViewController",
                              @"UIViewContentMode",
                              @"NSParagraphStyleAttributeName",
                              @"NSFontAttributeName",
                              @"NSForegroundColorAttributeName",
                              @"UIViewAutoresizing",
                              @"UIApplicationDidChangeStatusBarFrame",
                              @"AVCaptureTorchMode",
                              @"UITableViewCellSeparatorStyle",
                              @"UIImageOrientation",
                              @"UILayoutPriorityDefaultHigh",
                              @"UILayoutPriorityDefaultLow",

                              @"UIKeyboardFrameEndUserInfoKey",
                              @"AVCaptureDevicePosition",
                              @"AVCaptureSessionPresetPhoto",
                              @"AVLayerVideoGravityResizeAspectFill",
                              @"UIBarButtonItemStyle",
                              @"AVMetadataObjectTypeQRCode",
                              @"UICollectionViewScrollPosition",
                              @"ReachabilityChangedNotification",
                              @"NSUIResponder.keyboardWillShowNotification",
                              @"UIKeyboardAnimationDurationUserInfoKey",
                              @"AVAudioSessionCategoryPlayback",
                              @"NSNotification.Name.UIKeyboardWillHide",
                              @"UIKeyboardIsLocalUserInfoKey",
                              @"UIKeyboardFrameBeginUserInfoKey",
                              @"UIViewAnimationCurve",
                              @"UIKeyboardAnimationCurveUserInfoKey",
                              @"AVLayerVideoGravityResizeAspect"
                              ];
        NSArray *replaceWords = @[@"children",
                             @"addChild",
                             @"didMove(toParent",
                             @"UIView.AnimationOptions",
                             @"UITextField.textDidChangeNotification",
                             @"UITextField.textDidBeginEditingNotification",
                             @"UITextField.textDidEndEditingNotification",
                             @"UITextView.textDidChangeNotification",
                             @"UITextView.textDidBeginEditingNotification",
                             @"UITextView.textDidEndEditingNotification",
                             @"bringSubviewToFront(",
                             @"UIControl.State",
                             @"UIControl.Event",
                             @"UITableViewCell.CellStyle",
                             @"removeFromParent",
                             @"UIView.ContentMode",
                             @"NSAttributedString.Key.paragraphStyle",
                             @"NSAttributedString.Key.font",
                             @"NSAttributedString.Key.foregroundColor",
                             @"UIView.AutoresizingMask",
                             @"UIApplication.didChangeStatusBarFrameNotification",
                             @"AVCaptureDevice.TorchMode",
                             @"UITableViewCell.SeparatorStyle",
                             @"UIImage.Orientation",
                             @"UILayoutPriority.defaultHigh",
                             @"UILayoutPriority.defaultLow",
                             @"UIResponder.keyboardFrameEndUserInfoKey",
                             @"AVCaptureDevice.Position",
                             @"AVCaptureSession.Preset.photo",
                             @"AVLayerVideoGravity.resizeAspectFill",
                             @"UIBarButtonItem.Style",
                             @"AVMetadataObject.ObjectType.qr",
                             @"UICollectionView.ScrollPosition",
                             @"Notification.Name.reachabilityChanged",
                             @"UIResponder.keyboardWillShowNotification",
                             @"UIResponder.keyboardAnimationDurationUserInfoKey",
                             @"AVAudioSession.Category.playback",
                             @"UIResponder.keyboardWillHideNotification",
                             @"UIResponder.keyboardIsLocalUserInfoKey",
                             @"UIResponder.keyboardFrameBeginUserInfoKey",
                             @"UIView.AnimationCurve",
                             @"UIResponder.keyboardAnimationCurveUserInfoKey",
                             @"AVLayerVideoGravity.resizeAspect"
                             ];
        manager.targetWords = [[NSMutableArray alloc] initWithArray:targetWords];
        manager.replaceWords = [[NSMutableArray alloc] initWithArray:replaceWords];
        NSLog(@"\n\n开始执行\n\n");
        [manager startWork];
        NSLog(@"\n\n完成咯\n\n");
    }
    return 0;
}
