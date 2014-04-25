//
//  AppDelegate.m
//  RegIP
//
//  Created by bi119aTe5hXk on 12-7-29.
//  Copyright (c) 2014年 bi119aTe5hXk. All rights reserved.
//



#import "AppDelegate.h"


@implementation AppDelegate
@synthesize window;
- (BOOL)applicationShouldHandleReopen:(NSApplication *) __unused theApplication hasVisibleWindows:(BOOL)flag{
    if (!flag){
            [[self window] makeKeyAndOrderFront:self];
    }
    return YES;
}
-(void)applicationWillTerminate:(NSNotification *)notification{
    [userdefaults synchronize];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    userdefaults = [NSUserDefaults standardUserDefaults];
    logstr = [[NSString alloc] init];
    oldIPAddr = [[NSString alloc] init];
    ipAddr = [[NSString alloc] init];
    
    [userdefaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:nil,@"Services", nil]];
    [userdefaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"AutoUpdate", nil]];
    [userdefaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:10],@"AutoUpdateTime", nil]];
    [userdefaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"LogViewOpen", nil]];
    
    servicelist = [userdefaults mutableArrayValueForKey:@"Services"];
    autoUpdate = [userdefaults boolForKey:@"AutoUpdate"];
    autoUpdateTime = [userdefaults integerForKey:@"AutoUpdateTime"];
    logviewOpen = [userdefaults boolForKey:@"LogViewOpen"];
    
    if (logviewOpen == YES) {
        [self toggleLeftDrawer:nil];
    }
    
    if (servicelist == nil) {
        servicelist = [[NSMutableArray alloc] init];
    }
    
    if (autoUpdate == YES) {
        [self.autoUpdateSwitch setState:NSOnState];
        [self.autoUpdateField setEnabled:YES];
        [self.autoUpdateField setDelegate:self];
        [self.autoUpdateField setStringValue:[NSString stringWithFormat:@"%ld",autoUpdateTime]];
        [self setupTimer];
    }else{
        [self.autoUpdateSwitch setState:NSOffState];
        [self.autoUpdateField setEnabled:NO];
    }
    [self.tableview setDoubleAction:@selector(updateSelect:)];
    [self.tableview reloadData];
    [self setupLeftDrawer];
    [self logWithString:@"Init compete."];
    [self refreship:nil];
    [self manualbtnpressed:nil];
    
    
    
    
}

