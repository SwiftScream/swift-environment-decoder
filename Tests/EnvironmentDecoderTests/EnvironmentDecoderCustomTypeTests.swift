import EnvironmentDecoder
import Foundation
import Testing

struct EnvironmentDecoderCustomTypeTests {
    @Test func base64DataTest() throws {
        typealias T = Data
        #expect(try decode("", as: T.self) == T())
        #expect(try decode("AQIDBAUGBwg=", as: T.self) == T([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]))
        #expect(try decode("VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wZWQgb3ZlciB0aGUgbGF6eSBkb2ch", as: T.self)
            == T("The quick brown fox jumped over the lazy dog!".utf8))
        #expect(try decode("VGhl,cXVpY2s=,YnJvd24=,Zm94", as: [T].self)
            == ["The", "quick", "brown", "fox"].map { T($0.utf8) })
        #expect(throws: Swift.DecodingError.self) {
            try decode(" ", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("invalid-base-64", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
    }

    @Test func delegatedDataTest() throws {
        typealias T = Data
        let decoder = EnvironmentDecoder(dataDecodingStrategy: .deferredToData)
        #expect(try decode("", as: T.self, with: decoder) == T())
        #expect(try decode("1,2,3,4,5,6,7,8", as: T.self, with: decoder) == T([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]))
        #expect(try decode("0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8", as: T.self, with: decoder) == T([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]))
        #expect(try decode("0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08", as: T.self, with: decoder) == T([0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08]))
        #expect(try decode("0x54,0x68,0x65,0x20,0x71,0x75,0x69,0x63,0x6b,0x20,0x62,0x72,0x6f,0x77,0x6e,0x20,0x66,0x6f,0x78,0x20,0x6a,0x75,0x6d,0x70,0x65,0x64,0x20,0x6f,0x76,0x65,0x72,0x20,0x74,0x68,0x65,0x20,0x6c,0x61,0x7a,0x79,0x20,0x64,0x6f,0x67,0x21", as: T.self, with: decoder)
            == T("The quick brown fox jumped over the lazy dog!".utf8))
        #expect(try decode("VGhl,cXVpY2s=,YnJvd24=,Zm94", as: [T].self)
            == ["The", "quick", "brown", "fox"].map { T($0.utf8) })
        #expect(throws: Swift.DecodingError.self) {
            try decode(" ", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("invalid,int,array", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Data.self)
        }
    }

    @Test func unixTimestampDateTest() throws {
        typealias T = Date
        let decoder = EnvironmentDecoder(dateDecodingStrategy: .secondsSince1970)
        #expect(try decode("0", as: T.self, with: decoder) == Date(timeIntervalSince1970: 0))
        #expect(try decode("1722582300", as: T.self, with: decoder) == Date(timeIntervalSince1970: 1_722_582_300))
        #expect(try decode("0,1722582300,1732582300", as: [T].self, with: decoder)
            == [Date(timeIntervalSince1970: 0), Date(timeIntervalSince1970: 1_722_582_300), Date(timeIntervalSince1970: 1_732_582_300)])
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self, with: decoder)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self, with: decoder)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 0", as: T.self, with: decoder)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0 ", as: T.self, with: decoder)
        }
    }

    @Test func unixMillisecondTimestampDateTest() throws {
        typealias T = Date
        let decoder = EnvironmentDecoder(dateDecodingStrategy: .millisecondsSince1970)
        #expect(try decode("0", as: T.self, with: decoder) == Date(timeIntervalSince1970: 0))
        #expect(try decode("1722582300000", as: T.self, with: decoder) == Date(timeIntervalSince1970: 1_722_582_300))
        #expect(try decode("0,1722582300000,1732582300000", as: [T].self, with: decoder)
            == [Date(timeIntervalSince1970: 0), Date(timeIntervalSince1970: 1_722_582_300), Date(timeIntervalSince1970: 1_732_582_300)])
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self, with: decoder)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self, with: decoder)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 0", as: T.self, with: decoder)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0 ", as: T.self, with: decoder)
        }
    }

    @Test func isoDateTest() throws {
        typealias T = Date
        let decoder = EnvironmentDecoder(dateDecodingStrategy: .iso8601)
        #expect(try decode("1970-01-01T00:00:00Z", as: T.self, with: decoder) == Date(timeIntervalSince1970: 0))
        #expect(try decode("1970-01-01T00:00:00+00:00", as: T.self, with: decoder) == Date(timeIntervalSince1970: 0))
        #expect(try decode("1970-01-01T10:00:00+10:00", as: T.self, with: decoder) == Date(timeIntervalSince1970: 0))
        #expect(try decode("2024-08-02T17:05:00+10:00", as: T.self, with: decoder) == Date(timeIntervalSince1970: 1_722_582_300))
        #expect(try decode("1970-01-01T00:00:00Z,2024-08-02T17:05:00+10:00,2024-11-26T11:51:40+11:00", as: [T].self, with: decoder)
            == [Date(timeIntervalSince1970: 0), Date(timeIntervalSince1970: 1_722_582_300), Date(timeIntervalSince1970: 1_732_582_300)])
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self, with: decoder)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self, with: decoder)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1722582300000", as: T.self, with: decoder)
        }
    }

    @Test func decimalTest() throws {
        typealias T = Decimal
        let formatter = Decimal.FormatStyle(locale: .init(identifier: ""))
            .precision(.integerAndFractionLength(integerLimits: 1...10, fractionLimits: 0...10))

        #expect(try decode("0", as: T.self).formatted(formatter) == "0")
        #expect(try decode("+0", as: T.self).formatted(formatter) == "0")
        #expect(try decode("-0", as: T.self).formatted(formatter) == "0")
        #expect(try decode("3.1415926", as: T.self).formatted(formatter) == "3.1415926")
        #expect(try decode("+3.1415926", as: T.self).formatted(formatter) == "3.1415926")
        #expect(try decode("-3.1415926", as: T.self).formatted(formatter) == "-3.1415926")
        #expect(try decode("3", as: T.self).formatted(formatter) == "3")
        #expect(try decode("+3", as: T.self).formatted(formatter) == "3")
        #expect(try decode("-3", as: T.self).formatted(formatter) == "-3")
        #expect(try decode("2837.5e-2", as: T.self).formatted(formatter) == "28.375")
        #expect(try decode("-2837.5e-2", as: T.self).formatted(formatter) == "-28.375")
        #expect(try decode(" 5.0", as: T.self).formatted(formatter) == "5")
        #expect(try decode("42degrees", as: T.self).formatted(formatter) == "42")
        #expect(try decode(" 1.23", as: T.self).formatted(formatter) == "1.23")
        #expect(try decode("1.23 ", as: T.self).formatted(formatter) == "1.23")
        #expect(try decode("3,3.14,-3", as: [T].self).map { $0.formatted(formatter) } == ["3", "3.14", "-3"])
        #expect(throws: Swift.DecodingError.self) {
            try decode("inf", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("infinity", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("nan", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1.23e17802", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-1.23e17802", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("±2.0", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
    }

    @Test func urlTest() throws {
        typealias T = URL
        #expect(try decode("https://example.com", as: T.self).absoluteString == "https://example.com")
        #expect(try decode("example.com", as: T.self).absoluteString == "example.com")
        #expect(try decode("a.example.com,b.example.com", as: [T].self).map(\.absoluteString) == ["a.example.com", "b.example.com"])
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" https://example.com", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("https://example.com ", as: T.self)
        }
    }
}
