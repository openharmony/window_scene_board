/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { ArrayList } from '@kit.ArkTS';
import { SCBPropertyChangeReason, ScenePanelState } from '@ohos/windowscene';

/**
 * Define the action as scb panel state has been changed.
 * @since 2024-10-08
 */
export interface MattesSwitchStrategy {
  // List of listeners to load different pictures for pandora carousel
  mainListenerList: ArrayList<MainPageListener>;

  /**
   * Interface to call different subPage of Mattes.
   *
   * @param reason the reason of SceneBoard's property change
   * @param scenePanelState the current state of scene panel
   * @param rotation the current rotation of screen
   */
  onMainPageRequested(reason: SCBPropertyChangeReason, scenePanelState: ScenePanelState, rotation: number): void;

  /**
   * Register a new listener.
   * @param listener
   */
  addMainPageListener(listener: MainPageListener): void;

  /**
   * Remove unused listener.
   * @param listener
   */
  removeMainPageListener(listener: MainPageListener): void;
}

/**
 * A type of listener that notifies mattes panel to change subpage under different scb panel state.
 * @since 2024-10-08
 */
export interface MainPageListener {
  animatorPlay: (reason: SCBPropertyChangeReason, scenePanelState: ScenePanelState, rotation: number) => void;
}