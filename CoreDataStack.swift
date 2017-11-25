//
//  CoreDataStack.swift
//
//  Created by Eduardo Moll on 11/11/17.
//  Copyright © 2017 Eduardo Moll. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
  
  // MARK: - Properties
  typealias Result = (Bool) -> ()
  private let modelName: String!
  
  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
       print("Unresolved error \(error), \(error.userInfo)")
      }
    })
    
    return container
  }()
  
  public lazy var managedContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()
  
  // MARK: - Init
  init(modelName: String) {
    self.modelName = modelName
  }
}

// MARK: - Operations Methods
extension CoreDataStack {
  
  /// Saves the current context
  public func save() {
    guard managedContext.hasChanges else { return }
    
    do {
      try managedContext.save()
    } catch {
      fatalError("Error saving context")
    }
  }
  
  /// Saves the current context with result handler
  public func save(_ result: Result) {
    guard managedContext.hasChanges else { return }
    
    do {
     try managedContext.save()
      result(true)
    } catch {
      result(false)
    }
  }
}
