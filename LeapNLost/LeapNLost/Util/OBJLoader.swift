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
        let path = Bundle.main.path(forResource: "model_" + name, ofType: "obj");
        
        do {
            // attempt to get contents of obj file
            let contents : String = try String(contentsOfFile: path!);
            
            // extract lines from the string
            let lines : [String] = contents.components(separatedBy: "\n");
            
            // process lines
            // get vertices from file
            let vertices : [Vertex] = extractVertexData(objLines: lines);
            
            // get indices from file
            let indices : [GLubyte] = extractIndices(objLines: lines);
            
            // create model from extracted data
            let model : Model = Model.init(vertices: vertices, indices: indices);
            
            return model;
        } catch {
            print("Error reading file. \(error)");
        }
        
        return nil;
    }
    
    /**
     * Extracts the vertex data from the lines
     */
    private static func extractVertexData(objLines lines:[String]) -> [Vertex] {
        var vertices : [Vertex] = [Vertex]();
        
        var vPos : [[GLfloat]] = [[GLfloat]]();
        
        var texCoord : [[GLfloat]] = [[GLfloat]]();
        
        var vNorm : [[GLfloat]] = [[GLfloat]]();
        
        // read data
        for line in lines {
            let elements : [String] = line.components(separatedBy: " ");
            
            switch elements[0] {
            // vertex position
            case "v":
                vPos.append(extract3Floats(line: line));
                
            // vertex texture UV
            case "vt":
                texCoord.append(extract2Floats(line: line));
                
            // vertex normal
            case "vn":
                vNorm.append(extract3Floats(line: line))
                
            // others
            default:
                continue;
            }
        }
        
        // create vertices
        for i in 0 ..< vPos.count {
            
            if (i < texCoord.count) {
                // use given texture coordinates
                let v : Vertex = Vertex.init(vPos[i][0], vPos[i][1], vPos[i][2], 0, 0, 0, 0, texCoord[i][0], texCoord[i][0]);
                vertices.append(v);
                
            } else {
                // use default 0,0 texture coordinates
                let v : Vertex = Vertex.init(vPos[i][0], vPos[i][1], vPos[i][2], 0, 0, 0, 0, 0, 0);
                vertices.append(v);
            }
        }
        
        return vertices;
    }
    
    /**
     * Extracts the indices from the lines
     */
    private static func extractIndices(objLines lines:[String]) -> [GLubyte] {
        var indices : [GLubyte] = [GLubyte]();
        
        for line in lines {
            let elements : [String] = line.components(separatedBy: " ");
            
            if (elements[0] == "f") {
                
                for i in 1 ..< elements.count {
                    let indexSet = elements[i].components(separatedBy: "/");
                    
//                    for index in indexSet {
//                        indices.append((GLubyte(index)!) - GLubyte(1));
//                    }
                    
                    indices.append((GLubyte(indexSet[0])!) - GLubyte(1));
                }
                
            }
        }
        
        return indices;
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
    
}
