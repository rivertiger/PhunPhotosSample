//
//  PhunPhotosViewController.m
//  PhunPhotosSample
//
//  Created by Ryan Newsome on 12/28/11.
//  Copyright (c) 2011 Phunware. All rights reserved.
//

#import "PhunPhotosViewController.h"
#import "OverlayViewController.h"

//Constants
NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";
NSString *SRCallbackURLBaseString = @"snapnrun://auth";

@implementation PhunPhotosViewController
@synthesize flickrRequest;



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)authorizeFlickrButtonPressed
{
    self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
    [self.flickrRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:SRCallbackURLBaseString]];
    
    
}

- (IBAction)choosePhoto 
{	
	// Show an image picker to allow the user to choose a new photo.
	
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	[self presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}

- (IBAction)defaultCameraButtonPressed
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}


- (IBAction)customCameraButtonPressed
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //Haven't gotten this to work yet.
    //OverlayViewController *overlayViewController = [[[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil] retain];
    
    // as a delegate we will be notified when pictures are taken and when to dismiss the image picker
    //self.overlayViewController.delegate = self;
    //self.capturedImages = [NSMutableArray array];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // camera is not on this device, don't show the camera button
        // NSMutableArray *toolbarItems = [NSMutableArray arrayWithCapacity:self.myToolbar.items.count];
        //[toolbarItems addObjectsFromArray:self.myToolbar.items];
        // [toolbarItems removeObjectAtIndex:2];
        // [self.myToolbar setItems:toolbarItems animated:NO];
    }
    
	[imagePicker release];
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
