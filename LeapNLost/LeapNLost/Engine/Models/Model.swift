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
 */
class Model {
    
    enum Primitive {
        case Cube;
    }
    
    // The model's vertices
    var vertices : [Vertex]
    
    // The model's indices
    var indices : [GLubyte]
    
    // Buffers
    var vao: GLuint;
    var vertexBuffer: GLuint;
    var indexBuffer: GLuint;
    
    init(vertices: [Vertex], indices: [GLubyte]) {
        // Initialize properties
        self.vertices = vertices;
        self.indices = indices;
        vao = 0;
        vertexBuffer = 0;
        indexBuffer = 0;
        
        // Generate and bind the vertex array object
        glGenVertexArraysOES(1, &vao)
        glBindVertexArrayOES(vao)
        
        // Generate and bind the vertex buffer
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        
        // Generate and bind the index buffer
        glGenBuffers(GLsizei(1), &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        
        // Model properties
        let count = vertices.count
        let size =  MemoryLayout<Vertex>.size
        
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, vertices, GLenum(GL_STATIC_DRAW))
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count * MemoryLayout<GLubyte>.size, indices, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(VertexAttributes.position.rawValue)
        glVertexAttribPointer(
            VertexAttributes.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(0))
        
        glEnableVertexAttribArray(VertexAttributes.color.rawValue)
        glVertexAttribPointer(
            VertexAttributes.color.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(3 * MemoryLayout<GLfloat>.size)) // x, y, z | r, g, b, a :: offset is 3*sizeof(GLfloat)
        
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    
    /**
     * Renders this model.
     */
    func render() {
        glBindVertexArrayOES(vao)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        glBindVertexArrayOES(0)
    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer.init(bitPattern: n)
    }
    
    /**
     * Creates a primitive model.
     * primitiveType - the type of primitive to create.
     * Returns a model based on the primitive type.
     */
    static func CreatePrimitive(primitiveType : Primitive) -> Model {
        // Vertices and indices of the model
        var vertices : [Vertex];
        var indices : [GLubyte];
        
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
        glDeleteBuffers(1, &vao)
        glDeleteBuffers(1, &vertexBuffer)
        glDeleteBuffers(1, &indexBuffer)
    }
}