-(IBAction)autoUpdateSWchanged:(id)sender{
    if (autoUpdate == YES) {
        autoUpdate = NO;
        [self.autoUpdateSwitch setState:NSOffState];
        [self.autoUpdateField setEnabled:NO];
        [userdefaults setBool:[NSNumber numberWithBool:NO] forKey:@"AutoUpdate"];
        [self logWithString:@"Timer canceled."];
        [timer invalidate];
        timer  = nil;
    }else{
        autoUpdate = YES;
        [self.autoUpdateSwitch setState:NSOnState];
        [self.autoUpdateField setEnabled:YES];
        [self.autoUpdateField setDelegate:self];
        [userdefaults setBool:[NSNumber numberWithBool:YES] forKey:@"AutoUpdate"];
        [self setupTimer];
    }
}
- (void)controlTextDidChange:(NSNotification *)notification{
    if([notification object] == self.autoUpdateField){
        autoUpdateTime = [self.autoUpdateField integerValue];
        [userdefaults setInteger:autoUpdateTime forKey:@"AutoUpdateTime"];
        [self setupTimer];
    }
}
-(void)setupTimer{
    [self logWithString:@"Timer setted."];
    timer = [NSTimer scheduledTimerWithTimeInterval:autoUpdateTime*60
                                             target:self
                                           selector:@selector(timeToUpdate)
                                           userInfo:nil
                                            repeats:YES];
}
-(IBAction)refreship:(id)sender{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@SELF_IP_SERVER]];
    NSURLResponse *response;
    NSError *error;
    NSData *urlData;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (urlData != nil) {
        NSString *data = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        data = [data stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
        data = [data stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
        data = [data stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        data = [data stringByReplacingOccurrencesOfString:@" " withString:@""];
        data = [data stringByReplacingOccurrencesOfString:@"." withString:@"."];
        
        //don't know why it compare the IP address always failed, just munal to re-create it.
        NSArray *ipaddrarr = [data componentsSeparatedByString:@"."];
        ipAddr = [NSString stringWithFormat:@"%@.%@.%@.%@",[ipaddrarr objectAtIndex:0],
                                                           [ipaddrarr objectAtIndex:1],
                                                           [ipaddrarr objectAtIndex:2],
                                                           [ipaddrarr objectAtIndex:3]];
        
        [self logWithString:[NSString stringWithFormat:@"Grobal IP Address: %@",ipAddr]];
        [self.ipAddress setStringValue:ipAddr];
        
//        if (ipAddr != oldIPAddr) {
//            oldIPAddr = ipAddr;
//            [self.ipAddress setStringValue:ipAddr];
//            [self logWithString:[NSString stringWithFormat:@"Grobal IP Address: %@",ipAddr]];
//        }else{
//            [self logWithString:[NSString stringWithFormat:@"IP Address not change: %@.",ipAddr]];
//        }
    }else{
        [self.ipAddress setStringValue:@"Network Error!"];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return servicelist.count;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *dic = [servicelist objectAtIndex:row];
    
    if ([[dic valueForKey:@"Type"] isEqual: @"ORAY"]) {
        return [self setCellViewWithTitle:[[dic valueForKey:@"Title"] mutableCopy]
                               WithDomain:[[dic valueForKey:@"Domain"] mutableCopy]
                                WithHosts:[[dic valueForKey:@"Hosts"] mutableCopy]
                           ForTableColumn:tableColumn
                                 ForTable:tableView];
    }else if ([[dic valueForKey:@"Type"]  isEqual: @"NAMECHEAP"]){
        return [self setCellViewWithTitle:[[dic valueForKey:@"Title"] mutableCopy]
                               WithDomain:[[dic valueForKey:@"Domain"] mutableCopy]
                                WithHosts:[[dic valueForKey:@"Hosts"] mutableCopy]
                           ForTableColumn:tableColumn
                                 ForTable:tableView];
    }else if ([[dic valueForKey:@"Type"]  isEqual: @"CLOUDFLARE"]){
        return [self setCellViewWithTitle:[[dic valueForKey:@"Title"] mutableCopy]
                               WithDomain:[[dic valueForKey:@"Domain"] mutableCopy]
                                WithHosts:[[dic valueForKey:@"CLname"] mutableCopy]
                           ForTableColumn:tableColumn
                                 ForTable:tableView];
    }
    return nil;
}

-(NSView *)setCellViewWithTitle:(NSString *)title WithDomain:(NSString *)domain WithHosts:(NSString *)hosts ForTableColumn:(NSTableColumn *)tableColumn ForTable:(NSTableView *)tableView{
    NSString *identifier = [tableColumn identifier];
    if ([identifier isEqualToString:@"title"]) {
        NSTableCellView *textfieldcell = [tableView makeViewWithIdentifier:identifier owner:self];
        textfieldcell.textField.stringValue = title;
        return textfieldcell;
    }else if ([identifier isEqualToString:@"domain"]){
        NSTableCellView *textfieldcell = [tableView makeViewWithIdentifier:identifier owner:self];
        textfieldcell.textField.stringValue = domain;
        return textfieldcell;
    }else if ([identifier isEqualToString:@"host"]){
        NSTableCellView *textfieldcell = [tableView makeViewWithIdentifier:identifier owner:self];
        textfieldcell.textField.stringValue = hosts;
        return textfieldcell;
    }else {
        NSLog(@"Unhandled table column identifier %@", identifier);
    }
    return nil;
}

-(IBAction)addbtnpressed:(id)sender{
    [NSApp beginSheet:addservicewindow
       modalForWindow:self.window
        modalDelegate:self
       didEndSelector:@selector(closeAddWindow:)
          contextInfo:NULL];
}
-(IBAction)removebtnpressed:(id)sender{
    if ([self.tableview selectedRow] >= 0) {
        [servicelist removeObjectAtIndex:[self.tableview selectedRow]];
        [self.tableview reloadData];
    }
}


#pragma mark - Add part -
-(IBAction)addOrayAccount:(id)sender{
    if ([[self.ORAY_USERNAME stringValue] length] != 0 &&
        [[self.ORAY_PASSWORD stringValue] length] != 0 &&
        [[self.ORAY_HOSTS stringValue] length] != 0) {
        [servicelist addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"ORAY",@"Type",
                                [self.ORAY_TITLE stringValue],@"Title",
                                [self.ORAY_USERNAME stringValue],@"Domain",
                                [self.ORAY_HOSTS stringValue],@"Hosts",
                                [self.ORAY_PASSWORD stringValue],@"APIkey", nil]];
        [self closeAddWindow:nil];
    }else{
        NSRunAlertPanel(@"Error!", @"Please fill all field.",nil,nil,nil);
    }
}
-(IBAction)addNameCheapAccount:(id)sender{
    if ([[self.NAMECHEAP_DOMAIN stringValue] length] != 0 &&
        [[self.NAMECHEAP_HOSTS stringValue] length] != 0 &&
        [[self.NAMECHEAP_APIKEY stringValue] length] != 0) {
        [servicelist addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"NAMECHEAP",@"Type",
                                [self.NAMECHEAP_TITLE stringValue],@"Title",
                                [self.NAMECHEAP_DOMAIN stringValue],@"Domain",
                                [self.NAMECHEAP_HOSTS stringValue],@"Hosts",
                                [self.NAMECHEAP_APIKEY stringValue],@"APIkey", nil]];
        [self closeAddWindow:nil];
    }else{
        NSRunAlertPanel(@"Error!", @"Please fill all field.",nil,nil,nil);
    }
}
-(IBAction)addCloudFlareAccount:(id)sender{
    if ([[self.CLOUDFLARE_EMAIL stringValue] length] != 0 &&
        [[self.CLOUDFLARE_DOMIAN stringValue] length] != 0 &&
        [[self.CLOUDFLARE_APIKEY stringValue] length] != 0) {
        
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:CLOUDFLARE_LOAD_ALL_RECORD_URL,
                                                    [self.CLOUDFLARE_APIKEY stringValue],
                                                    [self.CLOUDFLARE_EMAIL stringValue],
                                                    [self.CLOUDFLARE_DOMIAN stringValue]]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSError *error;
        NSURLResponse *response;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        NSArray* json = [NSJSONSerialization JSONObjectWithData:urlData
                                                        options:kNilOptions
                                                          error:&error];
        CLlist = [[[json valueForKey:@"response"] valueForKey:@"recs"] valueForKey:@"objs"];
        NSMenu *subDomainMenu = [[NSMenu alloc] initWithTitle:@"Select SubDomain"];
        
        for (int i = 0; i<[CLlist count]; i++) {
            [subDomainMenu addItem:[[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ - %@ - %@",
                                                             [[CLlist objectAtIndex:i] valueForKey:@"display_name"],
                                                             [[CLlist objectAtIndex:i] valueForKey:@"name"],
                                                             [[CLlist objectAtIndex:i] valueForKey:@"display_content"]]
                                                     action:nil
                                              keyEquivalent:@""]];
        }
        [self.selectCLSubDomain setMenu:subDomainMenu];
        
        [NSApp beginSheet:addcloudflarewindow
           modalForWindow:addservicewindow
            modalDelegate:self
           didEndSelector:@selector(closeCLAddwindow:)
              contextInfo:NULL];
    }else{
        NSRunAlertPanel(@"Error!", @"Please fill all field.",nil,nil,nil);
    }
}
//-(IBAction)addJiasuleAccount:(id)sender{
//    if ([[self.JIASULE_USERNAME stringValue] length] != 0 &&
//         [[self.JIASULE_APIKEY stringValue] length] != 0) {
//        
//        
//        NSString *urlstr = [Baidu_Jiasule stringByAppendingString:[NSString stringWithFormat:@"list/"]];
//        
//        NSString *post_string = [NSString stringWithFormat:@"time=%f",[[NSDate date] timeIntervalSince1970]];
//        
//        
//        NSMutableData *postData = [[post_string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES] mutableCopy];
//        
//        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
////        NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] init];;
////        [request setURL:[NSURL URLWithString:urlstr]];
////        [request setHTTPMethod:@"POST"];
////        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
////        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
////        [request setHTTPBody:postData];
//
//        NSString *pswstr = [self hmacsha1:post_string secret:[self.JIASULE_APIKEY stringValue]];
////        NSString* authorizationToken = [NSString stringWithFormat:@"%@:%@", [self.JIASULE_USERNAME stringValue], pswstr];
////        [request setValue:[NSString stringWithFormat:@"Basic %@", authorizationToken] forHTTPHeaderField:@"Authorization"];
////        NSLog(@"%@",authorizationToken);
//        
//        
//        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlstr]];
//        [request setUsername:[self.JIASULE_USERNAME stringValue]];
//        [request setPassword:pswstr];
//        [request addRequestHeader:@"Content-Length" value:postLength];
//        [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
//        [request setPostBody:postData];
//        
//        [request startSynchronous];
//        
//        NSError *error = [request error];
//        NSData *response = [request responseData];
//        NSLog(@"%@",[request responseString]);
//        
////        NSError *error;
////        NSURLResponse *response;
////        NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
////        NSLog(@"%@",[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding]);
//        NSArray* json = [NSJSONSerialization JSONObjectWithData:response
//                                                        options:kNilOptions
//                                                          error:&error];
//        JSLlist  = [json valueForKey:@"ret"];
//        NSMenu *subDomainMenu2 = [[NSMenu alloc] initWithTitle:@"Select SubDomain"];
//        
//        for (int i = 0; i<[JSLlist count]; i++) {
//            [subDomainMenu2 addItem:[[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ - %@ - %@",
//                                                                      [[JSLlist objectAtIndex:i] valueForKey:@"host"],
//                                                                      [[JSLlist objectAtIndex:i] valueForKey:@"domain"],
//                                                                      [[[JSLlist objectAtIndex:i] valueForKey:@"ip"] objectAtIndex:0]]
//                                                              action:nil
//                                                       keyEquivalent:@""]];
//        }
//        [self.selectJSLSubDomain setMenu:subDomainMenu2];
//        
//        [NSApp beginSheet:addjisulewindow
//           modalForWindow:addservicewindow
//            modalDelegate:self
//           didEndSelector:@selector(closeJSLAddwindow:)
//              contextInfo:NULL];
//        
//        
//    }else{
//        NSRunAlertPanel(@"Error!", @"Please fill all field.",nil,nil,nil);
//    }
//}


