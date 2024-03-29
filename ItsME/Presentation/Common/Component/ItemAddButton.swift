//
//  ItemAddButton.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/08.
//
import UIKit

final class ItemAddButton: UIButton {

    let fontSize: CGFloat = 17
    let mainColor: UIColor = .mainColor
    let borderLayer = CAShapeLayer()
    let cornerRadius: CGFloat = 6.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSymbolImage()
        configureTitle()

        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureBorder()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureColor()
    }
}

// MARK: - Private Functions
private extension ItemAddButton {

    func configureColor() {
        setBackgroundColor(.secondarySystemGroupedBackground, for: .normal)
        setBackgroundColor(.systemGray4, for: .highlighted)
        self.tintColor = mainColor
    }

    func configureSymbolImage() {
        let configuration: UIImage.SymbolConfiguration = .init(pointSize: fontSize, weight: .heavy, scale: .default)
        let symbolImage: UIImage? = .init(systemName: "plus", withConfiguration: configuration)
        self.setImage(symbolImage, for: .normal)
        self.setImage(symbolImage, for: .highlighted)
    }

    func configureTitle() {
        let title: NSAttributedString = .init(string: "항목추가", attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .heavy)])
        self.setAttributedTitle(title, for: .normal)
        self.setTitleColor(mainColor, for: .normal)
    }

    func configureBorder() {
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.secondaryLabel.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.lineWidth = 1.0
        borderLayer.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.addSublayer(borderLayer)
    }
}
