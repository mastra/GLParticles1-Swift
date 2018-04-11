//
//  Particle.swift
//  GLParticles1
//
//  Created by daniel mastracchio on 4/9/18.
//  Copyright © 2018 bugland. All rights reserved.
//
import GLKit
struct Particle {
  public var tetha : GLfloat = 0.0
  public var shade : [GLfloat] = [0.0, 0.0, 0.0]
  init(t:GLfloat) {
    self.tetha = t
  }
}
