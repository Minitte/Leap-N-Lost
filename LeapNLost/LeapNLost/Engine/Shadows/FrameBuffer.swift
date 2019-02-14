//
//  FrameBuffer.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-13.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

class FrameBuffer {
    
    // The name of the buffer as an int
    var bufferName : GLuint;
    
    // The depth texture
    var depthTexture : GLuint;
    
    init() {
        // Initialize variables
        bufferName = 0;
        depthTexture = 0;
        
        // Generate buffers and texture
        generateFrameBuffer();
        generateDepthTexture();
    }
    
    func generateFrameBuffer() {
        // Generate the frame buffer
        glGenFramebuffers(1, &bufferName);
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), bufferName);
    }
    
    func generateDepthTexture() {
        // Generate the depth texture
        glGenTextures(1, &depthTexture);
        glBindTexture(GLenum(GL_TEXTURE_2D), depthTexture);
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_DEPTH_COMPONENT, 1024, 1024, 0,GLenum(GL_DEPTH_COMPONENT), GLenum(GL_UNSIGNED_INT), nil);

        // Set texture parameters
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR);
        
        // we do not want to wrap, this will cause incorrect shadows to be rendered
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        
        // set up the depth compare function to check the shadow depth in hardware
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_COMPARE_FUNC_EXT), GL_LEQUAL);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_COMPARE_MODE_EXT), GL_COMPARE_REF_TO_TEXTURE_EXT);
        
        // Bind the texture to the buffer
        glFramebufferTexture2D(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_TEXTURE_2D), depthTexture, 0);
        
        // Check if the frame buffer was successfully generated
        if(glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GLenum(GL_FRAMEBUFFER_COMPLETE)) {
            print("*** Error generating frame buffer ***");
        }
        // Check for errors
        if (glGetError() != GLenum(GL_NO_ERROR)) {
            print("GL Errors in FrameBuffer.generateDepthTexture()");
        }
        
        // Go back to default frame buffer
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), 0);
    }
}
