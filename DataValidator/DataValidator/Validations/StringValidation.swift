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
  case invalidEmailAddressFormat
  case invalidWebAddressFormat
  case invalidPhoneCharacters
  
  public var localizedDescription: String {
    switch self {
    case .notEnoughCharacters:
      return "You have not entered enough characters"
    case .tooManyCharacters:
      return "You have entered too many characters"
    case .invalidEmailAddressFormat:
      return "This is not a valid email address"
    case .invalidWebAddressFormat:
      return "This is not a valid web address"
    case .invalidPhoneCharacters:
      return "This is not a valid phone number"
    }
  }
}

public class StringValidation {
  
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
}

// MARK: - Email Validation

extension StringValidation {
  
  public static func isEmail() -> ((String?) -> (ValidationError?)) {
    let validation: (String?) -> ValidationError? = { str in
      guard let str = str else { return StringValidationError.invalidEmailAddressFormat }
      
      let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let test = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
      guard test.evaluate(with: str) == true else { return StringValidationError.invalidEmailAddressFormat }
      
      return nil
    }
    
    return validation
  }
}

// MARK: - Phone Number Validation

extension StringValidation {
  
  public static func isPhoneNumber() -> ((String?) -> (ValidationError?)) {
    let validation: (String?) -> ValidationError? = { str in
      guard let str = str else { return StringValidationError.invalidPhoneCharacters }
      guard str.rangeOfCharacter(from: CharacterSet(charactersIn: "+0123456789 ").inverted) == nil else { return StringValidationError.invalidPhoneCharacters }
      
      return nil
    }
    
    return validation
  }
}

// MARK: - Domain Validation

extension StringValidation {
  
  public static func isAddress() -> ((String?) -> (ValidationError?)) {
    let validation: (String?) -> ValidationError? = { str in
      guard let str = str else { return StringValidationError.invalidWebAddressFormat }
      
      let addressRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
      let test = NSPredicate(format:"SELF MATCHES %@", addressRegEx)
      guard test.evaluate(with: str) == true else { return StringValidationError.invalidWebAddressFormat }
      
      return nil
    }
    
    return validation
  }
}
