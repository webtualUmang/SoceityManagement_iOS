//
//  TNMMessageViewController.h
//  APlantApprove
//
//  Created by TNM3 on 11/22/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOMessagingViewController.h"

@interface DiscussionDetailsViewController : SOMessagingViewController
@property(nonatomic,retain)NSDictionary *disussionData;
@property(nonatomic,retain)IBOutlet UILabel *lblUserName;
@property(nonatomic,retain)IBOutlet UILabel *lblTile;
@property(nonatomic,retain)IBOutlet UILabel *lblDate;
@property(nonatomic,retain)IBOutlet UILabel *lblDesc;
@property(nonatomic,retain)IBOutlet UIImageView *userImage;
@property(nonatomic,retain)IBOutlet UILabel *lblCount;
@property(nonatomic,retain)NSString *LoginUserID;
@property(nonatomic,retain)NSString *SocietyID;

@end
