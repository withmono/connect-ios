//
//  ConnectData.swift
//
//  Created by Tristan Tsvetanov on 02021-06-01.
//

import Foundation

public class ConnectData {

    public let type: String // type of event mono.connect.xxxx
    public let reference: String? // reference passed through the connect setup
    public let pageName: String? // name of page the widget exited on
    public let prevAuthMethod: String? // auth method before it was last changed
    public let authMethod: String? // current auth method
    public let mfaType: String? // type of MFA the current user/bank requires
    public let selectedAccountsCount: Int? // number of accounts selected by the user
    public let errorType: String? // error thrown by widget
    public let errorMessage: String? // error message describing the error
    public let institutionId: String? // id of institution
    public let institutionName: String? // name of institution
    public let timestamp: Date // timestamp of the event converted to Date object

    public init(type: String, reference: String? = nil, pageName: String? = nil, prevAuthMethod: String? = nil, authMethod: String? = nil, mfaType: String? = nil, selectedAccountsCount: Int? = nil, errorType: String? = nil, errorMessage: String? = nil, institutionId: String? = nil, institutionName: String? = nil, timestamp: Date) {
        self.type = type
        self.reference = reference
        self.pageName = pageName
        self.prevAuthMethod = prevAuthMethod
        self.authMethod = authMethod
        self.mfaType = mfaType
        self.selectedAccountsCount = selectedAccountsCount
        self.errorType = errorType
        self.errorMessage = errorMessage
        self.institutionId = institutionId
        self.institutionName = institutionName
        self.timestamp = timestamp
    }

}
