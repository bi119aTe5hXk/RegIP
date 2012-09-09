//
//  AppDelegate.h
//  RegIP
//
//  Created by bi119aTe5hXk on 12-7-29.
//  Copyright (c) 2012年 bi119aTe5hXk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSTabView *tabview;
    IBOutlet NSTextField *info;
    //namecheap
    IBOutlet NSTextField *domainname;
    IBOutlet NSTextField *password;
    IBOutlet NSTextField *hostname;
    IBOutlet NSButton *namecheapbtn;
    
    //oray
    IBOutlet NSTextField *ousername;
    IBOutlet NSTextField *opassword;
    IBOutlet NSTextField *ohostname;
    IBOutlet NSButton *orayloginbtn;
    
    BOOL oremember;
    BOOL nremember;
    
    
}
@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSTabView *tabview;
@property (nonatomic, retain) IBOutlet NSTextField *info;

@property (nonatomic, retain) IBOutlet NSTextField *domainname;
@property (nonatomic, retain) IBOutlet NSTextField *password;
@property (nonatomic, retain) IBOutlet NSTextField *hostname;
@property (nonatomic, retain) IBOutlet NSButton *namecheapbtn;


@property (nonatomic, retain) IBOutlet NSTextField *ousername;
@property (nonatomic, retain) IBOutlet NSTextField *opassword;
@property (nonatomic, retain) IBOutlet NSTextField *ohostname;
@property (nonatomic, retain) IBOutlet NSButton *orayloginbtn;



-(IBAction)namecheaploginbtnpressed:(id)sender;
-(IBAction)orayloginbtnpressed:(id)sender;
-(IBAction)website:(id)sender;
@end
extern NSString * const KEY_OUSERPASSHOST;
extern NSString * const KEY_OUSERNAME;
extern NSString * const KEY_OPASSWORD;
extern NSString * const KEY_OHOSTNAME;

extern NSString * const KEY_NDOMAINPASSHOST;
extern NSString * const KEY_NDOMAINNAME;
extern NSString * const KEY_NPASSWORD;
extern NSString * const KEY_NHOSTNAME;