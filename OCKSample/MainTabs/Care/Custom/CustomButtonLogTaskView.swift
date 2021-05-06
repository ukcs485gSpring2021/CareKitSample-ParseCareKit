//
//  CustomButtonLogTaskView.swift
//  OCKSample
//
//  Created by Corey Baker on 5/5/21.
//  Copyright © 2021 Network Reconnaissance Lab. All rights reserved.
//

import UIKit
import CareKitUI

class CustomButtonLogTaskView: OCKButtonLogTaskView{

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        guard let typedCell = cell as? OCKButtonLogTaskView.DefaultCellType else { return cell }
        
        //typedCell.logButton.label.text = loc("START_SURVEY")
        //typedCell.accessibilityLabel = loc("START_SURVEY")
        return typedCell
    }
}
