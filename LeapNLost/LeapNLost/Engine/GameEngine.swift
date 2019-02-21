//
//  GameEngine.swift
//  LeapNLost
//
//  Created by Anthony Wong on 2019-02-06.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

/**
 * Class for the game engine.
 * Renders and updates all game objects every frame.
 */
class GameEngine {
    
    // Reference to the game view.
    private var view : GLKView;
    
    // Reference to the shader
    private var mainShader : Shader;
    
    // The current scene
    var currentScene : Scene;
    
    // Holds the timestamp for the last frame rendered
    var lastTime : UInt64;
    
    // Handles shadow mapping
    var shadowRenderer : ShadowRenderer;
    
    // Buffers
    var vertexBuffer: GLuint;
    var indexBuffer: GLuint;
    
    // Current offsets
    var currentOffset : BufferOffset;
    
    /**
     * Constructor for the game engine.
     * view - Reference to the application view.
     */
    init(_ view : GLKView) {
        // Initialize variables
        self.view = view;
        self.currentScene = Scene(view: view);
        self.shadowRenderer = ShadowRenderer(lightDirection: currentScene.directionalLight.direction);
        lastTime = Date().toMillis();
        //vao = 0;
        vertexBuffer = 0;
        indexBuffer = 0;
        self.currentOffset = BufferOffset();

        // Load shaders
        let shaderLoader = ShaderLoader();
        let programHandle : GLuint = shaderLoader.compile(vertexShader: "VertexShader.glsl", fragmentShader: "FragmentShader.glsl");
        self.mainShader = Shader(programHandle: programHandle);
        
        // Generate and bind the vertex buffer
        glGenBuffers(GLsizei(1), &vertexBuffer);
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer);
        
