//
//  TNMMessageViewController.m
//  APlantApprove
//
//  Created by TNM3 on 11/22/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

#import "DiscussionDetailsViewController.h"
#import "ContentManager.h"
#import "MessageChatRoom.h"
#import "JCDHTTPConnection.h"
#import "WGATE-Swift.h"
#import "MyDbManager.h"
#import "NSString+URLEncode.h"

@interface DiscussionDetailsViewController ()
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;
@property(nonatomic,retain)IBOutlet UIView *headerView;


@end

@implementation DiscussionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = [UIScreen mainScreen].bounds;
    self.dataSource = [[NSMutableArray alloc]init];
    self.myImage      = [UIImage imageNamed:@"arturdev.jpg"];
    self.partnerImage = [UIImage imageNamed:@"arturdev.jpg"];
    
    [self performSelector:@selector(SetDisscutionData) withObject:nil afterDelay:0.5];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self GetDiscussionReply];
    });
    
    self.navigationItem.title = @"Discussion";
//    [self loadMessages];
}
-(void)SetDisscutionData{
//    @property(nonatomic,retain)IBOutlet UILabel *lblUserName;
//    @property(nonatomic,retain)IBOutlet UILabel *lblTile;
//    @property(nonatomic,retain)IBOutlet UILabel *lblDate;
//    @property(nonatomic,retain)IBOutlet UILabel *lblDesc;
//    @property(nonatomic,retain)IBOutlet UIImageView *userImage;
    if ([self.disussionData objectForKey:@"title"]) {
        self.lblTile.text = [self.disussionData objectForKey:@"title"];
    }
    if ([self.disussionData objectForKey:@"user_name"]) {
        self.lblUserName.text = [self.disussionData objectForKey:@"user_name"];
    }
    if ([self.disussionData objectForKey:@"ago"]) {
        self.lblDate.text = [self.disussionData objectForKey:@"ago"];
    }
    if ([[self.disussionData objectForKey:@"replies"] isKindOfClass:[NSNumber class]]) {
       self.lblCount.text = [NSString stringWithFormat:@"%@",[self.disussionData objectForKey:@"replies"]];
    }
    
    if ([self.disussionData objectForKey:@"user_image"]) {
        NSString *urlStr = [self.disussionData objectForKey:@"user_image"];
        NSURL *imageUrl = [NSURL URLWithString:urlStr];
        [self.userImage sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil) {
                self.userImage.image = image;
            }
        }];
    }
    
//    NSLog(@"%@",str.bas)
    if ([self.disussionData objectForKey:@"desc"]) {
        NSString *descStr = [self.disussionData objectForKey:@"desc"];
//        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:descStr options:0];
//        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        
        self.lblDesc.text = descStr;
        [self.lblDesc sizeToFit];
        CGRect frame = self.headerView.frame;
        frame.size.height = self.lblDesc.frame.size.height + 102;
        self.headerView.frame = frame;
    }

    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.tableView.tableHeaderView = self.headerView;
        
    });
}
-(void)ShowProgress
{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [ProgressHUD show];
        
           
           
}
-(void)HideProgress
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
    
     if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
     {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
     }
    [ProgressHUD dismiss];

}
-(void)GetDiscussionReply{
    
    NSMutableDictionary *tempData = [[NSMutableDictionary alloc]init];
   
//    NSLog(@"%@",self.disussionData);
    NSString *discusID = @"0";
    if ([self.disussionData objectForKey:@"discusID"]) {
        discusID = [self.disussionData objectForKey:@"discusID"];
    }
    NSString *requestUrl = [NSString stringWithFormat:@"%@?view=discussion&page=discussion_reply&discussion_id=%@&userID=%@&societyID=%@&count=%@",kMainDomainUrl,discusID,self.LoginUserID,self.SocietyID,@"0"];
//    appDelegate.LoginUserID, appDelegate.SocietyID
    //    NSLog(@"data:%@",data);
    [self ShowProgress];
    
    JCDHTTPConnection *connection = [[JCDHTTPConnection alloc] initWithUrl:requestUrl params:tempData];
    
    //    NSLog(@"Requesting URL...");
    
    [connection executeRequestOnSuccess:
     ^(NSHTTPURLResponse *response, id bodyString) {
         //         NSLog(@"Success: %ld",(long)response.statusCode);
         //         NSLog(@"Body:%@",bodyString);
        [self HideProgress];
         NSDictionary *data = bodyString;
         
         if ([data objectForKey:@"msgcode"] && [[data objectForKey:@"msgcode"] isEqualToString:@"0"]) {
            NSLog(@"data:%@",data);
             if ([data objectForKey:@"reply_list"] && [[data objectForKey:@"reply_list"] isKindOfClass:[NSArray class]]) {
                 if ([[data objectForKey:@"reply_list"] isKindOfClass:[NSArray class]]) {
                     NSArray *resultData = [data objectForKey:@"reply_list"];
                     
//                     NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[data objectForKey:@"reply_list"]];
                     
//                     NSArray *NoticeBoardIDArray = [[MyDbManager sharedClass] Sorting:array sortBool:true SortingKey:@"id"];
                     
                     dispatch_async(dispatch_get_main_queue(), ^(void){
                         [self loadMessages:resultData];
                     });
                 }
                 
             }
             
         }else{
             
         }
         
         
     } failure:^(NSHTTPURLResponse *response, id bodyString, NSError *error) {
                  NSLog(@"Error: %ld",(long)response.statusCode);
                  NSLog(@"error:%@",error.localizedDescription);
         [self HideProgress];
         
     } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                  NSLog(@"Sending data...:");
         
         
     }];
}

