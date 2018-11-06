//
//  DataValidatorTests.swift
//  DataValidatorTests
//
//  Created by Richard Gravenor on 18/04/2018.
//  Copyright © 2018 Luminous Squares Ltd. All rights reserved.
//

import Quick
import Nimble

@testable import DataValidator

class StringValidationsSpec: QuickSpec {
  override func spec() {
    describe("StringValidations") {
      describe("max character count") {
        context("if exceeded") {
          var block: ((String?) -> (ValidationError?))!
          
          beforeEach {
            block = StringValidation.max(characterCount: 5)
          }
          
          it("returns too many characters error") {
            let error = block("Test string")
            expect(error as? StringValidationError).to(equal(StringValidationError.tooManyCharacters))
          }
        }
        context("if not exceeded") {
          var block: ((String?) -> (ValidationError?))!
          
          beforeEach {
            block = StringValidation.max(characterCount: 100)
          }
          
          it("returns nil") {
            let error = block("Test string")
            expect(error as? StringValidationError).to(beNil())
          }
        }
      }
      describe("min character count") {
        context("if not exceeded") {
          var block: ((String?) -> (ValidationError?))!
          
          beforeEach {
            block = StringValidation.min(characterCount: 20)
          }
          
          it("returns not enough characters error") {
            let error = block("Test string")
            expect(error as? StringValidationError).to(equal(StringValidationError.notEnoughCharacters))
          }
        }
        context("if exceeded") {
          var block: ((String?) -> (ValidationError?))!
          
          beforeEach {
            block = StringValidation.min(characterCount: 5)
          }
          
          it("returns nil") {
            let error = block("Test string")
            expect(error as? StringValidationError).to(beNil())
          }
        }
      }
      describe("email valdiation block") {
        context("if is not a valid email format") {
          var emailValidationBlock: ((String?) -> (ValidationError?))!
          var error: ValidationError?
            
          beforeEach {
            emailValidationBlock = StringValidation.isEmail()
            error = emailValidationBlock("not an email")
          }
          
          it("returns error") {
            expect(error as? StringValidationError).to(equal(StringValidationError.invalidEmailAddressFormat))
          }
        }
        context("if is a valid email format") {
          var emailValidationBlock: ((String?) -> (ValidationError?))!
          var error: ValidationError?
          
          beforeEach {
            emailValidationBlock = StringValidation.isEmail()
            error = emailValidationBlock("test@email.com")
          }
          
          it("returns nil") {
            expect(error as? StringValidationError).to(beNil())
          }
        }
      }
      describe("phone number valdiation block") {
        context("if is not a valid phone number format") {
          var phoneValidationBlock: ((String?) -> (ValidationError?))!
          var error: ValidationError?
          
          beforeEach {
            phoneValidationBlock = StringValidation.isPhoneNumber()
            error = phoneValidationBlock("not a phone number")
          }
          
          it("returns error") {
            expect(error as? StringValidationError).to(equal(StringValidationError.invalidPhoneCharacters))
          }
        }
        context("if has valid phone characters with no international code") {
          var phoneValidationBlock: ((String?) -> (ValidationError?))!
          var error: ValidationError?
          
          beforeEach {
            phoneValidationBlock = StringValidation.isPhoneNumber()
            error = phoneValidationBlock("07654 345 576")
          }
          
          it("returns nil") {
            expect(error as? StringValidationError).to(beNil())
          }
        }
        context("if has valid phone characters with international code") {
          var phoneValidationBlock: ((String?) -> (ValidationError?))!
          var error: ValidationError?
          
          beforeEach {
            phoneValidationBlock = StringValidation.isPhoneNumber()
            error = phoneValidationBlock("+44 7654 345 576")
          }
          
          it("returns nil") {
            expect(error as? StringValidationError).to(beNil())
          }
        }
      }
      describe("web address valdiation block") {
        context("if is not a valid web address format") {
          var validationBlock: ((String?) -> (ValidationError?))!
          var error: ValidationError?
          
          beforeEach {
            validationBlock = StringValidation.isAddress()
            error = validationBlock("com.domain://")
          }
          
          it("returns error") {
            expect(error as? StringValidationError).to(equal(StringValidationError.invalidWebAddressFormat))
          }
        }
        context("if is a valid http web address format") {
          var validationBlock: ((String?) -> (ValidationError?))!
          var error: ValidationError?
          
          beforeEach {
            validationBlock = StringValidation.isAddress()
            error = validationBlock("http://www.domain.com")
          }
          
          it("returns nil") {
            expect(error as? StringValidationError).to(beNil())
          }
        }
        context("if is a valid https web address format") {
          var validationBlock: ((String?) -> (ValidationError?))!
          var error: ValidationError?
          
          beforeEach {
            validationBlock = StringValidation.isAddress()
            error = validationBlock("https://www.domain.com")
          }
          
          it("returns nil") {
            expect(error as? StringValidationError).to(beNil())
          }
        }
        context("if is a valid web address format with no protocol") {
          var validationBlock: ((String?) -> (ValidationError?))!
          var error: ValidationError?
          
          beforeEach {
            validationBlock = StringValidation.isAddress()
            error = validationBlock("www.domain.com")
          }
          
          it("returns nil") {
            expect(error as? StringValidationError).to(beNil())
          }
        }
      }
    }
  }
}
