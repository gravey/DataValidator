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
    validateFields()
    validateImage()
  }
  
  // MARK: - Validation
  
  private func validateFields() {
    let stringValdiator = Validator<String>()

    let firstNameErrors = stringValdiator.validate(firstNameField.text, using: [StringValidations.min(characterCount: 2),
                                                                                StringValidations.max(characterCount: 50)])
    firstNameErrorField.text = errorMessages(forValidationErrors: firstNameErrors).first
    
    let surnameErrors = stringValdiator.validate(surnameField.text, using: [StringValidations.min(characterCount: 2),
                                                                            StringValidations.max(characterCount: 50)])
    surnameErrorField.text = errorMessages(forValidationErrors: surnameErrors).first
    
    let emailErrors = stringValdiator.validate(emailField.text, using: [StringValidations.isEmail()])
    emailErrorField.text = errorMessages(forValidationErrors: emailErrors).first
    
    let productCodeValidation: (String?) -> ValidationError? = { productCode in
      guard
        let productCode = productCode,
        productCode.count == 6,
        productCode.prefix(3).rangeOfCharacter(from: CharacterSet.letters.inverted) == nil,
        productCode.suffix(3).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        else { return CustomValdiationError.invalidProductCodeFormat }
      return nil
    }
    
    let productCodeErrors = stringValdiator.validate(productCodeField.text, using: [productCodeValidation])
    productCodeErrorField.text = errorMessages(forValidationErrors: productCodeErrors).first
  }
  
  private func validateImage() {
    let testImage = UIImage(named: "TestImage")
    
    let imageValidator = Validator<UIImage>()
    
    let imageSizeValidation: (UIImage?) -> ValidationError? = { image in
      guard let image = image else { return CustomValdiationError.imageNotProvided }
      guard image.size.width > 0, image.size.height > 0 else { return CustomValdiationError.imageTooSmall }
      guard image.size.width < 1000, image.size.height < 1000 else { return CustomValdiationError.imageTooBig }
      return nil
    }
    
    let errors = imageValidator.validate(testImage, using: [imageSizeValidation])
    print(errors)
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

