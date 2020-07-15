// Created by Bryan Keller on 6/7/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import HorizonCalendar
import UIKit

// MARK: - DayView

final class DayView: UIView, CalendarItemView {

  // MARK: Lifecycle

  init(initialConfiguration: InitialConfiguration) {
    super.init(frame: .zero)

    addSubview(dayLabel)

    layer.borderColor = UIColor.blue.cgColor
    layer.borderWidth = initialConfiguration.isSelectedStyle ? 2 : 0
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  func setViewModel(_ viewModel: ViewModel) {
    dayLabel.text = viewModel.dayText
    dayAccessibilityText = viewModel.dayAccessibilityText
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    dayLabel.frame = bounds
    layer.cornerRadius = min(bounds.width, bounds.height) / 2
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    updateHighlightState(isHighlighted: true)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    updateHighlightState(isHighlighted: false)
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    updateHighlightState(isHighlighted: false)
  }

  // MARK: Private

  private var dayAccessibilityText: String?

  private lazy var dayLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18)
    if #available(iOS 13.0, *) {
      label.textColor = .label
    } else {
      label.textColor = .black
    }
    return label
  }()

  private func updateHighlightState(isHighlighted: Bool) {
    backgroundColor = isHighlighted ? UIColor.black.withAlphaComponent(0.1) : .clear
  }

}

// MARK: UIAccessibility

extension DayView {

  override var isAccessibilityElement: Bool {
    get { true }
    set { }
  }

  override var accessibilityLabel: String? {
    get { dayAccessibilityText ?? dayLabel.text }
    set { }
  }

}

// MARK: - InitialConfiguration

extension DayView {

  struct InitialConfiguration: Hashable {
    let isSelectedStyle: Bool
  }

}

// MARK: - ViewModel

extension DayView {

  struct ViewModel: Equatable {
    let dayText: String
    let dayAccessibilityText: String?
  }

}
