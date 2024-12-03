public class day03 {
    public enum Token: Equatable, Sendable {
        case mul
        case number(Int)
        case comma
        case roundBracketLeft
        case roundBracketRight
        case invalid

        var isNumber: Bool {
            if case .number = self {
                return true
            }
            return false
        }
    }

    enum TokenizerState {
        case start
        case readingInt
        case readingWord
    }

    static func tokenize(_ input: String) -> [Token] {
        let characters = input.split(separator: "")
        var result: [Token] = []
        var state = TokenizerState.start
        var currentToken = ""
        for char in characters {
            switch char {
            case "m":
                if currentToken == "" && state == TokenizerState.start {
                    state = TokenizerState.readingWord
                    currentToken += "m"
                    break
                }
                result.append(.invalid)
                state = TokenizerState.start
                currentToken = ""
            case "u":
                if currentToken == "m" && state == TokenizerState.readingWord {
                    currentToken += "u"
                    break
                }
                result.append(.invalid)
                state = TokenizerState.start
                currentToken = ""
            case "l":
                if currentToken == "mu" && state == TokenizerState.readingWord {
                    result.append(.mul)
                    state = TokenizerState.start
                    currentToken = ""
                    break
                }

                result.append(.invalid)
                state = TokenizerState.start
                currentToken = ""
            case "(":
                if state == TokenizerState.start {
                    result.append(.roundBracketLeft)
                    break
                }

                result.append(.invalid)
                state = TokenizerState.start
                currentToken = ""
            case ")":
                if state == TokenizerState.readingInt {
                    if let n = Int(currentToken) {
                        result.append(.number(n))
                        result.append(.roundBracketRight)
                        state = TokenizerState.start
                        currentToken = ""
                        break
                    }
                }

                if state == TokenizerState.start {
                    result.append(.roundBracketRight)
                    break
                }

                result.append(.invalid)
                state = TokenizerState.start
                currentToken = ""
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                if state == TokenizerState.start {
                    state = TokenizerState.readingInt
                    currentToken += char
                    break
                }

                if state == TokenizerState.readingInt {
                    currentToken += char
                    break
                }

                result.append(.invalid)
                state = TokenizerState.start
                currentToken = ""
            case ",":
                if state == TokenizerState.readingInt {
                    if let n = Int(currentToken) {
                        result.append(.number(n))
                        result.append(.comma)
                        state = TokenizerState.start
                        currentToken = ""
                        break
                    }
                }

                if state == TokenizerState.start {
                    result.append(.comma)
                    break
                }

                result.append(.invalid)
                state = TokenizerState.start
                currentToken = ""
            default:
                result.append(.invalid)
                state = TokenizerState.start
                currentToken = ""
            }
        }
        return result
    }

    public enum TokenSequence: Equatable, Sendable {
        case mul(_ lhf: Int, _ rhs: Int)
    }

    enum TokenSequenceState {
        case start
        case parsingMul
    }

    static func parseTokens(_ tokens: [Token]) -> [TokenSequence] {
        var result: [TokenSequence] = []
        var currentSequence: [Token] = []
        var state = TokenSequenceState.start
        for token in tokens {
            switch token {
            case .mul:
                if currentSequence.isEmpty && state == .start {
                    currentSequence.append(token)
                    state = .parsingMul
                    break
                }
                currentSequence = []
                state = .start
            case .roundBracketLeft:
                if currentSequence.last == .mul && state == .parsingMul {
                    currentSequence.append(token)
                    break
                }
                currentSequence = []
                state = .start
            case .number:
                if currentSequence.last == .roundBracketLeft && state == .parsingMul {
                    currentSequence.append(token)
                    break
                }
                if currentSequence.last == .comma && state == .parsingMul {
                    currentSequence.append(token)
                    break
                }
                currentSequence = []
                state = .start
            case .comma:
                if let last = currentSequence.last, last.isNumber && state == .parsingMul {
                    currentSequence.append(token)
                    break
                }
                currentSequence = []
                state = .start
            case .roundBracketRight:
                if let last = currentSequence.last, last.isNumber && state == .parsingMul {
                    if case let .number(lhf) = currentSequence[2] {
                        if case let .number(rhs) = currentSequence[4] {
                            result.append(.mul(lhf, rhs))
                        }
                    }
                    currentSequence = []
                    state = .start
                    break
                }
                currentSequence = []
                state = .start
            case .invalid:
                currentSequence = []
                state = .start
            }
        }

        return result
    }

    static func sumSequences(_ sequences: [TokenSequence]) -> Int {
        var sum = 0
        for sequence in sequences {
            if case let .mul(lhf, rhs) = sequence {
                sum += lhf * rhs
            }
        }
        return sum
    }

    public static func runPart1(_ input: String) -> Int {
        let tokens = tokenize(input)
        let sequences = parseTokens(tokens)
        return sumSequences(sequences)
    }
}