-(void)closeAddWindow:(id)sender{
    [self.ORAY_PASSWORD setStringValue:@""];
    [self.ORAY_HOSTS setStringValue:@""];
    [self.ORAY_TITLE setStringValue:@""];
    [self.ORAY_USERNAME setStringValue:@""];
    [self.NAMECHEAP_APIKEY setStringValue:@""];
    [self.NAMECHEAP_DOMAIN setStringValue:@""];
    [self.NAMECHEAP_HOSTS setStringValue:@""];
    [self.NAMECHEAP_TITLE setStringValue:@""];
    [self.CLOUDFLARE_APIKEY setStringValue:@""];
    [self.CLOUDFLARE_DOMIAN setStringValue:@""];
    [self.CLOUDFLARE_EMAIL setStringValue:@""];
    [self.CLOUDFLARE_TITLE setStringValue:@""];
    [self.JIASULE_TITLE setStringValue:@""];
    [self.JIASULE_APIKEY setStringValue:@""];
    [self.JIASULE_USERNAME setStringValue:@""];
    
    [addservicewindow close];
    [self.tableview reloadData];
    [userdefaults setObject:[servicelist copy] forKey:@"Services"];
    [NSApp endSheet:addservicewindow returnCode:NSOKButton];
}
-(IBAction)cancelbtnpressed:(id)sender{
    [self closeAddWindow:nil];
}
#pragma mark - CloudFlare Account part -
-(IBAction)CLdonebtn:(id)sender{
    [servicelist addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"CLOUDFLARE",@"Type",
                            [self.CLOUDFLARE_TITLE stringValue],@"Title",
                            [self.CLOUDFLARE_DOMIAN stringValue],@"Domain",
                            [self.CLOUDFLARE_APIKEY stringValue],@"APIkey",
                            [self.CLOUDFLARE_EMAIL stringValue],@"Mail",
                            [[CLlist objectAtIndex:[self.selectCLSubDomain indexOfSelectedItem]] valueForKey:@"name"],@"CLname",
                            [[CLlist objectAtIndex:[self.selectCLSubDomain indexOfSelectedItem]] valueForKey:@"rec_id"],@"CLid",
                            nil]];
    
    [self closeCLAddwindow:self];
}
-(void)closeCLAddwindow:(id)sender{
    [addcloudflarewindow close];
    [addservicewindow close];
    [NSApp endSheet:addcloudflarewindow returnCode:NSOKButton];
    [self closeAddWindow:nil];
}

