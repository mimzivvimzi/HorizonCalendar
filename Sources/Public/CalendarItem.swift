// Created by Bryan Keller on 9/16/19.
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

// MARK: - CalendarItem

/// Represents a view that `CalendarView` will display at a particular location.
///
/// `CalendarItem`s are what are provided to `CalendarView` via `CalendarViewContent`, and are used to tell
/// `CalendarView` what types of views to display for month headers, day-of-week items, day items, day-range items, and more.
///
/// `CalendarItem` is generic over a `ViewType` - a special type of view that is a function of its `initialConfiguration` and
/// its `viewModel`.
/// `ViewType` is the type of view that will be displayed by `CalendarView`, and should be a `UIView` or `UIView` subclass
/// that conforms to `CalendarItemView`.
public struct CalendarItem<ViewType>: AnyCalendarItem where ViewType: CalendarItemView {

  // MARK: Lifecycle

  /// Initializes a new `CalendarItem`.
  ///
  /// - Parameters:
  ///   - initialConfiguration: A type containing all of the immutable / view-model-independent properties necessary to
  ///   initialize a `ViewType`. Use this to configure appearance options that do not change based on the data in the `viewModel`.
  ///   For example, you might pass a type that contains properties to configure a `UILabel`'s `textAlignment`, `textColor`,
  ///   and `font`, assuming none of those things change in response to `viewModel` updates.
  ///   - viewModel: A type containing all of the variable data necessary to update an instance of`ViewType`. Use this to specify
  ///   the dynamic, data-driven parts of the view.
  public init(initialConfiguration: ViewType.InitialConfiguration, viewModel: ViewType.ViewModel) {
    self.initialConfiguration = initialConfiguration
    self.viewModel = viewModel

    itemViewDifferentiator = CalendarItemViewDifferentiator(
      viewType: AnyHashable("\(ViewType.self)"),
      initialConfiguration: AnyHashable(initialConfiguration))
  }

  // MARK: Public

  /// A type that helps `ItemViewReuseManager` determine which views are compatible with one another and can therefore be
  /// recycled / reused.
  public let itemViewDifferentiator: CalendarItemViewDifferentiator

  /// Builds an instance of `ViewType` by invoking its initializer with `initialConfiguration`.
  public func buildView() -> UIView {
    ViewType.init(initialConfiguration: initialConfiguration)
  }

  /// Updates the view model on an instance of `ViewType` by invoking `setViewModel`.
  public func updateViewModel(view: UIView) {
    guard let view = view as? ViewType else {
      preconditionFailure("Failed to convert the UIView to the type-erased ViewType")
    }

    view.setViewModel(viewModel)
  }

  /// Compares the initial configurations of two `CalendarItem`s for equality.
  public func isInitialConfiguration(
    equalToInitialConfigurationOf otherCalendarItem: CalendarItemInitialConfigurationEquatable)
    -> Bool
  {
    guard let otherCalendarItem = otherCalendarItem as? Self else { return false }
    return initialConfiguration == otherCalendarItem.initialConfiguration
  }

  /// Compares the view models of two `CalendarItem`s for equality.
  public func isViewModel(
    equalToViewModelOf otherCalendarItem: CalendarItemViewModelEquatable)
    -> Bool
  {
    guard let otherCalendarItem = otherCalendarItem as? Self else { return false }
    return viewModel == otherCalendarItem.viewModel
  }

  // MARK: Private

  private let initialConfiguration: ViewType.InitialConfiguration
  private let viewModel: ViewType.ViewModel

}
