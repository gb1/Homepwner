//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Gregor Brett on 03/04/2013.
//  Copyright (c) 2013 Gregor Brett. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+(id)allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

+(BNRImageStore *)sharedStore{
    static BNRImageStore *sharedStore = nil;
    if(!sharedStore){
        //create singleton
        sharedStore = [[super allocWithZone:NULL]init];
    }
    return sharedStore;
}
-(id)init{
    self = [super init];
    if(self){
        dictionary = [[NSMutableDictionary alloc]init];
    }
return self;
}

#pragma mark -finished init

-(void)setImage:(UIImage *)i forKey:(NSString *)s{
    [dictionary setObject:i forKey:s];
    
    //create full path  for image
    NSString *imagePath = [self imagePathForKey:s];
    
    //turn image into JPEG
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    
    //write it to path
    [d writeToFile:imagePath atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)s{
    //return [dictionary objectForKey:s];
    
    
}

-(void)deleteImageForKey:(NSString *)s{
    if(!s) return;
    [dictionary removeObjectForKey:s];
    
    //delete file
    NSString *path = [self imagePathForKey:s];
    [[NSFileManager defaultManager]removeItemAtPath:path error:NULL];
}

-(NSString *)imagePathForKey:(NSString *)key{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingString:key];
}


@end
