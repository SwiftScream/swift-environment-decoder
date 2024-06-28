@testable import EnvironmentDecoder
import Testing

struct CamelCaseToUppercaseSnakeCaseTests {
    @Test("", arguments: [
        ("", ""),
        ("_", "_"),
        ("word", "WORD"),
        ("twoWords", "TWO_WORDS"),
        ("nowThreeWords", "NOW_THREE_WORDS"),
        ("btwAcronyms", "BTW_ACRONYMS"),
        ("acronymsFTW", "ACRONYMS_FTW"),
        ("acronymsYOLOInMiddle", "ACRONYMS_YOLO_IN_MIDDLE"),
        ("_leadingUnderscore", "_LEADING_UNDERSCORE"),
        ("trailingUnderscore_", "TRAILING_UNDERSCORE_"),
        ("middle_Underscore", "MIDDLE__UNDERSCORE"),
        ("middle_underscore", "MIDDLE_UNDERSCORE"),
        ("includeNumbers16", "INCLUDE_NUMBERS16"),
        ("include2Numbers16", "INCLUDE2_NUMBERS16"),
    ])
    func caseConverstion(input: String, expectation: String) {
        #expect(convertToUppercaseSnakeCase(input) == expectation)
    }
}
