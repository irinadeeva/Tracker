//
//  File.swift
//  Tracker
//
//  Created by Irina Deeva on 12/03/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override public func viewDidLoad() {
        super.viewDidLoad()

        let trackerViewController = UINavigationController(rootViewController: TrackersViewController())
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tab_tracker_active"),
            selectedImage: nil
        )

        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tab_statistic_inactive"),
            selectedImage: nil
        )

        viewControllers = [trackerViewController, statisticViewController]
    }
}
