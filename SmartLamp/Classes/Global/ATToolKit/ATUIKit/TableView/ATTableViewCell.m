//
//  ATTableViewCell.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATTableViewCell.h"
#import "MDRippleLayer.h"


@interface ATTableViewCell ()

// layer
@property (strong, nonatomic) MDRippleLayer *mdLayer;



@end

@implementation ATTableViewCell


- (void)awakeFromNib {
    
    // Initialization code
    [self initUI];
    [super awakeFromNib];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}


// init UI
- (void)initUI{
    [self initLayer];
    
}

- (void)initLayer {
    if (!_rippleColor)
        _rippleColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    _mdLayer = [[MDRippleLayer alloc] initWithSuperLayer:self.layer];
    _mdLayer.effectColor = _rippleColor;
    _mdLayer.rippleScaleRatio = 1;
    _mdLayer.enableElevation = NO;
    _mdLayer.effectSpeed = 300;
}

- (void)setRippleColor:(UIColor *)rippleColor {
    _rippleColor = rippleColor;
    [_mdLayer setEffectColor:rippleColor];
}


#pragma mark - private methods

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self updateImageViewFrame];
}

- (void)updateImageViewFrame{
    
    self.accessoryImageV.widthAndHeightEqual(18);
    self.accessoryImageV.centerY = self.height * 0.5;
    self.accessoryImageV.right = self.right - 2*sMargin;
    
    [self.accessoryImageV at_animatedScaleIn:2.5 duration:0.6f completion:nil];
}

- (UIImageView *)accessoryImageV{
    if (!_accessoryImageV) {
        // create it
        _accessoryImageV = [[UIImageView alloc] init];
        [self addSubview:_accessoryImageV];
        [self updateImageViewFrame];
        
    }
    
    return _accessoryImageV;
}

#pragma mark touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [touches.allObjects[0] locationInView:self];
    [_mdLayer startEffectsAtLocation:point];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [_mdLayer stopEffectsImmediately];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [_mdLayer stopEffects];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [_mdLayer stopEffects];
}



@end
