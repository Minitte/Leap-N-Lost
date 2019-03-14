//
//  ModelCachManager.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-13.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit;

class ModelCacheManager {
    
    private static var meshDictionary : [String : MeshSet] = [:];
    
    // Map for models that have been loaded in by the game engine
    static var modelDictionary : [String : BufferOffset] = [:];
    
    /**
     * returns a model with the given texture and mesh.
     * If the mesh has not been loaded yet, this will try to load it from file.
     */
    public static func loadModel(withMeshName meshName:String, withTextureName texName:String, saveToCache save:Bool = true) -> Model? {
        
        var mesh : MeshSet? = meshDictionary[meshName];
        
        // mesh not found in cach, try to load a new one
        if (mesh == nil) {
            NSLog("Mesh " + meshName + " not founnd in cach, loading a new one");
            
            mesh = OBJLoader.loadMeshSet(nameOfMesh: meshName);
            
            // check if still null
            if (mesh == nil) {
                return nil;
            }
            
            if (save) {
                meshDictionary[meshName] = mesh;
            }
        }
        
        let model : Model = Model.init(vertices: mesh!.vertices, indices: mesh!.indices, modelName: meshName);
        
        model.loadTexture(fileName: texName);
        
        return model;
    }
    
    /**
     * Remove all in cache
     */
    public static func flushCache() {
        meshDictionary.removeAll();
        modelDictionary.removeAll();
        
    }
}

struct MeshSet {
    
    var vertices : [Vertex];
    
    var indices : [GLuint];
    
}
