//
//  TCFUSEPlugin.h
//  technicolor-fuse
//
//  Created by Steve Streza on 11/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Technicolor.h"
#import "TCOrganizationPlugin.h"
#import <MacFUSE/MacFUSE.h>
#import "TCFUSEHandler.h"

@interface TCFUSEPlugin : TCOrganizationPlugin {
	GMUserFileSystem *fileSystem;
	TCFUSEHandler *rootHandler;
}

@end
