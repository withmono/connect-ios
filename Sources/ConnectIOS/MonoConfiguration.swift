//
//  MonoConfiguration.swift
//  Mono Test
//
//  Created by Tristan Tsvetanov on 02021-06-02.
//

import Foundation

public class MonoConfiguration {

    // required parameters
    var publicKey: String
    var onSuccess: ((_ authCode: String) -> Void?)

    // optional parameters
    var reference: String?
    var onClose: (() -> Void?)?
    var onEvent: ((_ data: ConnectEvent) -> Void?)?
    var reauthCode: String?

    init(publicKey: String, onSuccess: @escaping ((_ authCode: String) -> Void?), reference: String? = nil, reauthCode: String? = nil, onClose: (() -> Void?)? = nil, onEvent: ((_ data: ConnectEvent) -> Void?)? = nil){

        self.publicKey = publicKey
        self.onSuccess = onSuccess

        if onClose != nil {
            self.onClose = onClose!
        }else{
            self.onClose = nil
        }
        if onEvent != nil {
            self.onEvent = onEvent!
        }else{
            self.onEvent = nil
        }
        if reference != nil {
            self.reference = reference
        }else{
            self.reference = nil
        }
        if reauthCode != nil {
            self.reauthCode = reauthCode
        }else{
            self.reauthCode = nil
        }

    }

}
