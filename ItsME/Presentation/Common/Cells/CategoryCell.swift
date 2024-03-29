//
//  CategoryCell.swift
//  ItsME
//
//  Created by MacBook Air on 2023/01/31.
//

import SnapKit
import Then
import UIKit

class CategoryCell: UITableViewCell {

    private let cellBottomPadding = 5

    // MARK: - UI Component
    private lazy var periodLabel = UILabel().then {
        $0.text = "기간"
        $0.numberOfLines = 0
        $0.textColor = .label
    }

    private lazy var titleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = .label
        $0.font = .boldSystemFont(ofSize: 20)
    }

    private lazy var secondTitleLabel = UILabel().then {
        $0.text = "부제목"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 15, weight: .light)
    }

    private lazy var descriptionLabel = UILabel().then {
        $0.text = "상세설명"
        $0.numberOfLines = 0
        $0.textColor = .label
        $0.font = .boldSystemFont(ofSize: 15)
    }

    private var customBackgroundView: UIView = .init().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }

    private var coverView: UIView = .init().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("awakeFromNib() has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bind(resumeItem: ResumeItem) {
        periodLabel.text = resumeItem.period
        titleLabel.text = resumeItem.title
        secondTitleLabel.text = resumeItem.secondTitle
        descriptionLabel.text = resumeItem.description
    }
}

// MARK: - Private Functions

private extension CategoryCell {

    func configureSubviews() {

        self.backgroundColor = .clear

        self.addSubview(customBackgroundView)
        customBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-cellBottomPadding)
        }

        self.contentView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-cellBottomPadding)
        }

        self.coverView.addSubview(periodLabel)
        periodLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.lessThanOrEqualToSuperview()
            make.top.equalToSuperview().offset(10)
        }

        self.coverView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalTo(periodLabel.snp.trailing).offset(15)
            make.width.equalTo(periodLabel.snp.width).multipliedBy(2.5)
            make.top.equalToSuperview().offset(10)
        }

        self.coverView.addSubview(secondTitleLabel)
        secondTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalTo(periodLabel.snp.trailing).offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.width.equalTo(titleLabel.snp.width)
        }

        self.coverView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalTo(periodLabel.snp.trailing).offset(15)
            make.top.equalTo(secondTitleLabel.snp.bottom).offset(10)
            make.width.equalTo(titleLabel.snp.width)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
