//
//  PhunPhotosViewController.m
//  PhunPhotosSample
//
//  Created by Ryan Newsome on 12/28/11.
//  Copyright (c) 2011 Phunware. All rights reserved.
//

#import "PhunPhotosViewController.h"
#import "OverlayViewController.h"
//#import "MyViewController.h"


//Constants
NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";
NSString *SRCallbackURLBaseString = @"snapnrun://auth";

@implementation PhunPhotosViewController
@synthesize flickrRequest;
@synthesize navController;
@synthesize overlay;
@synthesize picker;

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
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.showsCameraControls = YES;
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
    imagePicker.navigationBarHidden = NO;
    imagePicker.toolbarHidden = NO;
    imagePicker.wantsFullScreenLayout = YES;
    //[self presentModalViewController:imagePicker animated:YES];
    
    
    // Insert the overlay
    OverlayViewController *overlayview = [[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
    imagePicker.cameraOverlayView = overlayview.view;
    //self.overlay.pickerReference = self.picker;
    //imagePicker.cameraOverlayView = self.overlay.view;
    [self presentModalViewController:imagePicker animated:YES];
    //imagePicker.delegate = self.overlay;
    [overlayview release];
    [imagePicker release];
    
    

    //[navController setNavigationBarHidden:NO animated:NO];
	//[navController pushViewController:self.picker animated:YES];
    //[self presentModalViewController:customview animated:YES];

	
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
    [overlay release];
    [picker release];
    [navController release];
    [super dealloc];
}

@end
