//
//  NSString+iCloud.m
//  MKProject
//
//  Created by baojuan on 14-9-3.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "NSString+iCloud.h"

@implementation NSString (iCloud)
//设置云同步
+(void)addNotBackUp:(NSString *)fileName
{
    
    NSString *pathPrefix = [NSHomeDirectory() stringByAppendingPathComponent:@"library"];
    
    NSString *folderPath = [pathPrefix stringByAppendingPathComponent:fileName];
    
    NSURL *url = [NSURL URLWithString:folderPath];
    
    [self addSkipBackupAttributeToItemAtURL:url];
    
}
//设置云同步
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    if (&NSURLIsExcludedFromBackupKey == nil) {
        // iOS 5.0.1 and lower
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else {
        // First try and remove the extended attribute if it is present
        int result = getxattr(filePath, attrName, NULL, sizeof(u_int8_t), 0, 0);
        if (result != -1) {
            // The attribute exists, we need to remove it
            int removeResult = removexattr(filePath, attrName, 0);
            if (removeResult == 0) {
                NSLog(@"Removed extended attribute on file %@", URL);
            }
        }
        
        // Set the new key
        return [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
}@end
