//
//  Texture.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-22.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Class for storing texture logic.
 */
class Texture {
    
    static var textureDictionary : [String : GLuint] = [:];
    
    // The id of the texture.
    var id : GLuint;
    
    // The texture's width.
    var width : GLsizei;
    
    // The texture's height.
    var height : GLsizei;
    
    /**
     * Default constructor.
     */
    init() {
        self.id = 0;
        self.width = 0;
        self.height = 0;
    }
    
    /**
     * Constructor that loads in a texture by its file name.
     * fileName - the name of the texture file
     */
    init(fileName: String) {
        self.id = 0;
        self.width = 0;
        self.height = 0;
        
        loadTexture(fileName: fileName);
    }
    
    /**
     * Loads a texture.
     * filename - the name of the texture file.
     */
    func loadTexture(fileName: String) {
        if (Texture.textureDictionary[fileName] != nil) {
            id = Texture.textureDictionary[fileName]!;
            return;
        }
        
        // Path to the image
        let path = CFBundleCopyResourceURL(CFBundleGetMainBundle(), fileName as NSString, "" as CFString, nil)
        
        // Create the image source
        let imageSource = CGImageSourceCreateWithURL(path!, nil)
        let image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)
        
        // Image dimensions
        let width = GLsizei((image?.width)!)
        let height = GLsizei((image?.height)!)
        
        // Update instance dimensions
        self.width = width;
        self.height = height;
        
        // Create a rectangle to draw the image onto
        let zero: CGFloat = 0
        let rect = CGRect(x: zero, y: zero, width: CGFloat(Int(width)), height: CGFloat(Int(height)))
        let colourSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate space for the image
        let imageData: UnsafeMutableRawPointer = malloc(Int(width * height * GLsizei(MemoryLayout<Int>.size)))
        
        // Create the CGContext
        let ctx = CGContext(data: imageData, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: Int(width * 4), space: colourSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        // Draw the image onto the rectangle object
        ctx?.translateBy(x: zero, y: CGFloat(Int(height)))
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.setBlendMode(CGBlendMode.copy)
        ctx?.draw(image!, in: rect)
        
        // Generate a new OpenGL texture
        glGenTextures(1, &self.id);
        glBindTexture(GLenum(GL_TEXTURE_2D), self.id);
        
        // Set texture parameters
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        
        // Load the image onto the texture
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, width, height, 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), imageData);
        
        // Only generate mipmaps for textures that are a power of 2
        if ((width & width-1) == 0 && (height & height-1) == 0) {
            glGenerateMipmap(GLenum(GL_TEXTURE_2D));
        }
        
        // Deallocate memory that was used for the image
        free(imageData);
        
        // Unbind the texture for now
        glBindTexture(GLenum(GL_TEXTURE_2D), 0);
        
        Texture.textureDictionary[fileName] = self.id;
    }
}