- (void)loadMessages:(NSArray*)listOfData
{
        self.dataSource = [[NSMutableArray alloc]init];
    for (NSDictionary *data in listOfData) {
        MessageChatRoom *msg = [[MessageChatRoom alloc] init];
        msg.resultData = data;
        msg.text = [data objectForKey:@"detail"];
        if ([[data objectForKey:@"align"] isEqualToString:@"left"]) {
            msg.fromMe = NO;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self receiveMessage:msg];
            });
            
        }else{
            msg.fromMe = YES;
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self sendMessage:msg];
            });
        }
                
    }
    
    
}


#pragma mark - SOMessaging data source
- (NSMutableArray *)messages
{
    return self.dataSource;
}

- (NSTimeInterval)intervalForMessagesGrouping
{
    // Return 0 for disableing grouping
//    return 2 * 24 * 3600;
    return 0;
}

- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
    MessageChatRoom *message = self.dataSource[index];
    
    // Adjusting content for 3pt. (In this demo the width of bubble's tail is 3pt)
    if (!message.fromMe) {
        cell.contentInsets = UIEdgeInsetsMake(0, 3.0f, 0, 0); //Move content for 3 pt. to right
        cell.textView.textColor = [UIColor blackColor];
    } else {
        cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 3.0f); //Move content for 3 pt. to left
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.userImageView.layer.cornerRadius = self.userImageSize.width/2;
    
    // Fix user image position on top or bottom.
    cell.userImageView.autoresizingMask = message.fromMe ? UIViewAutoresizingFlexibleTopMargin : UIViewAutoresizingFlexibleBottomMargin;
    
    // Setting user images
    cell.userImage = message.fromMe ? self.myImage : self.partnerImage;
    
    [self generateUsernameLabelForCell:cell];
}

- (void)generateUsernameLabelForCell:(SOMessageCell *)cell
{
    static NSInteger labelTag = 666;
    
    MessageChatRoom *message = (MessageChatRoom *)cell.message;
    UILabel *label = (UILabel *)[cell.containerView viewWithTag:labelTag];
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:7];
        label.textColor = [UIColor grayColor];
        label.tag = labelTag;
        [cell.containerView addSubview:label];
    }
    NSString *partner = @"";
    if ([message.resultData objectForKey:@"name"]) {
        partner = [message.resultData objectForKey:@"name"];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message.fromMe ? @"Me" : partner;
    label.numberOfLines = 2;
    [label sizeToFit];
    
    CGRect frame = label.frame;
    
    CGFloat topMargin = 2.0f;
    if (message.fromMe) {
        frame.origin.x = cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width/2 - frame.size.width/2;
        frame.origin.y = cell.containerView.frame.size.height + topMargin;
        
    } else {
        CGFloat tempXPos = (cell.userImageView.frame.size.width/2 - frame.size.width/2);
        CGFloat xPos = 0.0f;
        if (tempXPos > 0) {
            xPos = tempXPos;
        }
        frame.origin.x = cell.userImageView.frame.origin.x + xPos;
        frame.origin.y = cell.userImageView.frame.origin.y + cell.userImageView.frame.size.height + topMargin;
    }
    frame.size.width = cell.userImageView.frame.size.width;
    frame.size.height = 20;
    
    label.frame = frame;
}

