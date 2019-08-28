//  Created by Geoff Pado on 8/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#import "PhotoEditingCanvasBrushStrokeView.h"

#import "PhotoEditingCanvasView.h"

@interface PhotoEditingCanvasBrushStrokeView ()

@property (nonatomic, strong) PhotoEditingCanvasView *canvasView;
@property (nonatomic) BOOL canvasViewIsDirty;
@property (nonatomic, nullable, strong) UIBezierPath *currentPath;

@end

@implementation PhotoEditingCanvasBrushStrokeView

@synthesize currentPath;

- (instancetype)init {
    if ((self = [super initWithFrame:CGRectZero])) {
        self.canvasViewIsDirty = NO;
        self.translatesAutoresizingMaskIntoConstraints = false;

        self.canvasView = [[PhotoEditingCanvasView alloc] init];
        self.canvasView.delegate = self;
        [self addSubview:self.canvasView];

        [NSLayoutConstraint activateConstraints:@[
            [self.canvasView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:1.0],
            [self.canvasView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:1.0],
            [self.canvasView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.canvasView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];
    }

    return self;
}

- (void)updateToolWithCurrentZoomScale:(CGFloat)currentZoomScale {
    [self.canvasView updateToolWithCurrentZoomScale:currentZoomScale];
}

#pragma mark PKCanvasViewDelegate

- (void)canvasViewDidBeginUsingTool:(PKCanvasView *)canvasView {
    self.canvasViewIsDirty = YES;
}

- (void)canvasViewDidEndUsingTool:(PKCanvasView *)canvasView {
    if (self.canvasViewIsDirty == false) { return; }

    self.canvasViewIsDirty = false;
    self.canvasView.drawing = [PKDrawing new];
}

#pragma mark Path Manipulation

- (UIBezierPath *)newPath {
    UIBezierPath *newPath = [UIBezierPath bezierPath];
    newPath.lineCapStyle = kCGLineCapRound;
    newPath.lineJoinStyle = kCGLineJoinRound;
    newPath.lineWidth = self.canvasView.currentLineWidth;
    return newPath;
}

#pragma mark Touch Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch == nil) { return; }

    self.currentPath = [self newPath];
    [self.currentPath moveToPoint:[touch locationInView:self]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch == nil) { return; }
    [self.currentPath addLineToPoint:[touch locationInView:self]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    self.currentPath = nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.currentPath = nil;
}

@end
