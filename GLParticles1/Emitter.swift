//
//  Emitter.swift
//  GLParticles1
//
//  Created by daniel mastracchio on 4/9/18.
//  Copyright © 2018 bugland. All rights reserved.
//
import GLKit

public class Emitter {
  public let NUM = 360
  var particles = [Particle]()
  var k : GLfloat = 0.0
  
  func loadParticles() {
    for i in 0..<NUM {
      var p : GLfloat = 0.0
    
      p = GLKMathDegreesToRadians(Float(i))
      let particle = Particle(tetha: p)
      particles.append(particle)
      
    }
  }
}
