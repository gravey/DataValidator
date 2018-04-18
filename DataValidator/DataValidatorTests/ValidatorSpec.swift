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
        describe("when validate is called with string validation blocks") {
          it("executes validation block") {
            var executed = false
            let _ = sut?.validate("TEST", using: [{ (str) -> (ValidationError?) in
              executed = true
              return nil
            }])
            
            expect(executed).to(beTrue())
          }
          it("returns the nil if validation passed") {
            let errors = sut?.validate("TEST", using: [TestValidations.pass()])
            expect(errors?.first).to(beNil())
          }
          it("returns the error if validation failed") {
            let errors = sut?.validate("TEST", using: [TestValidations.fail()])
            expect(errors?.first as? TestValidationError).to(equal(TestValidationError.testHasFailed))
          }
          it("groups and returns errors if there is more than one failed validation") {
            let errors = sut?.validate("TEST", using: [TestValidations.fail(), TestValidations.fail()])
            expect(errors?.count).to(equal(2))
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
