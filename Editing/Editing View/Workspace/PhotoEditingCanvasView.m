//  Created by Geoff Pado on 8/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#import "PhotoEditingCanvasView.h"
#import "PhotoEditingCanvasBrushStrokeView.h"

#define STANDARD_LINE_WIDTH 10.0

@implementation PhotoEditingCanvasView

- (instancetype)init
{
    if ((self = [super initWithFrame:CGRectZero])) {
        self.accessibilityIgnoresInvertColors = YES;
        self.drawingPolicy = PKCanvasViewDrawingPolicyAnyInput;
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor blackColor];
        self.opaque = NO;
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        self.tool = [self toolForZoomScale:1.0];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }

    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    PKInkingTool *currentTool = (PKInkingTool *)[self tool];
    PKInkingTool *newTool = [[PKInkingTool alloc] initWithInkType:currentTool.inkType color:color width:currentTool.width];
    self.tool = newTool;
}

// MARK: Tool Creation

- (CGFloat)currentLineWidth {
    return [((PKInkingTool *)[self tool]) width];
}

- (PKTool *)toolForZoomScale:(CGFloat)zoomScale {
    return [[PKInkingTool alloc] initWithInkType:PKInkTypeMarker color:self.color width:[self adjustedLineWidthForZoomScale:zoomScale]];
}

// MARK: Zoom Handling

- (void)updateToolWithCurrentZoomScale:(CGFloat)currentZoomScale {
    self.tool = [self toolForZoomScale:currentZoomScale];
}

- (CGFloat)adjustedLineWidthForZoomScale:(CGFloat)zoomScale {
    return STANDARD_LINE_WIDTH * pow(zoomScale, -1.0);
}

// MARK: Touch Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.brushStrokeView touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self.brushStrokeView touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self.brushStrokeView touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.brushStrokeView touchesEnded:touches withEvent:event];
}

- (PhotoEditingCanvasBrushStrokeView *)brushStrokeView {
    return (PhotoEditingCanvasBrushStrokeView *)[self superview];
}

@end
