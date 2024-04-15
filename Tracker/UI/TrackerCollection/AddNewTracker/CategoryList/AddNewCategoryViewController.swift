//
//  AddNewCategory.swift
//
//  Created by Irina Deeva on 15/04/24.
//

import UIKit

protocol AddNewCategoryDelegate: AnyObject {
    func didAddNewCategory(_ category: String)
}

final class AddNewCategoryViewController: UIViewController {
    weak var delegate: AddNewCategoryDelegate?

    private var typeTitle: UILabel = {
        let typeTitle = UILabel()
        typeTitle.text = "Новая категория"
        typeTitle.textColor = .ypBlackDay
        typeTitle.font = .systemFont(ofSize: 16, weight: .medium)
        return typeTitle
    }()

    private var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .ypBackgroundDay
        textField.layer.cornerRadius = 16
        textField.placeholder = "Введите название категории"
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.textAlignment = .left
        return textField
    }()

    private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypGray
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension AddNewCategoryViewController {
    private func setupUI() {
        view.backgroundColor = .ypWhite

        textField.delegate = self

        [typeTitle, textField, saveButton].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            typeTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            typeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: typeTitle.bottomAnchor, constant: 24),

            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

    @objc private func actionButtonTapped(_ sender: UIButton) {
        let trackerName = textField.text ?? ""

        delegate?.didAddNewCategory(trackerName)
        dismiss(animated: true, completion: nil)
    }

    private func checkConditions() {
        let text = textField.text ?? ""

        if !text.isEmpty {
            saveButton.backgroundColor = .ypBlackDay
            saveButton.isEnabled = true
        }
    }
}


extension AddNewCategoryViewController: UITextFieldDelegate {
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


