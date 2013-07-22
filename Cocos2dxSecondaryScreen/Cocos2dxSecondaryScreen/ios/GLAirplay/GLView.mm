/*
     File: GLView.m
 Abstract: The OpenGL ES view which renders a rotating cube. Responsible for creating a CADisplayLink for the new target display when a connection/disconnection occurs.
  Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

/*
 
    add comment by peter
 
    My cocos2dx version:cocos2d-2.1beta3-x-2.1.0
 
    I disable CC_TEXTURE_ATLAS_USE_VAO (I am not sure must do it?)
    
    CCDirectorCaller
    add #import "EAGLView.h"
 
    -(void) doCaller: (id) sender
    {
    add [EAGLContext setCurrentContext:[[EAGLView sharedEGLView]context]];
        ....
    }
 
    to avoid autorelease in mainloop by CCPoolManager
    add CCScene::create2()
    add CCLayer::create2()
    add CCSprite::create2()
    and GLView call these to create Scene
 
 Instrument result:
 Severity	Total   Occurrences	Unique Occurrences	Category	Summary
 3          107706	1                               Recommend Using VBO	Vertex array not contained in buffer object
 3          67422	17                              Redundant Call	Redundant state call
 3          29918	1                               Recommend Using VAO	Lack of vertex array objects
 3          9001	2                               Unnecessary Logical Buffer Store	Unnecessary logical buffer store operation
 3          3019	1                               Recommend Indexed Rendering	Recommend indexed primitives for lines and triangles
 2          480     1                               Texture Format Compactness	8-bit per channel texture format
 3          387     2                               Logical Buffer Load	Slow framebuffer load
 3          1       1                               Inefficient State Update	Inefficient state update
 2          1       1                               State Query Call Count	Numerous state query calls in current frame

 
 Capture OpenGL ES frame result:
 
 file://localhost/Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/ios/GLAirplay/GLView.mm: warning: Redundant Call: glBindFramebuffer(GL_FRAMEBUFFER, 2u) set a piece of GL state to its current value.
 
 file://localhost/Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/ios/GLAirplay/GLView.mm: warning: Redundant Call: glBindRenderbuffer(GL_RENDERBUFFER, 3u) set a piece of GL state to its current value.
 
 file://localhost/Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/ios/GLAirplay/GLView.mm: warning: Redundant Call: glClearColor(0.0000000f, 0.0000000f, 0.0000000f, 1.0000000f) set a piece of GL state to its current value.
 
 /Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/libs/cocos2dx/shaders/CCGLProgram.cpp
 file://localhost/Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/libs/cocos2dx/shaders/CCGLProgram.cpp: error: GL Error: Invalid Operation: The specified operation is invalid for the current OpenGL state.
 
 /Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/libs/cocos2dx/shaders/ccGLStateCache.cpp
 file://localhost/Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/libs/cocos2dx/shaders/ccGLStateCache.cpp: warning: Redundant Call: glActiveTexture(GL_TEXTURE0) set a piece of GL state to its current value.
 
 file://localhost/Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/libs/cocos2dx/shaders/ccGLStateCache.cpp: warning: Redundant Call: glBindTexture(GL_TEXTURE_2D, 2u) set a piece of GL state to its current value.
 
 /Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/libs/cocos2dx/sprite_nodes/CCSprite.cpp
 file://localhost/Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/libs/cocos2dx/sprite_nodes/CCSprite.cpp: warning: Redundant Call: glVertexAttribPointer(0u, 3, GL_FLOAT, 0u, 24, 0x1eb175dc) set a piece of GL state to its current value.
 
 file://localhost/Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/libs/cocos2dx/sprite_nodes/CCSprite.cpp: warning: Redundant Call: glVertexAttribPointer(2u, 2, GL_FLOAT, 0u, 24, 0x1eb175ec) set a piece of GL state to its current value.
 
 file://localhost/Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/libs/cocos2dx/sprite_nodes/CCSprite.cpp: warning: Redundant Call: glVertexAttribPointer(1u, 4, GL_UNSIGNED_BYTE, 1u, 24, 0x1eb175e8) set a piece of GL state to its current value.
 
 file://localhost/Users/peter/Desktop/Work/Project/Cocos2dxSecondaryScreen/Cocos2dxSecondaryScreen/libs/cocos2dx/sprite_nodes/CCSprite.cpp: error: Use of Non-Existent Program: Program #0 was set to be used for this draw call, but it does not exist. Ensure this program has not been deleted.

 
 CCSprite 不addChild,不會有openGL 502 error
 
 CCSprite 拿掉CC_NODE_DRAW_SETUP,就沒error,但也不會render
 
 */

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>

