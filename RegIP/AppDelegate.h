//
//  AppDelegate.h
//  RegIP
//
//  Created by bi119aTe5hXk on 12-7-29.
//  Copyright (c) 2014年 bi119aTe5hXk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
@interface AppDelegate : NSObject <NSApplicationDelegate,NSTableViewDelegate,NSTableViewDataSource,ASIHTTPRequestDelegate,NSTextFieldDelegate>{
    NSUserDefaults *userdefaults;
    
    BOOL logviewOpen;
    BOOL autoUpdate;
    NSInteger autoUpdateTime;
    
    NSString *ipAddr;
    NSString *oldIPAddr;
    NSString *logstr;
    NSMutableArray *servicelist;
    NSArray *CLlist;
    NSArray *JSLlist;
    NSTimer *timer;
    
    IBOutlet NSWindow *addservicewindow;
    IBOutlet NSWindow *addcloudflarewindow;
    IBOutlet NSWindow *addjisulewindow;
    IBOutlet NSDrawer *leftDrawer;
    
}
@property (nonatomic, strong) NSOperationQueue *queue;
@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet NSMenuItem *showlogitem;
-(IBAction)website:(id)sender;

//Main window
@property (nonatomic, strong) IBOutlet NSTextField *ipAddress;
@property (nonatomic, strong) IBOutlet NSTableView *tableview;
@property (nonatomic, strong) IBOutlet NSButton *autoUpdateSwitch;
@property (nonatomic, strong) IBOutlet NSTextField *autoUpdateField;

@property (nonatomic, strong) IBOutlet NSTextView *logtextview;
-(IBAction)refreship:(id)sender;
-(IBAction)autoUpdateSWchanged:(id)sender;
- (IBAction)toggleLeftDrawer:(id)sender;
-(IBAction)cleanlog:(id)sender;
-(IBAction)addbtnpressed:(id)sender;
-(IBAction)removebtnpressed:(id)sender;
-(IBAction)updateSelect:(id)sender;
-(IBAction)manualbtnpressed:(id)sender;


//Add window
@property (nonatomic, strong) IBOutlet NSTextField *ORAY_TITLE;
@property (nonatomic, strong) IBOutlet NSTextField *ORAY_USERNAME;
@property (nonatomic, strong) IBOutlet NSTextField *ORAY_PASSWORD;
@property (nonatomic, strong) IBOutlet NSTextField *ORAY_HOSTS;
-(IBAction)addOrayAccount:(id)sender;

@property (nonatomic, strong) IBOutlet NSTextField *NAMECHEAP_TITLE;
@property (nonatomic, strong) IBOutlet NSTextField *NAMECHEAP_DOMAIN;
@property (nonatomic, strong) IBOutlet NSTextField *NAMECHEAP_APIKEY;
@property (nonatomic, strong) IBOutlet NSTextField *NAMECHEAP_HOSTS;
-(IBAction)addNameCheapAccount:(id)sender;

@property (nonatomic, strong) IBOutlet NSTextField *CLOUDFLARE_TITLE;
@property (nonatomic, strong) IBOutlet NSTextField *CLOUDFLARE_APIKEY;
@property (nonatomic, strong) IBOutlet NSTextField *CLOUDFLARE_DOMIAN;
@property (nonatomic, strong) IBOutlet NSTextField *CLOUDFLARE_EMAIL;
-(IBAction)addCloudFlareAccount:(id)sender;

@property (nonatomic, strong) IBOutlet NSTextField *JIASULE_TITLE;
@property (nonatomic, strong) IBOutlet NSTextField *JIASULE_USERNAME;
@property (nonatomic, strong) IBOutlet NSTextField *JIASULE_APIKEY;
-(IBAction)addJiasuleAccount:(id)sender;


-(IBAction)cancelbtnpressed:(id)sender;

//CloudFlare window
@property (nonatomic, strong) IBOutlet NSPopUpButton *selectCLSubDomain;
-(IBAction)CLdonebtn:(id)sender;

//Jiasule window
@property (nonatomic, strong) IBOutlet NSPopUpButton *selectJSLSubDomain;
-(IBAction)JSLdonebtn:(id)sender;

@end
