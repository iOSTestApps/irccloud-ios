//
//  NotificationsDataSource.m
//  IRCCloud
//
//  Created by Sam Steele on 7/21/15.
//  Copyright © 2015 IRCCloud, Ltd. All rights reserved.
//

#import "NotificationsDataSource.h"
#import "BuffersDataSource.h"
#import "EventsDataSource.h"

@implementation NotificationsDataSource
+(NotificationsDataSource *)sharedInstance {
    static NotificationsDataSource *sharedInstance;
    
    @synchronized(self) {
        if(!sharedInstance)
            sharedInstance = [[NotificationsDataSource alloc] init];
        
        return sharedInstance;
    }
    return nil;
}

-(id)init {
    self = [super init];
    if(self) {
        if(!_notifications)
            _notifications = [[NSMutableDictionary alloc] init];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"cacheVersion"] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]) {
            NSString *cacheFile = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"notifications"];
            
            @try {
                NSArray *ns = [[NSKeyedUnarchiver unarchiveObjectWithFile:cacheFile] mutableCopy];
                for(UILocalNotification *n in ns) {
                    NSNumber *bid = [[n.userInfo objectForKey:@"d"] objectAtIndex:1];
                    if(![_notifications objectForKey:bid])
                        [_notifications setObject:[[NSMutableArray alloc] init] forKey:bid];
                    [[_notifications objectForKey:bid] addObject:n];
                }
            } @catch(NSException *e) {
                [[NSFileManager defaultManager] removeItemAtPath:cacheFile error:nil];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cacheVersion"];
            }
        }
    }
    return self;
}

-(void)serialize {
    NSString *cacheFile = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"notifications"];
    
    NSMutableArray *n;
    @synchronized(_notifications) {
        for(NSNumber *bid in _notifications.allKeys) {
            [n addObjectsFromArray:[_notifications objectForKey:bid]];
        }
    }
    
    @synchronized(self) {
        @try {
            [NSKeyedArchiver archiveRootObject:n toFile:cacheFile];
            [[NSURL fileURLWithPath:cacheFile] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:NULL];
        }
        @catch (NSException *exception) {
            [[NSFileManager defaultManager] removeItemAtPath:cacheFile error:nil];
        }
    }
}

-(void)clear {
    @synchronized(_notifications) {
        [_notifications removeAllObjects];
#ifndef EXTENSION
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
#endif
    }
}

-(void)notify:(NSString *)alert cid:(int)cid bid:(int)bid eid:(NSTimeInterval)eid {
#ifndef EXTENSION
    UILocalNotification *n = [[UILocalNotification alloc] init];
    n.alertTitle = @"IRCCloud";
    n.alertBody = alert;
    n.alertAction = @"Reply";
    n.userInfo = @{@"d": @[@(cid), @(bid), @(eid)]};
    @synchronized(_notifications) {
        if(![_notifications objectForKey:@(bid)])
            [_notifications setObject:[[NSMutableArray alloc] init] forKey:@(bid)];
        [[_notifications objectForKey:@(bid)] addObject:n];
    }
    //[[UIApplication sharedApplication] presentLocalNotificationNow:n];
#endif
}

-(void)removeNotificationsForBID:(int)bid olderThan:(NSTimeInterval)eid {
#ifndef EXTENSION
    @synchronized(_notifications) {
        NSArray *ns = [NSArray arrayWithArray:[_notifications objectForKey:@(bid)]];
        for(UILocalNotification *n in ns) {
            NSArray *d = [n.userInfo objectForKey:@"d"];
            if([[d objectAtIndex:1] intValue] == bid && [[d objectAtIndex:1] doubleValue] < eid) {
                [[UIApplication sharedApplication] cancelLocalNotification:n];
                [[_notifications objectForKey:@(bid)] removeObject:n];
            }
        }
        if(![[_notifications objectForKey:@(bid)] count])
            [_notifications removeObjectForKey:@(bid)];
    }
#endif
}

-(void)updateBadgeCount {
#ifndef EXTENSION
    int count = 0;
    NSArray *buffers = [[BuffersDataSource sharedInstance] getBuffers];
    for(Buffer *b in buffers) {
        count += [[EventsDataSource sharedInstance] highlightCountForBuffer:b.bid lastSeenEid:b.last_seen_eid type:b.type];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = count;
    if(!count)
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
#endif
}

@end
