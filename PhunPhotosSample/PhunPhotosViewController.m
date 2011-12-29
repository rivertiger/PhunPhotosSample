//
//  PhunPhotosViewController.m
//  PhunPhotosSample
//
//  Created by Ryan Newsome on 12/28/11.
//  Copyright (c) 2011 Phunware. All rights reserved.
//

#import "PhunPhotosViewController.h"
#import "OverlayViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


//Constants
NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";
NSString *SRCallbackURLBaseString = @"snapnrun://auth";

@implementation PhunPhotosViewController
@synthesize flickrRequest;
@synthesize navController;



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)authorizeFlickrButtonPressed
{
    NSLog(@"authorize Flickr button pressed.");
    self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
    [self.flickrRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:SRCallbackURLBaseString]];
    
    
}

- (IBAction)defaultLibraryButtonPressed
{	
    NSLog(@"defaultLibrary button pressed.");
	// Show an image picker to allow the user to choose a new photo.
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:imagePicker animated:YES];
	[imagePicker release];


}

- (IBAction)defaultCameraButtonPressed
{
    NSLog(@"defaultCamera button pressed.");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
    //Property to set Camera Sourcetype
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //Property to show Camera Controls
    imagePicker.showsCameraControls = YES;
    //Property to allow editing
    imagePicker.allowsEditing = TRUE;
	[self presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}


- (IBAction)customCameraButtonPressed
{
    NSLog(@"customCamera button pressed.");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePicker.showsCameraControls = NO;
    imagePicker.navigationBarHidden = YES;
    imagePicker.toolbarHidden = YES;
    imagePicker.wantsFullScreenLayout = YES;
    
    // Create the overlay and use the design from XIB //
    OverlayViewController *overlayview = [[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
    // Call the setupImagePIcker method to specify the camera and location //
    //[overlayview setupImagePicker:UIImagePickerControllerSourceTypeCamera];
    
    overlayview.imagePickerController = imagePicker;
    overlayview.delegate = self;
    imagePicker.cameraOverlayView = overlayview.view;
    [self presentModalViewController:imagePicker animated:YES];
    
    //[overlayview release];
    [imagePicker release];
	
}

- (IBAction)defaultVideoCameraButtonPressed
{
    //Requires MobileServices Framework
    NSLog(@"customVideoCamera button pressed.");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    
    //imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;
    imagePicker.videoQuality=UIImagePickerControllerQualityTypeHigh;
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePicker.showsCameraControls = YES;
    imagePicker.navigationBarHidden = YES;
    //Property to display toolbar at Bottom/below camera button
    imagePicker.toolbarHidden = YES;
    imagePicker.wantsFullScreenLayout = YES;
    
    // Create the overlay and use the design from XIB //
    OverlayViewController *overlayview = [[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
    // Call the setupImagePIcker method to specify the camera and location //
    //[overlayview setupImagePicker:UIImagePickerControllerSourceTypeCamera];
    
    overlayview.imagePickerController = imagePicker;
    overlayview.delegate = self;
    //imagePicker.cameraOverlayView = overlayview.view;
    [self presentModalViewController:imagePicker animated:YES];
    
    //[overlayview release];
    [imagePicker release];

    
}

#pragma mark -
#pragma mark OverlayViewControllerDelegate

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    NSMutableArray *capturedImages;
    [capturedImages addObject:picture];
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    NSMutableArray *capturedImages;
    [self dismissModalViewControllerAnimated:YES];


}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc
{	
    [super dealloc];
}

@end
