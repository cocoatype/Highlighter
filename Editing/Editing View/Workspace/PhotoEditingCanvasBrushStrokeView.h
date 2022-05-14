//  Created by Geoff Pado on 8/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#import <Editing/PhotoEditingBrushStrokeView.h>
#import <PencilKit/PencilKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoEditingCanvasBrushStrokeView : UIControl <PhotoEditingBrushStrokeView, PKCanvasViewDelegate>

@property (nonatomic, nullable, readonly) UIBezierPath *currentPath;

@end

NS_ASSUME_NONNULL_END
