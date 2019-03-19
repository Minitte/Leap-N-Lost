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
class GameEngine : BufferManager {
    
    // Reference to the game view.
    private var view : GLKView;
    
    // Reference to the shader
    private var mainShader : Shader;
    
    private var physicsEngine : PhysicsEngine;
    
    // The current scene
    var currentScene : Scene;
    
    // Holds the timestamp for the last frame rendered
    var lastTime : UInt64;
    
    // Handles shadow mapping
    var shadowRenderer : ShadowRenderer;
    
    // Buffers
    var vertexBuffer: GLuint;
    var indexBuffer: GLuint;
    var vertexArrayObject : GLuint;
    
    // Current offsets
    var currentOffset : BufferOffset;
    
    var totalFrames = 0;
    var totalTime : Float = 0;
    
    /**
     * Constructor for the game engine.
     * view - Reference to the application view.
     */
    init(_ view : GLKView) {
        print("Engine Init");
        // Initialize variables
        self.view = view;
        self.currentScene = Scene(view: view);
        self.shadowRenderer = ShadowRenderer(lightDirection: currentScene.directionalLight.direction);
        self.lastTime = Date().toMillis();
        self.vertexBuffer = 0;
        self.indexBuffer = 0;
        self.vertexArrayObject = 0;
        self.currentOffset = BufferOffset();
        self.physicsEngine = PhysicsEngine(currentScene: currentScene);

        // Load shaders
        let shaderLoader = ShaderLoader();
        let programHandle : GLuint = shaderLoader.compile(vertexShader: "VertexShader.glsl", fragmentShader: "FragmentShader.glsl");
        self.mainShader = Shader(programHandle: programHandle);
        
        // Generate a vertex array object for tiles
        glGenVertexArraysOES(1, &vertexArrayObject);
        glBindVertexArrayOES(vertexArrayObject);
        
        // Generate and bind the vertex buffer
        glGenBuffers(GLsizei(1), &vertexBuffer);
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer);
        
