//
//  ColorCollectionViewController.swift
//  Tracker
//
//  Created by Irina Deeva on 08/04/24.
//

import UIKit

protocol ColorDelegate: AnyObject {
    func didColorSelected(_ color: UIColor)
}

final class ColorCollectionViewController: UIViewController {
    weak var delegate: ColorDelegate?

    private let colors: [UIColor] = [
        .ypSelection1, .ypSelection2, .ypSelection3, .ypSelection4, .ypSelection5, .ypSelection6,
        .ypSelection7, .ypSelection8, .ypSelection9, .ypSelection10, .ypSelection11, .ypSelection12,
        .ypSelection13, .ypSelection14, .ypSelection15, .ypSelection16, .ypSelection17,  .ypSelection18
    ]

    private let params: GeometricParams = GeometricParams(cellCount: 6,
                                                          leftInset: 18,
                                                          rightInset: 0,
                                                          cellSpacing: 5)

   let colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )

       collectionView.isScrollEnabled = false

        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
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
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorCollectionView)
        NSLayoutConstraint.activate([
            colorCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            colorCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
    }
}

extension ColorCollectionViewController: UICollectionViewDataSource {
    func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath) as? ColorCollectionViewCell else {
                return UICollectionViewCell()
            }

        cell.colorView.backgroundColor = colors[indexPath.row]
        cell.colorView.layer.cornerRadius = 8
        cell.colorView.layer.masksToBounds = true
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

        view.titleLabel.text = "Цвет"
        return view
    }
}

extension ColorCollectionViewController: UICollectionViewDelegateFlowLayout {
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
        return UIEdgeInsets(top: 6, left: params.leftInset, bottom: 6, right: params.rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else {
            return
        }

        guard let selectedColor = cell.colorView.backgroundColor else {
            return
        }


        cell.layer.borderWidth = 3
        cell.layer.borderColor = selectedColor.withAlphaComponent(0.3).cgColor
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true

        delegate?.didColorSelected(selectedColor)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell =  collectionView.cellForItem(at: indexPath)

        guard let cell else {
            return
        }

        cell.layer.borderWidth = 0
    }
}
