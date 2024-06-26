import Foundation

struct Sharpener: Codable {
    var date: String
    var type: String
    var parameters: [(String, String)]

    enum CodingKeys: String, CodingKey {
        case date, type, parameters
    }

    enum ParameterKeys: String, CodingKey {
        case key, value
    }

    init(date: String, type: String, parameters: [(String, String)]) {
        self.date = date
        self.type = type
        self.parameters = parameters
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        type = try container.decode(String.self, forKey: .type)
        
        var parametersContainer = try container.nestedUnkeyedContainer(forKey: .parameters)
        var parametersArray: [(String, String)] = []

        while !parametersContainer.isAtEnd {
            let parameterContainer = try parametersContainer.nestedContainer(keyedBy: ParameterKeys.self)
            let key = try parameterContainer.decode(String.self, forKey: .key)
            let value = try parameterContainer.decode(String.self, forKey: .value)
            parametersArray.append((key, value))
        }
        
        parameters = parametersArray
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(type, forKey: .type)
        
        var parametersContainer = container.nestedUnkeyedContainer(forKey: .parameters)
        
        for parameter in parameters {
            var parameterContainer = parametersContainer.nestedContainer(keyedBy: ParameterKeys.self)
            try parameterContainer.encode(parameter.0, forKey: .key)
            try parameterContainer.encode(parameter.1, forKey: .value)
        }
    }
}
