# Mimic

`Mimic` is a simply library for stubbing network request.

## Integration

`Mimic` currently only support integration with [Cocoapods](https://www.cocoapods.org).

To integrate `Mimic` into your Xcode project, add the following to your `Podfile`.

```ruby
    pod Mimic, ~> '0.0.3'
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
request(with method: MimicHTTPMethod, url: String)
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