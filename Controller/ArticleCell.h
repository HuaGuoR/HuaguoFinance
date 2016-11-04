//
//  ArticleCell.h
//  fanwe_p2p
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleCell : UITableViewCell{
    
    IBOutlet UILabel *_titleLabel;
}

-(void)setCellContent:(Article *)article;

@end
