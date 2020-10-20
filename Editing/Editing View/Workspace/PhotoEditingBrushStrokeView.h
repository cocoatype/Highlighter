//  Created by Geoff Pado on 8/19/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PhotoEditingBrushStrokeView <NSObject>

@property (readwrite, nonnull) UIColor *color;
@property (readonly, nullable) UIBezierPath *currentPath;
- (void)updateToolWithCurrentZoomScale:(CGFloat)currentZoomScale NS_SWIFT_NAME(updateTool(currentZoomScale:));

@end

NS_ASSUME_NONNULL_END
