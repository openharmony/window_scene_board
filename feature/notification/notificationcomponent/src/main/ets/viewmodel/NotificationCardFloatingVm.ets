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
import { SCBSceneMode } from '@ohos/windowscene';

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FloatingDisplayMode } from '@ohos/systemuicommon/Index';
import { AnimationBase, INotificationCardFloatingVm, ASCFWindowMgrAdapter,
  NotificationItemBaseVm } from '@ohos/systemuicommon/newIndex';
import { WantAgentUtil } from '@ohos/systemuicommon/newTsIndex';
import {
  NotificationCardFloatingWantAgentParams
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationCardFloatingVm';
import { NotificationWantAgentInfo, SceneSessionAdapter } from '@ohos/systemuicommon';
import { bundleManager } from '@kit.AbilityKit';

const TAG = 'NotificationCardFloatingVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NotificationCardFloatingVm extends NotificationItemBaseVm implements INotificationCardFloatingVm {
  private isStartingFloating = false;

  async canOpenFloating(params: NotificationCardFloatingWantAgentParams): Promise<boolean> {
    const agentInfo = params.wantAgentInfo ?? await WantAgentUtil.parseWantAgentInfo(params.wantAgent);
    params.wantAgentInfo = agentInfo;

    if (!await this.isNeedFloating(agentInfo?.bundleName)) {
      log.showInfo(`${this.ntf.key} is not need floating`);
      return false;
    }
    if (await SceneSessionAdapter.getIsMidScene()) {
      log.showInfo('Current window mode is middle scene');
      return false;
    }
    if (!await this.isSupportFloating(agentInfo)) {
      log.showInfo(TAG, `${this.ntf.key} is not supportFloating`);
      return false;
    }

    return true;
  }

  async startFloatingForClick(params: NotificationCardFloatingWantAgentParams): Promise<void> {
    log.showInfo(`startFloatingForClick: ${this.ntf.key}`);
    if (this.isStartingFloating) {
      log.showWarn(`Current is running: ${this.ntf.key}`);
      return;
    }
    this.isStartingFloating = true;
    try {
      this.startFloatingWindow(FloatingDisplayMode.CLICK_WITH_ANIMATION, params);
    } catch (e) {
      log.error(`startFloatingForClick for ${this.ntf.key} error:`, e);
    } finally {
      this.isStartingFloating = false;
    }
  }

  async runCardHideAnimation(event: () => void): Promise<void> {
    const animation = new AnimationBase(AnimationBase.NAMES.FLOATING_LAYER_ANIMATION, true);
    await animation.executeAnimation([
      {
        curve: Curve.Linear,
        duration: 200,
        event,
      }
    ]);
  }

  protected async isNeedFloating(bundleName?: string): Promise<boolean> {
    if (await ASCFWindowMgrAdapter.isWindowModeForMetaService(bundleName)) {
      log.showInfo(TAG, 'app need floating');
      return true;
    }

    return false;
  }

  private async isSupportFloating(wantAgentInfo?: NotificationWantAgentInfo): Promise<boolean> {
    const want = wantAgentInfo?.want;
    log.showInfo(TAG, `checkIsSupportFloating, want:${want?.bundleName}, ${want?.moduleName}, ${want?.abilityName}`);
    if (!this.ntf || !want) {
      return false;
    }

    const bundleName = want.bundleName ?? '';
    const abilityName = want.abilityName ?? '';
    const queryKey: string = bundleName + (want.moduleName ?? '') + abilityName;
    const supportModes =
      await SceneSessionAdapter.getAbilityWindowSupportInfo(queryKey, bundleName, abilityName);
    return supportModes?.indexOf(bundleManager.SupportWindowMode.FLOATING) > -1;
  }

  private async startFloatingWindow(displayMode: FloatingDisplayMode,
    params: NotificationCardFloatingWantAgentParams): Promise<void> {
    log.showInfo(`StartFloatingWindow, displayMode: ${displayMode}`);

    if (!params.wantAgent) {
      log.showWarn(TAG, `No wantAgent for ${this.ntf.key}`);
      return;
    }

    const agentInfo = params.wantAgentInfo ?? await WantAgentUtil.parseWantAgentInfo(params.wantAgent);
    if (!agentInfo?.want) {
      log.showWarn(`No want for ${this.ntf.key}`);
      return;
    }
    await WantAgentUtil.startWantAgent(params.wantAgent, {
      code: 0,
      extraInfos: { floatingDisplayMode: displayMode },
      startOptions: { windowMode: SCBSceneMode.FLOATING },
    });
  }
}

