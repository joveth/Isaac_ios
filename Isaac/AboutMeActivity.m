//
//  AboutMeActivity.m
//  Isaac
//
//  Created by jov jov on 7/28/15.
//  Copyright (c) 2015 Shuwei. All rights reserved.
//

#import "AboutMeActivity.h"
#import "Common.h"
#import "SKPSMTPMessage.h"
#import "SVProgressHUD.h"

@interface AboutMeActivity ()
@property (weak, nonatomic) IBOutlet SLKTextView *contentTxt;

@end

@implementation AboutMeActivity{
    BOOL sended;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=[Common colorWithHexString:@"#e0e0e0"];
    self.tableView.tableFooterView=[[UIView alloc] init];
    self.contentTxt.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//secltion head
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *myHeader = [[UIView alloc] init];
    UILabel *myLabel = [[UILabel alloc] init];
    [myLabel setFrame:CGRectMake(8, 5, 200, 20)];
    [myLabel setTag:101];
    [myLabel setAlpha:0.5];
    [myLabel setFont: [UIFont fontWithName:@"Arial" size:14]];
    [myLabel setBackgroundColor:[UIColor clearColor]];
    [myHeader setBackgroundColor:[Common colorWithHexString:@"#e0e0e0"]];
    
    switch (section) {
        case 1:
            [myLabel setText:[NSString stringWithFormat:@"软件声明"]];
            break;
        case 2:
            [myLabel setText:[NSString stringWithFormat:@"作者的话"]];
            break;
        case 3:
            [myLabel setText:[NSString stringWithFormat:@"给我留言"]];
            break;
        default:
            [myLabel setText:[NSString stringWithFormat:@" "]];
            break;
    }
    [myHeader addSubview:myLabel];
    return myHeader;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    if(indexPath.section==4){
        if([Common isEmptyString:_contentTxt.text]){
            return;
        }else{
            [_contentTxt resignFirstResponder];
            [SVProgressHUD showWithStatus:@"正在发送" maskType:SVProgressHUDMaskTypeBlack];
            [self sendMsg];
        }
    }
}


-(void)sendMsg{
    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = @"funny_ba@163.com";
    testMsg.toEmail = @"funny_ba@163.com";
    testMsg.bccEmail = @"funny_ba@163.com";
    testMsg.relayHost = @"smtp.163.com";
    
    testMsg.requiresAuth = YES;
    
    if (testMsg.requiresAuth) {
        testMsg.login = @"funny_ba@163.com";
        testMsg.pass = @"funny_ba@163";
    }
    testMsg.wantsSecure = YES;
    
    testMsg.subject = @"IOS ISaac Mail ";
    //testMsg.bccEmail = @"testbcc@test.com";
    
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
    testMsg.delegate = self;
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               [NSString stringWithCString:[_contentTxt.text UTF8String] encoding:NSUTF8StringEncoding],kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    testMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
    
    [testMsg send];
}
-(void)messageSent:(SKPSMTPMessage *)message{
    NSLog(@"%@",message);
    sended=YES;
    [SVProgressHUD showSuccessWithStatus:@"谢谢你给我留言!" ];
    
}
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    NSLog(@"%@,err:%@",message,error);
    [SVProgressHUD showErrorWithStatus:@"发送失败了!"];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if([Common isEmptyString:_contentTxt.text]){
            return YES;
        }else{
            [_contentTxt resignFirstResponder];
            [SVProgressHUD showWithStatus:@"正在发送" maskType:SVProgressHUDMaskTypeBlack ];
            [self sendMsg];
        }
        return NO;
    }
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - Notification Methods Sample

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillDisappearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
}

- (void)handleNotification:(NSNotification *)notif
{
    NSLog(@"Notification recieved: %@", notif.name);
    NSLog(@"Status user info key: %@", [notif.userInfo objectForKey:SVProgressHUDStatusUserInfoKey]);
}

@end
