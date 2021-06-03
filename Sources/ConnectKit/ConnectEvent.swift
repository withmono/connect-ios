//
//  ConnectEvent.swift
//
//  Created by Tristan Tsvetanov on 02021-06-01.
//

import Foundation

public class ConnectEvent {

    public let eventName: String // name of event XXXXX
    public let metadata: ConnectMetadata // holds all the related metadata

    public init(eventName: String, type: String, reference: String? = nil, pageName: String? = nil, prevAuthMethod: String? = nil, authMethod: String? = nil, mfaType: String? = nil, selectedAccountsCount: Int? = nil, errorType: String? = nil, errorMessage: String? = nil, institutionId: String? = nil, institutionName: String? = nil, code: String? = nil, timestamp: Date) {

        let metadata = ConnectMetadata(type: type, reference: reference, pageName: pageName, prevAuthMethod: prevAuthMethod, authMethod: authMethod, mfaType: mfaType, selectedAccountsCount: selectedAccountsCount, errorType: errorType, errorMessage: errorMessage, institutionId: institutionId, institutionName: institutionName, code: code, timestamp: timestamp)

        self.metadata = metadata
        self.eventName = eventName
    }

}
