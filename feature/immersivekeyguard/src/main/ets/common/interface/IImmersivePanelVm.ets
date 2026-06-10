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

import { IBaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { INotificationPanelVm } from '@ohos/systemuicommon/newIndex';
import { DownPosition } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';

/**
 * 沉浸面板业务管理抽象
 */
export interface IImmersivePanelVm extends INotificationPanelVm {
  /**
   * 锁屏模块通用静态状态
   *
   * @returns 通用状态
   */
  getSlComStaticState(): IBaseState | undefined;

  /**
   * 锁屏模块通用UI绑定状态
   *
   * @returns 通用状态
   */
  getSlComBindState(): IBaseState | undefined;

  /**
   * 设置锁屏面板触摸点
   *
   * @param downPosition 触摸点
   */
  setPanelGlobalDownPosition(downPosition: DownPosition): void;
}