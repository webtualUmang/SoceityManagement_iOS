//
//  TNMMessageViewController.h
//  APlantApprove
//
//  Created by TNM3 on 11/22/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOMessagingViewController.h"

@interface ComplainDetailsViewController : SOMessagingViewController
@property(nonatomic,retain)NSDictionary *disussionData;

@property(nonatomic,retain)IBOutlet UILabel *lblType;
@property(nonatomic,retain)IBOutlet UILabel *lblTime;
@property(nonatomic,retain)IBOutlet UILabel *lblTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblDesc;
@property(nonatomic,retain)IBOutlet UILabel *lblCatagory;
@property(nonatomic,retain)IBOutlet UILabel *lblStatus;
@property(nonatomic,retain)IBOutlet UILabel *lblSuperwise;
@property(nonatomic,retain)IBOutlet UILabel *lblClosedBy;
@property(nonatomic,retain)IBOutlet UIImageView *imagesview;

@property(nonatomic,retain)NSString *isCloseCompalint;
@property(nonatomic,retain)NSString *LoginUserID;
@property(nonatomic,retain)NSString *SocietyID;

@end
