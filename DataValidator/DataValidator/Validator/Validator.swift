//
//  Validatables.swift
//  DataValidator
//
//  Created by Richard Gravenor on 18/04/2018.
//  Copyright © 2018 Luminous Squares Ltd. All rights reserved.
//

import Foundation

public protocol ValidationError {}

public protocol Validatable {
  associatedtype T
  
  typealias Validation = (T?) -> (ValidationError?)
  typealias ValidationSuccess = (T?) -> ()
  typealias ValidationFail = ([ValidationError]) -> ()
  
  func validate(_ data: T?, using validations: [Validation], success: ValidationSuccess?, fail: ValidationFail?)
  func validate(_ data: T?, using validation: @escaping Validation, success: ValidationSuccess?, fail: ValidationFail?)
}

public class Validator<V>: Validatable {
  public typealias T = V
  
  public init() {}
  
  public func validate(_ data: V?, using validation: @escaping Validation, success: ValidationSuccess? = nil, fail: ValidationFail? = nil) {
    self.validate(data, using: [validation], success: success, fail: fail)
  }
  
  public func validate(_ data: V?, using validations: [Validation], success: ValidationSuccess? = nil, fail: ValidationFail? = nil) {
    let errors = validations.compactMap {
      return $0(data)
    }
    
    guard errors.isEmpty else { fail?(errors); return }
    
    success?(data)
  }
}
