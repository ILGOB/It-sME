//
//  EducationEditingViewController.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/28.
//

import RxSwift
import SnapKit
import Then
import UIKit

final class EducationEditingViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()
    private let viewModel: EducationEditingViewModel
    
    // MARK: - UI Components
    
    private lazy var inputTableView: IntrinsicHeightTableView = .init(style: .insetGrouped).then {
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.reuseIdentifier)
    }
    
    private lazy var titleInputCell: TextFieldCell = .init().then {
        $0.textField.placeholder = "학교"
        $0.textField.autocorrectionType = .no
        $0.textField.clearButtonMode = .whileEditing
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private lazy var descriptionInputCell: TextFieldCell = .init().then {
        $0.textField.placeholder = "계열 또는 학과"
        $0.textField.autocorrectionType = .no
        $0.textField.clearButtonMode = .whileEditing
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private lazy var entranceDateInputCell: PeriodInputCell = {
        let cell: PeriodInputCell = .init(title: "입학일")
        let action: UIAction = .init { [weak self] _ in
            self?.toggleEntranceDatePickerCell()
        }
        cell.dateSelectionButton.addAction(action, for: .touchUpInside)
        cell.backgroundColor = .secondarySystemGroupedBackground
        return cell
    }()
    
    private lazy var entranceDatePickerCell: YearMonthPickerCell = .init().then {
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.layer.zPosition = -1
        $0.yearMonthPickerView.yearMonthPickerViewDelegate = self
    }
    
    private lazy var graduateDateInputCell: PeriodInputCell = .init(title: "졸업일").then {
        let presentTitle = "재학중"
        let selectPresentAction: UIAction = .init(title: presentTitle) { [weak self] _ in
            self?.graduateDateInputCell.dateSelectionButton.setTitle(presentTitle, for: .normal)
        }
        let selectPeriodAction: UIAction = .init(title: "날짜 선택") { [weak self] _ in
            
        }
        let menu: UIMenu = .init(children: [selectPresentAction, selectPeriodAction])
        $0.dateSelectionButton.menu = menu
        $0.dateSelectionButton.showsMenuAsPrimaryAction = true
        $0.backgroundColor = .secondarySystemGroupedBackground
    }
    
    private lazy var graduateDatePickerCell: YearMonthPickerCell = .init().then {
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.layer.zPosition = -1
    }
    
    private(set) lazy var inputTableViewDataSource: [[UITableViewCell]] = [
        [titleInputCell, descriptionInputCell],
        [entranceDateInputCell, graduateDateInputCell]
    ]
    
    private lazy var completeButton: UIBarButtonItem = .init(title: "완료").then {
        $0.style = .done
    }
    
    // MARK: - Initalizer
    
    init(viewModel: EducationEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        layoutSubviews()
        configureNavigationBar()
    }
}

// MARK: - Private Functions

private extension EducationEditingViewController {
    
    func layoutSubviews() {
        self.view.addSubview(inputTableView)
        inputTableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "학력 편집"
        self.navigationItem.rightBarButtonItem = completeButton
    }
    
    func toggleEntranceDatePickerCell() {
        let section = 1
        let row = 1
        let indexPath: IndexPath = .init(row: row, section: section)
        let animationDuration: TimeInterval = 0.3
        let isShowingDatePickerCell: Bool = inputTableViewDataSource[section].contains(entranceDatePickerCell)
        if isShowingDatePickerCell {
            UIView.animate(withDuration: animationDuration, animations: {
                self.inputTableViewDataSource[section].removeAll { $0 == self.entranceDatePickerCell }
                self.inputTableView.deleteRows(at: [indexPath], with: .fade)
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                self.inputTableViewDataSource[section].insert(self.entranceDatePickerCell, at: row)
                self.inputTableView.insertRows(at: [indexPath], with: .fade)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func toggleGraduateDatePickerCell() {
        
    }
}

// MARK: - Binding ViewModel

private extension EducationEditingViewController {
    
    func bindViewModel() {
        let input: EducationEditingViewModel.Input = .init(
            title: titleInputCell.textField.rx.text.orEmpty.asDriver(),
            description: descriptionInputCell.textField.rx.text.orEmpty.asDriver(),
            entranceDate: entranceDatePickerCell.yearMonthPickerView.rx.dateSelected.asDriver(),
            graduateDate: graduateDatePickerCell.yearMonthPickerView.rx.dateSelected.asDriver(),
            doneTrigger: completeButton.rx.tap.asSignal()
        )
        let output = viewModel.transform(input: input)
        
        [
            output.educationItem
                .drive(educationItemBinding),
            output.doneHandler
                .emit(with: self, onNext: { owner, _ in
                    owner.navigationController?.popViewController(animated: true)
                }),
        ]
            .forEach { $0.disposed(by: disposeBag) }
    }
    
    var educationItemBinding: Binder<EducationItem> {
        .init(self) { vc, educationItem in
            vc.titleInputCell.textField.text = educationItem.title
            vc.descriptionInputCell.textField.text = educationItem.description
            vc.entranceDateInputCell.dateSelectionButton.setTitle(educationItem.entranceDate, for: .normal)
            vc.entranceDatePickerCell.yearMonthPickerView.setDate(year: educationItem.entranceYear, month: educationItem.entranceMonth, animated: false)
            vc.graduateDateInputCell.dateSelectionButton.setTitle(educationItem.graduateDate, for: .normal)
            vc.graduateDatePickerCell.yearMonthPickerView.setDate(year: educationItem.graduateYear, month: educationItem.graduateMonth, animated: false)
        }
    }
}

// MARK: - UITableViewDataSource

extension EducationEditingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        inputTableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inputTableViewDataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return inputTableViewDataSource[indexPath.section][indexPath.row]
    }
}

// MARK: - YearMonthPickerViewDelegate

extension EducationEditingViewController: YearMonthPickerViewDelegate {
    
    func yearMonthPickerViewDidSelect(year: Int, month: Int) {
        print("\(year), \(month)")
    }
}