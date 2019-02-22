//
//  Model.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Class for handling game object models.
 * Most of this code is referenced from https://github.com/skyfe79/LearningOpenGLES2
 */
class Model : BufferManager {

    // Primitive types
    enum Primitive {
        case Cube;
    }
    
    // The model's vertices
    var vertices : [Vertex]
    
    // The model's indices
    var indices : [GLuint]
    
    // The model's texture
    var texture : GLuint;
    
    // Vertex array object
    var vao: GLuint;
    
    // Offsets
    var offset : BufferOffset;
    
    // Name of the model
    var name : String;
    
    init(vertices: [Vertex], indices: [GLuint], modelName: String) {
        // Initialize properties
        self.vertices = vertices;
        self.indices = indices;
        self.name = modelName;
        self.vao = 0;
        self.texture = 0;
        self.offset = BufferOffset();
        
        // Default texture
        loadTexture(filename: "default-texture.png");
    }
    
    /**
     * Renders this model.
     */
    func render() {
        glBindVertexArrayOES(vao);
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), BUFFER_OFFSET(offset.indexOffset * MemoryLayout<GLuint>.size));
        glBindVertexArrayOES(0);
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
        glGenTextures(1, &self.texture);
        glBindTexture(GLenum(GL_TEXTURE_2D), self.texture);
        
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
        if (texture != 0) {
            let textures : [GLuint] = [GLuint].init(repeating: texture, count: 1);
            glDeleteTextures(1, textures);
        }
    }
    
    /**
     * Creates a primitive model.
     * primitiveType - the type of primitive to create.
     * Returns a model based on the primitive type.
     */
    static func CreatePrimitive(primitiveType : Primitive) -> Model {
        // Vertices and indices of the model
        var vertices : [Vertex];
        var indices : [GLuint];
        var name : String;
        
        // Check which primitive type to make
        switch primitiveType {
        case Primitive.Cube:
            vertices = Cube.vertexList;
            indices = Cube.indexList;
            name = "PrimitiveCube";
            break;
        }
            
        return Model(vertices: vertices, indices: indices, modelName: name);
    }
    
    deinit {
        // Cleanup
        deleteTexture();
    }
}

/**
 * Struct for holding offset values for the vertex and index buffers.
 */
struct BufferOffset {
    
    // Offset for the vertex buffer
    var vertexOffset : Int;
    
    // Offset for the index buffer
    var indexOffset : Int;
    
    init() {
        vertexOffset = 0;
        indexOffset = 0;
    }
}
