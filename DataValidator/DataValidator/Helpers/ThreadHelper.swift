//
//  ThreadHelper.swift
//  DataValidator
//
//  Created by Richard Gravenor on 12/04/2018.
//  Copyright © 2018 Luminous Squares Ltd. All rights reserved.
//

import Foundation

class SwitchToMainThread {
  class func with(_ block: @escaping () -> ()) {
    guard Thread.isMainThread else {
      DispatchQueue.main.async {
        SwitchToMainThread.with(block)
      }
      return
    }
    
    block()
  }
}
