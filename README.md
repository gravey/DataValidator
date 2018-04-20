# DataValidator

Provides a simple framework for executing validations on data and reporting back the validaton errors. Primarily written for validating strings from user input fields; however, using generics and a block based functional style, it can be used for validating any type. As validations are encapsulated in closures, it promotes code resuse of the validaton code and good seperation of concerns. Some basic validations for common scenarios (character range, email format, etc.) have been provided in a factory, with the intent of adding more in the future.

## Getting Started

Clone the [the project](https://github.com/gravey/DataValidator) or use [Carthage](https://github.com/Carthage/Carthage) to build/manage the dependency.

### Prerequisites

* Xcode 9.3
* Swift 4.1.

## Examples

Validating strings:

```swift
let stringValdiator = Validator<String>()
let errors = stringValdiator.validate("to be validated...", using: [StringValidations.min(characterCount: 2),
                                                                  	StringValidations.max(characterCount: 50),
                                                                  	StringValidations.isEmail()])
errors.forEach {
  switch $0 {
  case StringValidationError.notEnoughCharacters:
    print("You have not entered enough characters")
  case StringValidationError.tooManyCharacters:
    print("You have entered too many characters")
  case StringValidationError.invalidEmailAddressFormat:
    print("You have not entered a valid email address")
  }
}
```

Custom validation block:

```swift
let productCodeValidation: (String?) -> ValidationError? = { productCode in
  guard
    let productCode = productCode,
    productCode.count == 6,
    productCode.prefix(3).rangeOfCharacter(from: CharacterSet.letters.inverted) == nil,
    productCode.suffix(3).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    else { return CustomValdiationError.invalidProductCodeFormat }
  return nil
}    
let productCodeErrors = stringValdiator.validate("ABC123", using: [productCodeValidation])
```

Conform to ValidationError to provide custom errors:

```
enum CustomValdiationError: ValidationError {
  case invalidProductCodeFormat
} 
```

Validating other data types:

```swift
let testImage = UIImage(named: "TestImage")
let imageValidator = Validator<UIImage>()
let imageSizeValidation: (UIImage?) -> ValidationError? = { image in
  guard let image = image else { return CustomValdiationError.imageNotProvided }
  guard image.size.width > 0, image.size.height > 0 else { return CustomValdiationError.imageTooSmall }
  guard image.size.width < 1000, image.size.height < 1000 else { return CustomValdiationError.imageTooBig }
  return nil
}
let errors = imageValidator.validate(testImage, using: [imageSizeValidation])
```

## Built With

* [Quick](https://github.com/Quick/Quick) - For unit testing
* [Nimble](https://github.com/Quick/Nimble) - For unit testing

## Running the tests

Project is tested with Quick and Nimble and tests can be run via the standard Xcode menu option or key command: ⌘U.

## Contributing

Contributions are welcome.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Richard Gravenor** - *Initial work* - [Gravey](https://github.com/gravey)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