#pragma mark - Jiasule Account part -

-(IBAction)JSLdonebtn:(id)sender{
    
    
    
    
}
-(void)closeJSLAddwindow:(id)sender{
    [addjisulewindow close];
    [addservicewindow close];
    [NSApp endSheet:addjisulewindow returnCode:NSOKButton];
    [self closeAddWindow:nil];
}

#pragma mark - update part -
-(IBAction)manualbtnpressed:(id)sender{
    [self refreship:self];
    if (![self queue]) {
        [self setQueue:[[NSOperationQueue alloc] init]];
    }
    for (int l = 0; l < [servicelist count]; l++) {
        [self updateListAtRow:l];
    }
}

-(IBAction)updateSelect:(id)sender{
    [self refreship:self];
    
    if (![self queue]) {
        [self setQueue:[[NSOperationQueue alloc] init]];
    }
    
    [self updateListAtRow:[self.tableview selectedRow]];
}
-(void)timeToUpdate{
    [self logWithString:@"It's time to Update."];
    oldIPAddr = ipAddr;
    [self refreship:self];
    if (ipAddr != oldIPAddr) {
        if (![self queue]) {
            [self setQueue:[[NSOperationQueue alloc] init]];
        }
        
        for (int l = 0; l < [servicelist count]; l++) {
            [self updateListAtRow:l];
        }
    }else{
        [self logWithString:@"IP not change."];
    }
}
-(void)updateListAtRow:(NSInteger)row{
    
    NSArray *arr = [servicelist objectAtIndex:row];
    if ([[arr valueForKey:@"Type"]  isEqual: @"ORAY"]) {
        NSString *url = [NSString stringWithFormat:ORAY_SERVER_URL,
                         [self encodeString:[arr valueForKey:@"Domain"] ],
                         [self encodeString:[arr valueForKey:@"APIkey"]],
                         [self encodeString:[arr valueForKey:@"Hosts"]]];
        [self startRequestWithURL:url];
        
    }else if ([[arr valueForKey:@"Type"]  isEqual: @"NAMECHEAP"]){
        NSString *url = [NSString stringWithFormat:NAMECHEAP_SERVER_URL,
                         [self encodeString:[arr valueForKey:@"Hosts"]],
                         [self encodeString:[arr valueForKey:@"Domain"]],
                         [self encodeString:[arr valueForKey:@"APIkey"]]];
        [self startRequestWithURL:url];
        
    }else if ([[arr valueForKey:@"Type"]  isEqual: @"CLOUDFLARE"]){
        NSString *url = [NSString stringWithFormat:CLOUDFLARE_SERVER_URL,
                         [self encodeString:[arr valueForKey:@"APIkey"]],
                         [self encodeString:[arr valueForKey:@"Mail"]],
                         [self encodeString:[arr valueForKey:@"Domain"]],
                         [self encodeString:[arr valueForKey:@"CLid"]],
                         [self encodeString:[arr valueForKey:@"CLname"]],
                         [self encodeString:ipAddr]];
        [self startRequestWithURL:url];
    }
}
-(NSString *)encodeString:(NSString *)str{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)str,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",kCFStringEncodingUTF8);
}
-(void)startRequestWithURL:(NSString *)url{
    [self logWithString:@"Connecting Server..."];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [[self queue] addOperation:request];
}

