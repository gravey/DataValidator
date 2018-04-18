//
//  FormViewController.swift
//  DataValidatorDemo
//
//  Created by Richard Gravenor on 11/04/2018.
//  Copyright © 2018 Luminous Squares Ltd. All rights reserved.
//

import UIKit
import DataValidator

struct DataEntryField {
  let identifier: String
  let field: UITextField
  let errorLabel: UILabel
}

enum FieldIdentifiers: String {
  case firstName = "First Name"
  case surnameName = "Surname"
  case email = "Email"
}

class FormViewController: UIViewController {
  
  @IBOutlet var firstNameField: UITextField!
  @IBOutlet var surnameField: UITextField!
  @IBOutlet var emailField: UITextField!
  
  @IBOutlet var firstNameErrorField: UILabel!
  @IBOutlet var surnameErrorField: UILabel!
  @IBOutlet var emailErrorField: UILabel!
  
  private var dataEntryFields: [DataEntryField] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let field1 = DataEntryField(identifier: FieldIdentifiers.firstName.rawValue, field: firstNameField, errorLabel: firstNameErrorField)
    let field2 = DataEntryField(identifier: FieldIdentifiers.surnameName.rawValue, field: surnameField, errorLabel: surnameErrorField)
    let field3 = DataEntryField(identifier: FieldIdentifiers.email.rawValue, field: emailField, errorLabel: emailErrorField)
    
    dataEntryFields = [field1, field2, field3]
  }
  
  // MARK: - Actions
  
  @IBAction func submitPressed(_ sender: UIButton) {
//    validate()
  }
  
//  // MARK: - Field Validations
//
//  private func firstNameValidations() -> [Validation] {
//    let charRangeValidation = CharacterRange(withText: firstNameField.text,
//                                        min: 5,
//                                        max: 10,
//                                        identifier: FieldIdentifiers.firstName.rawValue)
//    return [charRangeValidation]
//  }
//
//  private func surnameValidations() -> [Validation] {
//    let charRangeValidation = CharacterRange(withText: surnameField.text,
//                                        min: 5,
//                                        max: 10,
//                                        identifier: FieldIdentifiers.surnameName.rawValue)
//    return [charRangeValidation]
//  }
//
//  private func emailValidations() -> [Validation] {
//    let charRangeValidation = CharacterRange(withText: emailField.text,
//                                        identifier: FieldIdentifiers.email.rawValue)
//    return [charRangeValidation]
//  }
//
//  // MARK: - Validate
//
//  private func validate() {
//    let allValidations = [firstNameValidations(),
//                          surnameValidations(),
//                          emailValidations()].flatMap { $0 }
//
//    let validator = ValidatorFactory.validator(validations: allValidations)
//
//    validator.execute { [unowned self] (completedValidations) in
//      self.updateUI(forValidations: completedValidations)
//    }
//  }
//
//  private func updateUI(forValidations validations: [Validation]) {
//    for validation in validations {
//      guard let dataEntryField = (dataEntryFields.filter { $0.identifier == validation.identifier }.first) else { return }
//      dataEntryField.errorLabel.text = nil
//
//      guard let error = validation.state.error else { return }
//      dataEntryField.errorLabel.text = message(forValidationErrorType: error.type)
//    }
//  }
//
//  private func message(forValidationErrorType type: ValidationErrorType) -> String? {
//    switch type {
//    case CharacterValidationErrorType.noInput:
//      return "You need to enter some characters"
//    case CharacterValidationErrorType.notEnoughCharacters:
//      return "You have not entered enough characters"
//    case CharacterValidationErrorType.tooManyCharacters:
//      return "You have entered too many characters"
//    default:
//      return nil
//    }
//  }
}

