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
    
    // The id of the texture.
    var id : GLuint;
    
    /**
     * Default constructor.
     * id - the id of the texture
     */
    init(id: GLuint = 0) {
        self.id = id;
    }
    
    /**
     * Constructor that loads in a texture by its file name.
     * filename - the name of the texture file
     */
    init(filename: String) {
        self.id = 0;
        
        loadTexture(filename: filename);
    }
    
    /**
     * Loads a texture.
     * filename - the name of the texture file.
     */
    func loadTexture(filename: String) {
        deleteTexture(); // Delete existing texture if it exists
        
        // Path to the image
        let path = CFBundleCopyResourceURL(CFBundleGetMainBundle(), filename as NSString, "" as CFString, nil)
        
        // Create the image source
        let imageSource = CGImageSourceCreateWithURL(path!, nil)
        let image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)
        
        // Image dimensions
        let width = GLsizei((image?.width)!)
        let height = GLsizei((image?.height)!)
        
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
        glGenerateMipmap(GLenum(GL_TEXTURE_2D))
        
        // Deallocate memory that was used for the image
        free(imageData);
        
        // Unbind the texture for now
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        
        /*
         let path = Bundle.main.path(forResource: filename, ofType: nil)!
         let option = [ GLKTextureLoaderOriginBottomLeft: true]
         do {
         let info = try GLKTextureLoader.texture(withContentsOfFile: path, options: option as [String : NSNumber]?)
         self.texture = info.name
         } catch {
         print("*** Texture loading error ***");
         }
         */
    }
    
    /**
     * Deletes an existing texture from memory.
     */
    func deleteTexture() {
        // Cleanup if there is an existing texture
        if (id != 0) {
            glDeleteTextures(1, &id);
        }
    }
    
    deinit {
        // Cleanup
        deleteTexture();
    }
}
