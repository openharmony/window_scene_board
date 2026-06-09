/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import lazy ArrayList from '@ohos.util.ArrayList';

/**
 * Defines category specific action when device status has been changed.
 *
 * @since 2024-03-15
 */
export interface ReloadStrategy {
  // List of listeners from its owner, used to iterate for notifying events
  listenerList: ArrayList<ReloadListener>;

  /**
   * Interface for engine manager to call to notify listeners when resource reload is needed
   *
   * @param reloadParam Containing information for resource reload
   * @param engine next engine instance
   */
  onReloadRequested(reloadParam: object): void;

  /**
   * Register a new listener to the current listener pool
   *
   * @param listener New listener from the object
   */
  addReloadListener(listener: ReloadListener): void;

  /**
   * Remove unused listener, recommended for object when destroyed
   *
   * @param listener Listener to be removed from the listener pool
   */
  removeReloadListener(listener: ReloadListener): void;
}

/**
 * Empty interface for other listener to inherit from
 *
 * @since 2024-03-15
 */
export interface ReloadListener {

}

/**
 * A type of listener that notifies its user that a resource reload is needed
 * Client may use ResourceQualifierChecker with the latest resourceQualifier to get the correct resource qualifier
 *
 * @since 2024-03-15
 */
export interface ResourceReloadListener extends ReloadListener {
  reloadResource: (resourceQualifier: number) => void;
}

/**
 * A type of listener that notifies its user that the window reload is needed
 *
 * @since 2024-03-25
 */
export interface WindowReloadListener extends ReloadListener {
  reloadWindow: (resourceQualifier: number, screenWidth: number, screenHeight: number) => void;
}

/**
 * A type of listener that notifies its user that the layout reload is needed
 *
 * @since 2025-01-11
 */
export interface LayoutReloadListener extends ReloadListener {
  reloadLayout: (screenWidth: number, screenHeight: number, resourceQualifier: number) => void;
}