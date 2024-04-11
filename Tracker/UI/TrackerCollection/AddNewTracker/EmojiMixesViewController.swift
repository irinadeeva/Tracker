import UIKit

protocol EmojiMixesDelegate: AnyObject {
    func didEmojiSelected(_ emoji: String)
}

final class EmojiMixesViewController: UIViewController {
    weak var delegate: EmojiMixesDelegate?
    
    private let emojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸",  "🏝",  "😪"
    ]
    
    private let params: GeometricParams = GeometricParams(cellCount: 6,
                                                          leftInset: 18,
                                                          rightInset: 0,
                                                          cellSpacing: 5)
    
    private let emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        collectionView.isScrollEnabled = false
        
        collectionView.register(EmojiMixCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SupplementaryView.supplementaryIdentifier
        )
        
        collectionView.allowsMultipleSelection = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiCollectionView)
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            emojiCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
    }
}

extension EmojiMixesViewController: UICollectionViewDataSource {
    func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojies.count
    }
    
    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? EmojiMixCollectionViewCell else { return UICollectionViewCell() }
        
        cell.updateLabel(title: emojies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionHeader:
            id = "footer"
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath
        ) as? SupplementaryView else {
            return UICollectionReusableView()
        }
        
        view.titleLabel.text = "Emoji"
        return view
    }
}

extension EmojiMixesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)
        
        return CGSize(width: cellWidth,
                      height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiMixCollectionViewCell
        
        guard let cell else {
            return
        }
        
        cell.backgroundColor = .ypLightGay
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        guard let emoji = cell.getLabelText() else {
            return
        }
        
        delegate?.didEmojiSelected(emoji)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell =  collectionView.cellForItem(at: indexPath) as? EmojiMixCollectionViewCell
        
        guard let cell else {
            return
        }
        
        cell.backgroundColor = nil
    }
}
