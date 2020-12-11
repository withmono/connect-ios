import UIKit

public class MonoConnect {
    let publicKey: String
    let successHandler: ((_ authCode: String) -> Void?)
    let closeHandler: (() -> Void?)
    
    public init(publicKey: String, onClose: @escaping (() -> Void?), onSuccess: @escaping ((_ authCode: String) -> Void?)) {
        self.publicKey = publicKey
        self.closeHandler = onClose
        self.successHandler = onSuccess
    }
    
    public func Reauthorise(code: String) -> UIViewController {
        let widget = MonoViewController(publicKey: self.publicKey, reauth_code: code, onClose: {() -> Void in
            self.closeHandler()
        }, onSuccess: {(code: String) -> Void in
            self.successHandler(code)
        })
        
        return widget
    }

    public func GetWidget() -> UIViewController {
        let widget = MonoViewController(publicKey: self.publicKey, onClose: {() -> Void in
            self.closeHandler()
        }, onSuccess: {(code: String) -> Void in
            self.successHandler(code)
        })
        
        return widget
    }
}
