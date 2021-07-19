//
//  ConnectInstitution.swift
//  
//
//  Created by Tristan Tsvetanov on 02021-07-19.
//

import Foundation

class ConnectInstitution: Codable {
    
    public let id: String // institution id in Mono DB
    public let auth_method: ConnectAuthMethod // enum representing possible authentication methods

    public init(id: String, authMethod: ConnectAuthMethod) {
        self.id = id
        self.auth_method = authMethod
    }

    
}
