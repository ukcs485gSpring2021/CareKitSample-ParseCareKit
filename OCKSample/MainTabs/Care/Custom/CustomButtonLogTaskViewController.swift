//
//  CustomButtonLogTaskViewController.swift
//  OCKSample
//
//  Created by Corey Baker on 5/5/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import CareKit
import CareKitUI
import CareKitStore

class CustomButtonLogTaskViewController: OCKButtonLogTaskViewController {
    
    //Need access to local storage
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var selectedEventIndex = IndexPath()

    override func taskView(_ taskView: UIView & OCKTaskDisplayable, didCreateOutcomeValueAt index: Int, eventIndexPath: IndexPath, sender: Any?) {
        
        self.selectedEventIndex = eventIndexPath
        guard let event = controller.eventFor(indexPath: self.selectedEventIndex) else { return }
        
        let logValue = LogValue()
        logValue.delegate = self
        let logValueView = LogValueView(model: logValue).formattedHostingController()
        
        let titleLabel = UILabel()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "Avenir", size: 18)
        titleLabel.textColor = .black
        titleLabel.text = event.task.title
        logValueView.navigationItem.titleView = titleLabel
        
        present(logValueView, animated: true, completion: nil)
    }
}

//Conform to delegate so we can accept values
extension CustomButtonLogTaskViewController: LogValueDelegate {

    func save(_ value: String) {
        guard let event = controller.eventFor(indexPath: self.selectedEventIndex),
              let value = Int(value) else { return }
        
        let newOutcomeValue = OCKOutcomeValue(value)
        
        // Update the outcome with the new value
        if var outcome = event.outcome {
            outcome.values.append(newOutcomeValue)
            appDelegate.coreDataStore.updateAnyOutcome(outcome, callbackQueue: .main) { result in
                print("Updated outcome with \(result)")
            }

        // Else Save a new outcome if one does not exist
        } else {
            do {
                guard let outcome = try controller.makeOutcomeFor(event: event, withValues: [newOutcomeValue]) as? OCKOutcome else{
                    print("Error in SurveyButtonLogViewController.didfinishWith could not cast to OCKOutcome")
                    return
                }

                appDelegate.coreDataStore.addOutcome(outcome, callbackQueue: .main) { result in
                    switch result{
                    case .success(let savedOutcome):
                        print("Saved outcome to CareKit \(savedOutcome)")
                    case .failure(_):
                        print("Error")
                    }
                    print("Saved outcome with result \(result)")
                }
            } catch {
                print(error)
            }
        }
    }
}
