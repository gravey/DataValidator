//
//  Validatables.swift
//  DataValidator
//
//  Created by Richard Gravenor on 18/04/2018.
//  Copyright © 2018 Luminous Squares Ltd. All rights reserved.
//

import Foundation

public protocol ValidationError: Error {}

public enum ValidationResponse {
  case success
  case fail
}

public protocol Validatable {
  associatedtype T
  
  typealias Validation = (T?) -> (ValidationError?)
  typealias ValidationSuccess = (T?) -> ()
  typealias ValidationFail = ([ValidationError]) -> ()
  
  func validate(_ data: T?, using validations: [Validation], success: ValidationSuccess?, fail: ValidationFail?)
  func validate(_ data: T?, using validation: @escaping Validation, success: ValidationSuccess?, fail: ValidationFail?)
}

public protocol ValidationPerformer {
  typealias PerformanceCompletion = (ValidationResponse) -> ()
  func perform(continueAfterErrors: Bool, completed: PerformanceCompletion?)
}

public class Validator<V>: Validatable, ValidationPerformer {
  
  public typealias T = V
  private typealias ValidationWrapper = () -> (ValidationResponse)
  
  private var wrappers: [ValidationWrapper] = []
  
  public init() {}
  
  public func validate(_ data: V?, using validation: @escaping Validation, success: ValidationSuccess? = nil, fail: ValidationFail? = nil) {
    return self.validate(data, using: [validation], success: success, fail: fail)
  }
  
  public func validate(_ data: V?, using validations: [Validation], success: ValidationSuccess? = nil, fail: ValidationFail? = nil) {
    
    let wrapper: ValidationWrapper = {
      let errors = validations.compactMap {
        return $0(data)
      }
      
      guard errors.isEmpty else {
        fail?(errors)
        return ValidationResponse.fail
      }
      
      success?(data)
      return ValidationResponse.success
    }
    
    wrappers.append(wrapper)
  }
  
  public func perform(continueAfterErrors: Bool = true, completed: PerformanceCompletion?) {
    
    var failures: [ValidationResponse] = []
    
    for wrapper in wrappers {
      let result = wrapper()
      
      if case ValidationResponse.fail = result {
        failures.append(result)
        if !continueAfterErrors {
          completed?(ValidationResponse.fail)
          return
        }
      }
    }
    
    guard failures.isEmpty else {
      completed?(ValidationResponse.fail)
      return
    }
    
    completed?(ValidationResponse.success)
  }
}
