//
//  FormViewController.swift
//  DataValidatorDemo
//
//  Created by Richard Gravenor on 11/04/2018.
//  Copyright © 2018 Luminous Squares Ltd. All rights reserved.
//

import UIKit
import DataValidator

enum CustomValdiationError: ValidationError {
  case invalidProductCodeFormat
  case imageNotProvided
  case imageTooBig
  case imageTooSmall
}

class FormViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet var firstNameField: UITextField!
  @IBOutlet var surnameField: UITextField!
  @IBOutlet var emailField: UITextField!
  @IBOutlet var productCodeField: UITextField!
  
  @IBOutlet var firstNameErrorField: UILabel!
  @IBOutlet var surnameErrorField: UILabel!
  @IBOutlet var emailErrorField: UILabel!
  @IBOutlet var productCodeErrorField: UILabel! //Format: ABC123
  
  // MARK: - Actions
  
  @IBAction func submitPressed(_ sender: UIButton) {
    validateTextFields()
    validateImage()
  }
  
  // MARK: - Validation
  
  private func validateTextFields() {
    let stringValdiator = Validator<String>()
    
    let charCountValidations = [StringValidations.min(characterCount: 2),
                                StringValidations.max(characterCount: 50)]
    
    stringValdiator.validate(firstNameField.text, using: charCountValidations, success: { [unowned self] (value) in
      self.firstNameErrorField.text = nil
    }) { [unowned self] (errors) in
      self.firstNameErrorField.text = self.errorMessages(forValidationErrors: errors).first
    }
    
    stringValdiator.validate(surnameField.text, using: charCountValidations, success: { [unowned self] (value) in
      self.surnameErrorField.text = nil
    }) { [unowned self] (errors) in
      self.surnameErrorField.text = self.errorMessages(forValidationErrors: errors).first
    }
    
    let emailValidations = charCountValidations + [StringValidations.isEmail()]
    
    stringValdiator.validate(emailField.text, using: emailValidations, success: { [unowned self] (value) in
      self.emailErrorField.text = nil
    }) { [unowned self] (errors) in
      self.emailErrorField.text = self.errorMessages(forValidationErrors: errors).first
    }
    
    stringValdiator.validate(productCodeField.text, using: { (productCode) -> Optional<ValidationError> in
      guard
        let productCode = productCode,
        productCode.count == 6,
        productCode.prefix(3).rangeOfCharacter(from: CharacterSet.letters.inverted) == nil,
        productCode.suffix(3).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        else { return CustomValdiationError.invalidProductCodeFormat }
      return nil
    }, success: { [unowned self] (value) in
      self.productCodeErrorField.text = nil
    }) { [unowned self] (errors) in
      self.productCodeErrorField.text = self.errorMessages(forValidationErrors: errors).first
    }
  }
  
  private func validateImage() {
    let imageValidator = Validator<UIImage>()
    
    imageValidator.validate(UIImage(named: "TestImage"), using: { (image) -> Optional<ValidationError> in
      guard let image = image else { return CustomValdiationError.imageNotProvided }
      guard image.size.width > 0, image.size.height > 0 else { return CustomValdiationError.imageTooSmall }
      guard image.size.width < 1000, image.size.height < 1000 else { return CustomValdiationError.imageTooBig }
      return nil
    }) { (errors) in
      print(errors)
    }
  }

  private func errorMessages(forValidationErrors errors: [ValidationError]) -> [String] {
    let messages: [String] = errors.compactMap {
      switch $0 {
      case StringValidationError.notEnoughCharacters:
        return "You have not entered enough characters"
      case StringValidationError.tooManyCharacters:
        return "You have entered too many characters"
      case StringValidationError.invalidEmailAddressFormat:
        return "This is not a valid email address"
      case CustomValdiationError.invalidProductCodeFormat:
        return "Not a valid product code"
      default:
        return "Error"
      }
    }
    
    return messages
  }
}

