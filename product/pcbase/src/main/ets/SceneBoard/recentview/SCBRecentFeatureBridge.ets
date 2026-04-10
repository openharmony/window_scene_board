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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  MultiInputRecentProxy,
  MultiInputRecentInterface
} from '@ohos/multiinput/src/main/ets/default/common/viewmodel/MultiInputRecentProxy';
import {
  PcDockRecentProxy,
} from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockRecentProxy';
import { SCBRecentSessionsViewModel } from './SCBRecentSessionsViewModel';
import { RecentFocusManager } from './recentFocus/RecentFocusManager';
import { RecentAndAppCenterSwitchManager } from '../../common/manager/RecentAndAppCenterSwitchManager';

const TAG = 'SCBRecentFeatureBridge';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);



export class SCBRecentFeatureBridge {
  private static instance: SCBRecentFeatureBridge | null = null;
  private recentFocusManager = RecentFocusManager.getInstance();

  /**
   * Obtains the RecentFocusManager data model object.
   *
   * @return RecentFocusManager
   */
  static getInstance(): SCBRecentFeatureBridge {
    if (!SCBRecentFeatureBridge.instance) {
      SCBRecentFeatureBridge.instance = new SCBRecentFeatureBridge();
      SCBRecentFeatureBridge.instance.init();
    }
    return SCBRecentFeatureBridge.instance;
  }

  public init(): void {
    this.initMultiInputProxy();
    this.initPcDockRecentProxy();
  }

  /*                    任务中心与multiInput快捷键交互  start                           */
  public initMultiInputProxy(): void {
    let multiInputRecentProxy = MultiInputRecentProxy.getInstance();
    multiInputRecentProxy.registerMultiInputRecent({
      isCrossScreenFocusable: (() => { return this.recentFocusManager.isCrossScreenFocusable(); }),
      getCurrentScreenId: (() => { return this.recentFocusManager.getCurrentScreenId(); }),
      setCurrentSelectedIndex: ((index: number) => { this.recentFocusManager.setCurrentSelectedIndex(index); }),
      getCurrentSelectedIndex: (() => { return this.recentFocusManager.getCurrentSelectedIndex(); }),
      crossFocusToNextScreenRecentByAltTab: (() => { this.recentFocusManager.crossFocusToNextScreenRecentByAltTab(); }),
      getCurrentSelectedItem: (() => { return this.recentFocusManager.getCurrentSelectedItem(); }),
      getContainerSessionListByScreenId: ((screenId: number) => {
        return SCBRecentSessionsViewModel.getInstance({ extendScreenId: screenId }).getContainerSessionList();
      }),
      enterRecent: (() => { RecentAndAppCenterSwitchManager.getInstance().enterRecent(); }),
      enterAppCenter: (() => { RecentAndAppCenterSwitchManager.getInstance().enterAppCenter(); }),
      getShowInCurRecentContainerSessionList: () => {
        return SCBRecentSessionsViewModel.getInstance({ extendScreenId: this.recentFocusManager.getCurrentScreenId() })
          .getShowInRecentContainerSessionList();
      }
    })
  }

  /*                      任务中心与PC Dock交互  start                                 */
  public initPcDockRecentProxy(): void {
    PcDockRecentProxy.getInstance().registerDockRecent({
      enterRecent: (() => { RecentAndAppCenterSwitchManager.getInstance().enterRecent(); }),
      enterAppCenter: ((screenId: number = 0) => {
        RecentAndAppCenterSwitchManager.getInstance().enterAppCenter(screenId);
      }),
    })
  }
}