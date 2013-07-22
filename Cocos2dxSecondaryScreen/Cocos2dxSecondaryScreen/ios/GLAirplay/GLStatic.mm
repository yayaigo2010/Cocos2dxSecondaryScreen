//
//  GLStatic.cpp
//  Cocos2dxSecondaryScreen
//
//  Created by Peter on 7/10/13.
//
//

#include "GLStatic.h"
#import "AppController.h"
void GLStatic::addSecondaryScreen()
{
    [[AppController instance] addSecondaryScreen];
}
void GLStatic::removeSecondaryScreen()
{
    [[AppController instance] removeSecondaryScreen];
}