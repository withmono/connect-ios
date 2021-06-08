# Mono Connect iOS SDK

The Mono Connect SDK is a quick and secure way to link bank accounts to Mono from within your iOS app. Mono Connect is a drop-in framework that handles connecting a financial institution to your app (credential validation, multi-factor authentication, error handling, etc).


For accessing customer accounts and interacting with Mono's API (Identity, Transactions, Income, TransferPay) use the server-side [Mono API](https://docs.mono.co/docs/intro-to-mono-api).

## Documentation

For complete information about Mono Connect, head to the [docs](https://docs.mono.co/docs/intro-to-mono-connect-widget).


## Getting Started

1. Register on the [Mono](https://app.withmono.com/dashboard) website and get your public and secret keys.
2. Setup a server to [exchange tokens](https://docs.mono.co/reference/authentication-endpoint) to access user financial data with your Mono secret key.

## Installation

### Manual

Get the latest version of ConnectKit and embed it into your application.

Go to File -> Swift Packages -> Add Package Dependency... 

Then enter the URL for this package `https://github.com/withmono/connect-ios.git` and select the most recent version.

<!--

Install the package with:

```sh
npm install mono-node --save
# or
yarn add mono-node
```

-->

## Requirements

- Xcode 11.0 or greater
- iOS 9.0 or greater
- The latest version of the ConnectKit

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
  onSuccess: { code in
    print("Success with code: \(code)")
 })
```

#### Initialize a Mono Connect Widget
```swift
let widget = Mono.create(configuration: configuration)
```

#### Load the Widiget
```swift
self.present(widget, animated: true, completion: nil)
```
## Configuration Options

- [`publicKey`](#publicKey)
- [`onSuccess`](#onSuccess)
- [`onClose`](#onClose)
- [`onEvent`](#onEvent)
- [`reference`](#reference)
- [`reauthCode`](#reauthCode)

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

### <a name="onSuccess"></a> `onSuccess`
**((_ code: String) -> Void): Required**

The closure is called when a user has successfully onboarded their account. It should take a single String argument containing the code that can be [exchanged for an account id](https://docs.mono.co/reference/authentication-endpoint).

```swift
let configuration = MonoConfiguration(
  publicKey: "test_pk_...",
  onSuccess: { code in
    print("Success with token: \(code)")
  }
)
```

### <a name="onClose"></a> `onClose `
**(() -> Void): Optional**

The optional closure is called when a user has specifically exited the Mono Connect flow. It does not take any arguments.

```swift
configuration.onClose = { () in
  print("Widget closed.")
}
```
### <a name="onEvent"></a> `onEvent `
**((_ event: ConnectEvent) -> Void): Optional**

This optional closure is called when certain events in the Mono Connect flow have occurred, for example, when the user selected an institution. This enables your application to gain further insight into what is going on as the user goes through the Mono Connect flow.

See the [ConnectEvent](#connectEvent) object below for details.

```swift
configuration.onEvent = { (event) -> Void in
  print(event.eventName)
}
```

### <a name="reference"></a> `reference `
**String: Optional**

When passing a reference to the configuration it will be provided back to you on all onEvent calls.

```swift
configuration.reference = "random_reference_string"
```
### <a name="reauthCode"></a> `reauthCode `
**String: Optional**

Reauthorisation of already authenticated accounts is done when MFA (Multi Factor Authentication) or 2FA is required by the institution for security purposes before more data can be fetched from the account.

Check Mono [docs](https://docs.mono.co/reference/data-sync-overview) on how to obtain `reauthCode` of an account.

```swift
configuration.reauthCode = "code_xyz"
```

### <a name="connectEvent"></a> ConnectEvent

#### <a name="eventName"></a> `eventName`

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


#### <a name="dataObject"></a> `data`
The data object returned from the onEvent callback.

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


## Examples

#### Connecting a Financial Account

On a button click, get an auth `code` for a first time user from [Mono Connect Widget](https://docs.mono.co/docs/widgets).

**Note:** Exchange tokens or a `code` must be passed to your backend for final verification with your `secretKey` for you can retrieve financial information. See [Exchange Token](https://docs.mono.co/reference/authentication-endpoint).

```swift
import UIKit
import ConnectKit

class ViewController: UIViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func AuthenticateWithMono(_ sender: UIButton) {
        
    let configuration = MonoConfiguration(
   	  publicKey: "test_pk_...",
      onSuccess: { code in
        print("Success with code: \(code)")
      })

    configuration.onEvent = { (event) -> Void in
      print(event.eventName)
      print(event.metadata.timestamp)
    }

    configuration.onClose = { () in
      print("Widget closed.")
    }

    let widget = Mono.create(configuration: configuration)

    self.present(widget, animated: true, completion: nil)
  }
}
```
##### Reauthorising an account with MFA

1. First you will need to get a Reauth token on your backend with the [Reauthorise API](https://docs.mono.co/reference/reauth-code).

2. Then you have to pass this token to the frontend for user authentication. 

3. Complete the reauthorisation flow by passing the token to the widget configuration and open the widget.

**Note:** The reauth token expires in 10 minutes. You need to request a token on your backend and pass it to the frontend for use immediately.

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
      reauthCode: "code_xyz"
    )

    let widget = Mono.reauthorise(configuration: configuration)

    self.present(widget, animated: true, completion: nil)
  }
}
```

## Support
If you're having general trouble with Mono Connect iOS SDK or your Mono integration, please reach out to us at <hi@mono.co> or come chat with us on [Slack](https://join.slack.com/t/devwithmono/shared_invite/zt-gvkqczzk-Ldt4FQpHtOL7FFTqh4Ux6A). We're proud of our level of service, and we're more than happy to help you out with your integration to Mono.

## Contributing
If you would like to contribute to the Mono Connect iOS SDK, please make sure to read our [contributor guidelines](https://github.com/withmono/connect-ios/tree/master/CONTRIBUTING.md).


## License

[MIT](https://github.com/withmono/mono-node/blob/develop/LICENSE) for more information.




# Deprecated Implementation

**Please consider migrating to the newest implementation that spports new features such as `onEvent`, `reference`, and `reauthCode`.**

This package makes it very easy to use Mono connect widget in your swift/ios project.

Request access [here](https://app.withmono.com/register) to get your API keys


## Usage

```swift
import UIKit
import ConnectIOS

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: Actions
    @IBAction func AuthenticateWithMono(_ sender: UIButton) {
        let connect = MonoConnect(publicKey: <YOUR_MONO_PUBLIC_KEY_HERE>, onClose: {() -> Void in print("widget closed")}, onSuccess: {(code) -> Void in print("successfully linked account: \(code)")})
        let widget = connect.GetWidget()
        self.present(widget, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func ReauthoriseUser(_ sender: UIButton) {
        let connect = MonoConnect(publicKey: <YOUR_MONO_PUBLIC_KEY_HERE>, onClose: {() -> Void in print("widget closed")}, onSuccess: {(code) -> Void in print("successfully reauthorised account: \(code)")})
        let widget = connect.Reauthorise(code: "code_xyz")
        self.present(widget, animated: true, completion: nil)
    }
}
```

Do not forget to replace <YOUR_MONO_PUBLIC_KEY> with your real public key. Do not use your secret key anywhere with this package.
