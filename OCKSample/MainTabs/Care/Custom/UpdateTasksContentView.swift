//
//  UpdateTasksContentView.swift
//  OCKSample
//
//  Created by Corey Baker on 5/9/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import UIKit
import CareKit
import CareKitUI

/// A simple subclass to take control of what CareKit already gives us.
class UpdateTasksContentView: OCKFeaturedContentView {
    let date: Date

    init (imageOverlayStyle: UIUserInterfaceStyle = .unspecified, date: Date) {
        self.date = date
        super.init(imageOverlayStyle: imageOverlayStyle)
        //Need to become a delegate so we know when view is tapped.
        self.delegate = self
    }
}

/// Need to conform to delegate in order to be delegated to.
extension UpdateTasksContentView: OCKFeaturedContentViewDelegate {
    //ToDo: Make this either open up a link relevant to your app or do something different when tapped.
    //It cannot be the same is what is already happening.
    func didTapView(_ view: OCKFeaturedContentView) {
        //When tapped, open a URL.
        let taskViewController = UpdateTasksView(date: date).customformattedHostingController() //Our view is a SwiftUI view, but we need to use it in UIKit

        //Allow the view to be a popover and dismiss with a swipe.
        //Also allows this to work properly on an iPad.
        let presentationController = taskViewController.popoverPresentationController
        //presentationController?.barButtonItem = self.controller?.navigationItem.leftBarButtonItem
        //presentationController?.sourceRect = self.tabBarController!.tabBar.frame
        presentationController?.sourceView = view
        presentationController?.permittedArrowDirections = UIPopoverArrowDirection.any

        //Ensure we have a real controller
        //UIApplication.shared.controller?.present(taskViewController, animated: true, completion: nil)
    }
}
