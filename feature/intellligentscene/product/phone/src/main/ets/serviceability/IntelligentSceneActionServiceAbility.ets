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

import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import Want from '@ohos.app.ability.Want';
import { AbilityContextManager } from '@ohos/scene.common/src/main/ets/ability/AbilityContextManager';
import { LogUtil } from '@ohos/scene.common/src/main/ets/utils/LogUtil';
import { SubscriberConstant } from '@ohos/scene.common/src/main/ets/constant/SubscriberConstant';
import { RdbStoreHelper } from '@ohos/scene.common/src/main/ets/rdbstore/RdbStoreHelper';
import { El1RdbStoreHelper } from '@ohos/scene.common/src/main/ets/rdbstore/El1RdbStoreHelper';
import { ActivationManager } from '@ohos/scene.activationmanage/src/main/ets/manager/ActivationManager';
import { SettingLinkageManager } from '@ohos/scene.configlinkage/src/main/ets/manager/SettingLinkageManager';
import { StateManager } from '@ohos/scene.statemanage/src/main/ets/manager/StateManager';
import { ActionManager } from '../manager/ActionManager';

/* instrument ignore file */
const TAG: string = 'IntelligentSceneActionServiceAbility:';
const TERMINATE_DELAY_MS: number = 3000;

/**
 * 静态广播 / Want 拉起的动作服务：规则下发、启停模式等。
 * 与 StaticSubscriberUtil.startActionServiceAbility 对齐。
 */
export default class IntelligentSceneActionServiceAbility extends ServiceExtensionAbility {
  private terminateTimerId?: number;

  onCreate(want: Want): void {
    LogUtil.showInfo(TAG, 'onCreate');
    AbilityContextManager.addContext(this.context);
  }

  async onRequest(want: Want, startId: number): Promise<void> {
    const action: string = want?.action ?? '';
    const params: Record<string, Object> | undefined =
      want?.parameters as Record<string, Object> | undefined;
    LogUtil.showInfo(TAG, `onRequest action:${action} startId:${startId}`);
    try {
      await El1RdbStoreHelper.getInstance().getRdbStore();
      await RdbStoreHelper.getInstance().getRdbStore();
      StateManager.getInstance().init();
      const currentScene: string = StateManager.getInstance().getCurrentScene();
      // 后台定时启停也需初始化联动状态机，否则深色/护眼不会同步
      await SettingLinkageManager.getInstance().init(currentScene);
      switch (action) {
        case SubscriberConstant.ACTION_UPDATE_RULE_SET:
        case SubscriberConstant.ACTION_CREATE_RULE_SET:
        case SubscriberConstant.ACTION_UPDATE_CONDITION:
          await ActivationManager.getInstance().updateIntelligentSceneRuleSet();
          break;
        case SubscriberConstant.ACTION_START_SCENE:
          ActionManager.getInstance().startScene(params);
          break;
        case SubscriberConstant.ACTION_STOP_SCENE:
          ActionManager.getInstance().dealStopSceneAction(params);
          break;
        default:
          LogUtil.showWarn(TAG, `unsupported action: ${action}`);
          break;
      }
    } catch (err) {
      LogUtil.showError(TAG, `onRequest fail: ${err?.code}, ${err?.message}`);
    }
    this.scheduleTerminate();
  }

  onDestroy(): void {
    LogUtil.showInfo(TAG, 'onDestroy');
    this.clearTerminateTimer();
    SettingLinkageManager.getInstance().deInit();
    StateManager.getInstance().deInit();
    AbilityContextManager.removeContext(this.context);
  }

  private scheduleTerminate(): void {
    this.clearTerminateTimer();
    this.terminateTimerId = setTimeout((): void => {
      try {
        this.context.terminateSelf();
      } catch (e) {
        LogUtil.showError(TAG, `terminateSelf fail: ${e?.code}, ${e?.message}`);
      }
    }, TERMINATE_DELAY_MS);
  }

  private clearTerminateTimer(): void {
    if (this.terminateTimerId !== undefined) {
      clearTimeout(this.terminateTimerId);
      this.terminateTimerId = undefined;
    }
  }
}
