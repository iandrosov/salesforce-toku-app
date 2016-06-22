//
//  CommonUtil.m
//  Appirian
//
//  Created by Igor Old MAC on 2/13/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

// Returns the parent document directory
+ (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = nil;
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

// Get local directory where to store a file, ensure directory exists or create it
+ (NSString*)localDocumentFilePath:(NSString*)dir {
    // Create floder if not exist
    NSString *documentDirPath = [CommonUtil applicationDocumentsDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    NSString *dataPath = [documentDirPath stringByAppendingPathComponent:dir];
    if (![fileManager fileExistsAtPath:dataPath]){
        [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    // folder section
    return dataPath;
}

// Create local stored images
+ (void)createLocalImage:(UIImage*)img fileId:(NSString*)fileId{
    
    // Initialize file manager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Open cell image folder
    NSString *imageFolderPath = [CommonUtil localDocumentFilePath:TOKU_LOCAL_IMAGE_FOLDER];
    
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png",fileId];
    
        NSLog(@"File path: %@ ",imageFileName);
        NSString *subFilePath = [NSString stringWithFormat:@"%@/%@",imageFolderPath,imageFileName];
        // Check if file exists and it is not resized to overwrite it
        if([fileManager fileExistsAtPath:subFilePath isDirectory:NO] && img)
        {
            // File Found in local store
            NSLog(@"FOUND Image File path: %@ ",subFilePath);
            
            // Save mage file here
            NSData * binaryImageData = UIImagePNGRepresentation(img);
            [binaryImageData writeToFile:subFilePath atomically:YES];
            
        }
    
}

+ (UIImage*) getCellImageLocal:(NSString*)imgId {
    
    UIImage *icon = [UIImage imageNamed:@"placeholder"];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png", imgId];
    NSString *documentDirPath = [CommonUtil localDocumentFilePath:TOKU_LOCAL_IMAGE_FOLDER];
    //NSLog(@"Image path: %@", documentDirPath);
    NSString *filePath = [documentDirPath stringByAppendingPathComponent:imageFileName];
    //NSLog(@"Imag file:  %@", filePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]){
        icon = [UIImage imageWithContentsOfFile:filePath];
    }
    
    return icon;
}

@end
