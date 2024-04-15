import UIKit

final class CategoryTableViewCell: UITableViewCell {
//    var viewModel: CategoryNameViewModel? {
//        didSet {
//            viewModel?.nameBinding = { [weak self] emojis in
//                self?.categoryLabel.text = emojis
//            }
//        }
//    }

    private let categoryLabel: UILabel = {
        let label = UILabel()
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

    func updateLabel(title: String) {
        categoryLabel.text = title
    }

    func getLabelText() -> String? {
        return categoryLabel.text
    }
}

