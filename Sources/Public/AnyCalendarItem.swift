// Created by Bryan Keller on 7/15/20.
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

import UIKit

// MARK: - AnyCalendarItem

/// A type-erased calendar item.
///
/// Useful for working with types conforming to `CalendarItem` without knowing the underlying concrete type.
public protocol AnyCalendarItem:
  CalendarItemInitialConfigurationEquatable,
  CalendarItemViewModelEquatable
{
  var itemViewDifferentiator: CalendarItemViewDifferentiator { get }

  func buildView() -> UIView
  func updateViewModel(view: UIView)

}

// MARK: - CalendarItemViewDifferentiator

/// A type that helps `ItemViewReuseManager` determine which views are compatible with one another and can therefore be
/// recycled / reused.
public struct CalendarItemViewDifferentiator: Hashable {
  let viewType: AnyHashable
  let initialConfiguration: AnyHashable
}

// MARK: - CalendarItemInitialConfigurationEquatable

/// Facilitates the comparison of type-earased `AnyCalendarItem`s based on their concrete types' `initialConfiguration`s.
public protocol CalendarItemInitialConfigurationEquatable {

  /// Compares the view configurations of two `CalendarItem`s for equality.
  ///
  /// - Parameters:
  ///   - otherCalendarItem: The calendar item to compare to `self`.
  /// - Returns: `true` if `otherCalendarItem` has the same type as `self` and
  /// `otherCalendarItem.initialConfiguration` equals `self.initialConfiguration`.
  func isInitialConfiguration(
    equalToInitialConfigurationOf otherCalendarItem: CalendarItemInitialConfigurationEquatable)
    -> Bool

}

// MARK: - CalendarItemViewModelEquatable

/// Facilitates the comparison of type-earased `AnyCalendarItem`s based on their concrete types' `viewModel`s.
public protocol CalendarItemViewModelEquatable {

  /// Compares the view models of two `CalendarItem`s for equality.
  ///
  /// - Parameters:
  ///   - otherCalendarItem: The calendar item to compare to `self`.
  /// - Returns: `true` if `otherCalendarItem` has the same type as `self` and `otherCalendarItem.viewModel`
  /// equals `self.viewModel`.
  func isViewModel(equalToViewModelOf otherCalendarItem: CalendarItemViewModelEquatable) -> Bool

}
