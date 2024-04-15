import UIKit

final class CategoryTableViewCell: UITableViewCell {
    var viewModel: CategoryNameViewModel? {
        didSet {
            viewModel?.nameBinding = { [weak self] name in
                self?.categoryLabel.text = name
            }
        }
    }

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()

    private let customSeparatorView = UIView()

    var showSeparator: Bool = true {
        didSet {
            customSeparatorView.isHidden = !showSeparator
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .ypBackgroundDay

        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        contentView.addSubview(customSeparatorView)
        customSeparatorView.backgroundColor = .ypLightGay
        customSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            customSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func getLabelText() -> String? {
        return categoryLabel.text
    }
}
