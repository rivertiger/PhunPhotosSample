//
//  PhunPhotosViewController.h
//  PhunPhotosSample
//
//  Created by Ryan Newsome on 12/28/11.
//  Copyright (c) 2011 Phunware. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIKit.h>

#import "SampleAPIKey.h"
#import "ObjectiveFlickr.h"

#import "OverlayViewController.h"
#import "PhunPhotosAppDelegate.h"
#import "OverlayViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PhunPhotosViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, OverlayViewControllerDelegate, OFFlickrAPIRequestDelegate>
{
    //Flickr Request Var
    OFFlickrAPIRequest *flickrRequest;
    OFFlickrAPIContext *flickrContext;
	NSString *flickrUserName;
    UINavigationController *navController;
    IBOutlet UIWebView *webView;

}
//Make navController Accessible
@property (nonatomic, retain) IBOutlet UINavigationController *navController;



//Authorize Flickr Methods
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, readonly) OFFlickrAPIContext *flickrContext;
@property (nonatomic, retain) NSString *flickrUserName;
@property (nonatomic, retain) UIWebView *webView;
- (IBAction)authorizeFlickrButtonPressed;
- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret;


//default Camera Methods
- (IBAction)defaultCameraButtonPressed;

//custom Camera Methods
- (IBAction)customCameraButtonPressed;

//default Camera Methods
- (IBAction)defaultVideoCameraButtonPressed;

//default Photo Methods
- (IBAction)defaultLibraryButtonPressed;
- (IBAction)deletePhoto;
- (void)updatePhotoInfo;


@end
