//
//  Common.swift
//  RxSwift-programming
//
//  Created by czw on 12/1/19.
//  Copyright © 2019 czw. All rights reserved.
//

import Foundation

public func example(_ description: String,
                    _ action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}
