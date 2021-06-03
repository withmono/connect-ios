//
//  EventData.swift
//  Mono Test
//
//  Created by Tristan Tsvetanov on 02021-06-01.
//

import Foundation

struct ConnectMetadata {

    let type: String // type of event mono.connect.xxxx
    let reference: String? // reference passed through the connect setup
    let pageName: String? // name of page the widget exited on
    let prevAuthMethod: String? // auth method before it was last changed
    let authMethod: String? // current auth method
    let mfaType: String? // type of MFA the current user/bank requires
    let selectedAccountsCount: Int? // number of accounts selected by the user
    let errorType: String? // error thrown by widget
    let errorMessage: String? // error message describing the error
    let institutionId: String? // id of institution
    let institutionName: String? // name of institution
    let code: String? // the code returned when a link is successful, see https://docs.mono.co/reference/authentication-endpoint
    let timestamp: Date // timestamp of the event converted to Date object

    init(type: String, reference: String? = nil, pageName: String? = nil, prevAuthMethod: String? = nil, authMethod: String? = nil, mfaType: String? = nil, selectedAccountsCount: Int? = nil, errorType: String? = nil, errorMessage: String? = nil, institutionId: String? = nil, institutionName: String? = nil, code: String? = nil, timestamp: Date) {
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
        self.code = code
        self.timestamp = timestamp
    }

}

public class ConnectEvent {


    let eventName: String // name of event XXXXX
    let metadata: ConnectMetadata // holds all the related metadata

//    init(type: String, reference: String, pageName: String){
//        self.type = type
//        self.reference = reference
//        self.pageName = pageName
//
//    }

    init(eventName: String, type: String, reference: String? = nil, pageName: String? = nil, prevAuthMethod: String? = nil, authMethod: String? = nil, mfaType: String? = nil, selectedAccountsCount: Int? = nil, errorType: String? = nil, errorMessage: String? = nil, institutionId: String? = nil, institutionName: String? = nil, code: String? = nil, timestamp: Date) {

        let metadata = ConnectMetadata(type: type, reference: reference, pageName: pageName, prevAuthMethod: prevAuthMethod, authMethod: authMethod, mfaType: mfaType, selectedAccountsCount: selectedAccountsCount, errorType: errorType, errorMessage: errorMessage, institutionId: institutionId, institutionName: institutionName, code: code, timestamp: timestamp)

        self.metadata = metadata
        self.eventName = eventName
    }

}
