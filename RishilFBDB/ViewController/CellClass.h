//
//  CellClass.h
//  RishilFBDB
//
//  Created by Rishil-iMac on 23/11/18.
//  Copyright © 2018 Rishil Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellClass : UITableViewCell
@property(retain,nonatomic)IBOutlet UIButton* btnDelete;
@property(retain,nonatomic)IBOutlet UIButton* btnUpdate;
@property(retain,nonatomic)IBOutlet UILabel* lblName;
@end

NS_ASSUME_NONNULL_END
