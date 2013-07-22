//
//  Cocos2dxSecondaryScreenAppController.mm
//  Cocos2dxSecondaryScreen
//
//  Created by Peter on 7/10/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppController.h"
#import "cocos2d.h"
#import "EAGLView.h"
#import "AppDelegate.h"

#import "RootViewController.h"

#import "GLViewController.h"

@implementation AppController

@synthesize window;
@synthesize viewController;
@synthesize windows;

#pragma mark -
#pragma mark Application lifecycle
static AppController* _instance;

GLViewController * gc;

// cocos2d application instance
static AppDelegate s_sharedApplication;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    EAGLView *__glView = [EAGLView viewWithFrame: [window bounds]
                                     pixelFormat: kEAGLColorFormatRGBA8
                                     depthFormat: GL_DEPTH_COMPONENT16
                              preserveBackbuffer: NO
                                      sharegroup: nil
                                   multiSampling: NO
                                 numberOfSamples:0 ];

    // Use RootViewController manage EAGLView
    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    viewController.wantsFullScreenLayout = YES;
    viewController.view = __glView;

    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [window addSubview: viewController.view];
    }
    else
    {
        // use this method on ios6
        [window setRootViewController:viewController];
    }
    
    [window makeKeyAndVisible];

    [[UIApplication sharedApplication] setStatusBarHidden: YES];

    cocos2d::CCApplication::sharedApplication()->run();
    
    _instance = self;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    cocos2d::CCDirector::sharedDirector()->pause();
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    cocos2d::CCDirector::sharedDirector()->resume();
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::CCApplication::sharedApplication()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::CCApplication::sharedApplication()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
     cocos2d::CCDirector::sharedDirector()->purgeCachedData();
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Private methods
- (UIWindow *) createWindowForScreen:(UIScreen *)screen {
    UIWindow    *_window    = nil;
    
    // Do we already have a window for this screen?
    for (UIWindow * windowPtr in self.windows){
        if (windowPtr.screen == screen){
            _window = windowPtr;
        }
    }
    // Still nil? Create a new one.
    if (_window == nil){
        CGRect bounds = [screen bounds];
        
        //can't control airplay screen size
        //bounds.size.width = 100;
        //bounds.size.height = 100;
        
        _window = [[UIWindow alloc] initWithFrame:bounds];
        [_window setScreen:screen];
        [self.windows addObject:_window];
    }
    
    return _window;
}
-(void)addSecondaryScreen
{
    if(gc)
        return;
    
    UIWindow    *_window    = nil;
    NSArray     *_screens   = nil;
    
    if(!windows)
        windows = [[NSMutableArray alloc] init];
    
    _screens = [UIScreen screens];
    for (UIScreen *_screen in _screens){
        
        if(_screen == [UIScreen mainScreen])
            continue;
        
//        if(gc)
//        {
//            [gc removeFromParentViewController];
//            [gc release];
//        }
        
        gc = [[GLViewController alloc] init];
        [gc setTargetScreen:_screen];
        [gc screenDidConnect:viewController];
        [gc startAnimation];
        //[(gc screenDidDisconnect:self.userInterfaceController];
        
        _window = [self createWindowForScreen:_screen];
        [self addViewController:gc toWindow:_window];
        
        
    }
    static bool addFinish = false;
    if(!addFinish)
    {
        //要改成完全用button控制開啟
        // Register for notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(screenDidConnect:)
                                                     name:UIScreenDidConnectNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(screenDidDisconnect:)
                                                     name:UIScreenDidDisconnectNotification
                                                   object:nil];
        addFinish = true;
    }
    cocos2d::CCLog("addSecondaryScreen");
}
- (void) addViewController:(UIViewController *)controller toWindow:(UIWindow *)windowPtr {
    [windowPtr setRootViewController:controller];
    [windowPtr setHidden:NO];
}
-(void) removeSecondaryScreen
{
    if(!gc)
        return;
    NSArray     *_screens   = nil;
    _screens = [UIScreen screens];
    
  
    for (UIWindow __strong *_window in self.windows){
        if (_window.screen != [UIScreen mainScreen]){
            NSUInteger windowIndex = [self.windows indexOfObject:_window];
            
            [self.windows removeObjectAtIndex:windowIndex];
            // If it wasn't autorelease, you would deallocate it here.
            [gc.view removeFromSuperview];
            [gc release];
            gc = nil;
            [_window release];
            _window = nil;
            
        }
    }
    
    cocos2d::CCLog("removeSecondaryScreen");
}
- (void) screenDidConnect:(NSNotification *) notification {
    UIScreen    *_screen    = nil;
    UIWindow    *_window    = nil;
    
    NSLog(@"Screen connected");
    _screen = [notification object];
    
    // Get a window for it
    gc = [[GLViewController alloc] init];
    _window = [self createWindowForScreen:_screen];
    
    // Add the view controller to it
    // This view controller does not do anything special, just presents a view that tells us
    // what screen we're on
    [self addViewController:gc toWindow:_window];
    
}

- (void) screenDidDisconnect:(NSNotification *) notification {
    UIScreen    *_screen    = nil;
    
    NSLog(@"Screen disconnected");
    _screen = [notification object];
    
    // Find any window attached to this screen, remove it from our window list, and release it.
    for (UIWindow __strong *_window in self.windows){
        if (_window.screen == _screen){
            NSUInteger windowIndex = [self.windows indexOfObject:_window];
            [self.windows removeObjectAtIndex:windowIndex];
            // If it wasn't autorelease, you would deallocate it here.
            _window = nil;
        }
    }
    return;
}

+(AppController*) instance
{
    return _instance;
}
@end

