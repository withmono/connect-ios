# Mono Connect iOS SDK

The Mono Connect SDK is a quick and secure way to link bank accounts to Mono from within your iOS app. Mono Connect is a drop-in framework that handles connecting a financial institution to your app (credential validation, multi-factor authentication, error handling, etc).


For accessing customer accounts and interacting with Mono's API (Identity, Transactions, Income, TransferPay) use the server-side [Mono API](https://docs.mono.co/api).

## Documentation

For complete information about Mono Connect, head to the [docs](https://docs.mono.co/docs/financial-data/overview).


## Getting Started

1. Register on the [Mono](https://app.mono.com) website and get your public and secret keys.
2. Setup a server to [exchange tokens](https://docs.mono.co/api/bank-data/authorisation/exchange-token) to access user financial data with your Mono secret key.

## Installation

### Manual

Get the latest version of ConnectKit and embed it into your application.

Go to File -> Swift Packages -> Add Package Dependency... 

Then enter the URL for this package `https://github.com/withmono/connect-ios.git` and select the most recent version.

## Requirements

- Xcode 11.0 or greater
- iOS 9.0 or greater
- The latest version of the ConnectKit
- Add the key `Privacy - Camera Usage Description` and a usage description to your `Info.plist`.

If editing `Info.plist` as text, add:

```xml
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
```

## To build without Rosetta
To resolve the missing architecture issue when building on M1 and M2 Macs, please follow these instructions, particularly when building for simulator devices:

    1. Add the two architectures, i386 and x86_64, to your project's settings.
    2. Set the "Build Active Architecture Only" flag to "Yes".

By adding these architectures and configuring the "Build Active Architecture Only" setting, you ensure that your project is compatible with both the Intel-based and Apple Silicon-based Macs, enabling successful builds on simulator devices.

## Usage

Before you can open Mono Connect, you need to first create a `publicKey`. Your `publicKey` can be found in the [Mono Dashboard](https://app.withmono.com/apps). 

#### Import ConnectKit
```swift
import ConnectKit
```

#### Create a MonoConfiguration
```swift
let configuration = MonoConfiguration(
  publicKey: "test_pk_...",
  customer: MonoCustomer(id: "customer_id"),
  onSuccess: { code in
    print("Success with code: \(code)")
 })
```

#### Initialize a Mono Connect Widget
```swift
let widget = Mono.create(configuration: configuration)
```

#### Show the Widget
```swift
self.present(widget, animated: true, completion: nil)
```
## Configuration Options

- [`publicKey`](#publicKey)
- [`customer`](#customer)
- [`onSuccess`](#onSuccess)
- [`onClose`](#onClose)
- [`onEvent`](#onEvent)
- [`reference`](#reference)
- [`accountId`](#accountId)
- [`selectedInstitution`](#selectedInstitution)

### <a name="publicKey"></a> `publicKey`
**String: Required**

This is your Mono public API key from the [Mono dashboard](https://app.withmono.com/apps).

```swift
let configuration = MonoConfiguration(
  publicKey: "test_pk_...",
  onSuccess: { code in
    print("Success with code: \(code)")
 })
```

### <a name="customer"></a> `customer`
**MonoCustomer: Required**

```swift
// Existing customer
let customer = MonoCustomer(id: "611aa53041247f2801efb222")

// new customer
let identity = MonoCustomerIdentity(type: "bvn", number: "2323233239")
let customer = MonoCustomer(name: "Samuel Olumide", email: "samuel.olumide@gmail.com", identity: identity)

let configuration = MonoConfiguration(
  publicKey: "test_pk_...",
  customer: customer,
  onSuccess: { code in
    print("Success with code: \(code)")
 })
```

### <a name="onSuccess"></a> `onSuccess`
**((_ code: String) -> Void): Required**

The closure is called when a user has successfully onboarded their account. It should take a single String argument containing the code that can be [exchanged for an account id](https://docs.mono.co/reference/authentication-endpoint).

```swift
let configuration = MonoConfiguration(
  publicKey: "test_pk_...",
  customer: customer,
  onSuccess: { code in
    print("Success with token: \(code)")
  }
)
```

### <a name="onClose"></a> `onClose`
**(() -> Void): Optional**

The optional closure is called when a user has specifically exited the Mono Connect flow. It does not take any arguments.

```swift
configuration.onClose = { () in
  print("Widget closed.")
}
```
### <a name="onEvent"></a> `onEvent`
**((_ event: ConnectEvent) -> Void): Optional**

This optional closure is called when certain events in the Mono Connect flow have occurred, for example, when the user selected an institution. This enables your application to gain further insight into what is going on as the user goes through the Mono Connect flow.

See the [ConnectEvent](#connectEvent) object below for details.

```swift
configuration.onEvent = { (event) -> Void in
  print(event.eventName)
}
```

### <a name="reference"></a> `reference`
**String: Optional**

When passing a reference to the configuration it will be provided back to you on all onEvent calls.

```swift
configuration.reference = "random_reference_string"
```

### <a name="accountId"></a> `accountId`
**String: Optional**

### Re-authorizing an Account with Mono: A Step-by-Step Guide
#### Step 1: Fetch Account ID for previously linked account

Fetch the Account ID of the linked account from the [Mono dashboard](https://app.mono.co/customers) or [API](https://docs.mono.co/docs/customers).

Alternatively, make an API call to the [Exchange Token Endpoint](https://api.withmono.com/v2/accounts/auth) with the code from a successful linking and your mono application secret key. If successful, this will return an Account ID.

##### Sample request:
```swift
import Foundation

let headers = ["accept": "application/json", "Content-Type": "application/json", "mono-sec-key": "your_secret_key"]

let request = NSMutableURLRequest(url: NSURL(string: "https://api.withmono.com/accounts/id/reauthorise")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
request.httpMethod = "POST"
request.allHTTPHeaderFields = headers

let body: [String: Any] = ["code": "some_code"]
let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
request.httpBody = jsonData 

let session = URLSession.shared
let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
  if (error != nil) {
    print(error as Any)
  } else {
    let httpResponse = response as? HTTPURLResponse
    print(httpResponse)
  }
})

dataTask.resume()
```
##### Sample response:
```json
{
  "id": "661d759280dbf646242634cc"
}
```

#### Step 2: Initiate your SDK with re-authorisation config option
With step one out of the way, pass the customer's Account ID to your config option in your installed SDK. Implementation example provided below for the iOS SDK

```swift
let configuration = MonoConfiguration(
  publicKey: "test_pk_...", // your publicKey
  onSuccess: { code in
      print("Success with code: \(code)")
  })
  configuration.reference = "reference"
  configuration.accountId = "account_xyz"
  configuration.onEvent = { (event) -> Void in
      print("Event Name: \(event.eventName), Event Time\(event.data.timestamp)")
      print("Event Reference: \(event.data.reference!)")
}
```

#### Step 3: Trigger re-authorisation widget
In this final step, ensure the widget is launched with the new config. Once opened the user provides a security information which can be: password, pin, OTP, token, security answer etc.
If the re-authorisation process is successful, the user's account becomes re-authorised after which two things happen.
a. The 'mono.events.account_reauthorized' webhook event is sent to the webhook URL that you specified on your dashboard app.
b. Updated financial data gets returned on the Mono connect data APIs when an API request is been made.


### <a name="selectedInstitution"></a> `selectedInstitution`
**String: Optional**

Passing a ConnectInstitution object will open the widget directly to the institution passed in the `id` field and will only allow the user to login to that institution and authentication method. You pass  `.InternetBanking` or `.MobileBanking` as possible options for the authentication method.

```swift
configuration.selectedInstitution = ConnectInstitution(id: "5f2d08c060b92e2888287706", authMethod: .InternetBanking)
```
Note: If an invalid institution id is passed the user is prompted to select an institution from the default list.

## API Reference

### Mono Object

The Mono Object provides two functions for easy interaction with the Mono Connect Widget. It provides two main methods `Mono.create(config: MonoConfiguration)` and `Mono.reauthorise(config: MonoConfiguration)` that both take a [MonoConfiguration](#MonoConfiguration).

### <a name="MonoConfiguration"></a> MonoConfiguration

The configuration option is passed to Mono.create(config: MonoConfiguration) or Mono.reauthorise(config: MonoConfiguration). 

```swift
publicKey: String // required
customer: MonoCustomer, // optional
onSuccesss: (_ code: String) -> Void // required
onClose: (() -> Void?)? // optional
onEvent: ((_ event: ConnectEvent) -> Void?)? // optional
reference: String // optional
accountId: String // optional
scope: String // optional
selectedInstitution: ConnectInstitution // optional
```
#### Usage

```swift
let configuration = MonoConfiguration( // required parameters go in the initializer
  publicKey: "test_pk_...",
  onSuccess: { code in
    print("Success with token: \(code)")
  }
)
// optional parameters can be added as so
configuration.onEvent = { (event) -> Void in
  print(event.eventName)
  print(event.data.institutionName)
}
configuration.onClose = { () -> Void in
  print("Widget closed.")
}
configuration.reference = "random_string"

configuration.selectedInstitution = ConnectInstitution(id: "5f2d08c060b92e2888287706", authMethod: .InternetBanking)

````

### <a name="connectEvent"></a> ConnectEvent

#### <a name="eventName"></a> `eventName: String`

Event names corespond to the `type` key returned by the event data. Possible options are in the table below.

| Event Name | Description |
| ----------- | ----------- |
| OPENED | Triggered when the user opens the Connect Widget. |
| EXIT | Triggered when the user closes the Connect Widget. |
| INSTITUTION_SELECTED | Triggered when the user selects an institution. |
| AUTH_METHOD_SWITCHED | Triggered when the user changes authentication method from internet to mobile banking, or vice versa. |
| SUBMIT_CREDENTIALS | Triggered when the user presses Log in. |
| ACCOUNT_LINKED | Triggered when the user successfully links their account. |
| ACCOUNT_SELECTED | Triggered when the user selects a new account. |
| ERROR | Triggered when the widget reports an error.|


#### <a name="dataObject"></a> `data: ConnectData`
The data object of type ConnectData returned from the onEvent callback.

```swift
type: String // type of event mono.connect.xxxx
reference: String? // reference passed through the connect config
pageName: String? // name of page the widget exited on
prevAuthMethod: String? // auth method before it was last changed
authMethod: String? // current auth method
mfaType: String? // type of MFA the current user/bank requires
selectedAccountsCount: Int? // number of accounts selected by the user
errorType: String? // error thrown by widget
errorMessage: String? // error message describing the error
institutionId: String? // id of institution
institutionName: String? // name of institution
timestamp: Date // timestamp of the event as a Date object
```

### <a name="connectInstitution"></a> ConnectInstitution

#### <a name="institutionId"></a> `id: String`

The id of an institution as provided by Mono. An API will be released for a complete list shortly.

#### <a name="authMethod"></a> `authMethod: Enum`
Can be `.InternetBanking` for internet banking login or `.MobileBanking` for a mobile banking login.


## Examples

#### Connecting a Financial Account

On a button click, get an auth `code` for a first time user from [Mono Connect Widget](https://docs.mono.co/docs/widgets).

**Note:** Exchange tokens or a `code` must be passed to your backend for final verification with your `secretKey` for you can retrieve financial information. See [Exchange Token](https://api.withmono.com/v2/accounts/auth).

```swift
import UIKit
import ConnectKit

class ViewController: UIViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func AuthenticateWithMono(_ sender: UIButton) {
    // let identity = MonoCustomerIdentity(type: "bvn", number: "2323233239")
    // let customer = MonoCustomer(name: "Samuel Olumide", email: "samuel.olumide@gmail.com", identity: identity)
    let customer = MonoCustomer(id: "611aa53041247f2801efb222") // mono customer id
    let configuration = MonoConfiguration(
   	  publicKey: "test_pk_...",
      customer: customer,
      onSuccess: { code in
        print("Success with code: \(code)")
      })

    configuration.onEvent = { (event) -> Void in
      print(event.eventName)
      print(event.data.timestamp)
    }

    configuration.onClose = { () in
      print("Widget closed.")
    }

    let widget = Mono.create(configuration: configuration)

    self.present(widget, animated: true, completion: nil)
  }
}
```
##### Reauthorising an account

1. First you will need to fetch the Account ID for the previously linked account.

2. Then add this ID to the widget configuration object and open the widget.

```swift
import UIKit
import ConnectKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func ReauthoriseUser(_ sender: UIButton) {

    let configuration = MonoConfiguration(
      publicKey: "test_pk_...",
      onSuccess: { code in
        print("Success with code: \(code)")
      },
      accountId: "account_xyz"
    )

    let widget = Mono.reauthorise(configuration: configuration)

    self.present(widget, animated: true, completion: nil)
  }
}
```

## Support
If you're having general trouble with Mono Connect iOS SDK or your Mono integration, please reach out to us at <support@mono.co> or come chat with us on [Slack](https://join.slack.com/t/devwithmono/shared_invite/zt-gvkqczzk-Ldt4FQpHtOL7FFTqh4Ux6A). We're proud of our level of service, and we're more than happy to help you out with your integration to Mono.

## Contributing
If you would like to contribute to the Mono Connect iOS SDK, please make sure to read our [contributor guidelines](https://github.com/withmono/connect-ios/tree/master/CONTRIBUTING.md).


## License

[MIT](https://github.com/withmono/connect-ios/tree/master/LICENSE) for more information.
