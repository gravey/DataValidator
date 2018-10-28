//
//  ValidatorSpec.swift
//  DataValidatorTests
//
//  Created by Richard Gravenor on 18/04/2018.
//  Copyright © 2018 Luminous Squares Ltd. All rights reserved.
//

import Quick
import Nimble

@testable import DataValidator

class ValidatorSpec: QuickSpec {
  override func spec() {
    describe("Validator") {
      context("for string validation") {
        var sut: Validator<String>?
        beforeEach {
          sut = Validator<String>()
        }
        describe("when validate is called with array of string validation blocks") {
          it("executes the validation block") {
            var executed = false
            let _ = sut?.validate("TEST", using: [{ (str) -> (ValidationError?) in
              executed = true
              return nil
            }])
            
            expect(executed).to(beTrue())
          }
          it("returns nil if validation passed") {
            var returnedErrors: [ValidationError] = []
            sut?.validate("TEST", using: [TestValidations.pass()], fail: { (errors: [ValidationError]) in
              returnedErrors = errors
            })
            expect(returnedErrors.first).to(beNil())
          }
          it("returns the error if validation failed") {
            var returnedErrors: [ValidationError] = []
            sut?.validate("TEST", using: [TestValidations.fail()], fail: { (errors: [ValidationError]) in
              returnedErrors = errors
            })
            expect(returnedErrors.first as? TestValidationError).to(equal(TestValidationError.testHasFailed))
          }
          it("groups and returns errors if there is more than one failed validation") {
            var returnedErrors: [ValidationError] = []
            sut?.validate("TEST", using: [TestValidations.fail(), TestValidations.fail()], fail: { (errors: [ValidationError]) in
              returnedErrors = errors
            })
            expect(returnedErrors.count).to(equal(2))
          }
        }
        describe("when validate is called with single string validation block") {
          it("executes the validation block") {
            var executed = false
            let _ = sut?.validate("TEST", using: { (str) -> (ValidationError?) in
              executed = true
              return nil
              })
            
            expect(executed).to(beTrue())
          }
          it("returns nil if validation passed") {
            var returnedErrors: [ValidationError] = []
            sut?.validate("TEST", using: TestValidations.pass(), fail: { (errors: [ValidationError]) in
              returnedErrors = errors
            })
            expect(returnedErrors.first).to(beNil())
          }
          it("returns the error if validation failed") {
            var returnedErrors: [ValidationError] = []
            sut?.validate("TEST", using: TestValidations.fail(), fail: { (errors: [ValidationError]) in
              returnedErrors = errors
            })
            expect(returnedErrors.first as? TestValidationError).to(equal(TestValidationError.testHasFailed))
          }
        }
      }
    }
  }
}

fileprivate enum TestValidationError: ValidationError {
  case testHasFailed
}

fileprivate class TestValidations {
  
  public static func pass() -> ((String?) -> (ValidationError?)) {
    let validation: (String?) -> ValidationError? = { str in
      return nil
    }
    return validation
  }
  
  public static func fail() -> ((String?) -> (ValidationError?)) {
    let validation: (String?) -> ValidationError? = { str in
      return TestValidationError.testHasFailed
    }
    return validation
  }
}
