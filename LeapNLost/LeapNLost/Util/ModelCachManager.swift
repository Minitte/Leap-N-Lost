//
//  ModelCachManager.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-13.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit;

class ModelCachManager {
    
    public static var instance : ModelCachManager = ModelCachManager.init();
    
    private var meshDictionary : [String : MeshSet];
    
    init() {
        meshDictionary = [:];
    }
    
    /**
     * returns a model with the given texture and mesh.
     * If the mesh has not been loaded yet, this will try to load it from file.
     */
    public func loadModel(withMeshName meshName:String, withTextureName texName:String, saveToCach save:Bool = true) -> Model? {
        
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
        
        let model : Model = Model.init(vertices: (mesh?.vertices)!, indices: (mesh?.indices)!);
        
        model.loadTexture(filename: texName);
        
        return model;
    }
}

struct MeshSet {
    
    var vertices : [Vertex];
    
    var indices : [GLuint];
    
}
