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

import ArrayList from '@ohos.util.ArrayList';
import { SCBPropertyChangeReason, ScenePanelState } from '@ohos/windowscene';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { MainPageListener, MattesSwitchStrategy } from './MattesSwitchStrategy';

const TAG: string = 'StateMattesSwitchStrategy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Defines action to control mattes' animation thread-mode.
 *
 * @since 2024-10-08
 */
export class StateMattesSwitchStrategy implements MattesSwitchStrategy {
  public mainListenerList: ArrayList<MainPageListener> = new ArrayList<MainPageListener>();

  public static instance: StateMattesSwitchStrategy;

  /**
   * StateMattesSwitchStrategy Singleton
   *
   * @returns StateMattesSwitchStrategy Singleton
   */
  public static getInstance(): StateMattesSwitchStrategy {
    if (!StateMattesSwitchStrategy.instance) {
      StateMattesSwitchStrategy.instance = new StateMattesSwitchStrategy();
    }
    return StateMattesSwitchStrategy.instance;
  }

  /**
   * listener: change mattes' animation mode.
   *
   * @param reason the reason of SceneBoard's property change
   * @param scenePanelState the current state of scene panel
   * @param rotation the current rotation of screen
   */
  public onMainPageRequested(reason: SCBPropertyChangeReason, scenePanelState: ScenePanelState,
    rotation: number): void {
    log.showInfo(`onMainPageRequested. ${this.mainListenerList.length}`);
    this.mainListenerList.forEach((listener) => {
      listener.animatorPlay(reason, scenePanelState, rotation);
    });
  }

  /**
   * add listener: change mattes' animation mode.
   *
   * @param listener needs to add.
   */
  public addMainPageListener(listener: MainPageListener): void {
    log.showInfo('register a new listener for mattes animation.');
    this.mainListenerList.add(listener);
  }

  /**
   * delete listener: change mattes' animation mode.
   *
   * @param listener needs to delete.
   */
  public removeMainPageListener(listener: MainPageListener): void {
    this.mainListenerList.remove(listener);
  }

}