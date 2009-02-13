//
//  TCFUSEHandler.m
//  technicolor-fuse
//
//  Created by Steve Streza on 11/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TCFUSEHandler.h"
#import "TCVideo.h"

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

- (BOOL)openFileAtPath:(NSString *)path 
                  mode:(int)mode
              userData:(id *)userData
                 error:(NSError **)error {
	NSLog(@"Opening path %@",path);
	TCVideo *video = [self videoAtPath:path];
	NSLog(@"Got video %@",video);
	if(!video){
		return NO;
	}
	
	NSString* p = [[video anyFile] valueForKey:@"path"];
	NSLog(@"Mapping \n%@\n  to\ %@",path,p);
	if(!path){
		return NO;
	}
	
	int fd = open([p UTF8String], mode);
	if ( fd < 0 ) {
		*error = [NSError errorWithPOSIXCode:errno];
		return NO;
	}
	NSLog(@"Opened %@ to fd %i",p,fd);
	*userData = [NSNumber numberWithLong:fd];
	return YES;
}

- (void)releaseFileAtPath:(NSString *)path userData:(id)userData {
	NSNumber* num = (NSNumber *)userData;
	int fd = [num longValue];
	close(fd);
}

- (int)readFileAtPath:(NSString *)path 
             userData:(id)userData
               buffer:(char *)buffer 
                 size:(size_t)size 
               offset:(off_t)offset
                error:(NSError **)error {
	NSNumber* num = (NSNumber *)userData;
	int fd = [num longValue];
	int ret = pread(fd, buffer, size, offset);
	if ( ret < 0 ) {
		*error = [NSError errorWithPOSIXCode:errno];
		return -1;
	}
	return ret;
}	

-(TCVideo *)videoAtPath:(NSString *)path{
	TCVideo *video = nil;
	for(TCFUSEHandler *handler in childHandlers){
		if([handler canHandlePath:path]){
			video = [handler videoAtPath:path];
			break;
		}
	}
	return video;
}
@end
