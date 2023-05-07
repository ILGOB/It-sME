//
//  ItsMEUtils.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/04/12.
//

import Foundation

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw ItsMEError.castingFailed(object: object, targetType: resultType)
    }
    return returnValue
}

func unwrapOrThrow<T>(_ optionalValue: T?) throws -> T {
    guard let unwrappedValue = optionalValue else {
        throw ItsMEError.nilValue(object: optionalValue)
    }
    return unwrappedValue
}

func closestValue<T: BinaryFloatingPoint>(_ target: T, in arr: [T]) -> T? {
    if arr.isEmpty { return nil }
    
    let sorted = arr.sorted()
    
    let over = sorted.first(where: { $0 >= target }) ?? .infinity
    let under = sorted.last(where: { $0 <= target }) ?? -.infinity
    
    let diffOver = over - target
    let diffUnder = target - under
    return (diffOver < diffUnder) ? over : under
}

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0..<16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                assertionFailure("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

struct ItsMEStandardDateFormatter {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    private init() {}
    
    static func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}

struct ItsMESimpleDateFormatter {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy.MM.dd."
        return dateFormatter
    }()
    
    private init() {}
    
    static func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    static func string(from date: Date?) -> String {
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
    
    static func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
}

/// 하이픈(-) 문자가 포함된 전화번호로 변환합니다.
/// - Parameter phoneNumber: 변환할 전화번호를 나타내는 문자열. 숫자간의 구분을 나타내는 다른 문자가 포함되어 있을 수 있습니다. (e.g. `.` `,` `-`...)
/// - Returns: 하이픈 문자가 포함된 전화번호입니다. 자릿수가 11자리를 초과시 하이픈 문자가 포함되지 않습니다.
func formatPhoneNumber(_ phoneNumber: String) -> String {
    var formattedNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: [.regularExpression])
    
    guard let _ = Int(formattedNumber) else { return phoneNumber }
    
    if formattedNumber.count <= "0101234567".count {
        if (4...6) ~= formattedNumber.count {
            formattedNumber.insert("-", at: formattedNumber.index(formattedNumber.startIndex, offsetBy: 3))
            return formattedNumber
        }
        if (7...10) ~= formattedNumber.count {
            formattedNumber.insert("-", at: formattedNumber.index(formattedNumber.startIndex, offsetBy: 3))
            formattedNumber.insert("-", at: formattedNumber.index(formattedNumber.startIndex, offsetBy: 7))
            return formattedNumber
        }
    }
    if formattedNumber.count == "01012345678".count {
        formattedNumber.insert("-", at: formattedNumber.index(formattedNumber.startIndex, offsetBy: 3))
        formattedNumber.insert("-", at: formattedNumber.index(formattedNumber.startIndex, offsetBy: 8))
        return formattedNumber
    }
    
    return formattedNumber
}
