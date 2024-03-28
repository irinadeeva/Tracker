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
    private var selectedTitle: [String] = ["Создание трекера", "Новая привычка", "Новое нерегулярное событие"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite

        habitButton = setupButtonUI()
        habitButton.setTitle("Привычка", for: .normal)

        eventButton = setupButtonUI()
        eventButton.setTitle("Нерегулярное событие", for: .normal)


        // Configure table view

        tableView = UITableView()
//        /tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100)
//        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        typeTitle = UILabel()
        typeTitle.text = selectedTitle[0]
        typeTitle.textColor = .ypBlackDay
        typeTitle.font = .systemFont(ofSize: 16, weight: .medium)

        textField = UITextField()
        textField.backgroundColor = .ypBackgroundDay
        textField.layer.cornerRadius = 16
        textField.placeholder = "Введите название трекера"
//        textField.textAlignment = .
        textField.isHidden = true

        // Add buttons to the view
        view.addSubview(habitButton)
        view.addSubview(eventButton)
        view.addSubview(typeTitle)
        view.addSubview(textField)
        view.addSubview(tableView)

        // Layout buttons
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        typeTitle.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

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

            tableView.heightAnchor.constraint(equalToConstant: 343),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24)
        ])
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

    @objc private func buttonTapped(_ sender: UIButton) {
        eventButton.removeFromSuperview()
        habitButton.removeFromSuperview()
        textField.isHidden = false
        tableView.isHidden = false

        if sender == habitButton {
            typeTitle.text = selectedTitle[1]
        } else {
            typeTitle.text = selectedTitle[2]
        }
    }
}

//extension AddTrackerViewController: UITableViewDelegate {
//
//}

extension AddTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Cell \(indexPath.row + 1)"
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
