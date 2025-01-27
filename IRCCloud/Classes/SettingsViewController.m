//
//  SettingsViewController.m
//
//  Copyright (C) 2013 IRCCloud, Ltd.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "SettingsViewController.h"
#import "NetworkConnection.h"
#import "LicenseViewController.h"
#import "AppDelegate.h"
#import "UIColor+IRCCloud.h"
#import "OpenInChromeController.h"
#import "ImgurLoginViewController.h"
#import "UIDevice+UIDevice_iPhone6Hax.h"
#import "ColorFormatter.h"

@interface FontSizeCell : UITableViewCell {
    UILabel *_small;
    UILabel *_large;
    UISlider *_fontSize;
}
-(void)setFontSize:(UISlider *)fontSize;
@end

@implementation FontSizeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _small = [[UILabel alloc] init];
        _small.font = [UIFont boldSystemFontOfSize:10];
        _small.lineBreakMode = NSLineBreakByCharWrapping;
        _small.textAlignment = NSTextAlignmentCenter;
        _small.numberOfLines = 0;
        _small.text = @"Aa";
        [self.contentView addSubview:_small];
        
        _large = [[UILabel alloc] init];
        _large.font = [UIFont systemFontOfSize:18];
        _large.lineBreakMode = NSLineBreakByCharWrapping;
        _large.textAlignment = NSTextAlignmentCenter;
        _large.numberOfLines = 0;
        _large.text = @"Aa";
        [self.contentView addSubview:_large];
    }
    return self;
}

-(void)setFontSize:(UISlider *)fontSize {
    [_fontSize removeFromSuperview];
    _fontSize = fontSize;
    [self.contentView addSubview:_fontSize];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = CGRectInset([self.contentView bounds], 6, 6);
    
    _small.frame = CGRectMake(frame.origin.x, frame.origin.y, 32, frame.size.height);
    _large.frame = CGRectMake(frame.origin.x + frame.size.width - 32, frame.origin.y, 32, frame.size.height);
    [_fontSize sizeToFit];
    _fontSize.frame = CGRectMake(frame.origin.x + 32, 0, frame.size.width - 64 - frame.origin.x, _fontSize.frame.size.height);
    CGPoint p = _fontSize.center;
    p.y = self.contentView.center.y;
    _fontSize.center = p;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

@interface ImageServiceViewController : UITableViewController
@end

@implementation ImageServiceViewController

-(id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.navigationItem.title = @"Image Service";
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageservicecell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageservicecell"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch(indexPath.row) {
        case 0:
            cell.textLabel.text = @"IRCCloud";
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"imageService"] isEqualToString:@"IRCCloud"])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case 1:
            cell.textLabel.text = @"imgur";
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"imageService"] isEqualToString:@"imgur"])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.row) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@"IRCCloud" forKey:@"imageService"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@"imgur" forKey:@"imageService"];
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@interface PhotoSizeViewController : UITableViewController
@end

@implementation PhotoSizeViewController

-(id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.navigationItem.title = @"Photo Size";
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photosizecell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"photosizecell"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch(indexPath.row) {
        case 0:
            cell.textLabel.text = @"Small";
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"photoSize"] intValue] == 512)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case 1:
            cell.textLabel.text = @"Medium";
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"photoSize"] intValue] == 1024)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case 2:
            cell.textLabel.text = @"Large";
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"photoSize"] intValue] == 2048)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case 3:
            cell.textLabel.text = @"Original";
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"photoSize"] intValue] == -1)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.row) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@(512) forKey:@"photoSize"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@(1024) forKey:@"photoSize"];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:@(2048) forKey:@"photoSize"];
            break;
        case 3:
            [[NSUserDefaults standardUserDefaults] setObject:@(-1) forKey:@"photoSize"];
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"Settings";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
        OpenInChromeController *c = [[OpenInChromeController alloc] init];
        _chromeInstalled = [c isChromeInstalled];
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    if([title isEqualToString:@"Confirm"]) {
        UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinny startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinny];
        
        _emailreqid = [[NetworkConnection sharedInstance] changeEmail:_email.text password:[alertView textFieldAtIndex:0].text];
    }
    
    _alertView = nil;
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    if(alertView.alertViewStyle == UIAlertViewStyleSecureTextInput && [alertView textFieldAtIndex:0].text.length == 0)
        return NO;
    else
        return YES;
}

