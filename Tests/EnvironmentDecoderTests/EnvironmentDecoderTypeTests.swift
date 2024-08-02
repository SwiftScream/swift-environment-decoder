import Foundation
import Testing

struct EnvironmentDecoderTypeTests {
    @Test func boolTest() throws {
        typealias T = Bool
        #expect(try decode("true", as: T.self) == true)
        #expect(try decode("false", as: T.self) == false)
        #expect(try decode("false,true,false", as: [T].self) == [false, true, false])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("0", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("TRUE", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("FALSE", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("True", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("False", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("yes", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("no", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" true", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("true ", as: T.self)
        }
    }

    @Test func string() throws {
        typealias T = String
        #expect(try decode("abcdef123456", as: T.self) == "abcdef123456")
        #expect(try decode("", as: T.self) == "")
        #expect(try decode("0", as: T.self) == "0")
        #expect(try decode("42", as: T.self) == "42")
        #expect(try decode("true", as: T.self) == "true")
        #expect(try decode("false", as: T.self) == "false")
        #expect(try decode("🤪", as: T.self) == "🤪")
        #expect(try decode("\"", as: T.self) == "\"")
        #expect(try decode("a,b,c,d,e,f", as: T.self) == "a,b,c,d,e,f")
        #expect(try decode(" abcdef123456", as: T.self) == " abcdef123456")
        #expect(try decode("a,b,,d,efg", as: [T].self) == ["a", "b", "", "d", "efg"])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Int.self)
        }
    }

    @Test func double() throws {
        typealias T = Double
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("+0", as: T.self) == 0)
        #expect(try decode("-0", as: T.self) == 0)
        #expect(try decode("3.1415926", as: T.self) == 3.1415926)
        #expect(try decode("+3.1415926", as: T.self) == 3.1415926)
        #expect(try decode("-3.1415926", as: T.self) == -3.1415926)
        #expect(try decode("3", as: T.self) == 3)
        #expect(try decode("+3", as: T.self) == 3)
        #expect(try decode("-3", as: T.self) == -3)
        #expect(try decode("2837.5e-2", as: T.self) == 28.375)
        #expect(try decode("0x1c.6", as: T.self) == 28.375)
        #expect(try decode("+0x1c.6", as: T.self) == +28.375)
        #expect(try decode("-0x1c.6", as: T.self) == -28.375)
        #expect(try decode("0x1.c6p4", as: T.self) == 28.375)
        #expect(try decode("+0x1.c6p4", as: T.self) == +28.375)
        #expect(try decode("-0x1.c6p4", as: T.self) == -28.375)
        #expect(try decode("inf", as: T.self) == T.infinity)
        #expect(try decode("infinity", as: T.self) == T.infinity)
        #expect(try decode("+inf", as: T.self) == T.infinity)
        #expect(try decode("+infinity", as: T.self) == T.infinity)
        #expect(try decode("-inf", as: T.self) == -T.infinity)
        #expect(try decode("-infinity", as: T.self) == -T.infinity)
        #expect(try decode("nan", as: T.self).isNaN)
        #expect(try decode("+nan", as: T.self).isNaN)
        #expect(try decode("-nan", as: T.self).isNaN)
        #expect(try decode("1.23e17802", as: T.self) == T.infinity)
        #expect(try decode("-1.23e17802", as: T.self) == -T.infinity)
        #expect(try decode("3,3.14,-3", as: [T].self) == [3.0, 3.14, -3.0])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 5.0", as: T.self)
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
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 1.23", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1.23 ", as: T.self)
        }
    }

    @Test func float() throws {
        typealias T = Float
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("+0", as: T.self) == 0)
        #expect(try decode("-0", as: T.self) == 0)
        #expect(try decode("3.1415926", as: T.self) == 3.1415926)
        #expect(try decode("+3.1415926", as: T.self) == 3.1415926)
        #expect(try decode("-3.1415926", as: T.self) == -3.1415926)
        #expect(try decode("3", as: T.self) == 3)
        #expect(try decode("+3", as: T.self) == 3)
        #expect(try decode("-3", as: T.self) == -3)
        #expect(try decode("2837.5e-2", as: T.self) == 28.375)
        #expect(try decode("0x1c.6", as: T.self) == 28.375)
        #expect(try decode("+0x1c.6", as: T.self) == +28.375)
        #expect(try decode("-0x1c.6", as: T.self) == -28.375)
        #expect(try decode("0x1.c6p4", as: T.self) == 28.375)
        #expect(try decode("+0x1.c6p4", as: T.self) == +28.375)
        #expect(try decode("-0x1.c6p4", as: T.self) == -28.375)
        #expect(try decode("inf", as: T.self) == T.infinity)
        #expect(try decode("infinity", as: T.self) == T.infinity)
        #expect(try decode("+inf", as: T.self) == T.infinity)
        #expect(try decode("+infinity", as: T.self) == T.infinity)
        #expect(try decode("-inf", as: T.self) == -T.infinity)
        #expect(try decode("-infinity", as: T.self) == -T.infinity)
        #expect(try decode("nan", as: T.self).isNaN)
        #expect(try decode("+nan", as: T.self).isNaN)
        #expect(try decode("-nan", as: T.self).isNaN)
        #expect(try decode("1.23e17802", as: T.self) == T.infinity)
        #expect(try decode("-1.23e17802", as: T.self) == -T.infinity)
        #expect(try decode("3,3.14,-3", as: [T].self) == [3.0, 3.14, -3.0])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 5.0", as: T.self)
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
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 1.23", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1.23 ", as: T.self)
        }
    }

    @Test func int() throws {
        typealias T = Int
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("123456", as: T.self) == 123_456)
        #expect(try decode("-123456", as: T.self) == -123_456)
        #expect(try decode("1,23,456", as: [T].self) == [1, 23, 456])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("123.456", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("9223372036854775808", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-9223372036854775809", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: T.self)
        }
    }

    @Test func int8() throws {
        typealias T = Int8
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("27", as: T.self) == 27)
        #expect(try decode("-27", as: T.self) == -27)
        #expect(try decode("1,23,45", as: [T].self) == [1, 23, 45])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("27.5", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("129", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-129", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 27", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("27 ", as: T.self)
        }
    }

    @Test func int16() throws {
        typealias T = Int16
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("1234", as: T.self) == 1234)
        #expect(try decode("-1234", as: T.self) == -1234)
        #expect(try decode("1,23,456", as: [T].self) == [1, 23, 456])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("1234.5", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("32768", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-32769", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 1234", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1234 ", as: T.self)
        }
    }

    @Test func int32() throws {
        typealias T = Int32
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("123456", as: T.self) == 123_456)
        #expect(try decode("-123456", as: T.self) == -123_456)
        #expect(try decode("1,23,456", as: [T].self) == [1, 23, 456])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456.78", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("2147483648", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-2147483649", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: T.self)
        }
    }

    @Test func int64() throws {
        typealias T = Int64
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("123456", as: T.self) == 123_456)
        #expect(try decode("-123456", as: T.self) == -123_456)
        #expect(try decode("1,23,456", as: [T].self) == [1, 23, 456])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456.78", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("9223372036854775808", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-9223372036854775809", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: T.self)
        }
    }

    @Test func uint() throws {
        typealias T = UInt
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("123456", as: T.self) == 123_456)
        #expect(try decode("0x00", as: T.self) == 0)
        #expect(try decode("0x1", as: T.self) == 1)
        #expect(try decode("0x01", as: T.self) == 1)
        #expect(try decode("0x00000000000000001", as: T.self) == 1)
        #expect(try decode("0xe000000000000000", as: T.self) == 16_140_901_064_495_857_664)
        #expect(try decode("0xFFFFFFFFFFFFFFFF", as: T.self) == 18_446_744_073_709_551_615)
        #expect(try decode("1,23,456", as: [T].self) == [1, 23, 456])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("-123456", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456.78", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("18446744073709551616", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x10000000000000000", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xx", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xhello", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: T.self)
        }
    }

    @Test func uint8() throws {
        typealias T = UInt8
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("27", as: T.self) == 27)
        #expect(try decode("0x00", as: T.self) == 0)
        #expect(try decode("0x1", as: T.self) == 1)
        #expect(try decode("0x01", as: T.self) == 1)
        #expect(try decode("0x001", as: T.self) == 1)
        #expect(try decode("0xe0", as: T.self) == 224)
        #expect(try decode("0xFF", as: T.self) == 255)
        #expect(try decode("1,23,45", as: [T].self) == [1, 23, 45])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("-27", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("27.5", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("256", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x100", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xx", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xhello", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 27", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("27 ", as: T.self)
        }
    }

    @Test func uint16() throws {
        typealias T = UInt16
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("1234", as: T.self) == 1234)
        #expect(try decode("0x00", as: T.self) == 0)
        #expect(try decode("0x1", as: T.self) == 1)
        #expect(try decode("0x01", as: T.self) == 1)
        #expect(try decode("0x00001", as: T.self) == 1)
        #expect(try decode("0xe000", as: T.self) == 57344)
        #expect(try decode("0xFFFF", as: T.self) == 65535)
        #expect(try decode("1,23,456", as: [T].self) == [1, 23, 456])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("-1234", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1234.5", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("65536", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x10000", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xx", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xhello", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 1234", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1234 ", as: T.self)
        }
    }

    @Test func uint32() throws {
        typealias T = UInt32
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("123456", as: T.self) == 123_456)
        #expect(try decode("0x00", as: T.self) == 0)
        #expect(try decode("0x1", as: T.self) == 1)
        #expect(try decode("0x01", as: T.self) == 1)
        #expect(try decode("0x000000001", as: T.self) == 1)
        #expect(try decode("0xe0000000", as: T.self) == 3_758_096_384)
        #expect(try decode("0xFFFFFFFF", as: T.self) == 4_294_967_295)
        #expect(try decode("1,23,456", as: [T].self) == [1, 23, 456])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("-123456", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456.78", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("4294967296", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x100000000", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xx", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xhello", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: T.self)
        }
    }

    @Test func uint64() throws {
        typealias T = UInt64
        #expect(try decode("0", as: T.self) == 0)
        #expect(try decode("123456", as: T.self) == 123_456)
        #expect(try decode("0x00", as: T.self) == 0)
        #expect(try decode("0x1", as: T.self) == 1)
        #expect(try decode("0x01", as: T.self) == 1)
        #expect(try decode("0x00000000000000001", as: T.self) == 1)
        #expect(try decode("0xe000000000000000", as: T.self) == 16_140_901_064_495_857_664)
        #expect(try decode("0xFFFFFFFFFFFFFFFF", as: T.self) == 18_446_744_073_709_551_615)
        #expect(try decode("1,23,456", as: [T].self) == [1, 23, 456])
        #expect(try decode("", as: [T].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("-123456", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456.78", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("18446744073709551616", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x10000000000000000", as: T.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xx", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xhello", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: T.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: T.self)
        }
    }
}
