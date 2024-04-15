import UIKit

protocol CategoryDelegate: AnyObject {
    func didDoneTapped(_ category: String)
}

final class CategoryViewController: UIViewController {
    weak var delegate: CategoryDelegate?

    private var categories: [String] =
    ["Important", "Unimportant"]
//    []
    private var selectedCategory: String = ""

    private lazy var typeTitle: UILabel = {
        let typeTitle = UILabel()
        typeTitle.text = "Категория"
        typeTitle.textColor = .ypBlackDay
        typeTitle.font = .systemFont(ofSize: 16, weight: .medium)
        return typeTitle
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        button.tintColor = .ypWhite
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setTitle("Добавить категорию", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension CategoryViewController {
    private func setupUI() {
        view.backgroundColor = .ypWhite
        view.addSubview(typeTitle)
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)

        typeTitle.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            typeTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            typeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: typeTitle.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75 * 7),

            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func addButtonTapped(_ sender: UIButton){

        let nextController = AddNewCategoryViewController()
        nextController.delegate = self
        nextController.isModalInPresentation = true
        present(nextController, animated: true)
    }
}


extension CategoryViewController: AddNewCategoryDelegate {
    func didAddNewCategory(_ category: String) {
        categories.append(category)
        tableView.reloadData()
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories.count == 0 {
            tableView.setEmptyMessage(message: "Привычки и события можно\nобъединить по смыслу", image: "emptyTracker")
        }

        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }

        let category = categories[indexPath.row]
        cell.updateLabel(title: category)
        cell.backgroundColor = .ypBackgroundDay
        cell.textLabel?.textColor = .ypBlackDay
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)

        if indexPath.row == 6 {
            cell.showSeparator = false
        }

        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else {
            return
        }

        delegate?.didDoneTapped(selectedCategory)
        dismiss(animated: true, completion: nil)
    }
}

extension UITableView {
    func setEmptyMessage(message: String, image: String) {
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        emptyView.backgroundColor = .white
        emptyView.sizeToFit()

        let imageStub = UIImageView()
        imageStub.image = UIImage(named: image) ?? UIImage()
        emptyView.addSubview(imageStub)

        let labelStub = UILabel()
        labelStub.text = message
        labelStub.font = .systemFont(ofSize: 12, weight: .medium)
        labelStub.textColor = .black
        labelStub.numberOfLines = 2
        labelStub.textAlignment = .center
        emptyView.addSubview(labelStub)

        imageStub.translatesAutoresizingMaskIntoConstraints = false
        labelStub.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageStub.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            imageStub.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            labelStub.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            labelStub.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 16),
            labelStub.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -16),
            labelStub.topAnchor.constraint(equalTo: imageStub.bottomAnchor, constant: 8)
        ])

        self.backgroundView = emptyView
    }

    func restore() {
        self.backgroundView = nil
    }
}

