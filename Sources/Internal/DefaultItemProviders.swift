// Created by Bryan Keller on 7/15/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.
//
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

import UIKit

// MARK: - DefaultLabel

final class DefaultLabel: UILabel, CalendarItemView {

  struct InitialConfiguration: Hashable {
    let font: UIFont
    let textAlignment: NSTextAlignment
    let textColor: UIColor
    let backgroundColor: UIColor
    let isAccessibilityElement: Bool
    let accessibilityTraits: UIAccessibilityTraits
  }

  struct ViewModel: Equatable {
    let text: String
    let accessibilityLabel: String?
  }

  // MARK: Lifecycle

  init(initialConfiguration: InitialConfiguration) {
    super.init(frame: .zero)

    font = initialConfiguration.font
    textAlignment = initialConfiguration.textAlignment
    textColor = initialConfiguration.textColor
    backgroundColor = initialConfiguration.backgroundColor
    isAccessibilityElement = initialConfiguration.isAccessibilityElement
    accessibilityTraits = initialConfiguration.accessibilityTraits
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  func setViewModel(_ viewModel: ViewModel) {
    text = viewModel.text
    accessibilityLabel = viewModel.accessibilityLabel
  }

}

// MARK: Default Item Providers

extension CalendarViewContent {

  // MARK: Internal

  static func defaultMonthHeaderItemProvider(
    for month: Month,
    calendar: Calendar,
    dateFormatter: DateFormatter)
    -> AnyCalendarItem
  {
    let textColor: UIColor
    if #available(iOS 13.0, *) {
      textColor = .label
    } else {
      textColor = .black
    }

    let monthText = dateFormatter.string(from: calendar.firstDate(of: month))

    return CalendarItem<DefaultLabel>(
      initialConfiguration: .init(
        font: UIFont.systemFont(ofSize: 22),
        textAlignment: .natural,
        textColor: textColor,
        backgroundColor: .clear,
        isAccessibilityElement: true,
        accessibilityTraits: [.header]),
      viewModel: .init(text: monthText, accessibilityLabel: monthText))
  }

  static func defaultDayOfWeekItemProvider(
    forWeekdayIndex weekdayIndex: Int,
    calendar: Calendar,
    dateFormatter: DateFormatter)
    -> AnyCalendarItem
  {
    let textColor: UIColor
    let backgroundColor: UIColor
    if #available(iOS 13.0, *) {
      textColor = .secondaryLabel
      backgroundColor = .systemBackground
    } else {
      textColor = .black
      backgroundColor = .white
    }

    let dayOfWeekText = dateFormatter.veryShortStandaloneWeekdaySymbols[weekdayIndex]

    return CalendarItem<DefaultLabel>(
      initialConfiguration: .init(
        font: UIFont.systemFont(ofSize: 16),
        textAlignment: .center,
        textColor: textColor,
        backgroundColor: backgroundColor,
        isAccessibilityElement: false,
        accessibilityTraits: []),
      viewModel: .init(text: dayOfWeekText, accessibilityLabel: nil))
  }

  static func defaultDayItemProvider(
    for day: Day,
    calendar: Calendar,
    dateFormatter: DateFormatter)
    -> AnyCalendarItem
  {
    let textColor: UIColor
    if #available(iOS 13.0, *) {
      textColor = .label
    } else {
      textColor = .black
    }

    let dayText = "\(day.day)"

    let date = calendar.startDate(of: day)
    let accessibilityLabel = dateFormatter.string(from: date)

    return CalendarItem<DefaultLabel>(
      initialConfiguration: .init(
        font: UIFont.systemFont(ofSize: 18),
        textAlignment: .center,
        textColor: textColor,
        backgroundColor: .clear,
        isAccessibilityElement: true,
        accessibilityTraits: []),
      viewModel: .init(text: dayText, accessibilityLabel: accessibilityLabel))
  }

}
