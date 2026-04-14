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
import { DesktopModeEnum } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AbstractObserverManager, KeyGuardMode, ObserverAble } from '@ohos/screenlockcommon';

const TAG: string = 'SpecialModeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Observed
export class SpecialModeViewData {
  @Track public curMode: KeyGuardMode = KeyGuardMode.DEFAULT;
}

/**
 * 特殊模式状态变化监听
 */
export interface SpecialModeChangeListener extends ObserverAble {
  /**
   * 特殊模式状态变化
   *
   * @param curMode 当前的特殊模式
   */
  onSpecialModeChange: (curMode: KeyGuardMode) => void;
}

/**
 * 特殊模式管理器
 */
export class SpecialModeManager extends AbstractObserverManager<SpecialModeChangeListener> {
  private static sInstance: SpecialModeManager;
  private specialModeData: SpecialModeViewData = new SpecialModeViewData();

  /**
   * 获取特殊模式管理实例
   */
  public static getInstance(): SpecialModeManager {
    if (!SpecialModeManager.sInstance) {
      SpecialModeManager.sInstance = new SpecialModeManager();
    }
    return SpecialModeManager.sInstance;
  }

  /**
   * 获取特殊模式数据
   *
   * @returns 特殊模式数据
   */
  public getSpecialModeViewData(): SpecialModeViewData {
    return this.specialModeData;
  }
}