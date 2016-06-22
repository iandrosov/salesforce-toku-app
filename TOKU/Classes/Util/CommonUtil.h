//
//  CommonUtil.h
//  Appirian
//
//  Created by Igor Old MAC on 2/13/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import <Foundation/Foundation.h>

// App Local folder name for file storage
#define TOKU_LOCAL_IMAGE_FOLDER @"TOKU_IMAGE"

@interface CommonUtil : NSObject

+ (NSString *)applicationDocumentsDirectory;
+ (NSString *)localDocumentFilePath:(NSString*)dir;
+ (void)createLocalImage:(UIImage*)img fileId:(NSString*)fileId;
+ (UIImage*) getCellImageLocal:(NSString*)imgId;

@end
