//
//  MovieCell.swift
//  MovieViewerAdvanced
//
//  Created by user116136 on 1/30/16.
//  Copyright © 2016 Hannah Werbel. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    
    override var highlighted: Bool {
        didSet {
            func highlighted(highlighted: Bool) {
                if (highlighted){
                    self.layer.opacity = 0.5
                }
                else {
                    self.layer.opacity = 1.0
                }
            }
        }
    }
    
}
