//
//  NSManagedObjectContext+NLCoreData.m
//  
//  Created by Jesper Skrufve <jesper@neolo.gy>
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//  

#import "NSManagedObjectContext+NLCoreData.h"
#import "NSObject+AssociatedObjects.h"

@implementation NSManagedObjectContext (NLCoreData)

//static char* kSaveCompletionKey	= "saveCompletionBlock";

@dynamic
undoEnabled;

- (BOOL)save
{
	return [NLCoreData saveContext:self];
}

- (void)notifySharedContextOnSave
{
	[self notifyContextOnSave:[[NLCoreData shared] context]];
}

- (void)stopNotifyingSharedContextOnSave
{
	[self stopNotifyingContextOnSave:[[NLCoreData shared] context]];
}

- (void)notifyContextOnSave:(NSManagedObjectContext *)context
{
	[self notifyContextOnSave:context completion:NULL];
}

- (void)notifyContextOnSave:(NSManagedObjectContext *)context completion:(NLSaveCompletionBlock)completion
{
	dlog();
	if (!context || context == self) return;
	
//	[self associateValue:completion withKey:kSaveCompletionKey];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self selector:@selector(contextDidSave:)
	 name:NSManagedObjectContextDidSaveNotification object:context];
}

- (void)stopNotifyingContextOnSave:(NSManagedObjectContext *)context
{
	dlog();
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self name:NSManagedObjectContextDidSaveNotification object:context];
	
//	[self associateValue:nil withKey:kSaveCompletionKey];
}

- (void)contextDidSave:(NSNotification *)note
{
	dlog();
	[self mergeChangesFromContextDidSaveNotification:note];
	
//	NLSaveCompletionBlock completion = [self associatedValueForKey:kSaveCompletionKey];
//	if (completion) completion(note);
}

- (void)setUndoEnabled:(BOOL)undoEnabled
{
	if (undoEnabled && ![self isUndoEnabled]) [self setUndoManager:[[NSUndoManager alloc] init]];
	else if (!undoEnabled) [self setUndoManager:nil];
}

- (BOOL)isUndoEnabled
{
	return !![self undoManager];
}

@end