//
//  CustomInstructionsTaskViewController.swift
//  OCKSample
//
//  Created by Corey Baker on 5/5/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import UIKit
import CareKit
import CareKitStore
import CareKitUI

/// A custom version of OCKInstructionsTaskViewController that allows adding a detail image and instruction.
/// You can customize any Card CareKit gives you by subclassing it.
class CustomInstructionsTaskViewController: OCKInstructionsTaskViewController {

    /// String representations of HTML and CSS for styling.
    var detailHTML = OCKDetailView.StyledHTML(html: "")

    // Can add images and description by overriding this method
    override func didSelectTaskView(_ taskView: UIView & OCKTaskDisplayable, eventIndexPath: IndexPath) {
        do {
            let detailsViewController = try controller.initiateDetailsViewController(forIndexPath: eventIndexPath)
            if let task = controller.eventFor(indexPath: eventIndexPath)?.task as? OCKTask {
                detailsViewController.detailView.imageView.image = UIImage.asset(task.asset)
            }
            detailsViewController.detailView.html = detailHTML
            
            present(detailsViewController, animated: true)
        } catch {
            if delegate == nil {
                print("CareKit error: A task error occurred, but no delegate was set to forward it to! \(error)")
            }
            delegate?.taskViewController(self, didEncounterError: error)
        }
    }
}

extension UIImage {
    static func asset(_ name: String?) -> UIImage?{
        // We can't be sure if the image they provide is in the assets folder, in the bundle, or in a directory.
        guard let name = name else { return nil }
        // We can check all 3 possibilities and then choose whichever is non-nil.
        let symbol = UIImage(systemName: name)
        let appAssetsImage = UIImage(named: name)
        let otherUrlImage = UIImage(contentsOfFile: name)
        return otherUrlImage ?? appAssetsImage ?? symbol
    }
}
