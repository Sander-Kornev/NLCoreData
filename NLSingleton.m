//
//  NLSingleton.m
//
//  Created by j on 28/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NLSingleton.h"

static NSMutableDictionary* Shared_ = nil;

@interface NLSingleton ()

+ (void)initializeShared;

@end

#pragma mark -
@implementation NLSingleton

+ (id)shared
{
	[self initializeShared];
	id instance = [Shared_ objectForKey:[self class]];
	
	@synchronized(self) {
		if (!instance) {
			
			instance = [[[self class] alloc] init];
			[Shared_ setObject:instance forKey:NSStringFromClass([self class])];
		}
	}
	return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
	[self initializeShared];
	id instance = [Shared_ objectForKey:[self class]];
	
	@synchronized(self) {
		if (!instance) {
			
			instance = [super allocWithZone:zone];
			[Shared_ setObject:instance forKey:NSStringFromClass([self class])];
			
			return instance;
		}
	}
	return nil;
}

+ (void)initializeShared
{
	if (!Shared_) {
		Shared_ = [[NSMutableDictionary alloc] init];
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (unsigned)retainCount
{
	return NSUIntegerMax;
}

- (oneway void)release
{
}

- (id)autorelease
{
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end
