//
//  ShaderProcessor.swift
//  GLParticles1
//
//  Created by daniel mastracchio on 4/9/18.
//  Copyright © 2018 bugland. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES


class ShaderProcessor {
  public private(set) var program:GLuint = 0
  
  public init(vertex:String, fragment:String)
  {
    let vertexID = glCreateShader( GLenum(GL_VERTEX_SHADER))
    defer{ glDeleteShader(vertexID) }
    if let errorMessage = ShaderProcessor.compileShader(shader: vertexID, source: vertex) {
      fatalError(errorMessage)
    }
    let fragmentID = glCreateShader( GLenum(GL_FRAGMENT_SHADER))
    defer{ glDeleteShader(fragmentID) }
    if let errorMessage = ShaderProcessor.compileShader(shader: fragmentID, source: fragment) {
      fatalError(errorMessage)
    }
    self.program = glCreateProgram()
    if let errorMessage = ShaderProcessor.linkProgram(program: program, vertex: vertexID, fragment: fragmentID) {
      fatalError(errorMessage)
    }
  }
  
  public convenience init(vertexFile:String, fragmentFile:String)
  {
    do {
      let vertexData = try NSData(contentsOfFile: vertexFile,
                                  options: [.uncached, .alwaysMapped])
      let fragmentData = try NSData(contentsOfFile: fragmentFile,
                                    options: [.uncached, .alwaysMapped])
      let vertexString = NSString(data: vertexData as Data, encoding: String.Encoding.utf8.rawValue)
      let fragmentString = NSString(data: fragmentData as Data, encoding: String.Encoding.utf8.rawValue)
      self.init(vertex: String(vertexString!), fragment: String(fragmentString!))
    }
    catch let error as NSError {
      fatalError(error.localizedFailureReason!)
    }
  }
  
  
  private static func linkProgram(program: GLuint, vertex: GLuint, fragment: GLuint) -> String?
    {
      glAttachShader(program, vertex)
      glAttachShader(program, fragment)
      glLinkProgram(program)
      var success:GLint = 0
      glGetProgramiv(program, GLenum(GL_LINK_STATUS), &success)
      if success != GL_TRUE {
        var logSize:GLint = 0
        glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &logSize)
        if logSize == 0 { return "" }
        var infoLog = [GLchar](repeating: 0, count: Int(logSize))
        glGetProgramInfoLog(program, logSize, nil, &infoLog)
        return String(cString:infoLog)
      }
      return nil
    }
  
  private static func compileShader(shader: GLuint, source: String) -> String?
  {
    //var cStringSource = (source as NSString).utf8String
    //glShaderSource(shader, GLsizei(1), &cStringSource, nil)
    let shaderStringUTF8 = source.cString(using: String.Encoding.utf8)
    var shaderStringUTF8Pointer = UnsafePointer<GLchar>(shaderStringUTF8)
    var shaderStringLength: GLint = GLint(shaderStringUTF8!.count)
    glShaderSource(shader, GLsizei(1), &shaderStringUTF8Pointer, &shaderStringLength)
    
    //source.withCString {
    //  var s  = [$0]
    //  glShaderSource(shader, 1, &s, nil)
    //}
    glCompileShader(shader)
    var success:GLint = 0
    glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &success)
    if success != GL_TRUE {
      var logSize:GLint = 0
      glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logSize)
      if logSize == 0 { return "" }
      var infoLog = [GLchar](repeating: 0, count: Int(logSize))
      glGetShaderInfoLog(shader, logSize, nil, &infoLog)
      print(String(cString:infoLog))
      return String(cString:infoLog)
    }
    return nil
  }
  
  deinit
  {
    glDeleteProgram(program)
  }
  
  public func use()
  {
    glUseProgram(program)
  }
}
