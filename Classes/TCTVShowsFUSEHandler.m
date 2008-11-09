//
//  TCTVShowsFUSEHandler.m
//  technicolor-fuse
//
//  Created by Steve Streza on 11/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TCTVShowsFUSEHandler.h"
#import "TCTVShow.h"
#import "TCTVEpisode.h"

@implementation TCTVShowsFUSEHandler
-(BOOL)canHandlePath:(NSString *)path{
	return ([path rangeOfString:@"/TV Shows"].location == 0);
}

- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error{
	NSMutableArray *movieNames = [NSMutableArray array];
	if([path isEqualToString:@"/TV Shows"]){
		NSArray *movies = [TCTVShow allShows:YES];
		for(TCTVShow *show in movies){
			NSString *name = [show valueForKeyPath:@"showName"];
			[movieNames addObject:name];
		}
	}else{
		NSArray *pathComponents = [path pathComponents];
		pathComponents = [pathComponents subarrayWithRange:NSMakeRange(1, pathComponents.count-1)];
		NSLog(@"Path components: %@",pathComponents);
		//TV Shows/South Park/Season 5/501 - Scott Tenorman Must Die.avi
		if(pathComponents.count >= 2){
			TCTVShow *show = [TCTVShow showWithName:[pathComponents objectAtIndex:1]];
			NSLog(@"Adding episodes for %@",[show showName]);
			if(pathComponents.count < 3){
				NSUInteger numberOfSeasons = [(NSNumber *)[show valueForKeyPath:@"numberOfSeasons"] unsignedIntegerValue];
				NSUInteger index=0;
				for(index; index < numberOfSeasons; index++){
					NSString *seasonName = [NSString stringWithFormat:@"Season %i",(index+1)];
					NSLog(@"Season adding %@ for show %@",seasonName, [show valueForKeyPath:@"showName"]);
					[movieNames addObject:seasonName];
				}
			}else{
				NSUInteger seasonNumber = (NSUInteger)([(NSString *)[[pathComponents objectAtIndex:2] substringFromIndex:[@"Season " length]] intValue]);
				NSArray *episodes = [show episodesInSeason:seasonNumber];
				for(TCTVEpisode *episode in episodes){
					NSString *name = [NSString stringWithFormat:@"%ix%02i - %@",
									  seasonNumber,
									  [[episode valueForKeyPath:@"episodeNumber"] intValue],
									  [episode valueForKeyPath:@"episodeName"]];
					
					NSLog(@"Adding %@ for %@",name,[show valueForKeyPath:@"showName"]);
					
					[movieNames addObject:name];
				}
				//			}else{
				
				//			}
			}
		}
	}
	return movieNames;	
}

- (NSDictionary *)attributesOfItemAtPath:(NSString *)path 
								   error:(NSError **)error{
	return [NSDictionary dictionaryWithObjectsAndKeys:
			NSFileTypeDirectory, NSFileType,
			nil];
}
@end
