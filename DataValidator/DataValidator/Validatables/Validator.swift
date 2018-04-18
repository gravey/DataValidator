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
  typealias ValidationBlock = (T?) -> (ValidationError?)
  func validate(_ data: T?, using validations: [ValidationBlock]) -> [ValidationError]
}

public class Validator<V>: Validatable {
  public typealias T = V
  
  public init() {}
  
  public func validate(_ data: T?, using validations: [(T?) -> (ValidationError?)]) -> [ValidationError] {
    let errors = validations.compactMap {
      return $0(data)
    }
    
    return errors
  }
}
