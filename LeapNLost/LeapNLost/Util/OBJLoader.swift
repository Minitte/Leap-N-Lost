//
//  OBJLoader.swift
//  LeapNLost
//
//  Created by Davis Pham on 2019-02-11.
//  Copyright © 2019 bcit. All rights reserved.
//

import Foundation
import GLKit

class OBJLoader {
    
    /**
     * tries to load a model
     */
    public static func loadModel(nameOfModel name:String) -> Model? {
        // get full obj file path
        let path = Bundle.main.path(forResource: name, ofType: "obj");
        
        if (path == nil) {
            NSLog("OBJLoader.loadModel() -> Failed to load " + name + ".obj because file was not found.");
            return nil;
        }
        
        do {
            // attempt to get contents of obj file
            let contents : String = try String(contentsOfFile: path!);
            
            // extract lines from the string
            let lines : [String] = contents.components(separatedBy: "\n");
            
            // process lines
            // Read in reference data
            let ref : ModelRefData = extractDataRef(objLines: lines);
            
            // read in index data for faces
            let face : FaceData = extractFaceData(objLines: lines);
            
            // create list of vertices
            let vertices : [Vertex] = createVertices(refData: ref, faceData: face);
            
            // create indice list
            var indices : [GLubyte] = [GLubyte]();
            
            for i in 0 ..< face.refCount {
                indices.append(GLubyte(i));
            }
            
            // create model from extracted data
            let model : Model = Model.init(vertices: vertices, indices: indices);
            
            return model;
        } catch {
            print("Error reading file. \(error)");
        }
        
        return nil;
    }
    
    /**
     * Creates the vertices base on data ref and face ref
     */
    private static func createVertices(refData ref:ModelRefData, faceData face:FaceData) -> [Vertex] {
        
        var vertices : [Vertex] = [Vertex]();
        
        for i in 0 ..< face.refCount {
            
            var vPos : [GLfloat] = ref.vPos[face.vIndex[i]];
            
            var texCoord : [GLfloat] = ref.texCoord[face.texCoordIndex[i]];
            
            var vNorm : [GLfloat] = ref.vNorm[face.normIndex[i]];
            
            let v : Vertex = Vertex.init(vPos[0], vPos[1], vPos[2], 0, 0, 0, 0, texCoord[0], texCoord[1], vNorm[0], vNorm[1], vNorm[2]);
            
            vertices.append(v);
            
        }
        
        return vertices;
    }
    
    /**
     * Extracts the vertex data from the lines
     */
    private static func extractDataRef(objLines lines:[String]) -> ModelRefData {
        var refData : ModelRefData = ModelRefData(vPos: [[GLfloat]](), texCoord: [[GLfloat]](), vNorm: [[GLfloat]]());
        
        // read data
        for line in lines {
            let elements : [String] = line.components(separatedBy: " ");
            
            switch elements[0] {
            // vertex position
            case "v":
                refData.vPos.append(extract3Floats(line: line));
                
            // vertex texture UV
            case "vt":
                refData.texCoord.append(extract2Floats(line: line));
                
            // vertex normal
            case "vn":
                refData.vNorm.append(extract3Floats(line: line))
                
            // others
            default:
                continue;
            }
        }
        
        return refData;
    }
    
    /**
     * Extracts the face data from the lines
     */
    private static func extractFaceData(objLines lines:[String]) -> FaceData {
        var face : FaceData = FaceData(refCount: 0, vIndex: [Int](), texCoordIndex: [Int](), normIndex: [Int]());
        
        for line in lines {
            let elements : [String] = line.components(separatedBy: " ");
            
            // only proccess f elements
            if (elements[0] == "f") {
                
                // each face element
                for i in 1 ..< elements.count {
                    // extract data from v/vt/vn
                    let indices : [String] = elements[i].components(separatedBy: "/");
                    
                    face.vIndex.append(Int(indices[0])! - 1);
                    
                    face.texCoordIndex.append(Int(indices[1])! - 1)
                    
                    face.normIndex.append(Int(indices[2])! - 1)
                    
                    face.refCount += 1;
                }
            }
        }
        
        return face;
    }
    
    /**
     * Extracts 3 floats from the line
     */
    private static func extract3Floats(line:String) -> [GLfloat] {
        var v3 : [GLfloat] = [GLfloat]();
        
        let elements : [String] = line.components(separatedBy: " ");
        
        v3.append(GLfloat(elements[1])!);
        v3.append(GLfloat(elements[2])!);
        v3.append(GLfloat(elements[3])!);
        
        return v3;
    }
    
    /**
     * Extracts 2 floats from the line
     */
    private static func extract2Floats(line:String) -> [GLfloat] {
        var v2 : [GLfloat] = [GLfloat]();
        
        let elements : [String] = line.components(separatedBy: " ");
        
        v2.append(GLfloat(elements[1])!);
        v2.append(GLfloat(elements[2])!);
        
        return v2;
    }
    
    struct ModelRefData {
        var vPos : [[GLfloat]];
        
        var texCoord : [[GLfloat]];
        
        var vNorm : [[GLfloat]];
    }
    
    struct FaceData {
        var refCount : Int;
        
        var vIndex : [Int];
        
        var texCoordIndex : [Int];
        
        var normIndex : [Int];
    }
    
}