-(void)saveButtonPressed:(id)sender {
    [self.tableView endEditing:YES];
    
    if(sender && [NetworkConnection sharedInstance].userInfo && [[NetworkConnection sharedInstance].userInfo objectForKey:@"email"] && ![_email.text isEqualToString:[[NetworkConnection sharedInstance].userInfo objectForKey:@"email"]]) {
        [self.view endEditing:YES];
        _alertView = [[UIAlertView alloc] initWithTitle:@"Change Your Email Address" message:@"Please enter your current password to confirm this change" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        _alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [_alertView textFieldAtIndex:0].delegate = self;
        [_alertView show];
    } else {
        UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinny startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinny];
        NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithDictionary:[[NetworkConnection sharedInstance] prefs]];
        
        [prefs setObject:@(_24hour.isOn) forKey:@"time-24hr"];
        [prefs setObject:@(_seconds.isOn) forKey:@"time-seconds"];
        [prefs setObject:@(_symbols.isOn) forKey:@"mode-showsymbol"];
        [prefs setObject:@(_colors.isOn) forKey:@"nick-colors"];
        [prefs setObject:@(!_emocodes.isOn) forKey:@"emoji-disableconvert"];
        [prefs setObject:@(!_pastebin.isOn) forKey:@"pastebin-disableprompt"];
        
        SBJsonWriter *writer = [[SBJsonWriter alloc] init];
        NSString *json = [writer stringWithObject:prefs];
        
        _userinfosaved = NO;
        _prefssaved = NO;
        _userinforeqid = [[NetworkConnection sharedInstance] setRealname:_name.text highlights:_highlights.text autoaway:_autoaway.isOn];
        _prefsreqid = [[NetworkConnection sharedInstance] setPrefs:json];
        
        [[NSUserDefaults standardUserDefaults] setBool:_screen.on forKey:@"keepScreenOn"];
        [[NSUserDefaults standardUserDefaults] setBool:_chrome.on forKey:@"useChrome"];
        [[NSUserDefaults standardUserDefaults] setBool:_autoCaps.on forKey:@"autoCaps"];
        [[NSUserDefaults standardUserDefaults] setBool:_saveToCameraRoll.on forKey:@"saveToCameraRoll"];
        [[NSUserDefaults standardUserDefaults] setBool:_notificationSound.on forKey:@"notificationSound"];
        [[NSUserDefaults standardUserDefaults] setBool:_tabletMode.on forKey:@"tabletMode"];
        [[NSUserDefaults standardUserDefaults] setFloat:_fontSize.value forKey:@"fontSize"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        if([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8) {
#ifdef ENTERPRISE
            NSUserDefaults *d = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.irccloud.enterprise.share"];
#else
            NSUserDefaults *d = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.irccloud.share"];
#endif
            [d setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"photoSize"] forKey:@"photoSize"];
            [d setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uploadsAvailable"] forKey:@"uploadsAvailable"];
            [d setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageService"] forKey:@"imageService"];
            [d setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"fontSize"] forKey:@"fontSize"];
            [d synchronize];
        }
        
        if([ColorFormatter shouldClearFontCache])
            [ColorFormatter clearFontCache];
        [[EventsDataSource sharedInstance] clearFormattingCache];
    }
}

-(void)cancelButtonPressed:(id)sender {
    [self.tableView endEditing:YES];
    if([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8) {
#ifdef ENTERPRISE
        NSUserDefaults *d = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.irccloud.enterprise.share"];
#else
        NSUserDefaults *d = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.irccloud.share"];
#endif
        [d setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"photoSize"] forKey:@"photoSize"];
        [d setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"uploadsAvailable"] forKey:@"uploadsAvailable"];
        [d setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageService"] forKey:@"imageService"];
        [d synchronize];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEvent:) name:kIRCCloudEventNotification object:nil];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(SupportedOrientationsReturnType)supportedInterfaceOrientations {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)?UIInterfaceOrientationMaskAllButUpsideDown:UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return YES;
}

