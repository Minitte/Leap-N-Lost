//
//  BufferManager.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-22.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Interface for classes that manage vertex, index, or array buffers.
 * Inheriting from this interface will provide functionality as
 * declared in the extension below.
 */
protocol BufferManager {
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer?;
    func setupAttributes(offset: BufferOffset);
}

extension BufferManager {
    /**
     * Converts and returns an int into an unsafe pointer.
     * Used for inputting offsets for certain OpenGL functions.
     */
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer.init(bitPattern: n);
    }
    
    /**
     * Sets up the vertex array object attribute pointers by
     * enabling each attribute value, and getting the correct offsets
     * for this model's vertex attributes.
     */
    func setupAttributes(offset: BufferOffset = BufferOffset()) {
        // Vertices
        glEnableVertexAttribArray(VertexAttributes.position.rawValue);
        glVertexAttribPointer(
            VertexAttributes.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(offset.vertexOffset * MemoryLayout<Vertex>.size + 0));
        
        // Colour
        glEnableVertexAttribArray(VertexAttributes.color.rawValue);
        glVertexAttribPointer(
            VertexAttributes.color.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(offset.vertexOffset * MemoryLayout<Vertex>.size + 3 * MemoryLayout<GLfloat>.size));
        
        // Texture
        glEnableVertexAttribArray(VertexAttributes.texCoord.rawValue)
        glVertexAttribPointer(
            VertexAttributes.texCoord.rawValue,
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(offset.vertexOffset * MemoryLayout<Vertex>.size + 7 * MemoryLayout<GLfloat>.size))
        
        // Normals
        glEnableVertexAttribArray(VertexAttributes.normal.rawValue)
        glVertexAttribPointer(
            VertexAttributes.normal.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<Vertex>.size), BUFFER_OFFSET(offset.vertexOffset * MemoryLayout<Vertex>.size + 9 * MemoryLayout<GLfloat>.size))
    }
}
