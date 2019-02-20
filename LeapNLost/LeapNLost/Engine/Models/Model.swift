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
class Model {
    
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
    
    // Buffers
    var vao: GLuint;
    var vertexBuffer: GLuint;
    var indexBuffer: GLuint;
    
    init(vertices: [Vertex], indices: [GLuint]) {
        // Initialize properties
        self.vertices = vertices;
        self.indices = indices;
        vao = 0;
        vertexBuffer = 0;
        indexBuffer = 0;
        texture = 0;
        
        // Load a crate texture for testing purposes
        // default texture
        loadTexture(filename: "default-texture.png");
        
        // Generate and bind the vertex array object
        glGenVertexArraysOES(1, &vao);
        glBindVertexArrayOES(vao);
        
        // Generate and bind the vertex buffer
        glGenBuffers(GLsizei(1), &vertexBuffer);
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer);
        
        // Generate and bind the index buffer
        glGenBuffers(GLsizei(1), &indexBuffer);
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer);
        
        // Model properties
        let count = vertices.count;
        let size =  MemoryLayout<Vertex>.size;
        
        // Load vertices and indices into buffers
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, vertices, GLenum(GL_STATIC_DRAW));
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count * MemoryLayout<GLuint>.size, indices, GLenum(GL_STATIC_DRAW));
        
        // Vertices
        glEnableVertexAttribArray(VertexAttributes.position.rawValue);
        glVertexAttribPointer(
            VertexAttributes.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(0));
        
        // Colour
        glEnableVertexAttribArray(VertexAttributes.color.rawValue);
        glVertexAttribPointer(
            VertexAttributes.color.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(3 * MemoryLayout<GLfloat>.size));
        
        // Texture
        glEnableVertexAttribArray(VertexAttributes.texCoord.rawValue)
        glVertexAttribPointer(
            VertexAttributes.texCoord.rawValue,
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(7 * MemoryLayout<GLfloat>.size))
        
        // Normals
        glEnableVertexAttribArray(VertexAttributes.normal.rawValue)
        glVertexAttribPointer(
            VertexAttributes.normal.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(9 * MemoryLayout<GLfloat>.size))
        
        // Bind the buffers
        glBindVertexArrayOES(0);
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0);
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0);
    }
    
    /**
     * Renders this model.
     */
    func render() {
        glBindVertexArrayOES(vao);
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), nil);
        glBindVertexArrayOES(0);
    }
    
    /**
     * Loads a texture.
     * filename - the name of the texture file.
     */
    func loadTexture(filename: String) {
        deleteTexture(); // Delete existing texture if it exists
        
        let path = Bundle.main.path(forResource: filename, ofType: nil)!
        let option = [ GLKTextureLoaderOriginBottomLeft: true]
        do {
            let info = try GLKTextureLoader.texture(withContentsOfFile: path, options: option as [String : NSNumber]?)
            self.texture = info.name
        } catch {
            print("*** Texture loading error ***");
        }
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
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer.init(bitPattern: n);
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
        
        // Check which primitive type to make
        switch primitiveType {
        case Primitive.Cube:
            vertices = Cube.vertexList;
            indices = Cube.indexList;
            break;
        }
            
        return Model(vertices: vertices, indices: indices);
    }
    
    deinit {
        // Cleanup
        glDeleteBuffers(1, &vao);
        glDeleteBuffers(1, &vertexBuffer);
        glDeleteBuffers(1, &indexBuffer);
        deleteTexture();
    }
}