-(void)handleEvent:(NSNotification *)notification {
    kIRCEvent event = [[notification.userInfo objectForKey:kIRCCloudEventKey] intValue];
    IRCCloudJSONObject *o;
    int reqid;
    
    switch(event) {
        case kIRCEventUserInfo:
            if(_userinforeqid == 0 && _prefsreqid == 0 && _emailreqid == 0)
                [self refresh];
            break;
        case kIRCEventFailureMsg:
            o = notification.object;
            reqid = [[o objectForKey:@"_reqid"] intValue];
            if(reqid == _userinforeqid || reqid == _prefsreqid || reqid == _emailreqid) {
                if([[o objectForKey:@"message"] isEqualToString:@"oldpassword"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect password, please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to save settings, please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed:)];
            }
            break;
        case kIRCEventSuccess:
            o = notification.object;
            reqid = [[o objectForKey:@"_reqid"] intValue];
            if(reqid == _emailreqid) {
                _emailreqid = 0;
                [self saveButtonPressed:nil];
            }
            if(reqid == _userinforeqid)
                _userinfosaved = YES;
            if(reqid == _prefsreqid)
                _prefssaved = YES;
            if(_userinfosaved == YES && _prefssaved == YES) {
                [self.tableView endEditing:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        default:
            break;
    }
}

-(void)refresh {
    NSDictionary *userInfo = [NetworkConnection sharedInstance].userInfo;
    NSDictionary *prefs = [[NetworkConnection sharedInstance] prefs];
    
    if([[userInfo objectForKey:@"name"] isKindOfClass:[NSString class]] && [[userInfo objectForKey:@"name"] length])
        _name.text = [userInfo objectForKey:@"name"];
    else
        _name.text = @"";
    
    if([[userInfo objectForKey:@"email"] isKindOfClass:[NSString class]] && [[userInfo objectForKey:@"email"] length])
        _email.text = [userInfo objectForKey:@"email"];
    else
        _email.text = @"";
    
    if([[userInfo objectForKey:@"autoaway"] isKindOfClass:[NSNumber class]]) {
        _autoaway.on = [[userInfo objectForKey:@"autoaway"] boolValue];
    }
    
    if([[userInfo objectForKey:@"highlights"] isKindOfClass:[NSArray class]] && [(NSArray *)[userInfo objectForKey:@"highlights"] count])
        _highlights.text = [[userInfo objectForKey:@"highlights"] componentsJoinedByString:@", "];
    else if([[userInfo objectForKey:@"highlights"] isKindOfClass:[NSString class]] && [[userInfo objectForKey:@"highlights"] length])
        _highlights.text = [userInfo objectForKey:@"highlights"];
    else
        _highlights.text = @"";
    
    if([[prefs objectForKey:@"time-24hr"] isKindOfClass:[NSNumber class]]) {
        _24hour.on = [[prefs objectForKey:@"time-24hr"] boolValue];
    } else {
        _24hour.on = NO;
    }
    
    if([[prefs objectForKey:@"time-seconds"] isKindOfClass:[NSNumber class]]) {
        _seconds.on = [[prefs objectForKey:@"time-seconds"] boolValue];
    } else {
        _seconds.on = NO;
    }
    
    if([[prefs objectForKey:@"mode-showsymbol"] isKindOfClass:[NSNumber class]]) {
        _symbols.on = [[prefs objectForKey:@"mode-showsymbol"] boolValue];
    } else {
        _symbols.on = NO;
    }
    
    if([[prefs objectForKey:@"nick-colors"] isKindOfClass:[NSNumber class]]) {
        _colors.on = [[prefs objectForKey:@"nick-colors"] boolValue];
    } else {
        _colors.on = NO;
    }
    
    if([[prefs objectForKey:@"emoji-disableconvert"] isKindOfClass:[NSNumber class]]) {
        _emocodes.on = ![[prefs objectForKey:@"emoji-disableconvert"] boolValue];
    } else {
        _emocodes.on = YES;
    }
    
    if([[prefs objectForKey:@"pastebin-disableprompt"] isKindOfClass:[NSNumber class]]) {
        _pastebin.on = ![[prefs objectForKey:@"pastebin-disableprompt"] boolValue];
    } else {
        _pastebin.on = YES;
    }
    
    _screen.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"keepScreenOn"];
    _chrome.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"useChrome"];
    _autoCaps.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoCaps"];
    _saveToCameraRoll.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"saveToCameraRoll"];
    _notificationSound.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"notificationSound"];
    _tabletMode.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"tabletMode"];
    _fontSize.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"fontSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    int padding = 80;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        padding = 26;
        
    if([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7) {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 1, 0)] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.clipsToBounds = YES;
        padding = 0;
    }

    _email = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width / 2 - padding, 22)];
    _email.placeholder = @"john@example.com";
    _email.text = @"";
    _email.textAlignment = NSTextAlignmentRight;
    _email.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    _email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _email.autocorrectionType = UITextAutocorrectionTypeNo;
    _email.keyboardType = UIKeyboardTypeEmailAddress;
    _email.adjustsFontSizeToFitWidth = YES;
    _email.returnKeyType = UIReturnKeyDone;
    _email.delegate = self;
    
    _name = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width / 2 - padding, 22)];
    _name.placeholder = @"John Appleseed";
    _name.text = @"";
    _name.textAlignment = NSTextAlignmentRight;
    _name.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    _name.autocapitalizationType = UITextAutocapitalizationTypeWords;
    _name.autocorrectionType = UITextAutocorrectionTypeNo;
    _name.keyboardType = UIKeyboardTypeDefault;
    _name.adjustsFontSizeToFitWidth = YES;
    _name.returnKeyType = UIReturnKeyDone;
    _name.delegate = self;
    
    _autoaway = [[UISwitch alloc] init];
    _24hour = [[UISwitch alloc] init];
    _seconds = [[UISwitch alloc] init];
    _symbols = [[UISwitch alloc] init];
    _colors = [[UISwitch alloc] init];
    _screen = [[UISwitch alloc] init];
    _chrome = [[UISwitch alloc] init];
    _autoCaps = [[UISwitch alloc] init];
    _emocodes = [[UISwitch alloc] init];
    _saveToCameraRoll = [[UISwitch alloc] init];
    _notificationSound = [[UISwitch alloc] init];
    _tabletMode = [[UISwitch alloc] init];
    _pastebin = [[UISwitch alloc] init];

    _highlights = [[UITextView alloc] initWithFrame:CGRectZero];
    _highlights.text = @"";
    _highlights.backgroundColor = [UIColor clearColor];
    _highlights.returnKeyType = UIReturnKeyDone;
    _highlights.delegate = self;
    _highlights.font = _email.font;
    _highlights.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    _version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
