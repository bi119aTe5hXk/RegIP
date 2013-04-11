//
//  AppDelegate.m
//  RegIP
//
//  Created by bi119aTe5hXk on 12-7-29.
//  Copyright (c) 2012年 bi119aTe5hXk. All rights reserved.
//

#define autologtime 600.0

#import "AppDelegate.h"
#import <CFNetwork/CFNetwork.h>
#import "CHKeychain.h"

@implementation AppDelegate
@synthesize window;
@synthesize password,domainname,hostname,info,namecheapbtn;
@synthesize ohostname,opassword,ousername,orayloginbtn;

NSString * const KEY_OUSERPASSHOST = @"com.RegIP.ouserpasshost";
NSString * const KEY_OUSERNAME = @"com.RegIP.ousername";
NSString * const KEY_OPASSWORD = @"com.RegIP.opassword";
NSString * const KEY_OHOSTNAME = @"com.RegIP.ohostname";
NSString * const KEY_NDOMAINPASSHOST = @"com.RegIP.ndomainpasshost";
NSString * const KEY_NDOMAINNAME = @"com.RegIP.ndomainname";
NSString * const KEY_NPASSWORD = @"com.RegIP.npassword";
NSString * const KEY_NHOSTNAME = @"com.RegIP.nhostname";

NSString * const ORAY_SERVER_URL = @"http://%@:%@@ddns.oray.com/ph/update?hostname=%@";
NSString * const NAMECHEAP_SERVER_URL = @"https://dynamicdns.park-your-domain.com/update?host=%@&domain=%@&password=%@";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    logstring = [[NSString alloc] init];
    
    //init keychain
    NSMutableDictionary *ousernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_OUSERPASSHOST];
    if (ousernamepasswordKVPairs != nil) {
        [ousername setStringValue:[ousernamepasswordKVPairs objectForKey:KEY_OUSERNAME]];
        [opassword setStringValue:[ousernamepasswordKVPairs objectForKey:KEY_OPASSWORD]];
        [ohostname setStringValue:[ousernamepasswordKVPairs objectForKey:KEY_OHOSTNAME]];
    }
    NSMutableDictionary *nusernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_NDOMAINPASSHOST];
    if (nusernamepasswordKVPairs != nil) {
        [ndomainname setStringValue:[nusernamepasswordKVPairs objectForKey:KEY_NDOMAINNAME]];
        [npassword setStringValue:[nusernamepasswordKVPairs objectForKey:KEY_NPASSWORD]];
        [nhostname setStringValue:[nusernamepasswordKVPairs objectForKey:KEY_NHOSTNAME]];
    }
    
    //load user defaults for autolog
    userdefaults = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"namecheapautolog",nil]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"orayautolog",nil]];
    namecheapautolog = [userdefaults boolForKey:@"namecheapautolog"];
    if (namecheapautolog == NO) {
        [autologtonc setState:NSOffState];
        [self autologtonamecheap:nil];
    }else{
        [autologtonc setState:NSOnState];
        [self autologtonamecheap:nil];
    }
    orayautolog = [userdefaults boolForKey:@"orayautolog"];
    if (orayautolog == NO) {
        [self autologtooray:nil];
        [autologtooray setState:NSOffState];
    }else{
        [self autologtooray:nil];
        [autologtooray setState:NSOnState];
    }
    
    [self logwithstr:@"Load memory compete, please fill your info and press button."];
}

