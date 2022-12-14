//
//  IntrinsicHeightTableView.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/19.
//

import UIKit

final class IntrinsicHeightTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        return .init(
            width: self.contentSize.width + self.contentInset.left + self.contentInset.right,
            height: self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
