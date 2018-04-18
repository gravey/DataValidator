//
//  StringValidations.swift
//  DataValidator
//
//  Created by Richard Gravenor on 18/04/2018.
//  Copyright © 2018 Luminous Squares Ltd. All rights reserved.
//

import Foundation

public enum StringValidationError: ValidationError {
  case notEnoughCharacters
  case tooManyCharacters
  case notValidEmailAddress
}

public class StringValidations {
  
  public static func max(characterCount count: Int) -> ((String?) -> (ValidationError?)) {
    let validation: (String?) -> ValidationError? = { str in
      guard let str = str, str.count <= count else { return StringValidationError.tooManyCharacters }
      return nil
    }
    
    return validation
  }
  
  public static func min(characterCount count: Int) -> ((String?) -> (ValidationError?)) {
    let validation: (String?) -> ValidationError? = { str in
      guard let str = str, str.count >= count else { return StringValidationError.notEnoughCharacters }
      return nil
    }
    
    return validation
  }
  
  public static func isEmail() -> ((String?) -> (ValidationError?)) {
    let validation: (String?) -> ValidationError? = { str in
      guard let str = str, str.contains("rich@mac.com") else { return StringValidationError.notValidEmailAddress }
      return nil
    }
    
    return validation
  }
  
}
