//
//  TCMovieFUSEHandler.m
//  technicolor-fuse
//
//  Created by Steve Streza on 11/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TCMovieFUSEHandler.h"
#import "TCMovieVideo.h"

@implementation TCMovieFUSEHandler

-(BOOL)canHandlePath:(NSString *)path{
	return ([path rangeOfString:@"/Movies"].location == 0);
}

- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error{
	NSArray *movies = [TCMovieVideo allMovies:YES];
	NSArray *movieNames = [NSMutableArray array];
	for(TCMovieVideo *movie in movies){
		id name = [movie valueForKeyPath:@"movie.name"];
		
		[movieNames addObject:name]; 
	}
	return movieNames;	
}

- (NSDictionary *)attributesOfItemAtPath:(NSString *)path 
                                   error:(NSError **)error{
	return [NSDictionary dictionaryWithObjectsAndKeys:
			NSFileTypeDirectory, NSFileType,
			nil];	
}

-(TCVideo *)videoAtPath:(NSString *)path{
	TCVideo *video = nil;
	
	NSString *movieName = [[path substringFromIndex:[@"/Movies/" length]] stringByDeletingPathExtension];
	
	NSArray *movies = [TCMovieVideo videosForPredicate:[NSPredicate predicateWithFormat:@"movie.name == %@",movieName]];
	for(TCMovieVideo *movie in movies){
		if([[movie valueForKeyPath:@"movie.name"] isEqualToString:movieName]){
			video = movie;
		}
	}
	
	if(!video){
		video = [super videoAtPath:path];
	}
	
	return video;
}

@end
