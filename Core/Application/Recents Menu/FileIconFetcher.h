//
//  FileIconFetcher.h
//  Highlighter
//
//  Created by Geoff Pado on 2/10/21.
//  Copyright © 2021 Cocoatype, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileIconFetcher : NSObject

- (CGImageRef)iconForURL:(NSURL *)fileURL;

@end

NS_ASSUME_NONNULL_END
