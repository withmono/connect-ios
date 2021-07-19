//
//  MonoConfiguration.swift
//
//  Created by Tristan Tsvetanov on 02021-06-02.
//

import Foundation

public class MonoConfiguration {

    // required parameters
    public var publicKey: String
    public var onSuccess: ((_ authCode: String) -> Void?)

    // optional parameters
    public var reference: String?
    public var onClose: (() -> Void?)?
    public var onEvent: ((_ event: ConnectEvent) -> Void?)?
    public var reauthCode: String?
    public var selectedInstitution: ConnectInstitution?

    public init(publicKey: String, onSuccess: @escaping ((_ authCode: String) -> Void?), reference: String? = nil, reauthCode: String? = nil, onClose: (() -> Void?)? = nil, onEvent: ((_ event: ConnectEvent) -> Void?)? = nil, selectedInstitution: ConnectInstitution? = nil){

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
        if selectedInstitution != nil {
            self.selectedInstitution = selectedInstitution
        }else{
            self.selectedInstitution = nil
        }

    }

}
