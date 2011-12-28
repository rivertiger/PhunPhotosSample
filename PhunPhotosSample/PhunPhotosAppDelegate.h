//
//  PhunPhotosAppDelegate.h
//  PhunPhotosSample
//
//  Created by Ryan Newsome on 12/28/11.
//  Copyright (c) 2011 Phunware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhunPhotosViewController;

@interface PhunPhotosAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>
{
    UINavigationController *navController;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) PhunPhotosViewController *viewController;

@end
