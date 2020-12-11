# ConnectIOS

This package makes it very easy to use Mono connect widget in your swift/ios project.

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
        let connect = MonoConnect(publicKey: "live_pk_wC6uGSyaBdeenGnfZ4oB", onClose: {() -> Void in print("widget closed")}, onSuccess: {(code) -> Void in print("successfully reauthorised account: \(code)")})
        let widget = connect.Reauthorise(code: "code_xyz")
        self.present(widget, animated: true, completion: nil)
    }
}
```

Do no forget to replace <YOUR_MONO_PUBLIC_KEY> with your real public key. Do not use your secret key anywhere with this package.
