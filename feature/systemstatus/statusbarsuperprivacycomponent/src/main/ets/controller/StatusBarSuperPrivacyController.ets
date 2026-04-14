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
import { BaseController } from '@ohos/controlcentercommon/Index';
import { SingletonHelper, LogHelper, LogDomain } from '@ohos/basicutils';
import {
  EvtBus,
  PluginSlot,
  PluginRequestEvent,
} from '@ohos/frameworkwrapper';
import { SuperPrivacyModeData } from '../common/Constants';
// import superPrivacyManager from '@hms.security.superPrivacyManager';

const TAG = 'StatusBarSuperPrivacyController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
// 超级隐私模式开启状态，0代表未开启
const SUPER_PRIVACY_MODE_OFF: number = 0;

export class StatusBarSuperPrivacyController extends BaseController<SuperPrivacyModeData> {
  constructor() {
    super();
    this.onStart();
  }

  private mSuperPrivacyModeData: SuperPrivacyModeData = new SuperPrivacyModeData();

  public getData(): SuperPrivacyModeData {
    return this.mSuperPrivacyModeData;
  }

  isAvailable(): boolean {
    return true;
  }

  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_SUPER_PRIVACY;
  }

  async onStart(): Promise<void> {
    super.onStart();
    try {
      // const curMode = await superPrivacyManager.getSuperPrivacyMode();
      // log.showInfo(`curMode is ${curMode}`);
      // this.mSuperPrivacyModeData.isSuperPrivacyMode = curMode !== SUPER_PRIVACY_MODE_OFF;
      this.handleStatusBarState(this.mSuperPrivacyModeData.isSuperPrivacyMode);
      // superPrivacyManager.on('superPrivacyModeChange', this.onSuperPrivacyModeChange);
    } catch (error) {
      log.showError('StatusBarSuperPrivacyController register enable state error');
    }
  }

  onStop(): void {
    super.onStop();
    // superPrivacyManager.off('superPrivacyModeChange');
  }

  // private onSuperPrivacyModeChange = (mode: superPrivacyManager.SuperPrivacyMode): void => {
  //   log.showWarn('onSuperPrivacyModeChange. current mode: ' + mode);
  //   this.mSuperPrivacyModeData.isSuperPrivacyMode = mode !== SUPER_PRIVACY_MODE_OFF;
  //   // 图标显隐
  //   this.handleStatusBarState(this.mSuperPrivacyModeData.isSuperPrivacyMode);
  // };

  private handleStatusBarState(newState: boolean): void {
    let oldState = this.sbPluginRequest.isVisible();
    if (oldState !== newState) {
      log.showInfo(`StatusBarSuperPrivacy status bar status change, newState: ${newState}, oldState: ${oldState}`);
      // 发送事件，触发PluginRootComponent组件中的状态更新，进而统一控制整个图标的显示与隐藏。
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }
}

let sStatusBarSuperPrivacyController = SingletonHelper.getInstance(StatusBarSuperPrivacyController, TAG);

export default sStatusBarSuperPrivacyController as StatusBarSuperPrivacyController;