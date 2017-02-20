//
//  ArrayExtension.swift
//  SwiftOpenCV
//
//  Created by Lee Whitney on 10/28/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//

import Foundation

extension Array {
    func combine(_ separator: String) -> String{
        var str : String = ""
        for (idx, item) in self.enumerated() {
            str += "\(item)"
            if idx < self.count-1 {
                str += separator
            }
        }
        return str
    }
}
