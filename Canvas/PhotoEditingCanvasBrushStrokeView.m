//  Created by Geoff Pado on 8/27/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

#import "PhotoEditingCanvasBrushStrokeView.h"

#import "PhotoEditingCanvasView.h"

@interface PhotoEditingCanvasBrushStrokeView ()

@property (nonatomic, strong) PhotoEditingCanvasView *canvasView;
@property (nonatomic) BOOL canvasViewIsResetting;
@property (nonatomic, nullable, strong) UIBezierPath *currentPath;

@end

@implementation PhotoEditingCanvasBrushStrokeView

@synthesize currentPath;

- (instancetype)init {
    if ((self = [super initWithFrame:CGRectZero])) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

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

- (UIColor *)color {
    return self.canvasView.color;
}

- (void)setColor:(UIColor *)color {
    self.canvasView.color = color;
}

- (void)updateToolWithCurrentZoomScale:(CGFloat)currentZoomScale {
    [self.canvasView updateToolWithCurrentZoomScale:currentZoomScale];
}

#pragma mark PKCanvasViewDelegate

- (void)canvasViewDrawingDidChange:(PKCanvasView *)canvasView {
    if (self.canvasViewIsResetting) { return; }

    if (@available(iOS 14.0, *)) {
        self.currentPath = [self pathFromDrawing:self.canvasView.drawing];
    }

    [self sendActionsForControlEvents:UIControlEventTouchUpInside];

    self.canvasViewIsResetting = YES;
    self.canvasView.drawing = [PKDrawing new];
    self.canvasViewIsResetting = NO;
}

#pragma mark Path Manipulation

- (UIBezierPath *)newPath {
    UIBezierPath *newPath = [UIBezierPath bezierPath];
    newPath.lineCapStyle = kCGLineCapRound;
    newPath.lineJoinStyle = kCGLineJoinRound;
    newPath.lineWidth = self.canvasView.currentLineWidth;
    return newPath;
}

- (UIBezierPath *)pathFromDrawing:(PKDrawing *)drawing {
    if (@available(iOS 14.0, *)) {
        NSArray<PKStroke *> *strokes = [drawing strokes];
        PKStroke *currentStroke = [strokes lastObject];
        PKStrokePath *strokePath = [currentStroke path];
        UIBezierPath *bezierPath = [self newPath];
        [bezierPath moveToPoint:[strokePath interpolatedLocationAt:0]];
        for (NSUInteger i = 1; i < [strokePath count]; i++) {
            [bezierPath addLineToPoint:[strokePath interpolatedLocationAt:i]];
        }
        return bezierPath;
    } else {
        return [self newPath];
    }
}

#pragma mark Touch Handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (@available(iOS 14.0, *)) { return; }

    UITouch *touch = [touches anyObject];
    if (touch == nil) { return; }

    self.currentPath = [self newPath];
    [self.currentPath moveToPoint:[touch locationInView:self]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (@available(iOS 14.0, *)) { return; }

    UITouch *touch = [touches anyObject];
    if (touch == nil) { return; }
    [self.currentPath addLineToPoint:[touch locationInView:self]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (@available(iOS 14.0, *)) { return; }

    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    self.currentPath = nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (@available(iOS 14.0, *)) { return; }

    self.currentPath = nil;
}

@end