#pragma mark - Network return part -
- (void)requestDone:(ASIHTTPRequest *)request{
    NSString *response = [request responseString];
    [self logWithString:response];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    [self logWithString:[error localizedDescription]];
}


#pragma mark - Log part -
-(void)logWithString:(NSString *)log{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fixString = [dateFormatter stringFromDate:[NSDate date]];
    
    logstr = [logstr stringByAppendingString:[NSString stringWithFormat:@"%@ %@\n",fixString,log]];
    if ([logstr length] >= 5000) {
        [logstr substringFromIndex:5000];
    }
    [self.logtextview setString:logstr];
}
-(IBAction)cleanlog:(id)sender{
    logstr = @"";
    [self.logtextview setString:logstr];
}

- (void)setupLeftDrawer {
    [leftDrawer setContentSize:NSMakeSize(400, 100)];
    [leftDrawer setMinContentSize:NSMakeSize(400, 100)];
    [leftDrawer setMaxContentSize:NSMakeSize(400, 800)];
    
}

- (IBAction)toggleLeftDrawer:(id)sender{
    NSDrawerState state = [leftDrawer state];
    if (NSDrawerOpeningState == state || NSDrawerOpenState == state) {
        [self.showlogitem setTitle:@"Show Log"];
        [leftDrawer close];
        [userdefaults setBool:NO forKey:@"LogViewOpen"];
    } else {
        [self.showlogitem setTitle:@"Hide Log"];
        [leftDrawer openOnEdge:NSMinXEdge];
        [userdefaults setBool:YES forKey:@"LogViewOpen"];
    }
}


- (NSSize)drawerWillResizeContents:(NSDrawer *)sender toSize:(NSSize)contentSize {
    contentSize.width = 10 * ceil(contentSize.width / 10);
    if (contentSize.width < 50){
        contentSize.width = 50;
    }
    if (contentSize.width > 800){
        contentSize.width = 800;
    }
    return contentSize;
}

#pragma mark - other part -
-(IBAction)website:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@MYBLOG]];
}


- (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    
    for (int i = 0; i < HMACData.length; ++i)
        HMAC = [HMAC stringByAppendingFormat:@"%02lx", (unsigned long)buffer[i]];
    
    return HMAC;
}
@end
