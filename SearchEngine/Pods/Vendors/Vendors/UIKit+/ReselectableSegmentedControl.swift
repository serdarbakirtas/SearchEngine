//
//  ReselectableSegmentedControl.swift
//  Pods
//
//  Created by ALI KIRAN on 4/23/17.
//
//

import Foundation

open class ReselectableSegmentedControl: UISegmentedControl {
  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let previousSelectedSegmentIndex = selectedSegmentIndex
    super.touchesEnded(touches, with: event)
    if previousSelectedSegmentIndex == selectedSegmentIndex {
      if let touch = touches.first {
        let touchLocation = touch.location(in: self)
        if bounds.contains(touchLocation) {
          sendActions(for: .valueChanged)
        }
      }
    }
  }
}