        // Generate and bind the index buffer
        glGenBuffers(GLsizei(1), &indexBuffer);
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer);
        
        // Allocate the vertex and index buffers (use arbitruary numbers for now)
        glBufferData(GLenum(GL_ARRAY_BUFFER), 100000 * MemoryLayout<Vertex>.size, nil, GLenum(GL_STATIC_DRAW));
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), 500000 * MemoryLayout<GLuint>.size, nil, GLenum(GL_STATIC_DRAW));
        
        // Setup vertex attribute object attributes
        setupAttributes();
        
        // Load all tiles
        for tile in currentScene.tiles {
            loadTile(tile: tile);
        }
        
        // Unbind tile vertex array object for now
        glBindVertexArrayOES(0);
        
        // Load all other game objects
        for gameObject in currentScene.gameObjects {
            loadModel(model: gameObject.model);
            loadModel(model: gameObject.collider!.model!);
        }
    }
    
    /**
     * Loads a tile into the vertex buffer.
     * Modifies the vertex position and indices accordingly to offsets
     * so that it can be rendered directly from the buffer without
     * having to change any shader uniforms.
     * tile - the tile to load
     */
    func loadTile(tile: GameObject) {
        let model : Model = tile.model;
        
        // Offsets the vertex position by the tile position
        for i in 0..<model.vertices.count {
            model.vertices[i].x += tile.position.x;
            model.vertices[i].y += tile.position.y;
            model.vertices[i].z += tile.position.z;
        }
        
        // Append the model to the buffers
        appendModel(model: model);
    }
    
    /**
     * Loads a model into the buffers.
     * Will also check to see if it's in the model cache
     * before attempting to append the model.
     * model - the model to load
     */
    func loadModel(model: Model) {
        let name : String = model.name;
        
        // Check if this model has already been loaded in
        if (ModelCacheManager.modelDictionary[name] != nil) {
            model.offset = ModelCacheManager.modelDictionary[name]!;
            
            // Offset the indices by the model's vertex offset
            for i in 0..<model.indices.count {
                model.indices[i] += GLuint(model.offset.vertexOffset);
            }
            
        } else {
            // Save to cache
            ModelCacheManager.modelDictionary[name] = currentOffset;
            
            // Append the model to the buffers
            appendModel(model: model);
        }
    }
    
    /**
     * Appends a model to the vertex and index buffers.
     * Increments the offsets after appending.
     * model - the model to append
     */
    func appendModel(model: Model) {
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer);
        
        // Set the model's offset
        model.offset = currentOffset;
        
        // Offset the model's indices by the current vertex offset
        for i in 0..<model.indices.count {
            model.indices[i] += GLuint(currentOffset.vertexOffset);
        }
        
        // Input vertices into the vertex buffer
        glBufferSubData(GLenum(GL_ARRAY_BUFFER), currentOffset.vertexOffset * MemoryLayout<Vertex>.size, MemoryLayout<Vertex>.size * model.vertices.count, model.vertices);
        
        // Input indices into the index buffer
        glBufferSubData(GLenum(GL_ELEMENT_ARRAY_BUFFER), currentOffset.indexOffset * MemoryLayout<GLuint>.size, MemoryLayout<GLuint>.size * model.indices.count, model.indices);
        
        // Increment current offsets
        currentOffset.vertexOffset += model.vertices.count;
        currentOffset.indexOffset += model.indices.count;
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
        
        // Update the physics engine
        physicsEngine.update(delta: delta);
        
        totalTime += delta;
        totalFrames += 1;
        
        if (totalTime >= 1.0) {
            let fps = Float(totalFrames) / totalTime;
            print("FPS: \(fps)");
            
            totalFrames = 0;
            totalTime = 0;
        }
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
        glViewport(0, 0, GLsizei(Float(view.drawableWidth)), GLsizei(view.drawableHeight));
        
        // Switch back to regular back face culling
        glCullFace(GLenum(GL_BACK));
        
        // Set camera variables in shader
        mainShader.setVector(variableName: "view_Position", value: currentScene.mainCamera.position);
        mainShader.setMatrix(variableName: "u_ProjectionMatrix", value: currentScene.mainCamera.projectionMatrix);
        mainShader.setMatrix(variableName: "u_LightSpaceMatrix", value: shadowRenderer.shadowCamera.projectionMatrix);
        mainShader.setMatrix(variableName: "u_ViewMatrix", value: currentScene.mainCamera.transformMatrix);
        
        // Bind shadow map texture
        mainShader.setTexture(textureName: "u_ShadowMap", textureNum: 1);
        glActiveTexture(GLenum(GL_TEXTURE1));
        glBindTexture(GLenum(GL_TEXTURE_2D), shadowRenderer.shadowBuffer.depthTexture.id);
        
        // Switch back to object texture
        mainShader.setTexture(textureName: "u_Texture", textureNum: 0);
        glActiveTexture(GLenum(GL_TEXTURE0));
        
        // Apply all point lights to the rendering of this game object
        // TODO - Only apply point lights that are within range
        for i in 0..<currentScene.pointLights.count {
            currentScene.pointLights[i].render(shader: mainShader, lightNumber: i);
        }
        
        // Apply directional light
        currentScene.directionalLight.render(shader: mainShader);
        
        // Get information about the level's rows
        let numberOfRows : Int = currentScene.level.rows.count;
        let indicesPerRow : Int = currentScene.tiles[0].model.indices.count * Level.tilesPerRow;
        
        // Bind the vertex array object
        glBindVertexArrayOES(vertexArrayObject);
        
        // Model matrix for tiles is identity
        mainShader.setMatrix(variableName: "u_ModelMatrix", value: GLKMatrix4Identity);
        
        // Render each row
        for i in 0..<numberOfRows {
            // Bind the current row's texture, then draw it
            glBindTexture(GLenum(GL_TEXTURE_2D), currentScene.tiles[i * Level.tilesPerRow].model.texture.id);
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indicesPerRow), GLenum(GL_UNSIGNED_INT), BUFFER_OFFSET(indicesPerRow * i * MemoryLayout<GLuint>.size));
        }
        
        // Loop through every object in scene and call render
        for gameObject in currentScene.gameObjects {
            // Set transformation matrix
            mainShader.setMatrix(variableName: "u_ModelMatrix", value: gameObject.transformMatrix);
            
            // Set texture
            glBindTexture(GLenum(GL_TEXTURE_2D), gameObject.model.texture.id);
            
            // Render the object
            gameObject.model.render();
        }
        
        // Call render on physics engine
        physicsEngine.render();
    }
    
    deinit {
        print("Engine deinit");
        // Unbind everything
        glBindVertexArrayOES(0);
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0);
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0);
        
        // Free all the buffers
        glDeleteVertexArraysOES(1, &vertexArrayObject);
        glDeleteBuffers(1, &vertexBuffer);
        glDeleteBuffers(1, &indexBuffer);
        glDeleteBuffers(1, &shadowRenderer.shadowBuffer.bufferName);
        
        // Flush model cache
        ModelCacheManager.flushCache();
    }
}

extension Date {
    // Converts and returns the current date and time in milliseconds.
    func toMillis() -> UInt64! {
        return UInt64(self.timeIntervalSince1970 * 1000)
    }
}