#import "GLView.h"

#import "EAGLView.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

GLfloat gCubeVertexData[216] =
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};

static double GetTimeMS()
{
	return (CACurrentMediaTime()*1000.0);
}


@interface GLView ()
{
    NSInteger _animationFrameInterval;
	CADisplayLink *_displayLink;
    UIScreen *_targetScreen;
    
    EAGLContext *_context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint _backingWidth;
	GLint _backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint _defaultFramebuffer, _colorRenderbuffer;
    
    // The OpenGL frame for the depth buffer
    GLuint _depthRenderbuffer;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    float _rotation;
    float _radius;
    
    double _renderTime;
    BOOL _zeroDeltaTime;
}

@property (nonatomic, strong) GLKBaseEffect *effect;


@end


@implementation GLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}
- (id) initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {

        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
        //modify by peter
        //need use sharegroup to create another EAGLContext
        //[[EAGLView sharedEGLView ]sharegroup] is nil,add Sharegroup DIY in EAGLView initWithFrame()
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup: [[[EAGLView sharedEGLView ]context]sharegroup]];
        
        if (!_context || ![EAGLContext setCurrentContext:_context])
		{
            return nil;
        }
        
        //switch the type to test
        //type = GLVIEW_RENDER_OPENGL_BOX; //success
        type = GLVIEW_RENDER_COCOS2DX_SCENE;//have error,can't render normally

        if(type == GLVIEW_RENDER_OPENGL_BOX)
            [self setupGL];
        else
        {
            [self setupGL];
            [self setupCCScene];
        }
		_animating = FALSE;
        _animationFrameInterval = 1;
		_displayLink = nil;
        
        _zeroDeltaTime = TRUE;
        

    }
    
    return self;
}

// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

        
        if (!_context || ![EAGLContext setCurrentContext:_context])
		{
            return nil;
        }
        
        [self setupGL];
        
		_animating = FALSE;
        _animationFrameInterval = 1;
		_displayLink = nil;
        
        _zeroDeltaTime = TRUE;
    }
	
    return self;
}
- (void)setupCCScene
{
    //refer to:CCES2Renderer  initWithDepthFormat
//    glGenFramebuffers(1, &_defaultFramebuffer);
//    NSAssert( _defaultFramebuffer, @"Can't create default frame buffer");
//    
//    glGenRenderbuffers(1, &_colorRenderbuffer);
//    NSAssert( _colorRenderbuffer, @"Can't create default render buffer");
//    
//    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
//    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
    
    //this function make CCScene* autorelease,ChangeScene remove
    
    m_pRunningScene = CCScene::create2();
    //m_pRunningScene->setContentSize(CCSizeMake(1920, 720));
    CCLayer* layer = CCLayer::create2();
    //layer->setContentSize(CCSizeMake(1920, 720));
    
    cocos2d::CCSprite* pSprite = CCSprite::create2("Icon-72.png");
    // position the sprite on the center of the screen
    pSprite->setPosition( cocos2d::CCPointMake(300, 300) );
    layer->addChild(pSprite, 0);
    
//also crash the same OpenGL 502 error 
//    CCLabelTTF* t = CCLabelTTF::create("", "Helvetica", 12);
//    layer->addChild(t, 0);
    
    
    m_pRunningScene->addChild(layer);
    
}
- (void)setupGL
{
            
    // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
    glGenFramebuffers(1, &_defaultFramebuffer); 
    glGenRenderbuffers(1, &_colorRenderbuffer);
    NSAssert( _defaultFramebuffer, @"Can't create default frame buffer");
    NSAssert( _colorRenderbuffer, @"Can't create default render buffer");

    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);

    // Create a depth buffer as we want to enalbe GL_DEPTH_TEST in this sample
    if(type == GLVIEW_RENDER_OPENGL_BOX)
    {
        glEnable(GL_DEPTH_TEST);
        glGenRenderbuffers(1, &_depthRenderbuffer);
        
        // Create a GLKBaseEffect to render the object
        self.effect = [[GLKBaseEffect alloc] init];
        self.effect.light0.enabled = GL_TRUE;
        self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
        
        // Create a VAO that stores the cube vertex and normal data
        glGenVertexArraysOES(1, &_vertexArray);
        glBindVertexArrayOES(_vertexArray);
        
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
        
        glBindVertexArrayOES(0);
    }
}

