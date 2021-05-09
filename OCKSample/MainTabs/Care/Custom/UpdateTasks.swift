//
//  UpdateTasks.swift
//  OCKSample
//
//  Created by Corey Baker on 5/9/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import CareKit
import CareKitStore
import UIKit

/// In order to save values, UIKit classes should conform to this protocol and become a delegate.
protocol UpdateTasksDelegate: AnyObject {

    /// Dismisses the screen.
    func dismiss()
}

/// Simple Class for logging values.
class UpdateTasks: ObservableObject {

    @Published var tasks = [Task]()
    @Published var healthKitTasks = [HealthKitTask]()
    var delegate: UpdateTasksDelegate?

    ///Keeps the original state to compare against
    private var originalTasks: [OCKTask]? = nil {
        //Use property observer to keep views in sync.
        willSet {
            if let realTasks = newValue {
                //Transform tasks to viewable tasks
                tasks = realTasks.map { Task(task: $0) }
            }
        }
    }

    ///Keeps the original state to compare against
    private var originalHealthKitTasks: [OCKHealthKitTask]? = nil {
        //Use property observer to keep views in sync.
        willSet {
            if let realTasks = newValue {
                //Transform tasks to viewable tasks
                healthKitTasks = realTasks.map { HealthKitTask(task: $0) }
            }
        }
    }

    var date = Date() {
        //When ever the date changes, should load tasks with respect to that date.
        didSet {
            load()
        }
    }

    init () {
        load()
    }

    func load() {
        findCurrentTasks { tasks in
            self.originalTasks = tasks
        }
        findCurrentHealthKitTasks { tasks in
            self.originalHealthKitTasks = tasks
        }
    }
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate //Importing UIKit gives us access here to get the OCKStore and ParseRemote
    
    private func findCurrentTasks(completion: @escaping ([OCKTask]?)-> Void) {

        //Build query to search for OCKTask
        var queryForCurrentTasks = OCKTaskQuery(for: date) //This makes the query for the current version of Tasks
        queryForCurrentTasks.ids = ["doxylamine"] //Search for specific task.
        
        self.appDelegate.coreDataStore.fetchTasks(query: queryForCurrentTasks, callbackQueue: .main) { result in
            switch result {
            
            case .success(let foundTasks):
                guard let currentTask = foundTasks.first else {
                    completion(nil)
                    return
                }
                completion([currentTask])
                
            case .failure(let error):
                print("Error: Couldn't find tasks. Query error: \(error)")
                completion(nil)
            }
        }
    }

    private func findCurrentHealthKitTasks(completion: @escaping ([OCKHealthKitTask]?)-> Void) {

        //Build query to search for OCKHealthKitTask
        var queryForCurrentTasks = OCKTaskQuery(for: date) //This makes the query for the current version of Tasks
        queryForCurrentTasks.ids = ["steps"] //Search for specific task.
        
        self.appDelegate.healthKitStore.fetchTasks(query: queryForCurrentTasks, callbackQueue: .main) { result in
            switch result {
            
            case .success(let foundTasks):
                guard let currentTask = foundTasks.first else {
                    completion(nil)
                    return
                }
                completion([currentTask])
                
            case .failure(let error):
                print("Error: Couldn't find health kit tasks. Query error: \(error)")
                completion(nil)
            }
        }
    }

    /// Save the value to CareKit store.
    func save() {
        
    }

    /// Cancels the selection and ignores the value.
    func cancel() {
        delegate?.dismiss()
    }
}

extension HealthKitTask: Hashable, Equatable {
    static func == (lhs: HealthKitTask, rhs: HealthKitTask) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
