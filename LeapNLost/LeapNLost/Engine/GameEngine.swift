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
    
    init(_ view : GLKView) {
        self.view = view;
        vao = 0;
        vertexBuffer = 0;
        indexBuffer = 0;
        
        shaderLoader = ShaderLoader(vertexShader: "SimpleVertexShader.glsl", fragmentShader: "SimpleFragmentShader.glsl");
        
        setupGL();
    }
    
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer.init(bitPattern: n)
    }
    
    func setupGL() {
        glGenVertexArraysOES(1, &vao) // GPU에 VertexArrayObject를 생성해서 미리 정점과 인덱스를 CPU에서 GPU로 모두 복사한다
        glBindVertexArrayOES(vao)
        
        // Generate and bind the vertex buffer
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        
        let vertices = vertexList;
        let count = vertices.count
        let size =  MemoryLayout<Vertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, vertices, GLenum(GL_STATIC_DRAW))
        
        let indices = indexList;
        glGenBuffers(GLsizei(1), &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
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
    
    func update() {
        
    }
    
    func render(_ draw : CGRect) {
        glClearColor(1.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        shaderLoader.prepareToDraw();
        let indices = indexList;
        glBindVertexArrayOES(vao)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        glBindVertexArrayOES(0)
    }
}
