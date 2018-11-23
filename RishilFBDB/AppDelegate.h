//
//  AppDelegate.h
//  RishilFBDB
//
//  Created by Rishil-iMac on 22/11/18.
//  Copyright © 2018 Rishil Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) FIRFirestore *db;

@end

