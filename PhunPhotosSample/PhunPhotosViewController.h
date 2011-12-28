//
//  PhunPhotosViewController.h
//  PhunPhotosSample
//
//  Created by Ryan Newsome on 12/28/11.
//  Copyright (c) 2011 Phunware. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
#import "ObjectiveFlickr.h"

@interface PhunPhotosViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, OverlayViewControllerDelegate, OFFlickrAPIRequestDelegate>
{
    //Flickr Request Var
    OFFlickrAPIRequest *flickrRequest;
    OFFlickrAPIContext *flickrContext;
	NSString *flickrUserName;
    
}


//Authorize Flickr Methods
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, readonly) OFFlickrAPIContext *flickrContext;
@property (nonatomic, retain) NSString *flickrUserName;
- (IBAction)authorizeFlickrButtonPressed;
- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret;

//default Camera Methods
- (IBAction)defaultCameraButtonPressed;

//custom Camera Methods
- (IBAction)customCameraButtonPressed;

//default Photo Methods
- (IBAction)choosePhoto;
- (IBAction)deletePhoto;
- (void)updatePhotoInfo;


@end