- (void)drawView:(id)sender
{
    double currentTime = GetTimeMS();
    double deltaTime = _zeroDeltaTime ? 0.0 : currentTime - _renderTime;
    _renderTime = currentTime;
    
    if (_zeroDeltaTime)
        _zeroDeltaTime = FALSE;
    
    //must to Do , to support two openGLView
    [EAGLContext setCurrentContext:_context];
    
    //there is no need for re-binding frame- and render-buffers since your context is preserved.
    //but take away , it'll not show 
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFramebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);//must do
    
    glViewport(0, 0, _backingWidth, _backingHeight);
    
    glClearColor(0, 0, 0, 1.0f);
    
    /*
     Cocos2d: removeSecondaryScreen
     2013-07-10 18:21:23.467 Cocos2dxSecondaryScreen[2668:907] Failed to make complete framebuffer object 8cdd
     Cocos2d: addSecondaryScreen
     2013-07-10 18:21:23.759 Cocos2dxSecondaryScreen[2668:907] Received memory warning.
     Cocos2d: cocos2d: CCTextureCache: texture: /var/mobile/Applications/87D2A66E-1835-4215-95EE-9BF9C80182E5/Cocos2dxSecondaryScreen.app/CloseNormal.png
     Cocos2d: cocos2d: CCTextureCache: texture: /var/mobile/Applications/87D2A66E-1835-4215-95EE-9BF9C80182E5/Cocos2dxSecondaryScreen.app/CloseSelected.png
     Cocos2d: cocos2d: CCTextureCache: texture: /var/mobile/Applications/87D2A66E-1835-4215-95EE-9BF9C80182E5/Cocos2dxSecondaryScreen.app/HelloWorld.png
     
     fixed:GLView need release.
     */
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if(type == GLVIEW_RENDER_OPENGL_BOX)
        [self drawOpenGLES:deltaTime];
    else
        [self drawCCScene:deltaTime];
    

    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    //////////add by peter////////////
    //support multiple OpenGLView,refer to:http://stackoverflow.com/questions/8111345/ios-and-multiple-opengl-views
    // Unbind and flush
    //not need to do this.
    //glBindFramebuffer(GL_FRAMEBUFFER,0);
    //glBindBuffer (GL_ARRAY_BUFFER, 0);
    glFlush();
    ////////////////////////////////
    

}
- (void)drawCCScene:(float)deltaTime
{

    kmGLPushMatrix();
    
    
    //跑一兩個frame,不會當,但之後會變bad pointer
    //void visit do return,it still crash,m_pRunningScene is BAD point? 
    // draw the scene
    // because CCScene auto release at mainLoop
    m_pRunningScene->visit();
    
    kmGLPopMatrix();
}
- (void)drawOpenGLES:(float) deltaTime
{
    // Update animation states
    
    //mark by peter,crash
    //if (self.userControlDelegate)
    // _radius = [self.userControlDelegate rotatingRadius];
    
    _rotation += deltaTime * 0.05 * M_PI / 180.0;
    
    // Update OpenGL
    
    glBindVertexArrayOES(_vertexArray);
    
    // Compute the projection matrix
    float aspect = (GLfloat)_backingWidth / (GLfloat)_backingHeight;
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // Compute the model view matrix
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -4.0f);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -fabs(_radius));
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    // Render the object with GLKit
    [self.effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);

}
- (BOOL)resizeFromLayer
{

    CAEAGLLayer *layer = (CAEAGLLayer*)self.layer;
    
	// Allocate color buffer backing based on the current layer size
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    

    if(type == GLVIEW_RENDER_OPENGL_BOX)
    {
        // Allocate storage for the depth buffer, and attach it to the framebuffer’s depth attachment point
        glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _backingWidth, _backingHeight);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderbuffer);
    }
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        //add/remove Secondary screen 5次以上就會出現以下錯誤:
        //Failed to make complete framebuffer object 8cdd ,GL_FRAMEBUFFER_UNSUPPORTED
        //   The combination of internal formats of the attached images violates an implementation-dependent set of restrictions.
        //GL Error 0x0506 GL_INVALID_FRAMEBUFFER_OPERATION
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
        
    return YES;
}

