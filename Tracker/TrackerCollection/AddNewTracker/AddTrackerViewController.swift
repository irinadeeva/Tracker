//
//  AddTrackerViewController.swift
//  Tracker
//
//  Created by Irina Deeva on 28/03/24.
//

import UIKit

final class AddTrackerViewController: UIViewController{
    private var habitButton: UIButton!
    private var eventButton: UIButton!
    private var tableView: UITableView!
    private var typeTitle: UILabel!
    private var textField: UITextField!
//        private var discardButton: UIButton!
    private var saveButton: UIButton!
    private var stackView: UIStackView!
    private var selectedTitle: [String] = ["Создание трекера", "Новая привычка", "Новое нерегулярное событие"]
    private var cellTitle: [String] = ["Категория", "Расписание"]
    private var cellsNumber = 0

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

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        typeTitle = UILabel()
        typeTitle.text = selectedTitle[0]
        typeTitle.textColor = .ypBlackDay
        typeTitle.font = .systemFont(ofSize: 16, weight: .medium)

        textField = UITextField()
        textField.backgroundColor = .ypBackgroundDay
        textField.layer.cornerRadius = 16
        textField.placeholder = "Введите название трекера"
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

        stackView = UIStackView(arrangedSubviews: [discardButton, saveButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.isHidden = true

        view.addSubview(habitButton)
        view.addSubview(eventButton)
        view.addSubview(typeTitle)
        view.addSubview(textField)
        view.addSubview(tableView)
        view.addSubview(stackView)

        habitButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        typeTitle.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

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

            typeTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            typeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: typeTitle.bottomAnchor, constant: 24),

            //            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),

            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34)
        ])
    }

    private func setupActionButtonUI() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true

        return button
    }

    private func setupButtonUI() -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.tintColor = .ypWhite
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true

        return button
    }

    @objc private func actionButtonTapped(_ sender: UIButton) {
        if sender == saveButton {
        }

        dismiss(animated: true, completion: nil)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        eventButton.removeFromSuperview()
        habitButton.removeFromSuperview()
        textField.isHidden = false
        tableView.isHidden = false
        stackView.isHidden = false

        if sender == habitButton {
            typeTitle.text = selectedTitle[1]
            cellsNumber = 2
        } else {
            typeTitle.text = selectedTitle[2]
            cellsNumber = 1
        }

        tableView.reloadData()
    }
}

extension AddTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("here")

        tableView.deselectRow(at: indexPath, animated: true)


        // Present different views based on the button pressed
        if indexPath.row == 0 {
            print("here indexPath.row = 0")
            let viewController = CategoryViewController()
            //                viewController.view.backgroundColor = .blue
            navigationController?.pushViewController(viewController, animated: true)

        } else if indexPath.row == 1 {
            print("here indexPath.row = 1")
            let viewController = ScheduleViewController()
            //                viewController.view.backgroundColor = .green
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

}
