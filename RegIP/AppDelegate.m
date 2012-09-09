//
//  AppDelegate.m
//  RegIP
//
//  Created by bi119aTe5hXk on 12-7-29.
//  Copyright (c) 2012年 bi119aTe5hXk. All rights reserved.
//

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

- (void)dealloc
{
    [super dealloc];
    [password release];
    [domainname release];
    [hostname release];
    [info release];
    [orayloginbtn release];
    [opassword release];
    [ousername release];
    [namecheapbtn release];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [info setStringValue:@"Fill info and press button~"];
    oremember = YES;
    nremember = YES;
    NSMutableDictionary *ousernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_OUSERPASSHOST];
    [ousername setStringValue:[ousernamepasswordKVPairs objectForKey:KEY_OUSERNAME]];
    [opassword setStringValue:[ousernamepasswordKVPairs objectForKey:KEY_OPASSWORD]];
    [ohostname setStringValue:[ousernamepasswordKVPairs objectForKey:KEY_OHOSTNAME]];
    
    NSMutableDictionary *nusernamepasswordKVPairs = (NSMutableDictionary *)[CHKeychain load:KEY_NDOMAINPASSHOST];
    [domainname setStringValue:[nusernamepasswordKVPairs objectForKey:KEY_NDOMAINNAME]];
    [password setStringValue:[nusernamepasswordKVPairs objectForKey:KEY_NPASSWORD]];
    [hostname setStringValue:[nusernamepasswordKVPairs objectForKey:KEY_NHOSTNAME]];
    
    
    
}

-(IBAction)namecheaploginbtnpressed:(id)sender{
    NSError *error;
    
    if (nremember) {
		NSMutableDictionary *nusernamepasswordKVPairs = [NSMutableDictionary dictionary];
		[nusernamepasswordKVPairs setObject:[domainname stringValue] forKey:KEY_NDOMAINNAME];
		[nusernamepasswordKVPairs setObject:[password stringValue] forKey:KEY_NPASSWORD];
        [nusernamepasswordKVPairs setObject:[hostname stringValue] forKey:KEY_NHOSTNAME];
		[CHKeychain save:KEY_NDOMAINPASSHOST data:nusernamepasswordKVPairs];
	}else {
		[CHKeychain delete:KEY_NDOMAINPASSHOST];
	}
    
    
    NSString *url = [NSString stringWithFormat:@"https://dynamicdns.park-your-domain.com/update?host=%@&domain=%@&password=%@",[hostname stringValue],[domainname stringValue],[password stringValue]];
    NSLog(@"%@",url);
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSLog(@"request:%@",urlRequest);
    
    NSURLResponse *response;
    
    NSData *urlData;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    //servers response
    NSString *data = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"responsedata:%@",data);
    //NSLog(@"error:%@",error);
    [info setStringValue:data];
    
}
-(IBAction)orayloginbtnpressed:(id)sender{
    NSError *error;
    
    if (oremember) {
		NSMutableDictionary *ousernamepasswordKVPairs = [NSMutableDictionary dictionary];
		[ousernamepasswordKVPairs setObject:[ousername stringValue] forKey:KEY_OUSERNAME];
		[ousernamepasswordKVPairs setObject:[opassword stringValue] forKey:KEY_OPASSWORD];
        [ousernamepasswordKVPairs setObject:[ohostname stringValue] forKey:KEY_OHOSTNAME];
		[CHKeychain save:KEY_OUSERPASSHOST data:ousernamepasswordKVPairs];
	}else {
		[CHKeychain delete:KEY_OUSERPASSHOST];
	}
    
    NSString *url2 = [NSString stringWithFormat:@"http://%@:%@@ddns.oray.com/ph/update?hostname=%@",[ousername stringValue],[opassword stringValue],[ohostname stringValue]];
    NSLog(@"%@",url2);
    
    NSURLRequest *ourlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url2]];
    
    NSLog(@"request:%@",ourlRequest);
    
    NSURLResponse *response;
    
    NSData *ourlData;
    ourlData = [NSURLConnection sendSynchronousRequest:ourlRequest returningResponse:&response error:&error];
    //servers response
    NSString *odata = [[NSString alloc]initWithData:ourlData encoding:NSUTF8StringEncoding];
    NSLog(@"responsedata:%@",odata);
    //NSLog(@"error:%@",error);
    [info setStringValue:odata];
    
}
-(IBAction)website:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://billgateshxk.blog127.fc2.com"]];
}
@end
