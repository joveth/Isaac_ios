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

@interface AboutMeActivity ()
@property (weak, nonatomic) IBOutlet SLKTextView *contentTxt;

@end

@implementation AboutMeActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=[Common colorWithHexString:@"#e0e0e0"];
    self.tableView.tableFooterView=[[UIView alloc] init];
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
    if(indexPath.section==4){
        if([Common isEmptyString:_contentTxt.text]){
            return;
        }else{
            [self sendMsg];
        }
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [_contentTxt resignFirstResponder];
    return YES;
}

-(void)sendMsg{
    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = @"funny_ba@163.com";
    testMsg.toEmail = @"funny_ba@163.com";
    testMsg.bccEmail = @"smtp.163.com";
    testMsg.relayHost = @"";
    
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
}
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    NSLog(@"%@,err:%@",message,error);
}
@end
