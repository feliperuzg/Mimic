# Mimic

`Mimic` is a simple library for stubbing network request.

- [Integration](#integration)
- [Usage](#usage)
    - [Adding new stub](#adding-new-stub)
    - [Randomize stubs](#randomize-stubs)
    - [Using wild card parameters](#using-wild-card-parameters)
    - [Removing Stubs](#removing-stubs)
- [Testing](#testing)
- [Limitations](#limitations)

## Integration

Using `Mimic`  with [Cocoapods](https://www.cocoapods.org).

To integrate `Mimic` into your Xcode project, add the following to your `Podfile`.

```ruby
    pod 'Mimic', ~> '0.2.0'
```

Using `Mimic`  with [Carthage](https://github.com/Carthage/Carthage).

To integrate `Mimic` into your Xcode project, add the following to your `Cartfile`.

```ruby
github "feliperuzg/Mimic" 
```

## Usage

### Adding new stub

To create a new stub use

```swift
@discardableResult public class func mimic(
    request: @escaping MimicRequest,
    delay: TimeInterval = 0,
    response: @escaping MimicResponse
) -> MimicObject
````

Where `MimicRequest` is constructed like:

```swift
request(with method: MimicHTTPMethod, url: String, wildCard: Bool = false)
```

And `MimicResponse` is constructed like:

```swift
response(with json: Any status: Int = 200, headers: String : String]? = nil)
```

Example:

```swift
let stub = Mimic.mimic(
    request: request(with: .get, url: "http://example.com"),
    delay: 2,
    response: response(with: ["response": true], status: 200, headers: ["SomeHeader": "SomeValue"]) 
)
```

You could also prefer not to store the `MimicObject` that's returned, like:

```swift
Mimic.mimic(
    request: request(with: .get, url: "http://example.com"),
    delay: 2,
    response: response(with: ["response": true], status: 200, headers: ["SomeHeader": "SomeValue"]) 
)
```

### Randomize stubs

`Mimic` supports returning a random mimic for the same request, to archive this just add more than one mimic for the same request, for example:

```swift
Mimic.mimic(
    request: request(with: .get, url: "http://example.com"),
    delay: 2,
    response: response(with: ["response": true], status: 200]) 
)

Mimic.mimic(
    request: request(with: .get, url: "http://example.com"),
    delay: 2,
    response: response(with: ["response": false], status: 400]) 
)
```

And finally activate the randomize fuction by activating it's parameter in `Mimic`

```swift 
Mimic.randomizeMimics = true
```

This will search all mimics for a request and return a random element.

### Using wild card parameters

`Mimic` support adding multiple wild card parameters inside an url by replacing the string with `@wild`. This will allow to stub request to endpoints with dynamic paramters inside path o query, for example:

Let's take as example the followig url

`http://example.com/path1/path2?item1=value1&&item2=value2`

Adding wild parameter to path parater `path2`

`http://example.com/path1/`**@wild**`?item1=value1&&item2=value2`

Adding wild parameter to query parameter `value1`

`http://example.com/path1/path2?item1=`**@wild**`&&item2=value2`

Adding wild paramter to both `path2` and `value1`

`http://example.com/path1/`**@wild**`?item1=`**@wild**`&&item2=value2`

### Removing stubs

To remove a single stub you can use

```swift
public class func stopMimic(_ mimic: MimicObject)
```

For Example:

This will add a new stub

```swift 
let stub = Mimic(
    request: request(with: .get, url: "http://example.com"),
    delay: 2,
    response: response(with: ["response": true))
)
```

For removing it you would do:

```swift
Mimic.stopMimic(stub)
```

For removing all stubs call:

```swift
Mimic.stopAllMimics()
```

## Testing

To ensure the `URLSessionConfiguration` swizzle is performed before the request it's recommended to initialize `Mimic` first

```swift
class myTests: XCTests {
    ...
    // Test properties here
    override func setUp() {
        super.setUp()
        Mimic.start()
        ...
        // Other initializers
    }
    ...
    // Other tests functions
}
```

## Limitations

`Mimic` only support simple request, it doesn't support downloading or uploading tasks yet.

Request methods are limited to:
-  GET
- POST
- DELETE
- PUT
