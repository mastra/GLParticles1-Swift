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
 attribute vec3 aShade;

 // Uniforms
 uniform mat4 uProjectionMatrix;
 uniform float uK;
 uniform float uTime;

 varying vec3 vShade;

 void main(void)
{
  float x = uTime * cos(uK*aTheta)*sin(aTheta);
  float y = uTime * cos(uK*aTheta)*cos(aTheta);
  
  gl_Position = uProjectionMatrix * vec4(x, y, 0.0, 1.0);
  gl_PointSize = 16.0;
  vShade = aShade;
}
"""
  let fsh = """
// Input from Vertex Shader
varying highp vec3 vShade;
 
// Uniforms
uniform highp vec3 uColor;
 
void main(void)
{
    highp vec4 color = vec4((uColor+vShade), 1.0);
    color.rgb = clamp(color.rgb, vec3(0.0), vec3(1.0));
    gl_FragColor = color;
}
"""
  
  var aProgram : GLuint = 0
  var aTheta : GLint = 0
  var uProjectionMatrix : GLint = 0
  var uK : GLint = 0
  
  // with other attribute handles
  var aShade : GLint = 0
  
  // with other uniform handles
  var uColor: GLint = 0
  var uTime: GLint = 0
  
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
    
    // with the other attributes
    aShade = glGetAttribLocation(aProgram, "aShade")
    
    // with the other uniforms
    uColor = glGetUniformLocation(aProgram, "uColor")
    uTime = glGetUniformLocation(aProgram, "uTime")
    
  }
}
