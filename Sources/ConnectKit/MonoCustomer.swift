import Foundation

public struct MonoCustomer: Codable {
    public let id: String?
    public let name: String?
    public let email: String?
    public let identity: MonoCustomerIdentity?
    
    public init(id: String? = nil, name: String? = nil, email: String? = nil, identity: MonoCustomerIdentity? = nil) {
        // Validate that name and email are provided when id is not passed
        if id == nil {
            guard let providedName = name, let providedEmail = email else {
                fatalError("Both name and email are required when id is not provided.")
            }
            self.name = providedName
            self.email = providedEmail
        } else {
            self.name = name
            self.email = email
        }
        
        self.identity = identity
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case identity
    }
}

public struct MonoCustomerIdentity: Codable {
    public let number: String
    public let type: String
    
    public init(type: String, number: String) {
        self.number = number
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case number
    }
}
