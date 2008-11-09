//
//  TCFUSEHandler.h
//  technicolor-fuse
//
//  Created by Steve Streza on 11/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TCFUSEHandler : NSObject {
	NSMutableArray *childHandlers;
}

-(BOOL)canHandlePath:(NSString *)path;
- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error;
- (NSDictionary *)attributesOfItemAtPath:(NSString *)path 
                                   error:(NSError **)error;

-(void)addHandler:(TCFUSEHandler *)handler;
-(TCFUSEHandler *)handlerAtIndex:(NSUInteger)index;
-(NSUInteger)numberOfHandlers;
@end
