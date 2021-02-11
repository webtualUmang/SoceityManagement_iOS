//
//  TNMMessageViewController.m
//  APlantApprove
//
//  Created by TNM3 on 11/22/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

#import "ComplainDetailsViewController.h"
#import "ContentManager.h"
#import "MessageChatRoom.h"
#import "JCDHTTPConnection.h"
#import "WGATE-Swift.h"
#import "NSString+URLEncode.h"

@interface ComplainDetailsViewController ()
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;
@property(nonatomic,retain)IBOutlet UIView *headerView;
@property(nonatomic,retain)IBOutlet UILabel *lblAddedBy;
@end

@implementation ComplainDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = [UIScreen mainScreen].bounds;
    self.dataSource = [[NSMutableArray alloc]init];
    self.myImage      = [UIImage imageNamed:@"arturdev.jpg"];
    self.partnerImage = [UIImage imageNamed:@"arturdev.jpg"];
    
    [self performSelector:@selector(SetDisscutionData) withObject:nil afterDelay:0.1];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        [self GetComplainReply];
    });
    
    self.navigationItem.title = @"Complains";
//    [self loadMessages];
}
-(void)SetDisscutionData{
   
    NSLog(@"Result : %@",self.disussionData);
    
    if ([self.disussionData objectForKey:@"type"]) {
        self.lblType.text = [self.disussionData objectForKey:@"type"];
    }
    if ([self.disussionData objectForKey:@"time"]) {
        self.lblTime.text = [self.disussionData objectForKey:@"time"];
    }
    if ([self.disussionData objectForKey:@"title"]) {
        self.lblTitle.text = [self.disussionData objectForKey:@"title"];
    }
    if ([self.disussionData objectForKey:@"category"]) {
        self.lblCatagory.text = [self.disussionData objectForKey:@"category"];
    }
    if ([self.disussionData objectForKey:@"name"]) {
        self.lblAddedBy.text = [self.disussionData objectForKey:@"name"];
    }
    if ([self.disussionData objectForKey:@"status"]) {
        self.lblStatus.text = [self.disussionData objectForKey:@"status"];
    }
    if ([self.disussionData objectForKey:@"supervised_by_name"]) {
        self.lblSuperwise.text = [self.disussionData objectForKey:@"supervised_by_name"];
    }
    if ([self.disussionData objectForKey:@"servised_by_name"]) {
        self.lblClosedBy.text = [self.disussionData objectForKey:@"servised_by_name"];
    }
    
    if ([self.disussionData objectForKey:@"image"]) {
        
        NSURL *url = [[NSURL alloc] initWithString:[self.disussionData objectForKey:@"image"]];
        [self.imagesview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_gray_image"]];
    }
    
//    NSLog(@"%@",str.bas)
    if ([self.disussionData objectForKey:@"descrption"]) {
        NSString *descStr = [self.disussionData objectForKey:@"descrption"];
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:descStr options:0];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        
        self.lblDesc.text = decodedString;
        [self.lblDesc sizeToFit];
        CGRect frame = self.headerView.frame;
        frame.size.height = self.lblDesc.frame.size.height + 485;
        self.headerView.frame = frame;
    }

    dispatch_async(dispatch_get_main_queue(), ^(void){
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.backgroundColor = UIColor.clearColor;
        
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
-(void)GetComplainReply{
    
    NSMutableDictionary *tempData = [[NSMutableDictionary alloc]init];
   
    NSString *discusID = @"0";
    if ([self.disussionData objectForKey:@"complaintID"]) {
        discusID = [self.disussionData objectForKey:@"complaintID"];
    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?view=helpdesk&page=complainupdate&complaintID=%@&userID=%@&societyID=%@&count=%@",kMainDomainUrl,discusID,_LoginUserID,_SocietyID,@"0"];
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
//            NSLog(@"data:%@",data);
             if ([data objectForKey:@"updates_list"] && [[data objectForKey:@"updates_list"] isKindOfClass:[NSArray class]]) {
                 NSArray *array = [[NSArray alloc]initWithArray:[data objectForKey:@"updates_list"]];
                 dispatch_async(dispatch_get_main_queue(), ^(void){
                     [self loadMessages:array];
                 });
                 
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
        msg.text = [data objectForKey:@"note"];
        if ([[data objectForKey:@"type"] isEqualToString:@"left"]) {
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
//    [self.tableView reloadData];
//    self.dataSource = [[[ContentManager sharedManager] generateConversation] mutableCopy];
    
    
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
    UIImageView *tempImage = [[UIImageView alloc]init];
    if ([cell.message.resultData objectForKey:@"user_image"]) {
        NSString *urlStr = [cell.message.resultData objectForKey:@"user_image"];
        NSURL *imageUrl = [NSURL URLWithString:urlStr];
        
        [tempImage sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil) {
                cell.userImage = image;
            }
        }];
    }
    
    
    [self generateUsernameLabelForCell:cell];
}

- (void)generateUsernameLabelForCell:(SOMessageCell *)cell
{
    static NSInteger labelTag = 666;
    
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
    if ([message.resultData objectForKey:@"update_by"]) {
        partner = [message.resultData objectForKey:@"update_by"];
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
    if ([message.resultData objectForKey:@"added_on"]) {
        partner = [message.resultData objectForKey:@"added_on"];
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
-(void)TNMErrorMessage
{
    UIAlertController * alertvc = [UIAlertController alertControllerWithTitle: @""
                                   message:@"Complaint is closed" preferredStyle: UIAlertControllerStyleAlert
                                  ];
    UIAlertAction * action = [UIAlertAction actionWithTitle: @ "OK"
                              style: UIAlertActionStyleDefault handler: ^ (UIAlertAction * _Nonnull action) {
                                NSLog(@ "Dismiss Tapped");
                              }
                             ];
    [alertvc addAction: action];
    [self presentViewController: alertvc animated: true completion: nil];
}
    
- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
    if ([self.isCloseCompalint isEqualToString:@"true"]) {
       // [[self appDelegate] TNMErrorMessage:@"" message:@"Complaint is closed"];
        [self TNMErrorMessage];
    }else{
        if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
            return;
        }
        
        MessageChatRoom *msg = [[MessageChatRoom alloc] init];
        msg.text = message;
        msg.fromMe = YES;
        
        [self sendMessage:msg];
        
        [self SendDiscussionMessage:message];
    }
   
    
//    [self Partner:message];
}

-(void)SendDiscussionMessage:(NSString*)message{
    
    NSMutableDictionary *tempData = [[NSMutableDictionary alloc]init];
    
    NSString *discusID = @"0";
    if ([self.disussionData objectForKey:@"complaintID"]) {
        discusID = [self.disussionData objectForKey:@"complaintID"];
    }
    NSString *tempUrl = [NSString stringWithFormat:@"%@?view=helpdesk&page=complainupdate_add&complaintID=%@&userID=%@&societyID=%@&note=%@&file_name=",kMainDomainUrl,discusID,_LoginUserID,_SocietyID,message];
    
    NSString *requestUrl = [tempUrl URLEncode];
    
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
