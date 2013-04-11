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
    NSUserDefaults *userdefaults;
    //IBOutlet NSTabView *tabview;
    IBOutlet NSTextView *info;
    //namecheap
    IBOutlet NSTextField *ndomainname;
    IBOutlet NSTextField *npassword;
    IBOutlet NSTextField *nhostname;
    IBOutlet NSButton *namecheapbtn;
    IBOutlet NSButton *autologtonc;
    
    //oray
    IBOutlet NSTextField *ousername;
    IBOutlet NSTextField *opassword;
    IBOutlet NSTextField *ohostname;
    IBOutlet NSButton *orayloginbtn;
    IBOutlet NSButton *autologtooray;
    
    NSString *logstring;
    BOOL namecheapautolog;
    BOOL orayautolog;
    
    
    
}
@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSTabView *tabview;
@property (nonatomic, retain) IBOutlet NSTextView *info;

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
-(IBAction)autologtonamecheappress:(id)sender;
-(IBAction)autologtooraypress:(id)sender;
-(IBAction)cleandata:(id)sender;
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