#pragma mark - regip part -
-(IBAction)namecheaploginbtnpressed:(id)sender{
    if ([nhostname stringValue].length != 0 && [npassword stringValue].length != 0 && [ndomainname stringValue].length != 0) {
        NSMutableDictionary *nusernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [nusernamepasswordKVPairs setObject:[ndomainname stringValue] forKey:KEY_NDOMAINNAME];
        [nusernamepasswordKVPairs setObject:[npassword stringValue] forKey:KEY_NPASSWORD];
        [nusernamepasswordKVPairs setObject:[nhostname stringValue] forKey:KEY_NHOSTNAME];
        [CHKeychain save:KEY_NDOMAINPASSHOST data:nusernamepasswordKVPairs];
        
        NSString *url = [NSString stringWithFormat:NAMECHEAP_SERVER_URL,[nhostname stringValue],[ndomainname stringValue],[npassword stringValue]];
        NSURLRequest *nurlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLResponse *nresponse;
        NSError *error;
        NSData *nurlData;
        nurlData = [NSURLConnection sendSynchronousRequest:nurlRequest returningResponse:&nresponse error:&error];
        NSString *ndata = [[NSString alloc]initWithData:nurlData encoding:NSUTF8StringEncoding];
        [self logwithstr:ndata];
        [self logwithstr:[NSString stringWithFormat:@"Reged to NameCheap in %@",[NSCalendarDate date]]];
    }else{
        NSRunAlertPanel(@"!WARNING!", @"Please fill your NameCheap account info!",nil,nil,nil);
    }
    
}
-(IBAction)orayloginbtnpressed:(id)sender{
    if ([ousername stringValue].length != 0 && [opassword stringValue].length != 0 && [ohostname stringValue].length != 0) {
        NSMutableDictionary *ousernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [ousernamepasswordKVPairs setObject:[ousername stringValue] forKey:KEY_OUSERNAME];
        [ousernamepasswordKVPairs setObject:[opassword stringValue] forKey:KEY_OPASSWORD];
        [ousernamepasswordKVPairs setObject:[ohostname stringValue] forKey:KEY_OHOSTNAME];
        [CHKeychain save:KEY_OUSERPASSHOST data:ousernamepasswordKVPairs];
        
        NSString *url2 = [NSString stringWithFormat:ORAY_SERVER_URL,[ousername stringValue],[opassword stringValue],[ohostname stringValue]];
        NSURLRequest *ourlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url2]];
        NSURLResponse *response;
        NSError *error;
        NSData *ourlData;
        ourlData = [NSURLConnection sendSynchronousRequest:ourlRequest returningResponse:&response error:&error];
        NSString *odata = [[NSString alloc]initWithData:ourlData encoding:NSUTF8StringEncoding];
        [self logwithstr:odata];
        [self logwithstr:[NSString stringWithFormat:@"Reged to Oray in %@",[NSCalendarDate date]]];
    }else{
        NSRunAlertPanel(@"!WARNING!", @"Please fill your Oary account info!",nil,nil,nil);
    }
    
    
}

#pragma mark - autolog part -
-(IBAction)autologtonamecheappress:(id)sender{
    if (namecheapautolog == NO) {
        namecheapautolog = YES;
        [autologtonc setState:NSOnState];
        [userdefaults setBool:YES forKey:@"namecheapautolog"];
        [self autologtonamecheap:nil];
    }else{
        namecheapautolog = NO;
        [autologtonc setState:NSOffState];
        [userdefaults setBool:NO forKey:@"namecheapautolog"];
        [self autologtonamecheap:nil];
    }
}
-(IBAction)autologtooraypress:(id)sender{
    if (orayautolog == NO) {
        orayautolog = YES;
        [self autologtooray:nil];
        [autologtooray setState:NSOnState];
        [userdefaults setBool:YES forKey:@"orayautolog"];
    }else{
        orayautolog = NO;
        [self autologtooray:nil];
        [autologtooray setState:NSOffState];
        [userdefaults setBool:NO forKey:@"orayautolog"];
    }
}
-(void)autologtonamecheap:(NSTimer *)timer{
    if (namecheapautolog == YES) {
        timer = [NSTimer scheduledTimerWithTimeInterval:autologtime target:self selector:@selector(namecheaploginbtnpressed:) userInfo:nil repeats:YES];
        }else{
        [timer invalidate];
    }
}
-(void)autologtooray:(NSTimer *)timer{
    if (orayautolog == YES) {
        timer = [NSTimer scheduledTimerWithTimeInterval:autologtime target:self selector:@selector(orayloginbtnpressed:) userInfo:nil repeats:YES];
    }else{
        [timer invalidate];
    }
}

#pragma mark - other part -
-(IBAction)cleandata:(id)sender{
    [CHKeychain delete:KEY_NDOMAINPASSHOST];
    [CHKeychain delete:KEY_OUSERPASSHOST];
    [self logwithstr:@"All memory data deleted."];
}
-(void)logwithstr:(NSString *)str{
    logstring = [logstring stringByAppendingFormat:@"\n%@",str];
    self.info.string = logstring;
    str = nil;
}
-(IBAction)website:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://blog.bi119ate5hxk.net"]];
}
@end
