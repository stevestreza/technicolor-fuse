//
//  TCFUSEPlugin.m
//  technicolor-fuse
//
//  Created by Steve Streza on 11/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TCFUSEPlugin.h"
#import "TCTVEpisode.h"

#import "TCMovieFUSEHandler.h"
#import "TCTVShowsFUSEHandler.h"

@implementation TCFUSEPlugin

TCUUID(@"568DFAA7-CC50-4B74-81D9-B1B94DF67A42")

#define TCFUSEPluginEnabled
#ifdef  TCFUSEPluginEnabled

-(void)awake{
	NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(didMount:)
				   name:kGMUserFileSystemDidMount object:nil];
	[center addObserver:self selector:@selector(didUnmount:)
				   name:kGMUserFileSystemDidUnmount object:nil];
	
	rootHandler = [[TCFUSEHandler alloc] init];
	
	TCMovieFUSEHandler *movieHandler   = [[TCMovieFUSEHandler   alloc] init];
	TCTVShowsFUSEHandler *showsHandler = [[TCTVShowsFUSEHandler alloc] init];
	
	[rootHandler addHandler:movieHandler];
	[rootHandler addHandler:showsHandler];
	
	fileSystem = [[GMUserFileSystem alloc] initWithDelegate:self isThreadSafe:YES];
	[fileSystem mountAtPath:@"/Volumes/Technicolor" withOptions:[NSArray arrayWithObjects:
																				@"ro",
																				@"volname=Technicolor",
																				nil]];
}

- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error{
	NSLog(@"contentsOfDirectoryAtPath: %@",path);
	if([path isEqualToString:@"/"]){
		return [NSArray arrayWithObjects:@"Movies",@"TV Shows",nil];
	}else{
		return [rootHandler contentsOfDirectoryAtPath:path error:error];
	}
}

-(void)didMount:(NSNotification *)notif{
	
}

-(void)didUnmount:(NSNotification *)notif{
	
}

- (NSDictionary *)attributesOfItemAtPath:(NSString *)path 
                                   error:(NSError **)error{
	NSLog(@"attributesOfItemAtPath: %@",path);
	if([path isEqualToString:@"/"]){
		return [NSDictionary dictionaryWithObjectsAndKeys:
				NSFileTypeDirectory, NSFileType,
				nil];	
	}else{
		return [rootHandler attributesOfItemAtPath:path error:error];
	}
}

// BSD-equivalent: open(2)
- (BOOL)openFileAtPath:(NSString *)path 
                  mode:(int)mode
          fileDelegate:(id *)fileDelegate
                 error:(NSError **)error{
	return [rootHandler openFileAtPath:path 
								  mode:mode
							  userData:fileDelegate
								 error:error];
}

// BSD-equivalent: close(2)
- (void)releaseFileAtPath:(NSString *)path fileDelegate:(id)fileDelegate{
	[rootHandler releaseFileAtPath:path userData:fileDelegate];
}

// This is only called if the fileDelegate is nil or does not implement the 
// readToBuffer:size:offset:error: method.
//
// BSD-equivalent: pread(2)
- (int)readFileAtPath:(NSString *)path 
         fileDelegate:(id)fileDelegate
               buffer:(char *)buffer 
                 size:(size_t)size 
               offset:(off_t)offset
                error:(NSError **)error{
	return [rootHandler readFileAtPath:path 
							  userData:fileDelegate 
								buffer:buffer
								  size:size 
								offset:offset 
								 error:error];
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[fileSystem unmount];
	[fileSystem release];
	
	[super dealloc];
}

#endif

@end
