import Foundation
import Testing

struct EnvironmentDecoderTypeTests {
    @Test func boolTest() throws {
        #expect(try decode("true", as: Bool.self) == true)
        #expect(try decode("false", as: Bool.self) == false)
        #expect(try decode("false,true,false", as: [Bool].self) == [false, true, false])
        #expect(try decode("", as: [Bool].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("0", as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1", as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("TRUE", as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("FALSE", as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("True", as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("False", as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("yes", as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("no", as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" true", as: Bool.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("true ", as: Bool.self)
        }
    }

    @Test func string() throws {
        #expect(try decode("abcdef123456", as: String.self) == "abcdef123456")
        #expect(try decode("", as: String.self) == "")
        #expect(try decode("0", as: String.self) == "0")
        #expect(try decode("42", as: String.self) == "42")
        #expect(try decode("true", as: String.self) == "true")
        #expect(try decode("false", as: String.self) == "false")
        #expect(try decode("🤪", as: String.self) == "🤪")
        #expect(try decode("\"", as: String.self) == "\"")
        #expect(try decode("a,b,c,d,e,f", as: String.self) == "a,b,c,d,e,f")
        #expect(try decode(" abcdef123456", as: String.self) == " abcdef123456")
        #expect(try decode("a,b,,d,efg", as: [String].self) == ["a", "b", "", "d", "efg"])
        #expect(try decode("", as: [String].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Int.self)
        }
    }

    @Test func double() throws {
        #expect(try decode("0", as: Double.self) == 0)
        #expect(try decode("+0", as: Double.self) == 0)
        #expect(try decode("-0", as: Double.self) == 0)
        #expect(try decode("3.1415926", as: Double.self) == 3.1415926)
        #expect(try decode("+3.1415926", as: Double.self) == 3.1415926)
        #expect(try decode("-3.1415926", as: Double.self) == -3.1415926)
        #expect(try decode("3", as: Double.self) == 3)
        #expect(try decode("+3", as: Double.self) == 3)
        #expect(try decode("-3", as: Double.self) == -3)
        #expect(try decode("2837.5e-2", as: Double.self) == 28.375)
        #expect(try decode("0x1c.6", as: Double.self) == 28.375)
        #expect(try decode("+0x1c.6", as: Double.self) == +28.375)
        #expect(try decode("-0x1c.6", as: Double.self) == -28.375)
        #expect(try decode("0x1.c6p4", as: Double.self) == 28.375)
        #expect(try decode("+0x1.c6p4", as: Double.self) == +28.375)
        #expect(try decode("-0x1.c6p4", as: Double.self) == -28.375)
        #expect(try decode("inf", as: Double.self) == Double.infinity)
        #expect(try decode("infinity", as: Double.self) == Double.infinity)
        #expect(try decode("+inf", as: Double.self) == Double.infinity)
        #expect(try decode("+infinity", as: Double.self) == Double.infinity)
        #expect(try decode("-inf", as: Double.self) == -Double.infinity)
        #expect(try decode("-infinity", as: Double.self) == -Double.infinity)
        #expect(try decode("nan", as: Double.self).isNaN)
        #expect(try decode("+nan", as: Double.self).isNaN)
        #expect(try decode("-nan", as: Double.self).isNaN)
        #expect(try decode("1.23e17802", as: Double.self) == Double.infinity)
        #expect(try decode("-1.23e17802", as: Double.self) == -Double.infinity)
        #expect(try decode("3,3.14,-3", as: [Double].self) == [3.0, 3.14, -3.0])
        #expect(try decode("", as: [Double].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 5.0", as: Double.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("±2.0", as: Double.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Double.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: Double.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: Double.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: Double.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 1.23", as: Double.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1.23 ", as: Double.self)
        }
    }

    @Test func float() throws {
        #expect(try decode("0", as: Float.self) == 0)
        #expect(try decode("+0", as: Float.self) == 0)
        #expect(try decode("-0", as: Float.self) == 0)
        #expect(try decode("3.1415926", as: Float.self) == 3.1415926)
        #expect(try decode("+3.1415926", as: Float.self) == 3.1415926)
        #expect(try decode("-3.1415926", as: Float.self) == -3.1415926)
        #expect(try decode("3", as: Float.self) == 3)
        #expect(try decode("+3", as: Float.self) == 3)
        #expect(try decode("-3", as: Float.self) == -3)
        #expect(try decode("2837.5e-2", as: Float.self) == 28.375)
        #expect(try decode("0x1c.6", as: Float.self) == 28.375)
        #expect(try decode("+0x1c.6", as: Float.self) == +28.375)
        #expect(try decode("-0x1c.6", as: Float.self) == -28.375)
        #expect(try decode("0x1.c6p4", as: Float.self) == 28.375)
        #expect(try decode("+0x1.c6p4", as: Float.self) == +28.375)
        #expect(try decode("-0x1.c6p4", as: Float.self) == -28.375)
        #expect(try decode("inf", as: Float.self) == Float.infinity)
        #expect(try decode("infinity", as: Float.self) == Float.infinity)
        #expect(try decode("+inf", as: Float.self) == Float.infinity)
        #expect(try decode("+infinity", as: Float.self) == Float.infinity)
        #expect(try decode("-inf", as: Float.self) == -Float.infinity)
        #expect(try decode("-infinity", as: Float.self) == -Float.infinity)
        #expect(try decode("nan", as: Float.self).isNaN)
        #expect(try decode("+nan", as: Float.self).isNaN)
        #expect(try decode("-nan", as: Float.self).isNaN)
        #expect(try decode("1.23e17802", as: Float.self) == Float.infinity)
        #expect(try decode("-1.23e17802", as: Float.self) == -Float.infinity)
        #expect(try decode("3,3.14,-3", as: [Float].self) == [3.0, 3.14, -3.0])
        #expect(try decode("", as: [Float].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 5.0", as: Float.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("±2.0", as: Float.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Float.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: Float.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: Float.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: Float.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 1.23", as: Float.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1.23 ", as: Float.self)
        }
    }

    @Test func int() throws {
        #expect(try decode("0", as: Int.self) == 0)
        #expect(try decode("123456", as: Int.self) == 123_456)
        #expect(try decode("-123456", as: Int.self) == -123_456)
        #expect(try decode("1,23,456", as: [Int].self) == [1, 23, 456])
        #expect(try decode("", as: [Int].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("123.456", as: Int.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Int.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: Int.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("9223372036854775808", as: Int.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-9223372036854775809", as: Int.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: Int.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: Int.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: Int.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: Int.self)
        }
    }

    @Test func int8() throws {
        #expect(try decode("0", as: Int8.self) == 0)
        #expect(try decode("27", as: Int8.self) == 27)
        #expect(try decode("-27", as: Int8.self) == -27)
        #expect(try decode("1,23,45", as: [Int8].self) == [1, 23, 45])
        #expect(try decode("", as: [Int8].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("27.5", as: Int8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Int8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: Int8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("129", as: Int8.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-129", as: Int8.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: Int8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: Int8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 27", as: Int8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("27 ", as: Int8.self)
        }
    }

    @Test func int16() throws {
        #expect(try decode("0", as: Int16.self) == 0)
        #expect(try decode("1234", as: Int16.self) == 1234)
        #expect(try decode("-1234", as: Int16.self) == -1234)
        #expect(try decode("1,23,456", as: [Int16].self) == [1, 23, 456])
        #expect(try decode("", as: [Int16].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("1234.5", as: Int16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Int16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: Int16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("32768", as: Int16.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-32769", as: Int16.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: Int16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: Int16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 1234", as: Int16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1234 ", as: Int16.self)
        }
    }

    @Test func int32() throws {
        #expect(try decode("0", as: Int32.self) == 0)
        #expect(try decode("123456", as: Int32.self) == 123_456)
        #expect(try decode("-123456", as: Int32.self) == -123_456)
        #expect(try decode("1,23,456", as: [Int32].self) == [1, 23, 456])
        #expect(try decode("", as: [Int32].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456.78", as: Int32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Int32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: Int32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("2147483648", as: Int32.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-2147483649", as: Int32.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: Int32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: Int32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: Int32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: Int32.self)
        }
    }

    @Test func int64() throws {
        #expect(try decode("0", as: Int64.self) == 0)
        #expect(try decode("123456", as: Int64.self) == 123_456)
        #expect(try decode("-123456", as: Int64.self) == -123_456)
        #expect(try decode("1,23,456", as: [Int64].self) == [1, 23, 456])
        #expect(try decode("", as: [Int64].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456.78", as: Int64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: Int64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: Int64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("9223372036854775808", as: Int64.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("-9223372036854775809", as: Int64.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: Int64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: Int64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: Int64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: Int64.self)
        }
    }

    @Test func uint() throws {
        #expect(try decode("0", as: UInt.self) == 0)
        #expect(try decode("123456", as: UInt.self) == 123_456)
        #expect(try decode("0x00", as: UInt.self) == 0)
        #expect(try decode("0x1", as: UInt.self) == 1)
        #expect(try decode("0x01", as: UInt.self) == 1)
        #expect(try decode("0x00000000000000001", as: UInt.self) == 1)
        #expect(try decode("0xe000000000000000", as: UInt.self) == 16_140_901_064_495_857_664)
        #expect(try decode("0xFFFFFFFFFFFFFFFF", as: UInt.self) == 18_446_744_073_709_551_615)
        #expect(try decode("1,23,456", as: [UInt].self) == [1, 23, 456])
        #expect(try decode("", as: [UInt].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("-123456", as: UInt.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456.78", as: UInt.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: UInt.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: UInt.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("18446744073709551616", as: UInt.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x10000000000000000", as: UInt.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x", as: UInt.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xx", as: UInt.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xhello", as: UInt.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: UInt.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: UInt.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: UInt.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: UInt.self)
        }
    }

    @Test func uint8() throws {
        #expect(try decode("0", as: UInt8.self) == 0)
        #expect(try decode("27", as: UInt8.self) == 27)
        #expect(try decode("0x00", as: UInt8.self) == 0)
        #expect(try decode("0x1", as: UInt8.self) == 1)
        #expect(try decode("0x01", as: UInt8.self) == 1)
        #expect(try decode("0x001", as: UInt8.self) == 1)
        #expect(try decode("0xe0", as: UInt8.self) == 224)
        #expect(try decode("0xFF", as: UInt8.self) == 255)
        #expect(try decode("1,23,45", as: [UInt8].self) == [1, 23, 45])
        #expect(try decode("", as: [UInt8].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("-27", as: UInt8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("27.5", as: UInt8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: UInt8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: UInt8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("256", as: UInt8.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x100", as: UInt8.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x", as: UInt8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xx", as: UInt8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xhello", as: UInt8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: UInt8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: UInt8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 27", as: UInt8.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("27 ", as: UInt8.self)
        }
    }

    @Test func uint16() throws {
        #expect(try decode("0", as: UInt16.self) == 0)
        #expect(try decode("1234", as: UInt16.self) == 1234)
        #expect(try decode("0x00", as: UInt16.self) == 0)
        #expect(try decode("0x1", as: UInt16.self) == 1)
        #expect(try decode("0x01", as: UInt16.self) == 1)
        #expect(try decode("0x00001", as: UInt16.self) == 1)
        #expect(try decode("0xe000", as: UInt16.self) == 57344)
        #expect(try decode("0xFFFF", as: UInt16.self) == 65535)
        #expect(try decode("1,23,456", as: [UInt16].self) == [1, 23, 456])
        #expect(try decode("", as: [UInt16].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("-1234", as: UInt16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1234.5", as: UInt16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: UInt16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: UInt16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("65536", as: UInt16.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x10000", as: UInt16.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x", as: UInt16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xx", as: UInt16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xhello", as: UInt16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: UInt16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: UInt16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 1234", as: UInt16.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("1234 ", as: UInt16.self)
        }
    }

    @Test func uint32() throws {
        #expect(try decode("0", as: UInt32.self) == 0)
        #expect(try decode("123456", as: UInt32.self) == 123_456)
        #expect(try decode("0x00", as: UInt32.self) == 0)
        #expect(try decode("0x1", as: UInt32.self) == 1)
        #expect(try decode("0x01", as: UInt32.self) == 1)
        #expect(try decode("0x000000001", as: UInt32.self) == 1)
        #expect(try decode("0xe0000000", as: UInt32.self) == 3_758_096_384)
        #expect(try decode("0xFFFFFFFF", as: UInt32.self) == 4_294_967_295)
        #expect(try decode("1,23,456", as: [UInt32].self) == [1, 23, 456])
        #expect(try decode("", as: [UInt32].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("-123456", as: UInt32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456.78", as: UInt32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: UInt32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: UInt32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("4294967296", as: UInt32.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x100000000", as: UInt32.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x", as: UInt32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xx", as: UInt32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xhello", as: UInt32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: UInt32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: UInt32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: UInt32.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: UInt32.self)
        }
    }

    @Test func uint64() throws {
        #expect(try decode("0", as: UInt64.self) == 0)
        #expect(try decode("123456", as: UInt64.self) == 123_456)
        #expect(try decode("0x00", as: UInt64.self) == 0)
        #expect(try decode("0x1", as: UInt64.self) == 1)
        #expect(try decode("0x01", as: UInt64.self) == 1)
        #expect(try decode("0x00000000000000001", as: UInt64.self) == 1)
        #expect(try decode("0xe000000000000000", as: UInt64.self) == 16_140_901_064_495_857_664)
        #expect(try decode("0xFFFFFFFFFFFFFFFF", as: UInt64.self) == 18_446_744_073_709_551_615)
        #expect(try decode("1,23,456", as: [UInt64].self) == [1, 23, 456])
        #expect(try decode("", as: [UInt64].self) == [])
        #expect(throws: Swift.DecodingError.self) {
            try decode("-123456", as: UInt64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456.78", as: UInt64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(nil, as: UInt64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("", as: UInt64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("18446744073709551616", as: UInt64.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x10000000000000000", as: UInt64.self) // overflow
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0x", as: UInt64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xx", as: UInt64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("0xhello", as: UInt64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("helloworld", as: UInt64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("42degrees", as: UInt64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode(" 123456", as: UInt64.self)
        }
        #expect(throws: Swift.DecodingError.self) {
            try decode("123456 ", as: UInt64.self)
        }
    }
}
