//  Created by Geoff Pado on 2/10/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.

#import "FileIconFetcher.h"

@implementation FileIconFetcher

- (CGImageRef)iconForURL:(NSURL *)fileURL {
    id workspace = [NSClassFromString(@"NSWorkspace") valueForKeyPath:@"sharedWorkspace"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSObject *nsImage = [workspace performSelector:NSSelectorFromString(@"iconForFile:") withObject:[fileURL path]];
#pragma clang diagnostic pop

    CGSize desiredSize = CGSizeMake(16.0, 16.0);
    NSMethodSignature *sizeSignature = [nsImage methodSignatureForSelector:NSSelectorFromString(@"setSize:")];
    NSInvocation *sizeInvocation = [NSInvocation invocationWithMethodSignature:sizeSignature];
    [sizeInvocation setSelector:NSSelectorFromString(@"setSize:")];
    [sizeInvocation setArgument:&desiredSize atIndex:2];
    [sizeInvocation invokeWithTarget:nsImage];

    CGRect desiredRect = CGRectMake(0, 0, desiredSize.width, desiredSize.height);
    NSMethodSignature *cgImageSignature = [nsImage methodSignatureForSelector:NSSelectorFromString(@"CGImageForProposedRect:context:hints:")];
    NSInvocation *cgImageInvocation = [NSInvocation invocationWithMethodSignature:cgImageSignature];
    [cgImageInvocation setSelector:NSSelectorFromString(@"CGImageForProposedRect:context:hints:")];
    [cgImageInvocation setArgument:&desiredRect atIndex:2];
    [cgImageInvocation invokeWithTarget:nsImage];

    CGImageRef cgImage;
    [cgImageInvocation getReturnValue:&cgImage];

    return cgImage;
}

@end
