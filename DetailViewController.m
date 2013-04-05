//
//  DetailViewController.m
//  Homepwner
//
//  Created by Gregor Brett on 03/04/2013.
//  Copyright (c) 2013 Gregor Brett. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;
@synthesize dimissBlock;

-(id)initForNewItem:(BOOL)isNew{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if(self){
        if(isNew){
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem]setRightBarButtonItem:doneItem];
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem]setLeftBarButtonItem:cancelItem];
        }
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    @throw [NSException exceptionWithName:@"Wrong init" reason:@"use initForNewItem" userInfo:nil];
    return nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //[[self view]setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIColor *clr = nil;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    }
    else{
        clr = [UIColor groupTableViewBackgroundColor];
    }
    [[self view]setBackgroundColor:clr];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        return YES;
    }else{
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    //date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [dateLabel setText:[formatter stringFromDate:[item dateCreated]]];
    
    NSString *imageKey = [item imageKey];
    
    if(imageKey){
        UIImage *imageToDisplay = [[BNRImageStore sharedStore]imageForKey:imageKey];
        [imageView setImage:imageToDisplay];
    }else{
        [imageView setImage:nil];
    }

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
    [[self view]endEditing:YES];
    
    //save changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars: [[valueField text] intValue]];
}

-(void)setItem:(BNRItem *)i{
    item = i;
    [[self navigationItem]setTitle:[item itemName]];
}


- (IBAction)takePicture:(id)sender {
    
    NSLog(@"boop");
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    //check for camera
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    
    //check for ipad
    if([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        if(!imagePickerPopover){
            imagePickerPopover = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
            [imagePickerPopover setDelegate:self];
            [imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    else{
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)backgroundTapped:(id)sender {
    NSLog(@"tappy tap");
    [[self view]endEditing:YES];
}

- (IBAction)backTapped:(id)sender {
        [[self view]endEditing:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    NSString *oldKey = [item imageKey];
    
    if(oldKey){
        [[BNRImageStore sharedStore]deleteImageForKey:oldKey];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //create new CFUUID object
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
   
    NSString *key = (__bridge NSString *)newUniqueIDString;
    NSLog(@"%@",key);
    
    [item setImageKey:key];
    [[BNRImageStore sharedStore] setImage:image forKey:[item imageKey]];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    [imageView setImage:image];
    
    if([[UIDevice currentDevice]userInterfaceIdiom]== UIUserInterfaceIdiomPhone){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    imagePickerPopover = nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)save:(id)sender{
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:dimissBlock];
    
}

-(void)cancel:(id)sender{
    [[BNRItemStore sharedStore]removeItem:item];
    [[self presentingViewController]dismissViewControllerAnimated:YES completion:nil];
}

@end
