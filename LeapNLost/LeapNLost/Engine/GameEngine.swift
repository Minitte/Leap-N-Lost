//
//  GameEngine.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

class GameEngine {
    
    // Reference to the game view.
    private var view : GLKView;
    
    // Reference to the shader loader.
    private var shaderLoader : ShaderLoader;
    
    var vao: GLuint;
    var vertexBuffer: GLuint;
    var indexBuffer: GLuint;
    
    var radians : Float;
    
    init(_ view : GLKView) {
        self.view = view;
        vao = 0;
        vertexBuffer = 0;
        indexBuffer = 0;
        radians = 0;
        
        shaderLoader = ShaderLoader(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl");
        
        setupGL();
    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer.init(bitPattern: n)
    }
    
    func setupGL() {
        // Enable depth buffer
        view.drawableDepthFormat = GLKViewDrawableDepthFormat.format24;
        glEnable(GLbitfield(GL_DEPTH_TEST));
        
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
        let vertices = vertexList;
        let indices = indexList;
        let count = vertices.count
        let size =  MemoryLayout<Vertex>.size
        
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, vertices, GLenum(GL_STATIC_DRAW))
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count * MemoryLayout<GLubyte>.size, indices, GLenum(GL_STATIC_DRAW))
        
        // 현재 vao가 바인딩 되어 있어서 아래 함수를 실행하면 정점과 인덱스 데이터가 모두 vao에 저장된다.
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
        
        // 바인딩을 끈다
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    
    /**
     * The update loop
     */
    func update() {
        var mv = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -5.0);
        mv = GLKMatrix4RotateY(mv, radians)
        
        let aspect = Float(view.drawableWidth) / Float(view.drawableHeight);
        let perspective = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(60), aspect, 1, 20);
        
        shaderLoader.modelViewMatrix = mv;
        shaderLoader.projectionMatrix = perspective;
        //mvp = modelMatrix()
        
        // Continue rotation
        radians += 0.1;
    }
    
    func modelMatrix() -> GLKMatrix4 {
        var modelMatrix : GLKMatrix4 = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Translate(modelMatrix, 0, 0, -5.0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, 0, 1, 0, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, radians, 0, 1, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, 0, 0, 0, 1)
        ///modelMatrix = GLKMatrix4Scale(modelMatrix, self.scale, self.scale, self.scale)
        return modelMatrix
    }
    
    func render(_ draw : CGRect) {
        
        
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        //glClear(GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        let indices = indexList
        
        shaderLoader.prepareToDraw();
        glBindVertexArrayOES(vao)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        glBindVertexArrayOES(0)
    }
}
