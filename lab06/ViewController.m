//
//  ViewController.m
//  lab06
//
//  Created by Jinny Jin on 2018-02-02.
//  Copyright © 2018 Jinny Jin. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UITextField *textbox;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //connect my app to my service hosted online(Parse SDK)
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration){
        
        configuration.applicationId = @"Np3QvJwVRMD2PdJkPXUNPQBVULYAo0utGLuLoDDg";
        
        configuration.clientKey = @"93OxnzOrgMOsKxKCFOaELob6FIHQfUCbLedxfe0G";
        
        configuration.server = @"https://parseapi.back4app.com";
        
        configuration.localDatastoreEnabled = YES; // If you need to enable local data store
        
    }]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)post:(id)sender {
    [self startMediaBrowserFromViewController: self usingDelegate: self];
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller

                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               
                                               UINavigationControllerDelegate>) delegate {
    
    
    
    if (([UIImagePickerController isSourceTypeAvailable:
          
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        
        || (delegate == nil)
        
        || (controller == nil))
        
        return NO;
    
    
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    
    
    // Displays saved pictures and movies, if both are available, from the
    
    // Camera Roll album.
    
    mediaUI.mediaTypes =
    
    [UIImagePickerController availableMediaTypesForSourceType:
     
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    
    
    // Hides the controls for moving & scaling pictures, or for
    
    // trimming movies. To instead show the controls, use YES.
    
    mediaUI.allowsEditing = NO;
    
    
    
    mediaUI.delegate = delegate;
    
    
    
    [controller presentModalViewController: mediaUI animated: YES];
    
    return YES;
    
}

- (void) imagePickerController: (UIImagePickerController *) picker

 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    UIImage *originalImage, *editedImage, *imageToUse;
    
    
    
    // Handle a still image picked from a photo album
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        
        == kCFCompareEqualTo) {
        
        
        
        editedImage = (UIImage *) [info objectForKey:
                                   
                                   UIImagePickerControllerEditedImage];
        
        originalImage = (UIImage *) [info objectForKey:
                                     
                                     UIImagePickerControllerOriginalImage];
        
        
        
        if (editedImage) {
            
            imageToUse = editedImage;
            
        } else {
            
            imageToUse = originalImage;
            
        }
        
        // Do something with imageToUse
        
        [_ImageView setImage:originalImage];
        
    }
    
    //sync to cloud
    // Create a new Parse Object
    
    PFObject *FacebookPostObject = [PFObject objectWithClassName:@"FacebookPost"];
    

    
    //Fill the parse object with data
    FacebookPostObject[@"comment"] = _textbox.text;
    
    // Send the parse object to the cloud
    
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:UIImageJPEGRepresentation(originalImage, 0.05f)];
    
    FacebookPostObject[@"imageFile"] = imageFile;
    
    //[FacebookPostObject save];
    // Send the parse object to the cloud
    [FacebookPostObject saveInBackground];
    
    
    // Handle a movied picked from a photo album
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        
        == kCFCompareEqualTo) {
        
        
        
        NSString *moviePath = [[info objectForKey:
                                
                                UIImagePickerControllerMediaURL] path];
        
        
        
        // Do something with the picked movie available at moviePath
        
    }
    
    
    
    [self dismissModalViewControllerAnimated:YES];
    
}




@end
