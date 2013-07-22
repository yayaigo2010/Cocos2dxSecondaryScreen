//
//  Cocos2dxSecondaryScreenAppController.h
//  Cocos2dxSecondaryScreen
//
//  Created by Peter on 7/10/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

@class RootViewController;

@interface AppController : NSObject <UIAccelerometerDelegate, UIAlertViewDelegate, UITextFieldDelegate,UIApplicationDelegate> {
    UIWindow *window;
    RootViewController    *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *viewController;



@property (nonatomic, strong) NSMutableArray *windows;
-(void)addSecondaryScreen;
-(void)removeSecondaryScreen;
+(AppController*) instance;
@end

