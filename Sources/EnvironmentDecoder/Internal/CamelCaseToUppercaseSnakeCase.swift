import Foundation

// Cribbed from https://github.com/apple/swift-foundation/blob/main/Sources/FoundationEssentials/JSON/JSONEncoder.swift
// and tweaked slightly
func convertToUppercaseSnakeCase(_ stringKey: String) -> String {
    guard !stringKey.isEmpty else { return stringKey }

    var words: [Range<String.Index>] = []
    // The general idea of this algorithm is to split words on transition from lower to upper case, then on transition of >1 upper case characters to lowercase
    //
    // myProperty -> MY_PROPERTY
    // myURLProperty -> MY_URL_PROPERTY
    var wordStart = stringKey.startIndex
    var searchRange = wordStart..<stringKey.endIndex

    // Find next uppercase character
    while let upperCaseRange = stringKey[searchRange].rangeOfCharacter(from: .uppercaseLetters, options: []) {
        if wordStart < upperCaseRange.lowerBound {
            let untilUpperCase = wordStart..<upperCaseRange.lowerBound
            words.append(untilUpperCase)
        }

        // Find next lowercase character
        searchRange = upperCaseRange.lowerBound..<searchRange.upperBound
        guard let lowerCaseRange = stringKey[searchRange].rangeOfCharacter(from: .lowercaseLetters, options: []) else {
            // There are no more lower case letters. Just end here.
            wordStart = searchRange.lowerBound
            break
        }

        // Is the next lowercase letter more than 1 after the uppercase? If so, we encountered a group of uppercase letters that we should treat as its own word
        let nextCharacterAfterCapital = stringKey.index(after: upperCaseRange.lowerBound)
        if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
            // The next character after capital is a lower case character and therefore not a word boundary.
            // Continue searching for the next upper case for the boundary.
            wordStart = upperCaseRange.lowerBound
        } else {
            // There was a range of >1 capital letters. Turn those into a word, stopping at the capital before the lower case character.
            let beforeLowerIndex = stringKey.index(before: lowerCaseRange.lowerBound)
            words.append(upperCaseRange.lowerBound..<beforeLowerIndex)

            // Next word starts at the capital before the lowercase we just found
            wordStart = beforeLowerIndex
        }
        searchRange = lowerCaseRange.upperBound..<searchRange.upperBound
    }

    words = words.map { range in
        let lastCharacterIndex = stringKey.index(before: range.upperBound)
        if stringKey[lastCharacterIndex] == "_" {
            return range.lowerBound..<lastCharacterIndex
        }
        return range
    }

    words.append(wordStart..<searchRange.upperBound)
    let result = words.map { range in
        stringKey[range].uppercased()
    }.joined(separator: "_")
    return result
}

func uppercaseSnakeCaseToCamelCaseVariants(_ string: String) -> Set<String> {
    let components = string.split(separator: "_")
    guard let firstComponent = components.first else {
        return [""]
    }
    let variants = componentsToCamelCaseVariants(components.dropFirst()).map {
        firstComponent.lowercased() + $0
    }
    return Set(variants)
}

private func componentsToCamelCaseVariants(_ components: [String.SubSequence].SubSequence) -> [String] {
    componentsToCamelCaseVariantsUC(components) + componentsToCamelCaseVariantsLC(components)
}

private func componentsToCamelCaseVariantsLC(_ components: [String.SubSequence].SubSequence) -> [String] {
    guard let firstComponent = components.first else {
        return [""]
    }
    let suffixes = componentsToCamelCaseVariants(components.dropFirst())
    return suffixes.map {
        firstComponent.capitalized + $0
    }
}

private func componentsToCamelCaseVariantsUC(_ components: [String.SubSequence].SubSequence) -> [String] {
    guard let firstComponent = components.first else {
        return [""]
    }
    let suffixes = componentsToCamelCaseVariantsLC(components.dropFirst())
    return suffixes.map {
        firstComponent.uppercased() + $0
    }
}
