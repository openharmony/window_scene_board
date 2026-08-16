/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. All rights reserved.
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

import Want from '@ohos.app.ability.Want';
import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import { AbilityContextManager } from '@ohos/scene.common/src/main/ets/ability/AbilityContextManager';
import { GlobalContext } from '@ohos/scene.common/src/main/ets/utils/GlobalContext';
import { LogUtil } from '@ohos/scene.common/src/main/ets/utils/LogUtil';
import { RdbStoreHelper } from '@ohos/scene.common/src/main/ets/rdbstore/RdbStoreHelper';
import { El1RdbStoreHelper } from '@ohos/scene.common/src/main/ets/rdbstore/El1RdbStoreHelper';
import { SettingLinkageManager } from '@ohos/scene.configlinkage/src/main/ets/manager/SettingLinkageManager';
import { StateManager } from '@ohos/scene.statemanage/src/main/ets/manager/StateManager';

/* instrument ignore file */
const TAG: string = 'SceneTimeScheduleService';
const TIMER_CONTEXT_KEY: string = 'TimerContext';

/**
 * systemTimer / TIME_CHANGED 静态订阅拉起：按本地定时条件同步情景模式启停。
 * 对齐设置 DarkModeScheduleService。
 */
export default class SceneTimeScheduleService extends ServiceExtensionAbility {
  async onCreate(want: Want): Promise<void> {
    LogUtil.showInfo(TAG, 'onCreate');
    AbilityContextManager.addContext(this.context);
    GlobalContext.getInstance().set(TIMER_CONTEXT_KEY, this.context);
  }

  async onRequest(want: Want, startId: number): Promise<void> {
    LogUtil.showInfo(TAG, `onRequest startId=${startId}`);
    AbilityContextManager.addContext(this.context);
    GlobalContext.getInstance().set(TIMER_CONTEXT_KEY, this.context);
    try {
      await El1RdbStoreHelper.getInstance().getRdbStore();
      await RdbStoreHelper.getInstance().getRdbStore();
      StateManager.getInstance().init();
      const currentScene: string = StateManager.getInstance().getCurrentScene();
      await SettingLinkageManager.getInstance().init(currentScene);
      await StateManager.getInstance().syncByTimeSchedule(this.context);
    } catch (err) {
      LogUtil.showError(TAG, `onRequest fail: ${err?.code}, ${err?.message}`);
    } finally {
      try {
        this.context.terminateSelf();
      } catch (e) {
        LogUtil.showError(TAG, `terminateSelf fail: ${e?.code}, ${e?.message}`);
      }
    }
  }

  onDestroy(): void {
    LogUtil.showInfo(TAG, 'onDestroy');
    // 不 deInit StateManager/Linkage：UI 或其他 Extension 可能仍在使用同一单例
    AbilityContextManager.removeContext(this.context);
  }
}
