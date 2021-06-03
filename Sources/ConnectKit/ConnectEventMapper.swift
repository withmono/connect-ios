//
//  ConnectEventMapper.swift
//  Mono Test
//
//  Created by Tristan Tsvetanov on 02021-06-01.
//

import Foundation

var eventNames = [
                    "mono.connect.widget_opened": "OPENED",
                    "mono.connect.error_occured": "ERROR",
                    "mono.connect.institution_selected": "INSTITUTION_SELECTED",
                    "mono.connect.auth_method_switched": "AUTH_METHOD_SWITCHED",
                    "mono.connect.on_exit": "EXIT",
                    "mono.connect.login_attempt": "SUBMIT_CREDENTIALS",
                    "mono.connect.mfa_submitted": "SUBMIT_MFA",
                    "mono.connect.account_linked": "ACCOUNT_LINKED",
                    "mono.connect.account_selected": "ACCOUNT_SELECTED",
                    "mono.connect.widget.account_linked":"SUCCESS",
                    "mono.connect.widget.closed":"CLOSED",
                 ]

class ConnectEventMapper {
  func map(_ dictionary: [String: Any]) -> ConnectEvent? {

    // get event type
    var type = dictionary["type"] as? String
    if type == nil {
        type = "UNKNOWN"
    }

    let name = eventNames[type ?? "UNKNOWN", default: "UNKNOWN"]

    // get data variables
    if let data = dictionary["data"] as? [String : Any] {
        let reference = extractProperty(name: "reference", data: data) as? String
        let pageName = extractProperty(name: "pageName", data: data) as? String
        let prevAuthMethod = extractProperty(name: "prevAuthMethod", data: data) as? String
        let authMethod = extractProperty(name: "authMethod", data: data) as? String
        let mfaType = extractProperty(name: "mfaType", data: data) as? String
        let selectedAccountsCount = extractProperty(name: "selectedAccountsCount", data: data) as? Int
        let errorType = extractProperty(name: "errorType", data: data) as? String
        let errorMessage = extractProperty(name: "errorMessage", data: data) as? String

        // get institution
        let institutionData = data["institution"] as? [String : Any]
        var institutionId: String? = ""
        var institutionName: String? = ""
        if institutionData != nil {
            institutionId = (extractProperty(name: "id", data: institutionData!) as? String)!
            institutionName = (extractProperty(name: "name", data: institutionData!) as? String)!
        }else{
            institutionId = nil
            institutionName = nil
        }


        let code = extractProperty(name: "code", data: data) as? String
        var unixTimestamp = extractProperty(name: "timestamp", data: data) as? Int
        if unixTimestamp != nil {
            unixTimestamp = unixTimestamp! / 1000
        }else{
            unixTimestamp = Int(Date().timeIntervalSince1970)
        }

        let timestamp = Date(timeIntervalSince1970: TimeInterval(unixTimestamp!))

        return ConnectEvent(eventName: name, type: type ?? "UNKNOWN", reference: reference, pageName: pageName, prevAuthMethod: prevAuthMethod, authMethod: authMethod, mfaType: mfaType, selectedAccountsCount: selectedAccountsCount, errorType: errorType, errorMessage: errorMessage, institutionId: institutionId, institutionName: institutionName, code: code, timestamp: timestamp)

    }else{
        return ConnectEvent(eventName: name, type: type ?? "UNKNOWN", timestamp: Date())
    }

  }

    func extractProperty(name: String, data: [String : Any]) -> Any {
        var reference = data[name] as? Any
        return reference
    }

}