- (void)layoutSubviews
{
	if ([self resizeFromLayer])
    {
        // An external display might just have been connected/disconnected. We do not want to
        // consider time spent in the connection/disconnection in the animation.
        _zeroDeltaTime = TRUE;
        [self drawView:nil];
    }
}

#pragma Display Link 

- (NSInteger)animationFrameInterval
{
	return _animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1)
	{
		_animationFrameInterval = frameInterval;
		
		if (_animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (UIScreen *)targetScreen
{
    return _targetScreen;
}

- (void)setTargetScreen:(UIScreen *)screen
{
    if (_targetScreen != screen)
    {
        _targetScreen = screen;
    
        if (_animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
    }
}

- (void)startAnimation
{
	if (!_animating)
	{
        if (self.targetScreen) {
            // Create a CADisplayLink for the target display.
            // This will result in the native fps for whatever display you create it from.
            _displayLink = [self.targetScreen displayLinkWithTarget:self selector:@selector(drawView:)];
        }
        else {
            // Fall back to use CADislayLink's class method.
            // A CADisplayLink created using the class method is always bound to the internal display.
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        }
        [_displayLink setFrameInterval:self.animationFrameInterval];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

        
        // An external display might just have been connected/disconnected. We do not want to
        // consider time spent in the connection/disconnection in the animation.
        _zeroDeltaTime = TRUE;
        
		_animating = TRUE;
	}
}

- (void)stopAnimation
{
	if (_animating)
	{
        [_displayLink invalidate];
        _displayLink = nil;
        
		
		_animating = FALSE;
	}
}

- (void)dealloc
{
    
    // tear down OpenGL
	if (_defaultFramebuffer)
	{
		glDeleteFramebuffers(1, &_defaultFramebuffer);
		_defaultFramebuffer = 0;
	}
	
	if (_colorRenderbuffer)
	{
		glDeleteRenderbuffers(1, &_colorRenderbuffer);
		_colorRenderbuffer = 0;
	}
    
    if(_depthRenderbuffer)
    {
     	glDeleteRenderbuffers(1, &_depthRenderbuffer);   
        _depthRenderbuffer = 0;
    }
    
    if(_effect)
    {
        [_effect release];
        _effect = 0;
    }
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    // tear down context
	if ([EAGLContext currentContext] == _context)
        [EAGLContext setCurrentContext:nil];
    
    [_context release];
    _context = nil;
    
    [super dealloc];
    
    if(m_pRunningScene)
    {
        m_pRunningScene->release();
        m_pRunningScene = NULL;
    }
    //NSLog(@"GLView dealloc");
}

@end
