//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Irina Deeva on 28/03/24.
//

import UIKit

final class ScheduleViewController: UIViewController {
    private let weekdays = WeekDay.allCasesRawValue
    private var selectedWeekdays: [String] = []

    private lazy var typeTitle: UILabel = {
        let typeTitle = UILabel()
        typeTitle.text = "Расписание"
        typeTitle.textColor = .ypBlackDay
        typeTitle.font = .systemFont(ofSize: 16, weight: .medium)
        return typeTitle
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.register(WeekdayTableViewCell.self, forCellReuseIdentifier: "weekdayCell")
        return tableView
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        button.tintColor = .ypWhite
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Готово", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite
        view.addSubview(typeTitle)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        typeTitle.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            typeTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            typeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: typeTitle.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor),

            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func doneButtonTapped(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekdays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekdayCell", for: indexPath) as! WeekdayTableViewCell
       
        let weekday = weekdays[indexPath.row]
        cell.weekdayLabel.text = weekday
        cell.backgroundColor = .ypBackgroundDay
        cell.textLabel?.textColor = .ypBlackDay
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)

        cell.weekdaySwitch.isOn = selectedWeekdays.contains(weekday)
        cell.delegate = self
        
        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = tableView.cellForRow(at: indexPath) as? WeekdayTableViewCell else {
            return
        }

        cell.weekdaySwitch.setOn(!cell.weekdaySwitch.isOn, animated: true)

        if cell.weekdaySwitch.isOn {
            cell.weekdaySwitch.onTintColor = .ypBlue
        }
    }
}

extension ScheduleViewController: WeekdayTableViewCellDelegate {
    func switchStateChanged(for weekday: String, isOn: Bool) {
        if isOn {
            selectedWeekdays.append(weekday)
        } else {
            if let index = selectedWeekdays.firstIndex(of: weekday) {
            selectedWeekdays.remove(at: index)
            }
        }
        print(selectedWeekdays)
    }
}

protocol WeekdayTableViewCellDelegate: AnyObject {
    func switchStateChanged(for weekday: String, isOn: Bool)
}

class WeekdayTableViewCell: UITableViewCell {
    let weekdayLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let weekdaySwitch: UISwitch = {
        let weekdaySwitch = UISwitch()
        return weekdaySwitch
    }()

    weak var delegate: WeekdayTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(weekdayLabel)
        addSubview(weekdaySwitch)

        weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
        weekdaySwitch.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weekdayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            weekdayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            weekdaySwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            weekdaySwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        weekdaySwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchStateChanged(for: weekdayLabel.text ?? "", isOn: sender.isOn)
    }
}
