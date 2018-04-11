//
//  ViewController.swift
//  GLParticles1
//
//  Created by daniel mastracchio on 4/9/18.
//  Copyright © 2018 bugland. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES

class ViewController: GLKViewController, GLKViewControllerDelegate {

  
  let NUM_PARTICLES = 360
  var emitter = Emitter()
  var emitterShader = EmitterShader()
  var _timeCurrent : Float = 0.0
  var _timeMax : Float = 3.0
  var _timeDirection : Float = 1.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    // Do any additional setup after loading the view, typically from a nib.
    var context = EAGLContext(api: EAGLRenderingAPI.openGLES2)
    EAGLContext.setCurrent(context)
    var glView : GLKView = self.view as! GLKView
    glView.context = context!
    
    

    
    emitter.k = 4.0
    emitter.loadParticles()
    emitter.color[0] = 0.76
    emitter.color[1] = 0.12
    emitter.color[2] = 0.34
    
    emitterShader.loadShader()
    
    var particleBuffer  : GLuint = 0
    glGenBuffers(1, &particleBuffer)                   // Generate particle buffer
    glBindBuffer(GLenum(GL_ARRAY_BUFFER), particleBuffer)      // Bind particle buffer
    glBufferData(                                       // Fill bound buffer with particles
      GLenum(GL_ARRAY_BUFFER),                       // Buffer target
      MemoryLayout<Particle>.stride * emitter.particles.count,             // Buffer data size
      emitter.particles,                     // Buffer data pointer
      GLenum(GL_STATIC_DRAW))
  }

  override func glkView(_ view: GLKView, drawIn rect: CGRect) {
    glClearColor(0.0, 0.8, 0.1, 1.0)
    glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    
    // 1
    // Create Projection Matrix
    var aspectRatio = view.frame.size.width / view.frame.size.height
    var projectionMatrix = GLKMatrix4MakeScale(1.0, Float(aspectRatio), 1.0)
    
    // 2
    // Uniforms
    //glUniformMatrix4fv(self.emitterShader.uProjectionMatrix, 1, 0, &projectionMatrix.m)
    // Swift 3/4:
    let components = MemoryLayout.size(ofValue: projectionMatrix.m)/MemoryLayout.size(ofValue: projectionMatrix.m.0)
    withUnsafePointer(to: &projectionMatrix.m) {
      $0.withMemoryRebound(to: GLfloat.self, capacity: components) {
        glUniformMatrix4fv(self.emitterShader.uProjectionMatrix, 1, 0, $0)
      }
    }
    
    
    glUniform1f(self.emitterShader.uK, emitter.k)
    
    glUniform3f(self.emitterShader.uColor, emitter.color[0], emitter.color[1], emitter.color[2])
    glUniform1f(self.emitterShader.uTime, (_timeCurrent/_timeMax))
    
    // 3
    // Attributes
    //glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
    // glVertexAttribPointer(GLuint(GLKVertexAttrib.normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 24, BUFFER_OFFSET(12))
    //GLsizei(sizeof(Vertex)), BUFFER_OFFSET(0))
    glEnableVertexAttribArray(GLuint(self.emitterShader.aTheta))
    glVertexAttribPointer(GLuint(self.emitterShader.aTheta),                // Set pointer
      1,                                        // One component per particle
      GLenum(GL_FLOAT),                                 // Data is floating point type
      GLboolean(GL_FALSE),                                 // No fixed point scaling
      GLsizei(MemoryLayout<Particle>.size),                         // No gaps in data
      BUFFER_OFFSET(0))      // Start from "theta" offset within bound buffer
    
    glEnableVertexAttribArray(GLuint(self.emitterShader.aShade))
    glVertexAttribPointer(GLuint(self.emitterShader.aShade),                // Set pointer
      3,                                        // Three components per particle
      GLenum(GL_FLOAT),                                 // Data is floating point type
      GLboolean(GL_FALSE),                                 // No fixed point scaling
      GLsizei(MemoryLayout<Particle>.size),                         // No gaps in data
      BUFFER_OFFSET(4))
    // Start from "shade" offset within bound buffer
    //glVertexAttribPointer(index: 0, size: 3, type: GL_FLOAT,
    //                      normalized: false, stride: GLsizei(strideof(GLfloat) * 3), pointer: nil)
    
    // 4
    // Draw particles
    glDrawArrays(GLenum(GL_POINTS), 0, 360)
    glDisableVertexAttribArray(GLuint(self.emitterShader.aTheta))
    glDisableVertexAttribArray(GLuint(self.emitterShader.aShade))
  }
  
  func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer? {
    return UnsafeRawPointer(bitPattern: i)
  }

  func update() {
    if _timeCurrent > _timeMax {
      _timeDirection = -1.0
    } else {
      if _timeCurrent < 0.0 {
        _timeDirection = 1.0
      }
    }
    _timeCurrent += _timeDirection * Float(self.timeSinceLastUpdate)
  }
  
  func glkViewControllerUpdate(_ controller: GLKViewController) {
    update()
  }

}

