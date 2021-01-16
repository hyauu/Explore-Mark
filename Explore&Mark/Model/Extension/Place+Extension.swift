//
//  Place+Extension.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 16/1/2021.
//

import Foundation
import CoreData

extension Place {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        imageCount = 0
    }
}
