//
//  TCFileSystem.m
//  technicolor-fuse
//
//  Created by Steve Streza on 11/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TCFileSystem.h"


@implementation TCFileSystem

-(id)init{
	if(self = [super initWithDelegate:self
						 isThreadSafe:YES]){
		
	}
	return self;
}

@end
