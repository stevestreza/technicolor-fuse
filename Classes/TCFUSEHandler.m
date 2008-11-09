//
//  TCFUSEHandler.m
//  technicolor-fuse
//
//  Created by Steve Streza on 11/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TCFUSEHandler.h"


@implementation TCFUSEHandler

-(id)init{
	if(self = [super init]){
		childHandlers = [[NSMutableArray alloc] init];
	}
	return self;
}

-(BOOL)canHandlePath:(NSString *)path{
	BOOL handle = NO;
	for(TCFUSEHandler *handler in childHandlers){
		if([handler canHandlePath:path]){
			handle = YES;
			break;
		}
	}
	return handle;
}

- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error{
	NSArray *contents = nil;
	BOOL handle = NO;
	for(TCFUSEHandler *handler in childHandlers){
		if([handler canHandlePath:path]){
			contents = [handler contentsOfDirectoryAtPath:path error:error];			
			handle = YES;
			break;
		}
	}
	if(!handle){
		*error = [NSError errorWithDomain:@"TCFUSEHandlerDomain" 
									code:10 
								userInfo:[NSDictionary dictionaryWithObject:@"Unimplemented path" forKey:NSLocalizedDescriptionKey]];
		contents = [NSArray array];
	}
	return contents;
}

- (NSDictionary *)attributesOfItemAtPath:(NSString *)path 
                                   error:(NSError **)error{
	NSDictionary *contents = nil;
	BOOL handle = NO;
	for(TCFUSEHandler *handler in childHandlers){
		if([handler canHandlePath:path]){
			contents = [handler attributesOfItemAtPath:path error:error];
			handle = YES;
			break;
		}
	}
	if(!handle){
		*error = [NSError errorWithDomain:@"TCFUSEHandlerDomain" 
									 code:10 
								 userInfo:[NSDictionary dictionaryWithObject:@"Unimplemented path" forKey:NSLocalizedDescriptionKey]];
		contents = [NSDictionary dictionary];
	}
	return contents;
}

-(void)addHandler:(TCFUSEHandler *)handler{
	if(handler == self) return;
	if([childHandlers indexOfObject:handler] != NSNotFound) return;
	
	[childHandlers addObject:handler];
}

-(TCFUSEHandler *)handlerAtIndex:(NSUInteger)index{
	if(index >= childHandlers.count) return nil;
	return [childHandlers objectAtIndex:index];
}

-(NSUInteger)numberOfHandlers{
	return childHandlers.count;
}

@end
