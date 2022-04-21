//
//  ViewController.m
//  permissions-oc
//
//  Created by Yuchen Zhang on 2022/4/20.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "LocalNetworkAuthorization.h"
//#import<CoreTelephony/CTCallCenter.h>
//#import<CoreTelephony/CTCall.h>
//#import<CoreTelephony/CTCarrier.h>
//#import<CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCellularData.h>
#import "permissions_oc-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)getCameraPermissionStatus:(id)sender {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSLog(@"Camera Permission status: %ld", (long)status);
}

- (IBAction)askCameraPermission:(id)sender {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"Ask Camera Permission granted: %d", granted);
    }];
}

- (IBAction)getMicrophonePermissionStatus:(id)sender {
    AVAudioSessionRecordPermission status = [[AVAudioSession sharedInstance] recordPermission];
    NSLog(@"Microphone Permission status: %ld", (long)status);
}

- (IBAction)askMicrophonePermissions:(id)sender {
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        NSLog(@"Ask Microphone Permission granted: %d", granted);
    }];
}

- (IBAction)getPhotoLibraryPermissions:(id)sender {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
    NSLog(@"Photo Library Permission status: %ld", (long)status);
}

- (IBAction)askPhotoLibraryPermissions:(id)sender {
    [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly handler:^(PHAuthorizationStatus status) {
        NSLog(@"Ask Photo Library Permission status: %ld", (long)status);
    }];
}

- (IBAction)askLocalNetworkPermission:(id)sender {
    double startTime = [[NSProcessInfo processInfo] systemUptime];
    LocalNetworkAuthorization* localNetworkPrivacy = [LocalNetworkAuthorization new];
    [localNetworkPrivacy checkAccessState:^(BOOL granted) {
        NSLog(@"Granted: %@ in %f", granted ? @"YES" : @"NO", startTime - [[NSProcessInfo processInfo] systemUptime]);
    }];
}

- (IBAction)getWirelessDataPermission:(id)sender {
    NSLog(@"Get wireless data permission");
    [self monitorCanUseCellularData];
}

- (IBAction)askWirelessDataPermission:(id)sender {
    WirelessDataPermission *permission = [[WirelessDataPermission alloc] init];
    [permission triggerDialog];
}

- (IBAction)openSettings:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
        NSLog(@"Settings completion handler %d", success);
    }];
}

- (void)monitorCanUseCellularData {
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    //NSLog(@"%ld", cellularData.restrictedState);
    // 0, kCTCellularDataRestrictedStateUnknown
    [cellularData setCellularDataRestrictionDidUpdateNotifier:^(CTCellularDataRestrictedState state) {
        switch (state) {
            case kCTCellularDataRestrictedStateUnknown:
                NSLog(@"kCTCellularDataRestrictedStateUnknown");
                break;
            case kCTCellularDataRestricted:
                NSLog(@"kCTCellularDataRestricted");
                break;
            case kCTCellularDataNotRestricted:
                NSLog(@"kCTCellularDataNotRestricted");
                break;
        }
        //self.canUseCellularData = cellularData.restrictedState ==2?true:false;
    }];
    
}

@end
