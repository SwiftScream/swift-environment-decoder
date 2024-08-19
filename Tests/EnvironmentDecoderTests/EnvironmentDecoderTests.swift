@testable import EnvironmentDecoder
import Foundation
import Testing

struct EnvironmentDecoderTests {
    @Test func allTypeObjectTest() throws {
        struct A: Decodable {
            let bool: Bool
            let string: String
            let double: Double
            let float: Float
            let int: Int
            let int8: Int8
            let int16: Int16
            let int32: Int32
            let int64: Int64
            let uint: UInt
            let uint8: UInt8
            let uint16: UInt16
            let uint32: UInt32
            let uint64: UInt64
        }
        let env = [
            "BOOL": "true",
            "STRING": "abcdef123786",
            "DOUBLE": "3.141529",
            "FLOAT": "3.141529",
            "INT": "123456",
            "INT8": "123",
            "INT16": "1234",
            "INT32": "123456",
            "INT64": "123456",
            "UINT": "123456",
            "UINT8": "123",
            "UINT16": "1234",
            "UINT32": "123456",
            "UINT64": "123456",
        ]
        let result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.bool == true)
        #expect(result.string == "abcdef123786")
        #expect(result.double == 3.141529)
        #expect(result.float == 3.141529)
        #expect(result.int == 123_456)
        #expect(result.int8 == 123)
        #expect(result.int16 == 1234)
        #expect(result.int32 == 123_456)
        #expect(result.int64 == 123_456)
        #expect(result.uint == 123_456)
        #expect(result.uint8 == 123)
        #expect(result.uint16 == 1234)
        #expect(result.uint32 == 123_456)
        #expect(result.uint64 == 123_456)
    }

    @Test func allArrayTypeObjectTest() throws {
        struct A: Decodable {
            let bool: [Bool]
            let string: [String]
            let double: [Double]
            let float: [Float]
            let int: [Int]
            let int8: [Int8]
            let int16: [Int16]
            let int32: [Int32]
            let int64: [Int64]
            let uint: [UInt]
            let uint8: [UInt8]
            let uint16: [UInt16]
            let uint32: [UInt32]
            let uint64: [UInt64]
            let optionalBool: [Bool?]
            let optionalString: [String?]
            let optionalDouble: [Double?]
            let optionalFloat: [Float?]
            let optionalInt: [Int?]
            let optionalInt8: [Int8?]
            let optionalInt16: [Int16?]
            let optionalInt32: [Int32?]
            let optionalInt64: [Int64?]
            let optionalUint: [UInt?]
            let optionalUint8: [UInt8?]
            let optionalUint16: [UInt16?]
            let optionalUint32: [UInt32?]
            let optionalUint64: [UInt64?]
        }
        let env = [
            "BOOL": "true,false,true",
            "STRING": "abc,def,1,,23786",
            "DOUBLE": "3.14,0.1529",
            "FLOAT": "3.14,0.1529",
            "INT": "1,23,456",
            "INT8": "1,23",
            "INT16": "1,23,4",
            "INT32": "1,23,456",
            "INT64": "1,23,456",
            "UINT": "1,23,456",
            "UINT8": "1,23",
            "UINT16": "1,23,4",
            "UINT32": "1,23,456",
            "UINT64": "1,23,456",
            "OPTIONAL_BOOL": "true,false,true",
            "OPTIONAL_STRING": "abc,def,1,,23786",
            "OPTIONAL_DOUBLE": "3.14,0.1529",
            "OPTIONAL_FLOAT": "3.14,0.1529",
            "OPTIONAL_INT": "1,23,456",
            "OPTIONAL_INT8": "1,23",
            "OPTIONAL_INT16": "1,23,4",
            "OPTIONAL_INT32": "1,23,456",
            "OPTIONAL_INT64": "1,23,456",
            "OPTIONAL_UINT": "1,23,456",
            "OPTIONAL_UINT8": "1,23",
            "OPTIONAL_UINT16": "1,23,4",
            "OPTIONAL_UINT32": "1,23,456",
            "OPTIONAL_UINT64": "1,23,456",
        ]
        let result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.bool == [true, false, true])
        #expect(result.string == ["abc", "def", "1", "", "23786"])
        #expect(result.double == [3.14, 0.1529])
        #expect(result.float == [3.14, 0.1529])
        #expect(result.int == [1, 23, 456])
        #expect(result.int8 == [1, 23])
        #expect(result.int16 == [1, 23, 4])
        #expect(result.int32 == [1, 23, 456])
        #expect(result.int64 == [1, 23, 456])
        #expect(result.uint == [1, 23, 456])
        #expect(result.uint8 == [1, 23])
        #expect(result.uint16 == [1, 23, 4])
        #expect(result.uint32 == [1, 23, 456])
        #expect(result.uint64 == [1, 23, 456])
        #expect(result.optionalBool == [true, false, true])
        #expect(result.optionalString == ["abc", "def", "1", "", "23786"])
        #expect(result.optionalDouble == [3.14, 0.1529])
        #expect(result.optionalFloat == [3.14, 0.1529])
        #expect(result.optionalInt == [1, 23, 456])
        #expect(result.optionalInt8 == [1, 23])
        #expect(result.optionalInt16 == [1, 23, 4])
        #expect(result.optionalInt32 == [1, 23, 456])
        #expect(result.optionalInt64 == [1, 23, 456])
        #expect(result.optionalUint == [1, 23, 456])
        #expect(result.optionalUint8 == [1, 23])
        #expect(result.optionalUint16 == [1, 23, 4])
        #expect(result.optionalUint32 == [1, 23, 456])
        #expect(result.optionalUint64 == [1, 23, 456])
    }

    @Test func composedTest() throws {
        struct B: Decodable {
            let int: Int
            let boolTrue: Bool
        }
        struct A: Decodable {
            let string: String
            let valid: B
        }
        let env = [
            "STRING": "abcdef123786",
            "VALID_INT": "123456",
            "VALID_BOOL_TRUE": "true",
        ]
        let result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.string == "abcdef123786")
        #expect(result.valid.int == 123_456)
        #expect(result.valid.boolTrue == true)
    }

    @Test func optionalTest() throws {
        struct B: Decodable {
            let int: Int
        }
        struct A: Decodable {
            let string: String?
            let validInt: Int?
            let validObject: B?
            let validArray: [String]?
            let undefinedString: String?
            let undefinedInt: Int?
            let undefinedObject: B?
            let undefinedArray: [String]?
        }
        let env = [
            "STRING": "abcdef123786",
            "VALID_INT": "123456",
            "VALID_OBJECT_INT": "123456",
            "VALID_ARRAY": "hello,world",
        ]
        let result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.string == "abcdef123786")
        #expect(result.validInt == 123_456)
        #expect(result.validObject?.int == 123_456)
        #expect(result.validArray == ["hello", "world"])
        #expect(result.undefinedString == nil)
        #expect(result.undefinedInt == nil)
        #expect(result.undefinedObject == nil)
        #expect(result.undefinedArray == nil)
    }

    @Test func keyedContainerAllKeysGenericCodingKeyTest() throws {
        struct DecodeAllKeys: Decodable {
            let keys: Set<String>
            init(from decoder: Decoder) throws {
                let keyedContainer = try decoder.container(keyedBy: GenericCodingKey.self)
                keys = .init(keyedContainer.allKeys.map(\.stringValue))
            }
        }
        struct A: Decodable {
            let allKeysTest: DecodeAllKeys
            let undefined: DecodeAllKeys
        }
        let env = [
            "ALL_KEYS_TEST_ONE": "",
            "ALL_KEYS_TEST_TWO": "",
            "ALL_KEYS_TEST_THREE": "",
            "ALL_KEYS_TEST_ANOTHER_ONE": "",
            "ALL_KEYS_TEST_ANOTHER_TWO": "",
        ]
        let result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.allKeysTest.keys == Set(["one", "two", "three", "anotherOne", "anotherTwo", "anotherONE", "anotherTWO"]))
        #expect(result.undefined.keys == [])
    }

    @Test func keyedContainerAllKeysTest() throws {
        struct A: Decodable {
            enum CodingKeys: String, CodingKey {
                case one
                case twoWords
                case aHTTPAcronym
                case anAbsentKey
            }

            let keys: Set<CodingKeys>
            init(from decoder: any Decoder) throws {
                let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
                keys = .init(keyedContainer.allKeys)
            }
        }
        let env = [
            "ONE": "",
            "TWO_WORDS": "",
            "A_HTTP_ACRONYM": "",
        ]
        let result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.keys == Set([.one, .twoWords, .aHTTPAcronym]))
    }

    @Test func keyedContainerNestedContainerTest() throws {
        struct A: Decodable {
            let string: String
            let nestedInt: Int
            let nestedBool: Bool

            enum CodingKeys: CodingKey {
                case string
                case nested
            }

            enum NestedCodingKeys: CodingKey {
                case int
                case bool
            }

            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                string = try container.decode(String.self, forKey: .string)
                let nestedContainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .nested)
                nestedInt = try nestedContainer.decode(Int.self, forKey: .int)
                nestedBool = try nestedContainer.decode(Bool.self, forKey: .bool)
            }
        }
        let json =
            """
            {
              "string": "abcdef123786",
              "nested": {
                "int": 125687,
                "bool": true
              }
            }
            """
        let jsonResult = try JSONDecoder().decode(A.self, from: Data(json.utf8))
        #expect(jsonResult.string == "abcdef123786")
        #expect(jsonResult.nestedInt == 125_687)
        #expect(jsonResult.nestedBool == true)

        let env = [
            "STRING": "abcdef123786",
            "NESTED_INT": "125687",
            "NESTED_BOOL": "true",
        ]
        let result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.string == "abcdef123786")
        #expect(result.nestedInt == 125_687)
        #expect(result.nestedBool == true)
    }

    @Test func keyedContainerNestedUnkeyedContainerTest() throws {
        struct A: Decodable {
            let string: String
            let optionsA: JSONEncoder.OutputFormatting
            let optionsB: JSONEncoder.OutputFormatting
            let optionsC: JSONEncoder.OutputFormatting

            enum CodingKeys: CodingKey {
                case string
                case optionsA
                case optionsB
                case optionsC
            }

            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                string = try container.decode(String.self, forKey: .string)
                optionsA = try Self.options(from: container.nestedUnkeyedContainer(forKey: .optionsA))
                optionsB = try Self.options(from: container.nestedUnkeyedContainer(forKey: .optionsB))
                optionsC = try Self.options(from: container.nestedUnkeyedContainer(forKey: .optionsC))
            }

            static func options(from: UnkeyedDecodingContainer) throws -> JSONEncoder.OutputFormatting {
                var container = from
                var options: JSONEncoder.OutputFormatting = []
                while !container.isAtEnd {
                    let optionString = try container.decode(String.self)
                    switch optionString {
                    case "prettyPrinted":
                        options.insert(.prettyPrinted)
                    case "sortedKeys":
                        options.insert(.sortedKeys)
                    case "withoutEscapingSlashes":
                        options.insert(.withoutEscapingSlashes)
                    default:
                        break
                    }
                }
                return options
            }
        }
        let json =
            """
            {
              "string": "abcdef123786",
              "optionsA": ["prettyPrinted", "sortedKeys"],
              "optionsB": ["withoutEscapingSlashes", "sortedKeys", "invalidValue"],
              "optionsC": []
            }
            """
        let jsonResult = try JSONDecoder().decode(A.self, from: Data(json.utf8))
        #expect(jsonResult.string == "abcdef123786")
        #expect(jsonResult.optionsA == [.prettyPrinted, .sortedKeys])
        #expect(jsonResult.optionsB == [.sortedKeys, .withoutEscapingSlashes])
        #expect(jsonResult.optionsC == [])

        let env = [
            "STRING": "abcdef123786",
            "OPTIONS_A": "prettyPrinted,sortedKeys",
            "OPTIONS_B": "withoutEscapingSlashes,sortedKeys,invalidValue",
            "OPTIONS_C": "",
        ]
        let result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.string == "abcdef123786")
        #expect(result.optionsA == [.prettyPrinted, .sortedKeys])
        #expect(result.optionsB == [.sortedKeys, .withoutEscapingSlashes])
        #expect(result.optionsC == [])
    }

    @Test func unkeyedContainerTest() throws {
        struct B: Decodable {
            let listOfString: [String]
            var unkeyedContainer: UnkeyedDecodingContainer

            enum CodingKeys: CodingKey {
                case listOfString
            }

            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .listOfString)
                var strings: [String] = []
                while !unkeyedContainer.isAtEnd {
                    try strings.append(unkeyedContainer.decode(String.self))
                }
                listOfString = strings
            }
        }
        struct A: Decodable {
            var nested: B

            enum CodingKeys: CodingKey {
                case nested
            }
        }
        enum NestedCodingKeys: CodingKey {}
        let env = [
            "NESTED_LIST_OF_STRING": "so,long,and,thanks,for,all,the,fish",
        ]
        var result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.nested.listOfString == ["so", "long", "and", "thanks", "for", "all", "the", "fish"])
        #expect(result.nested.unkeyedContainer.count == 8)
        #expect(try result.nested.unkeyedContainer.decodeNil() == false)
        #expect(result.nested.unkeyedContainer.codingPath.count == 2)
        #expect(result.nested.unkeyedContainer.codingPath[0] as? A.CodingKeys == A.CodingKeys.nested)
        #expect(result.nested.unkeyedContainer.codingPath[1] as? B.CodingKeys == B.CodingKeys.listOfString)
        #expect(throws: Swift.DecodingError.self) {
            try result.nested.unkeyedContainer.nestedContainer(keyedBy: NestedCodingKeys.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try result.nested.unkeyedContainer.nestedUnkeyedContainer()
        }
        #expect(throws: Swift.DecodingError.self) {
            try result.nested.unkeyedContainer.superDecoder()
        }
    }

    @Test func invalidUnkeyedContainerTest() throws {
        struct A: Decodable {
            let key: String
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("we-cant,encode-a-container,here", as: [A].self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("we-cant,encode-a-container,here", as: [[String]].self)
        }
    }

    @Test func keyedContainerSuperDecoderTest() throws {
        class SuperA: Decodable {
            let int: Int
            let bool: Bool
        }
        class A: SuperA {
            let string: String

            enum CodingKeys: CodingKey {
                case string
            }

            required init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                string = try container.decode(String.self, forKey: .string)
                let superDecoder = try container.superDecoder()
                try super.init(from: superDecoder)
            }
        }
        let json =
            """
            {
              "string": "abcdef123786",
              "super": {
                "int": 123456,
                "bool": true
              }
            }
            """
        let jsonResult = try JSONDecoder().decode(A.self, from: Data(json.utf8))
        #expect(jsonResult.string == "abcdef123786")
        #expect(jsonResult.int == 123_456)
        #expect(jsonResult.bool == true)

        let env = [
            "STRING": "abcdef123786",
            "SUPER_INT": "123456",
            "SUPER_BOOL": "true",
        ]
        let result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.string == "abcdef123786")
        #expect(result.int == 123_456)
        #expect(result.bool == true)
    }

    @Test func keyedContainerSuperDecoderForKeyTest() throws {
        class SuperA: Decodable {
            let int: Int
            let bool: Bool
        }
        class A: SuperA {
            let string: String

            enum CodingKeys: CodingKey {
                case string
                case nested
            }

            required init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                string = try container.decode(String.self, forKey: .string)
                let superDecoder = try container.superDecoder(forKey: .nested)
                try super.init(from: superDecoder)
            }
        }
        let json =
            """
            {
              "string": "abcdef123786",
              "nested": {
                "int": 123456,
                "bool": true
              }
            }
            """
        let jsonResult = try JSONDecoder().decode(A.self, from: Data(json.utf8))
        #expect(jsonResult.string == "abcdef123786")
        #expect(jsonResult.int == 123_456)
        #expect(jsonResult.bool == true)

        let env = [
            "STRING": "abcdef123786",
            "NESTED_INT": "123456",
            "NESTED_BOOL": "true",
        ]
        let result = try EnvironmentDecoder().decode(A.self, from: env)
        #expect(result.string == "abcdef123786")
        #expect(result.int == 123_456)
        #expect(result.bool == true)
    }
}
