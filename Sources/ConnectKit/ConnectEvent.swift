//
//  ConnectEvent.swift
//
//  Created by Tristan Tsvetanov on 02021-06-01.
//

import Foundation

public class ConnectEvent {

    public let eventName: String // name of event XXXXX
    public let data: ConnectData // holds all the related data

    public init(eventName: String, type: String, reference: String? = nil, pageName: String? = nil, prevAuthMethod: String? = nil, authMethod: String? = nil, mfaType: String? = nil, selectedAccountsCount: Int? = nil, errorType: String? = nil, errorMessage: String? = nil, institutionId: String? = nil, institutionName: String? = nil, timestamp: Date) {

        let data = ConnectMetadata(type: type, reference: reference, pageName: pageName, prevAuthMethod: prevAuthMethod, authMethod: authMethod, mfaType: mfaType, selectedAccountsCount: selectedAccountsCount, errorType: errorType, errorMessage: errorMessage, institutionId: institutionId, institutionName: institutionName, timestamp: timestamp)

        self.data = data
        self.eventName = eventName
    }

}
