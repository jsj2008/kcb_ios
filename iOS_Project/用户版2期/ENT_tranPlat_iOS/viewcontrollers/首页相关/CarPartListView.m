//
//  CarPartListView.m
//  ENT_tranPlat_iOS
//
//  Created by 辛鹏贺 on 16/1/25.
//  Copyright © 2016年 ___ENT___. All rights reserved.
//

#import "CarPartListView.h"

static const CGFloat tag = 999;

@interface CarPartListView()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *footerView;

@end

static CGFloat const durition = 0.3f;

@implementation CarPartListView
{
    UIView *_view;
    UIButton *titleBtn;
    
    BOOL _res;
}

+(CarPartListView *)sharePartListView{
    CarPartListView *cv = [[CarPartListView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 75*y_6_plus)];

    return cv;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.backgroundColor = kWhiteColor;
        titleBtn.frame = CGRectMake(0, 0, self.width, self.height);
        [titleBtn setImage:[UIImage imageNamed:@"sj"] forState:UIControlStateNormal];
        titleBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [titleBtn setTitle:@"所有品牌"];
        titleBtn.titleLabel.font = V3_38PX_FONT;
        [titleBtn setTitleColor:kTextGrayColor];
        [titleBtn addActionBlock:^(id weakSender) {
            if (_commplete) {
                _commplete();
            }
        } forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.tableView];
        [self addSubview:titleBtn];
        titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -titleBtn.imageView.width, 0, titleBtn.imageView.width);
        titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, titleBtn.titleLabel.width, 0, -titleBtn.titleLabel.width);
        
        [self addLineWithFrame:CGRectMake(0, self.height-1, self.width, 1) lineColor:kLineGrayColor];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tableView.height = _view.height-self.height;
}

- (UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -300, self.width, 0)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
    tap.delegate = self;
    [_tableView addGestureRecognizer:tap];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = kWhiteColor;
    _tableView.tableFooterView = self.footerView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    return _tableView;
}

- (UIView *)footerView{
    if (_footerView) {
        return _footerView;
    }
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APP_WIDTH, 0)];
    _footerView.backgroundColor = kWhiteColor;
    
    return _footerView;
}

- (void)showInView:(UIView *)view{
    NSAssert(view != nil, @"view can't be nil");
    _view = view;
    for (UIView *subV in view.subviews) {
        if (subV.tag == tag) {
            subV.userInteractionEnabled = NO;
        }
    }
    if (!self.dataSource.count) {
    }else{
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        if (_res) {
            titleBtn.backgroundColor = kWhiteColor;
            [self dismissView:nil];
        }else{
            titleBtn.backgroundColor = [UIColor colorWithHex:0xe0e0e0];
            [UIView animateWithDuration:durition delay:0 usingSpringWithDamping:.7f initialSpringVelocity:1.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.tableView.y = self.height;
                titleBtn.imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }
        _res = !_res;
    }
    
    [self setNeedsLayout];
}

- (void)dismissView{
    [self dismissView:nil];
}

- (void)dismissView:(void(^)())block{
    [UIView animateWithDuration:durition/2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tableView.y = -self.tableView.height;
        titleBtn.backgroundColor = kWhiteColor;
        titleBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
        for (UIView *subV in _view.subviews) {
            if (subV.tag == tag) {
                subV.userInteractionEnabled = YES;
            }
        }
        _res = NO;
    }];
}

- (void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    self.tableView.height = 44*y_5_SCALE*dataSource.count;
    [self.tableView reloadData];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint p = [self convertPoint:point toView:self.tableView];
    BOOL res = [self.tableView pointInside:p withEvent:event];
    if (!res) {
        return [super hitTest:point withEvent:event];
    }
    
    return self.tableView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (indexPath) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row][@"brandName"];
    cell.textLabel.font = V3_36PX_FONT;
    cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissView:^{
        if (_block) {
            _block(self.dataSource[indexPath.row][@"brandId"]);
        }
    }];
}


@end
