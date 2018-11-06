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
  
  var localizedDescription: String {
    switch self {
    case .invalidProductCodeFormat:
      return "Invalid product code format"
    case .imageNotProvided:
      return "Image is required"
    case .imageTooBig:
      return "Image is too big"
    case .imageTooSmall:
      return "Image is too small"
    }
  }
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
    //validateImage()
  }
  
  // MARK: - Validation
  
  private func validateTextFields() {
    
    let stringValdiator = Validator<String>()
    
    let stringValidations = [StringValidation.min(characterCount: 2),
                             StringValidation.max(characterCount: 50)]
    
    stringValdiator.validate(firstNameField.text, using: stringValidations, success: { [unowned self] (_) in
      self.firstNameErrorField.text = nil
    }) { [unowned self] (errors) in
      self.firstNameErrorField.text = self.errorMessages(forValidationErrors: errors).first
      self.firstNameErrorField.pop()
    }

    stringValdiator.validate(surnameField.text, using: stringValidations, success: { [unowned self] (_) in
      self.surnameErrorField.text = nil
    }) { [unowned self] (errors) in
      self.surnameErrorField.text = self.errorMessages(forValidationErrors: errors).first
      self.surnameErrorField.pop()
    }

    let emailValidations = stringValidations + [StringValidation.isEmail()]

    stringValdiator.validate(emailField.text, using: emailValidations, success: { [unowned self] (_) in
      self.emailErrorField.text = nil
    }) { [unowned self] (errors) in
      self.emailErrorField.text = self.errorMessages(forValidationErrors: errors).first
      self.emailErrorField.pop()
    }

    stringValdiator.validate(productCodeField.text, using: { (productCode) -> Optional<ValidationError> in
      guard
        let productCode = productCode,
        productCode.count == 6,
        productCode.prefix(3).rangeOfCharacter(from: CharacterSet.letters.inverted) == nil,
        productCode.suffix(3).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        else { return CustomValdiationError.invalidProductCodeFormat }
      return nil
    }, success: { [unowned self] (_) in
      self.productCodeErrorField.text = nil
    }) { [unowned self] (errors) in
      self.productCodeErrorField.text = self.errorMessages(forValidationErrors: errors).first
      self.productCodeErrorField.pop()
    }
    
    stringValdiator.perform(continueAfterErrors: false) { (response) in
      switch response {
      case .fail:
        print("Display Error / animate labels, etc")
      case .success:
        print("Submit form")
      }
    }
  }
  
  private func validateImage() {
//    let imageValidator = Validator<UIImage>()
//    imageValidator.validate(UIImage(named: "TestImage"), using: { (image) -> Optional<ValidationError> in
//      guard let image = image else { return CustomValdiationError.imageNotProvided }
//      guard image.size.width > 0, image.size.height > 0 else { return CustomValdiationError.imageTooSmall }
//      guard image.size.width < 1000, image.size.height < 1000 else { return CustomValdiationError.imageTooBig }
//      return nil
//    }) { (errors) in
//      print(errors)
//    }
  }

  private func errorMessages(forValidationErrors errors: [ValidationError]) -> [String] {
    let messages: [String] = errors.compactMap {
      return $0.localizedDescription
    }
    
    return messages
  }
}

extension UIView {
  func pop() {
    let transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    UIView.animate(withDuration: 0.3, animations: {
      self.transform = transform
    }) { (_) in
      UIView.animate(withDuration: 0.3, animations: {
        self.transform = CGAffineTransform.identity
      })
    }
  }
}
