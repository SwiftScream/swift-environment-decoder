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
        ("middle_Underscore", "MIDDLE_UNDERSCORE"),
        ("middle_underscore", "MIDDLE_UNDERSCORE"),
        ("includeNumbers16", "INCLUDE_NUMBERS16"),
        ("include2Numbers16", "INCLUDE2_NUMBERS16"),
        ("ALREADY_CORRECT", "ALREADY_CORRECT"),
    ])
    func caseConverstion(input: String, expectation: String) {
        #expect(convertToUppercaseSnakeCase(input) == expectation)
    }

    @Test("", arguments: [
        ("", [""]),
        ("A", ["a"]),
        ("TWO_WORDS", ["twoWords", "twoWORDS"]),
        ("NOW_THREE_WORDS", ["nowThreeWords", "nowThreeWORDS", "nowTHREEWords"]),
        ("THIS_VARIABLE_NAME_IS_LENGTHY", [
            "thisVariableNameIsLengthy", "thisVariableNameIsLENGTHY", "thisVariableNameISLengthy", "thisVariableNAMEIsLengthy",
            "thisVariableNAMEIsLENGTHY", "thisVARIABLENameIsLengthy", "thisVARIABLENameIsLENGTHY", "thisVARIABLENameISLengthy",
        ]),
    ])
    func camelCaseVariants(input: String, expectation: [String]) {
        #expect(uppercaseSnakeCaseToCamelCaseVariants(input) == Set(expectation))
    }
}
