//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Irina Deeva on 28/03/24.
//

import UIKit

protocol AddTrackerDelegate: AnyObject {
    func didAddTracker(_ tracker: Tracker)
}

final class AddTrackerViewController: UIViewController {
    weak var delegate: AddTrackerDelegate?

    private var habitButton: UIButton!
    private var eventButton: UIButton!
    private var tableView: UITableView!
    private var typeTitle: UILabel!
    private var textField: UITextField!
    private var saveButton: UIButton!
    private var stackView: UIStackView!
    private var emojiCollectionViewController = EmojiMixesViewController()
    private var colorCollectionViewController = ColorCollectionViewController()
    private var tableViewHeightConstraint: NSLayoutConstraint!
    private var scrollView: UIScrollView!
    private var selectedTitle: [String] = ["Создание трекера", "Новая привычка", "Новое нерегулярное событие"]
    private var cellTitle: [String] = ["Категория", "Расписание"]
    private var cellsNumber = 0
    private var selectedWeekdays: [WeekDay] = []
    private var selectedEmoji = ""
    private var selectedColor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension AddTrackerViewController {
    private func setupUI() {
        view.backgroundColor = .ypWhite

        habitButton = setupButtonUI()
        habitButton.setTitle("Привычка", for: .normal)

        eventButton = setupButtonUI()
        eventButton.setTitle("Нерегулярное событие", for: .normal)

        scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.isHidden = true

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true

        typeTitle = UILabel()
        typeTitle.text = selectedTitle[0]
        typeTitle.textColor = .ypBlackDay
        typeTitle.font = .systemFont(ofSize: 16, weight: .medium)

        textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .ypBackgroundDay
        textField.layer.cornerRadius = 16
        textField.placeholder = "Введите название трекера"
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.textAlignment = .left
        textField.isHidden = true

        let discardButton = setupActionButtonUI()
        discardButton.setTitle("Отменить", for: .normal)
        discardButton.setTitleColor(.ypRed, for: .normal)
        discardButton.backgroundColor = .ypWhite
        discardButton.layer.borderColor = UIColor.ypRed.cgColor
        discardButton.layer.borderWidth = 1.0

        saveButton = setupActionButtonUI()
        saveButton.setTitle("Создать", for: .normal)
        saveButton.setTitleColor(.ypWhite, for: .normal)
        saveButton.backgroundColor = .ypGray
        saveButton.isEnabled = false

        stackView = UIStackView(arrangedSubviews: [discardButton, saveButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.isHidden = true

        emojiCollectionViewController.delegate = self
        addChild(emojiCollectionViewController)
        emojiCollectionViewController.didMove(toParent: self)
        emojiCollectionViewController.view.isHidden = true

        colorCollectionViewController.delegate = self
        addChild(colorCollectionViewController)
        colorCollectionViewController.didMove(toParent: self)
        colorCollectionViewController.view.isHidden = true

        [habitButton, eventButton, scrollView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [typeTitle, textField, tableView, emojiCollectionViewController.view, colorCollectionViewController.view,  stackView].forEach{
            scrollView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),

            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            typeTitle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 13),
            typeTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: typeTitle.bottomAnchor, constant: 24),

            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            tableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),

            emojiCollectionViewController.view.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiCollectionViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            emojiCollectionViewController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            emojiCollectionViewController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
            emojiCollectionViewController.view.heightAnchor.constraint(equalToConstant: 220),


            colorCollectionViewController.view.topAnchor.constraint(equalTo: emojiCollectionViewController.view.bottomAnchor, constant: 16),
            colorCollectionViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            colorCollectionViewController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            colorCollectionViewController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
            colorCollectionViewController.view.heightAnchor.constraint(equalToConstant: 220),

            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: colorCollectionViewController.view.bottomAnchor, constant: 34),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        ])
    }

    private func setupActionButtonUI() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true

        return button
    }

    private func setupButtonUI() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.tintColor = .ypWhite
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true

        return button
    }

    @objc private func actionButtonTapped(_ sender: UIButton) {
        let trackerName = textField.text as? String ?? ""

        if sender == saveButton {
            let newTracker = Tracker(
                id: UUID(),
                name: trackerName,
                color: selectedColor,
                emoji: selectedEmoji,
                timetable: selectedWeekdays
            )

            delegate?.didAddTracker(newTracker)

            dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        eventButton.removeFromSuperview()
        habitButton.removeFromSuperview()
        textField.isHidden = false
        tableView.isHidden = false
        stackView.isHidden = false
        emojiCollectionViewController.view.isHidden = false
        colorCollectionViewController.view.isHidden = false
        scrollView.isHidden = false

        if sender == habitButton {
            typeTitle.text = selectedTitle[1]
            cellsNumber = 2
        } else {
            typeTitle.text = selectedTitle[2]
            cellsNumber = 1
        }

        tableView.reloadData()
        tableView.setNeedsUpdateConstraints()
        tableView.layoutIfNeeded()
        tableViewHeightConstraint.constant = CGFloat(75 * cellsNumber)
    }

    private func checkConditions() {
        let flag: Bool
        let text = textField.text ?? ""

        if cellsNumber == 2 {
            flag = !text.isEmpty && !selectedWeekdays.isEmpty && !selectedEmoji.isEmpty && selectedColor != nil
        } else {
            flag = !text.isEmpty && !selectedEmoji.isEmpty && selectedColor != nil
        }

        if flag {
            saveButton.backgroundColor = .ypBlackDay
            saveButton.isEnabled = true
        }
    }
}

extension AddTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 {
            let destinationViewController = CategoryViewController()
            present(destinationViewController, animated: true, completion: nil)
        } else {
            let destinationViewController = ScheduleViewController()
            destinationViewController.delegate = self
            present(destinationViewController, animated: true, completion: nil)
        }
    }
}

extension AddTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsNumber
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = cellTitle[indexPath.row]
        cell.backgroundColor = .ypBackgroundDay
        cell.textLabel?.textColor = .ypBlackDay
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

extension AddTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.textLimit(existingText: textField.text,
                              newText: string,
                              limit: 38)
    }

    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkConditions()
    }
}

extension AddTrackerViewController: ScheduleDelegate {
    func didDoneTapped(_ weekdays: [String]) {
        for string in weekdays {
            if let weekday = WeekDay(rawValue: string) {
                self.selectedWeekdays.append(weekday)
            }
        }

        checkConditions()
    }
}

extension AddTrackerViewController: EmojiMixesDelegate {
    func didEmojiSelected(_ emoji: String) {
        selectedEmoji = emoji

        checkConditions()
    }
}

extension AddTrackerViewController: ColorDelegate {
    func didColorSelected(_ color: UIColor) {
        selectedColor = color
        
        checkConditions()
    }
}
