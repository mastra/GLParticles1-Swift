//
//  EmiterShader.swift
//  GLParticles1
//
//  Created by daniel mastracchio on 4/9/18.
//  Copyright © 2018 bugland. All rights reserved.
//

import Foundation
import GLKit

class EmitterShader {
  let vsh =
"""
// Attributes
 attribute float aTheta;
 
 // Uniforms
 uniform mat4 uProjectionMatrix;
 uniform float uK;
 
 void main(void)
{
  float x = cos(uK*aTheta)*sin(aTheta);
  float y = cos(uK*aTheta)*cos(aTheta);
  
  gl_Position = uProjectionMatrix * vec4(x, y, 0.0, 1.0);
  gl_PointSize = 16.0;
}
"""
  let fsh = """
 void main(void)
{
  gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
"""
  
  var aProgram : GLuint = 0
  var aTheta : GLint = 0
  var uProjectionMatrix : GLint = 0
  var uK : GLint = 0
  func loadShader() {
    
    // Program
    //ShaderProcessor* shaderProcessor = [[ShaderProcessor alloc] init];
    //self.program = [shaderProcessor BuildProgram:EmitterVS with:EmitterFS];
    let ourShader = ShaderProcessor(vertex: vsh, fragment:fsh)
    
      //ShaderProcessor(vertexFile: "Emitter.vsh", fragmentFile: "Emitter.fsh")
    ourShader.use()
    aProgram = ourShader.program
    
    aTheta = glGetAttribLocation(aProgram, "aTheta")
    
    uProjectionMatrix = glGetUniformLocation(aProgram, "uProjectionMatrix")
    uK = glGetUniformLocation(aProgram, "uK")
  }
}
