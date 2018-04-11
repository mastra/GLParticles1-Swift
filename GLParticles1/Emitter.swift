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
  public var color :[GLfloat] = [0.0, 0.0, 0.0]
  
  func loadParticles() {
    for i in 0..<NUM {
      var p : GLfloat = 0.0
    
      p = GLKMathDegreesToRadians(Float(i))
      var particle = Particle(t: p)
      particle.shade[0] = randomFloat(between: -0.25, and: 0.25)
      particle.shade[1] = randomFloat(between: -0.25, and: 0.25)
      particle.shade[2] = randomFloat(between: -0.25, and: 0.25)
      particles.append(particle)
      
    }
  }
  
  func randomFloat(between min:Float, and max:Float) -> Float
  {
    let range = max - min
    return (Float(arc4random()) / Float(RAND_MAX) * range) + min
  }
}
