//
//  UserInfoItem.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/17.
//

import Foundation

final class UserInfoItem: Codable {
    let icon: UserInfoItemIcon
    var contents: String
    
    init(icon: UserInfoItemIcon, contents: String) {
        self.icon = icon
        self.contents = contents
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let iconString = try container.decode(String.self, forKey: .icon)
        self.icon = .init(rawValue: iconString) ?? .default
        self.contents = try container.decode(String.self, forKey: .contents)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(icon.rawValue, forKey: .icon)
        try container.encode(contents, forKey: .contents)
    }
}

enum UserInfoItemIcon: String {
    case `default` = "default"
    case computer = "computer"
    case cake = "cake"
    case house = "house"
    case phone = "phone"
    case letter = "letter"
    
    /// 현재 인스턴스에 할당된 이모지입니다.
    var toEmoji: String {
        switch self {
        case .`default`:
            return "👤"
        case .computer:
            return "💻"
        case .cake:
            return "🎂"
        case .house:
            return "🏠"
        case .phone:
            return "📱"
        case .letter:
            return "✉️"
        }
    }
}

// MARK: - CodingKeys

extension UserInfoItem {
    
    enum CodingKeys: CodingKey {
        case icon
        case contents
    }
}

// MARK: - Equatable

extension UserInfoItem: Equatable {
    
    static func == (lhs: UserInfoItem, rhs: UserInfoItem) -> Bool {
        lhs.icon == rhs.icon &&
        lhs.contents == rhs.contents
    }
}

extension UserInfoItem {
    
    static var empty: UserInfoItem {
        .init(icon: .default, contents: "")
    }
}
