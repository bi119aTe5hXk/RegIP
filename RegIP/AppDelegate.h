//
//  AppDelegate.h
//  RegIP
//
//  Created by bi119aTe5hXk on 12-7-29.
//  Copyright (c) 2014年 bi119aTe5hXk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASIHTTPRequest.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,NSTableViewDelegate,NSTableViewDataSource,ASIHTTPRequestDelegate,NSTextFieldDelegate>{
    NSUserDefaults *userdefaults;
    
    BOOL customIP;
    
    BOOL logviewOpen;
    BOOL autoUpdate;
    NSInteger autoUpdateTime;
    
    NSString *ipAddr;
    NSString *oldIPAddr;
    NSString *logstr;
    NSMutableArray *servicelist;
    NSArray *CLlist;
    NSTimer *timer;
    
    IBOutlet NSWindow *addservicewindow;
    IBOutlet NSWindow *addcloudflarewindow;
    IBOutlet NSWindow *customIPwindow;
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
-(IBAction)customIP:(id)sender;
-(IBAction)refreship:(id)sender;
-(IBAction)autoUpdateSWchanged:(id)sender;
- (IBAction)toggleLeftDrawer:(id)sender;
-(IBAction)cleanlog:(id)sender;
-(IBAction)addbtnpressed:(id)sender;
-(IBAction)removebtnpressed:(id)sender;
-(IBAction)updateSelect:(id)sender;
-(IBAction)manualbtnpressed:(id)sender;

//Custom IP window
@property (nonatomic, strong) IBOutlet NSTextField *IP_FIELD_1;
@property (nonatomic, strong) IBOutlet NSTextField *IP_FIELD_2;
@property (nonatomic, strong) IBOutlet NSTextField *IP_FIELD_3;
@property (nonatomic, strong) IBOutlet NSTextField *IP_FIELD_4;
-(IBAction)customIPcancel:(id)sender;
-(IBAction)customIPdone:(id)sender;

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

-(IBAction)cancelbtnpressed:(id)sender;

//CloudFlare window
@property (nonatomic, strong) IBOutlet NSPopUpButton *selectSubDomain;
-(IBAction)CLdonebtn:(id)sender;

@end
