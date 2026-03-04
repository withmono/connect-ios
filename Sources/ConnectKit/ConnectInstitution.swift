//
//  ConnectInstitution.swift
//
//
//  Created by Tristan Tsvetanov on 02021-07-19.
//

import Foundation

public struct ConnectInstitution: Codable {

    public let id: String  // institution id in Mono DB
    public let authMethod: String  // enum representing possible authentication methods
    public let accountNumber: String  // customer account number

    public init(id: String, authMethod: ConnectAuthMethod, accountNumber: String) {
        self.id = id
        self.accountNumber = accountNumber

        switch authMethod {

        case .InternetBanking:
            self.authMethod = "internet_banking"

        case .MobileBanking:
            self.authMethod = "mobile_banking"

        default:
            self.authMethod = "internet_banking"

        }

    }

    enum CodingKeys: String, CodingKey {
        case id
        case authMethod = "auth_method"
        case accountNumber = "account_number"
    }

}
