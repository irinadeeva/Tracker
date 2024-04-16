import UIKit

final class CategoryTableViewCell: UITableViewCell {
    var viewModel: CategoryNameViewModel? {
        didSet {
            viewModel?.nameBinding = { [weak self] name in
                self?.categoryLabel.text = name
            }
        }
    }

    private let checkmarkView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "ypCheck"))
        view.isHidden = true

        return view
    }()

    var showCheckmark: Bool = false {
        didSet {
            checkmarkView.isHidden = !showCheckmark
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

    override func prepareForReuse() {
      super.prepareForReuse()
      customSeparatorView.isHidden = false
      checkmarkView.isHidden = true
     }

    private func setupUI() {
        contentView.backgroundColor = .ypBackgroundDay
        customSeparatorView.backgroundColor = .ypLightGay

        addSubview(categoryLabel)
        addSubview(checkmarkView)
        contentView.addSubview(customSeparatorView)

        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        customSeparatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            checkmarkView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkmarkView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkView.heightAnchor.constraint(equalToConstant: 24),
            checkmarkView.widthAnchor.constraint(equalToConstant: 24),

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
