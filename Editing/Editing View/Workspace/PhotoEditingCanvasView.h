//
//  PhotoEditingCanvasView.h
//  Canvas
//
//  Created by Geoff Pado on 8/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.
//

#import <PencilKit/PencilKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoEditingCanvasView : PKCanvasView

@property (nonatomic, nonnull) UIColor *color;
@property (nonatomic) CGFloat currentLineWidth;

- (void)updateToolWithCurrentZoomScale:(CGFloat)currentZoomScale;

@end

NS_ASSUME_NONNULL_END
