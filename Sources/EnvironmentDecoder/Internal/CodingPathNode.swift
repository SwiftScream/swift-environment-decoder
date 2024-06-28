enum CodingPathNode: Sendable {
    case root
    indirect case node(CodingKey, CodingPathNode)

    var path: [CodingKey] {
        switch self {
        case .root:
            []
        case let .node(key, parent):
            parent.path + [key]
        }
    }

    func appending(_ key: CodingKey) -> CodingPathNode {
        .node(key, self)
    }

    func path(byAppending key: CodingKey) -> [CodingKey] {
        path + [key]
    }
}

enum GenericCodingKey: CodingKey {
    case string(String)
    case int(Int)

    public init(stringValue: String) {
        self = .string(stringValue)
    }

    public init(intValue: Int) {
        self = .int(intValue)
    }

    var stringValue: String {
        switch self {
        case let .string(str): str
        case let .int(int): "\(int)"
        }
    }

    var intValue: Int? {
        switch self {
        case .string: nil
        case let .int(int): int
        }
    }

    static let `super` = GenericCodingKey.string("super")
}