#ifdef BRAND_NAME
    _version = [_version stringByAppendingFormat:@"-%@", BRAND_NAME];
#endif
#ifndef APPSTORE
    _version = [_version stringByAppendingFormat:@" (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
#endif
    
    _fontSize = [[UISlider alloc] init];
    _fontSize.minimumValue = 10;
    _fontSize.maximumValue = 18;
    _fontSize.continuous = YES;
    [_fontSize addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];

    [self refresh];
}

-(void)sliderChanged:(UISlider *)slider {
    [slider setValue:(int)slider.value animated:NO];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self.tableView endEditing:YES];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(_alertView) {
        [_alertView dismissWithClickedButtonIndex:1 animated:YES];
        [self alertView:_alertView clickedButtonAtIndex:1];
    }
    [self.tableView endEditing:YES];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1)
        return 80;
    else
        return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return 3;
        case 1:
            return 1;
        case 2:
            return 6;
        case 3:
            return ((_chromeInstalled)?4:3) + (([[UIDevice currentDevice] isBigPhone] || [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)?1:0);
        case 4:
            return 1;
        case 5:
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"uploadsAvailable"]) {
                return [[[NSUserDefaults standardUserDefaults] objectForKey:@"imageService"] isEqualToString:@"imgur"]?4:3;
            } else {
                return 3;
            }
        case 6:
            return 4;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Account";
        case 1:
            return @"Highlight Words";
        case 2:
            return @"Display";
        case 3:
            return @"Device";
        case 4:
            return @"Font Size";
        case 5:
            return @"Photo Sharing";
        case 6:
            return @"About";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    NSString *identifier = [NSString stringWithFormat:@"settingscell-%li-%li", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(indexPath.section != 4) {
        if(!cell)
            cell = [[UITableViewCell alloc] initWithStyle:(indexPath.section == 2)?UITableViewCellStyleSubtitle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = nil;
    }

    switch(indexPath.section) {
        case 0:
            switch(row) {
                case 0:
                    cell.textLabel.text = @"Email Address";
                    cell.accessoryView = _email;
                    break;
                case 1:
                    cell.textLabel.text = @"Full Name";
                    cell.accessoryView = _name;
                    break;
                case 2:
                    cell.textLabel.text = @"Auto Away";
                    cell.accessoryView = _autoaway;
                    break;
            }
            break;
        case 1:
            cell.textLabel.text = nil;
            [_highlights removeFromSuperview];
            _highlights.frame = CGRectInset(cell.contentView.bounds, 4, 4);
            [cell.contentView addSubview:_highlights];
            break;
        case 2:
            switch(row) {
                case 0:
                    cell.textLabel.text = @"24-hour Clock";
                    cell.accessoryView = _24hour;
                    break;
                case 1:
                    cell.textLabel.text = @"Show Seconds";
                    cell.accessoryView = _seconds;
                    break;
                case 2:
                    cell.textLabel.text = @"Usermode Symbols";
                    cell.accessoryView = _symbols;
                    cell.detailTextLabel.text = @"@, +, etc.";
                    break;
                case 3:
                    cell.textLabel.text = @"Colourise Nicknames";
                    cell.accessoryView = _colors;
                    break;
                case 4:
                    if([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] < 7)
                        cell.textLabel.text = @"Convert :emocodes:";
                    else
                        cell.textLabel.text = @"Convert :emocodes: to Emoji";
                    cell.detailTextLabel.text = @":thumbsup: → 👍";
                    cell.accessoryView = _emocodes;
                    break;
                case 5:
                    cell.textLabel.text = @"Ask to Pastebin";
                    cell.accessoryView = _pastebin;
                    cell.detailTextLabel.text = @"Before sending multi-line messages";
                    break;
            }
            break;
        case 3:
            switch(row) {
                case 0:
                    cell.textLabel.text = @"Prevent Auto-Lock";
                    cell.accessoryView = _screen;
                    break;
                case 1:
                    cell.textLabel.text = @"Auto-capitalization";
                    cell.accessoryView = _autoCaps;
                    break;
                case 2:
                    cell.textLabel.text = @"Play Alert Sounds";
                    cell.accessoryView = _notificationSound;
                    break;
                case 3:
                    if([[UIDevice currentDevice] isBigPhone] || [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
                        cell.textLabel.text = @"Show Sidebars In Landscape";
                        cell.accessoryView = _tabletMode;
                        break;
                    }
                case 4:
                    cell.textLabel.text = @"Open URLs in Chrome";
                    cell.accessoryView = _chrome;
                    break;
            }
            break;
        case 4:
            if(!cell) {
                cell = [[FontSizeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                ((FontSizeCell *)cell).fontSize = _fontSize;
            }
            break;
        case 5:
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"uploadsAvailable"]) {
                if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"imageService"] isEqualToString:@"imgur"] && row > 0)
                    row++;
            } else {
                row++;
            }
            switch (row) {
                case 0:
                    cell.textLabel.text = @"Image Service";
                    cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"imageService"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    cell.textLabel.text = @"Imgur.com Account";
                    cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"imgur_account_username"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 2:
                    cell.textLabel.text = @"Save to Camera Roll";
                    cell.accessoryView = _saveToCameraRoll;
                    break;
                case 3:
                    cell.textLabel.text = @"Image Size";
                    int size = [[[NSUserDefaults standardUserDefaults] objectForKey:@"photoSize"] intValue];
                    switch(size) {
                        case 512:
                            cell.detailTextLabel.text = @"Small";
                            break;
                        case 1024:
                            cell.detailTextLabel.text = @"Medium";
                            break;
                        case 2048:
                            cell.detailTextLabel.text = @"Large";
                            break;
                        case -1:
                            cell.detailTextLabel.text = @"Original";
                            break;
                    }
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
            }
            break;
        case 6:
            switch(row) {
                case 0:
                    cell.textLabel.text = @"FAQ";
                    break;
                case 1:
                    cell.textLabel.text = @"Feedback Channel";
                    break;
                case 2:
                    cell.textLabel.text = @"Open-Source Licenses";
                    break;
                case 3:
                    cell.textLabel.text = @"Version";
                    cell.detailTextLabel.text = _version;
                    break;
            }
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.tableView endEditing:YES];
    if(indexPath.section == 5) {
        NSInteger row = indexPath.row;
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"uploadsAvailable"]) {
            if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"imageService"] isEqualToString:@"imgur"] && row > 0)
                row++;
        } else {
            row++;
        }

        if(row == 0) {
            [self.navigationController pushViewController:[[ImageServiceViewController alloc] init] animated:YES];
        }
        if(row == 1) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imgur_access_token"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imgur_refresh_token"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imgur_account_username"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imgur_token_type"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imgur_expires_in"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController pushViewController:[[ImgurLoginViewController alloc] init] animated:YES];
        }
        if(row == 3) {
            [self.navigationController pushViewController:[[PhotoSizeViewController alloc] init] animated:YES];
        }
    }
    if(indexPath.section == 6 && indexPath.row == 0) {
        [(AppDelegate *)([UIApplication sharedApplication].delegate) launchURL:[NSURL URLWithString:@"https://www.irccloud.com/faq"]];
    }
    if(indexPath.section == 6 && indexPath.row == 1) {
        [self.tableView endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            [(AppDelegate *)([UIApplication sharedApplication].delegate) launchURL:[NSURL URLWithString:@"irc://irc.irccloud.com/%23feedback"]];
        }];
    }
    if(indexPath.section == 6 && indexPath.row == 2) {
        [self.navigationController pushViewController:[[LicenseViewController alloc] init] animated:YES];
    }
}

@end
