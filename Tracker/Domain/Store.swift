//
//  Store.swift
//  Tracker
//
//  Created by Irina Deeva on 06/04/24.
//

import CoreData
import UIKit

final class Store {
    private let context: NSManagedObjectContext

    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
