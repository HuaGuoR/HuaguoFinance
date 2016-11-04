//
//  MyLogCell.m
//  fanwe_p2p
//
//  Created by GuoMs on 14-8-12.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "MyLogCell.h"
#import "LogList.h"

#define kTop 15
#define kRight 10
#define kinfoW 240
#define kinfoFont [UIFont systemFontOfSize:15]
#define kotherFont [UIFont systemFontOfSize:14]
#define kpadding 5
#define kfonColor [UIColor grayColor]

@interface MyLogCell()
{
    UILabel *_info;
    UILabel *_time;
    UILabel *_money;
    UILabel *_moneyword;
    UIImageView *_splite;
    UILabel *_lockMoney;
    UILabel *_lockMoneyWord;
    UIImageView *_bottomImage;
}

@end

@implementation MyLogCell

- (void)awakeFromNib
{
    // Initialization code
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self addAllSubViews];
    }
    return  self;
}

#pragma mark 添加评论本身子控件
- (void)addAllSubViews
{
    _info = [[UILabel alloc]init];
    _info.numberOfLines = 0;
    _info.font = kinfoFont;
    [self.contentView addSubview:_info];
    
    _time = [[UILabel alloc]init];
    _time.font = kotherFont;
    _time.textColor = kfonColor;
    [self.contentView addSubview:_time];
    
    _money = [[UILabel alloc]init];
    _money.font = kotherFont;
    [self.contentView addSubview:_money];
    
    _moneyword = [[UILabel alloc]init];
    _moneyword.font = kotherFont;
    _moneyword.textColor = kfonColor;
    [self.contentView addSubview:_moneyword];
    
    _splite = [[UIImageView alloc]init];
    _splite.image = [UIImage imageNamed:@"table_cell_splite"];
    [self.contentView addSubview:_splite];
    
    _lockMoney = [[UILabel alloc]init];
    _lockMoney.font = kotherFont;
    [self.contentView addSubview:_lockMoney];
    
    _lockMoneyWord = [[UILabel alloc]init];
    _lockMoneyWord.font = kotherFont;
    _lockMoneyWord.textColor = kfonColor;
    [self.contentView addSubview:_lockMoneyWord];
    
    _bottomImage = [[UIImageView alloc]init];
    _bottomImage.image = [UIImage imageNamed:@"table_line"];
    [self.contentView addSubview:_bottomImage];
}

#pragma mark 设置控件位置
- (void)setcellFrame:(LogList*)list
{
    
    CGFloat infoX = kRight;
    CGFloat infoY = kTop;
    CGSize info = [list.loginfo sizeWithFont:kinfoFont constrainedToSize:CGSizeMake([list.logtime sizeWithFont:kotherFont].width, MAXFLOAT)];
    _info.frame = (CGRect){{infoX,infoY},info};
    _info.text = list.loginfo;
    
    CGFloat timeX = kRight;
    CGFloat timeY = infoY + info.height + 2*kpadding;
    CGSize  timeSize = [list.logtime sizeWithFont:kotherFont];
    _time.frame = (CGRect){{timeX,timeY},timeSize};
    _time.text = list.logtime;
    
    CGFloat spliteX = timeX + timeSize.width + 18*kpadding;
    CGFloat spliteY = kTop;
    CGSize spliteSize = [UIImage imageNamed:@"table_cell_splite"].size;
    _splite.frame = (CGRect){{spliteX,spliteY},spliteSize};
    
    CGSize moneySize = [list.logmoney sizeWithFont:kotherFont];
    CGFloat infoheight = [@"编号" sizeWithFont:kinfoFont].height;
    CGFloat momeyY = infoheight == info.height ? infoY + 5 : infoheight - kpadding + 5;
    CGFloat moneyX = spliteX - 2*kpadding - moneySize.width;
    _money.frame =(CGRect){{moneyX,momeyY},moneySize};
    _money.text = list.logmoney;
    
    
    
    CGSize moneyWordSize = [@"金额" sizeWithFont:kotherFont];
    CGFloat moneyWordX = moneyX + (moneySize.width - moneyWordSize.width);
    CGFloat moneyWOrdY = momeyY + moneySize.height + kpadding;
    _moneyword.frame = (CGRect){{moneyWordX,moneyWOrdY},moneyWordSize};
    _moneyword.text = @"金额";
    
    CGFloat lockmomeyY = momeyY;
    CGFloat lockmoneyX = spliteX + spliteSize.width + 2*kpadding;
    CGSize lockmoneySize = [list.loglockMoney sizeWithFont:kotherFont];
    _lockMoney.frame =(CGRect){{lockmoneyX,lockmomeyY},lockmoneySize};
    _lockMoney.text = list.loglockMoney;
    
    CGFloat lockmoneyWordX = lockmoneyX;
    CGFloat lockmoneyWOrdY = lockmomeyY +lockmoneySize.height+ kpadding;
    CGSize lockmoneyWordSize = [@"冻结/提现" sizeWithFont:kotherFont];
    _lockMoneyWord.frame = (CGRect){{lockmoneyWordX,lockmoneyWOrdY},lockmoneyWordSize};
    _lockMoneyWord.text = @"冻结/提现";
    
    CGFloat bottomX = 0;
    CGFloat bottomY = timeY + timeSize.height + kTop;
    CGSize bottomSize = [UIImage imageNamed:@"table_line"].size;
    _bottomImage.frame = (CGRect){{bottomX,bottomY},bottomSize};
    
    self.cllHeigh = bottomY+bottomSize.height;
}


@end
