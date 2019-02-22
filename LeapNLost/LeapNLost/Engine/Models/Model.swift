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