        // Generate and bind the index buffer
        glGenBuffers(GLsizei(1), &indexBuffer);
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer);
        
        // Allocate the vertex and index buffers (use arbitruary numbers for now)
        glBufferData(GLenum(GL_ARRAY_BUFFER), 100000 * MemoryLayout<Vertex>.size, nil, GLenum(GL_STATIC_DRAW));
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), 500000 * MemoryLayout<GLuint>.size, nil, GLenum(GL_STATIC_DRAW));
        
        // Initialize the first level
        currentScene.loadLevel(area: 1, level: 1);
        for gameObject in currentScene.gameObjects {
            loadModel(model: gameObject.model, name: gameObject.type);
        }
    }
    
    /**
     * Loads a model into the buffers.
     * model - the model to load
     */
    func loadModel(model: Model, name: String) {
        
        // Check if this model has already been loaded in
        if (Model.ModelVaoCache[name] != nil) {
            model.vao = Model.ModelVaoCache[name]!;
            model.offset = Model.ModelOffsetCache[name]!;
        } else {
            // Generate a vertex array object
            glGenVertexArraysOES(1, &model.vao);
            
            // Bind the vertex array object with the index buffer
            glBindVertexArrayOES(model.vao);
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer);
            
            // Input vertices into the vertex buffer
            glBufferSubData(GLenum(GL_ARRAY_BUFFER), currentOffset.vertexOffset * MemoryLayout<Vertex>.size, MemoryLayout<Vertex>.size * model.vertices.count, model.vertices);
            
            // Input indices into the index buffer
            glBufferSubData(GLenum(GL_ELEMENT_ARRAY_BUFFER), currentOffset.indexOffset * MemoryLayout<GLuint>.size, MemoryLayout<GLuint>.size * model.indices.count, model.indices);
            
            // Set the offsets
            model.offset = currentOffset;
            
            // Save to cache
            Model.ModelOffsetCache[name] = currentOffset;
            Model.ModelVaoCache[name] = model.vao;
            
            // Increment current offset
            currentOffset.vertexOffset += model.vertices.count;
            currentOffset.indexOffset += model.indices.count;
            
            // Setup attributes
            model.setupAttributes();
            
            // Unbind vertex array object
            glBindVertexArrayOES(0);
        }
        
    }
    
    /**
     * Converts and returns an int into an unsafe pointer.
     * Used for inputting offsets for certain OpenGL functions.
     */
    func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer.init(bitPattern: n);
    }
    
    /**
     * The update loop.
     */
    func update() {
        // Calculate delta time
        let date : Date = Date();
        let delta : Float = Float(date.toMillis() - lastTime) / 1000; // Convert milliseconds to seconds
        lastTime = date.toMillis();

        // Update the scene
        currentScene.update(delta: delta);
        print(delta)
    }
    
    /**
     * The render loop.
     */
    func render(_ draw : CGRect) {
        // Render shadows first
        shadowRenderer.render(scene: currentScene);
        
        // Switch view back to the default frame buffer
        view.bindDrawable();
        glUseProgram(mainShader.programHandle);
        
        // Clear screen and buffers, set viewport to correct size
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        glViewport(0, 0, GLsizei(Float(draw.width * 2)), GLsizei(draw.height * 2));
        
        // Switch back to regular back face culling
        glCullFace(GLenum(GL_BACK));
        
        // Set camera variables in shader
        mainShader.setVector(variableName: "view_Position", value: currentScene.mainCamera.position);
        mainShader.setMatrix(variableName: "u_ProjectionMatrix", value: currentScene.mainCamera.perspectiveMatrix);
        mainShader.setMatrix(variableName: "u_LightSpaceMatrix", value: shadowRenderer.shadowCamera.perspectiveMatrix);
        
        // Bind shadow map texture
        mainShader.setTexture(textureName: "u_ShadowMap", textureNum: 1, texture: shadowRenderer.shadowBuffer.depthTexture);
        glActiveTexture(GLenum(GL_TEXTURE1));
        glBindTexture(GLenum(GL_TEXTURE_2D), shadowRenderer.shadowBuffer.depthTexture);
        
        // Loop through every object in scene and call render
        for gameObject in currentScene.gameObjects {
            
            // Get the game object's rotation as a matrix
            var rotationMatrix : GLKMatrix4 = GLKMatrix4RotateX(GLKMatrix4Identity, gameObject.rotation.x);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.y);
            rotationMatrix = GLKMatrix4RotateY(rotationMatrix, gameObject.rotation.z);
            
            // Get the game object's position as a matrix
            let positionMatrix : GLKMatrix4 = GLKMatrix4Translate(GLKMatrix4Identity, gameObject.position.x, gameObject.position.y, gameObject.position.z);
            
            // Multiply together to get transformation matrix
            var objectMatrix : GLKMatrix4 = GLKMatrix4Multiply(currentScene.mainCamera.transformMatrix, positionMatrix);
            objectMatrix = GLKMatrix4Multiply(objectMatrix, rotationMatrix);
            objectMatrix = GLKMatrix4Scale(objectMatrix, gameObject.scale.x, gameObject.scale.y, gameObject.scale.z); // Scaling
            
            // Apply all point lights to the rendering of this game object
            // TODO - Only apply point lights that are within range
            for i in 0..<currentScene.pointLights.count {
                currentScene.pointLights[i].render(shader: mainShader, lightNumber: i);
            }
            
            // Apply directional light
            currentScene.directionalLight.render(shader: mainShader);
            
            // Render the object after passing model view matrix and texture to the shader
            mainShader.setMatrix(variableName: "u_ModelViewMatrix", value: objectMatrix);
            mainShader.setTexture(textureName: "u_Texture", textureNum: 0, texture: gameObject.model.texture);
            glActiveTexture(GLenum(GL_TEXTURE0));
            glBindTexture(GLenum(GL_TEXTURE_2D), gameObject.model.texture);
            
            gameObject.model.render();
        }
    }
    
    deinit {
        // Cleanup
        for var vao in Model.ModelVaoCache.values {
            glDeleteBuffers(1, &vao);
        }
    }
}

extension Date {
    // Converts and returns the current date and time in milliseconds.
    func toMillis() -> UInt64! {
        return UInt64(self.timeIntervalSince1970 * 1000)
    }
}
