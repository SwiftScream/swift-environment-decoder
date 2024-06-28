@testable import EnvironmentDecoder
import Testing

struct GenericCodingKeyTests {
    @Test("", arguments: [
        (GenericCodingKey(stringValue: ""), String?.some(""), Int?.none),
        (.string("a"), "a", nil),
        (GenericCodingKey(intValue: 1), "1", 1),
        (.int(2), "2", 2),
    ])
    func caseConverstion(input: GenericCodingKey, stringExpectation: String?, intExpectation: Int?) {
        #expect(input.stringValue == stringExpectation)
        #expect(input.intValue == intExpectation)
    }
}