- (void)generateDateLabelForCell:(SOMessageCell *)cell
{
    static NSInteger labelTag = 777;
    
    MessageChatRoom *message = (MessageChatRoom *)cell.message;
    UILabel *label = (UILabel *)[cell.containerView viewWithTag:labelTag];
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:8];
        label.textColor = [UIColor grayColor];
        label.tag = labelTag;
        [cell.containerView addSubview:label];
    }
    NSString *partner = @"";
    if ([message.resultData objectForKey:@"name"]) {
        partner = [message.resultData objectForKey:@"name"];
    }
    label.text = message.fromMe ? @"Me" : partner;
    [label sizeToFit];
    
    CGRect frame = label.frame;
    
    CGFloat topMargin = 2.0f;
    if (message.fromMe) {
        frame.origin.x = cell.userImageView.frame.origin.x + cell.userImageView.frame.size.width/2 - frame.size.width/2;
        frame.origin.y = cell.containerView.frame.size.height + topMargin;
        
    } else {
        CGFloat tempXPos = (cell.userImageView.frame.size.width/2 - frame.size.width/2);
        CGFloat xPos = 0.0f;
        if (tempXPos > 0) {
            xPos = tempXPos;
        }
        frame.origin.x = cell.userImageView.frame.origin.x + xPos;
        frame.origin.y = cell.userImageView.frame.origin.y + cell.userImageView.frame.size.height + topMargin;
    }
    label.frame = frame;
}


- (CGFloat)messageMaxWidth
{
    return 140;
}

- (CGSize)userImageSize
{
    return CGSizeMake(40, 40);
}

- (CGFloat)messageMinHeight
{
    return 0;
}

#pragma mark - SOMessaging delegate

- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell
{
    // Show selected media in fullscreen
    [super didSelectMedia:media inMessageCell:cell];
}

- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
    
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    
    MessageChatRoom *msg = [[MessageChatRoom alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    
    [self sendMessage:msg];
    
    [self SendDiscussionMessage:message];
    
//    [self Partner:message];
}

-(void)SendDiscussionMessage:(NSString*)message{
    
    NSMutableDictionary *tempData = [[NSMutableDictionary alloc]init];
    
    
    NSString *discusID = @"0";
    if ([self.disussionData objectForKey:@"discusID"]) {
        discusID = [self.disussionData objectForKey:@"discusID"];
    }
    NSString *tempUrl = [NSString stringWithFormat:@"%@?view=discussion&page=discussion_reply_add&discussion_id=%@&userID=%@&societyID=%@&description=%@",kMainDomainUrl,discusID,self.LoginUserID,self.SocietyID,message];

    NSString *requestUrl = [tempUrl URLEncode];
    NSLog(@"Decode Url:%@",requestUrl);
    
//    NSString *requestUrl = [tempUrl stringByReplacingOccurrencesOfString:@" "
//                                                                    withString:@"%20"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    JCDHTTPConnection *connection = [[JCDHTTPConnection alloc] initWithUrl:requestUrl params:tempData];
  
    //    NSLog(@"Requesting URL...");
    
    [connection executeRequestOnSuccess:
     ^(NSHTTPURLResponse *response, id bodyString) {
         //         NSLog(@"Success: %ld",(long)response.statusCode);
         //         NSLog(@"Body:%@",bodyString);
         [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
         NSDictionary *data = bodyString;
         NSLog(@"data:%@",data);
         if ([data objectForKey:@"msgcode"] && [[data objectForKey:@"msgcode"] isEqualToString:@"0"]) {
//             NSLog(@"data:%@",data);
             
         }else{
             
         }
         
         
     } failure:^(NSHTTPURLResponse *response, id bodyString, NSError *error) {
         NSLog(@"Error: %ld",(long)response.statusCode);
         NSLog(@"error:%@",error.localizedDescription);
         [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
         
     } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
         NSLog(@"Sending data...:");
         
         
     }];
}


-(void)Partner:(NSString*)message{
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    
    MessageChatRoom *msg = [[MessageChatRoom alloc] init];
    msg.text = @"send partner";
    msg.fromMe = NO;
    
    [self sendMessage:msg];
    
    msg.text = @"reiceive partner";
    [self receiveMessage:msg];
    
}
- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
    // Take a photo/video or choose from gallery
}

#pragma mark - PubNub client
-(AppDelegate*)appDelegate
{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
