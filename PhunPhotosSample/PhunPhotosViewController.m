//
//  PhunPhotosViewController.m
//  PhunPhotosSample
//
//  Created by James Nguyen on 12/28/11.
//  Copyright (c) 2011 Phunware. All rights reserved.
//

#import "PhunPhotosViewController.h"



//Constants
NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";
NSString *SRCallbackURLBaseString = @"snapnrun://auth";

// preferably, the auth token is stored in the keychain, but since working with keychain is a pain, we use the simpler default system
NSString *kStoredAuthTokenKeyName = @"FlickrOAuthToken";
NSString *kStoredAuthTokenSecretKeyName = @"FlickrOAuthTokenSecret";

NSString *kGetAccessTokenStep = @"kGetAccessTokenStep";
NSString *kCheckTokenStep = @"kCheckTokenStep";
NSString *SnapAndRunShouldUpdateAuthInfoNotification = @"SnapAndRunShouldUpdateAuthInfoNotification";

@implementation PhunPhotosViewController
@synthesize flickrRequest;
@synthesize flickrContext;
@synthesize navController;
@synthesize webView;
@synthesize authorizeDescriptionLabel;



#pragma mark - IBAction Flickr Button Methods

- (IBAction)authorizeFlickrButtonPressed
{
    NSLog(@"authorize Flickr button pressed.");
    //self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
    //[self.flickrRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:SRCallbackURLBaseString]];
    //NSLog(@"flickr SAMPLE API KEY IS: %@", OBJECTIVE_FLICKR_SAMPLE_API_KEY);
    
    //Set the API Key and call the ObjectiveFlickr Classes
    flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
	flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
	[flickrRequest setDelegate:self];

    
    //Public Flickr API methods: DOES NOT REQUIRE AUTH LOGON //
    //This flickr call assigns flickrRequest with the most recent Photos
    //[flickrRequest callAPIMethodWithGET:@"flickr.photos.getRecent" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"per_page", nil]];
    
    
    if ([self.flickrContext.OAuthToken length]) {
		[self flickrRequest].sessionInfo = kCheckTokenStep;
    [flickrRequest callAPIMethodWithGET:@"flickr.test.login" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"per_page", nil]];
    }
    
    
    
    
}

#pragma mark - Flickr Custom Methods

- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret
{
	if (![inAuthToken length] || ![inSecret length]) {
		self.flickrContext.OAuthToken = nil;
        self.flickrContext.OAuthTokenSecret = nil;        
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:kStoredAuthTokenKeyName];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStoredAuthTokenSecretKeyName];
        
	}
	else {
		self.flickrContext.OAuthToken = inAuthToken;
        self.flickrContext.OAuthTokenSecret = inSecret;
		[[NSUserDefaults standardUserDefaults] setObject:inAuthToken forKey:kStoredAuthTokenKeyName];
		[[NSUserDefaults standardUserDefaults] setObject:inSecret forKey:kStoredAuthTokenSecretKeyName];
	}
}

- (OFFlickrAPIContext *)flickrContext
{
    if (!flickrContext) {
        flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET];
        
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenKeyName];
        NSString *authTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenSecretKeyName];
        
        if (([authToken length] > 0) && ([authTokenSecret length] > 0)) {
            flickrContext.OAuthToken = authToken;
            flickrContext.OAuthTokenSecret = authTokenSecret;
        }
    }
    
    return flickrContext;
}


- (OFFlickrAPIRequest *)flickrRequest
{
	if (!flickrRequest) {
		flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
		flickrRequest.delegate = self;		
	}
	
	return flickrRequest;
}


#pragma mark - Flickr Delegate Methods
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"flickr Response Dictionary is:%@", inResponseDictionary);
	NSDictionary *photoDict = [[inResponseDictionary valueForKeyPath:@"photos.photo"] objectAtIndex:0];
	
	NSString *title = [photoDict objectForKey:@"title"];
	if (![title length]) {
		title = @"No title";
	}
	
    
    //UITextView *textView = [[UITextView alloc] init];
    
    //This returns the URL for entire HTML page
	//NSURL *photoSourcePage = [flickrContext photoWebPageURLFromDictionary:photoDict];
    //This returns the URL for just the photo
    NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
    
    NSLog(@"photoSourcePage URL is:%@", photoURL);
    NSURLRequest *urLReturnedObject = [NSURLRequest requestWithURL:photoURL];
    [webView loadRequest:urLReturnedObject];
    
    //NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
    
    //Fix these later to render correctly//
	//NSDictionary *linkAttr = [NSDictionary dictionaryWithObjectsAndKeys:photoSourcePage, NSLinkAttributeName, nil];
	//NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:title attributes:linkAttr] autorelease];	
	//[[textView textStorage] setAttributedString:attrString];
    
	//NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDict size:OFFlickrSmallSize];
    /*
     NSString *htmlSource = [NSString stringWithFormat:
     @"<html>"
     @"<head>"
     @"  <style>body { margin: 0; padding: 0; } </style>"
     @"</head>"
     @"<body>"
     @"  <table border=\"0\" align=\"center\" valign=\"center\" cellspacing=\"0\" cellpadding=\"0\" height=\"240\">"
     @"    <tr><td><img src=\"%@\" /></td></tr>"
     @"  </table>"
     @"</body>"
     @"</html>"
     , photoURL];
     
     [[webView mainFrame] loadHTMLString:htmlSource baseURL:nil];
     */
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
	if (inRequest.sessionInfo == kGetAccessTokenStep) {
	}
	else if (inRequest.sessionInfo == kCheckTokenStep) {
		[self setAndStoreFlickrAuthToken:nil secret:nil];
	}
	
	//[activityIndicator stopAnimating];
	//[progressView removeFromSuperview];
    
	[[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
	[[NSNotificationCenter defaultCenter] postNotificationName:SnapAndRunShouldUpdateAuthInfoNotification object:self];
}

#pragma mark - IB Action Methods

- (void)checkForPreviousLogin 
{
    if ([self.flickrContext.OAuthToken length]) {
		[self flickrRequest].sessionInfo = kCheckTokenStep;
		[flickrRequest callAPIMethodWithGET:@"flickr.test.login" arguments:nil];
    }
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
    //Requires OverlayViewController class
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


#pragma mark - OverlayViewControllerDelegate Methods

// as a delegate we are being told a picture was taken
- (void)didTakePicture:(UIImage *)picture
{
    NSMutableArray *capturedImages;
    [capturedImages addObject:picture];
}

// as a delegate we are told to finished with the camera
- (void)didFinishWithCamera
{
    //NSMutableArray *capturedImages;
    [self dismissModalViewControllerAnimated:YES];


}




#pragma mark - Default View lifecycle Methods

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
    [webView release];
}   


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
