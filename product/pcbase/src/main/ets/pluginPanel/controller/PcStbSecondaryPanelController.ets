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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import { PluginSlot, ViewCallback, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import { SCBSceneSessionManager, windowMgr } from '@ohos/windowscene';

const TAG: string = 'PcStbSecondaryPanelController';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class PcStbSecondaryPanelController extends BaseViewController {

  private focusCallback: ViewCallback = {
    onGainFocus: (): void => {
      log.showInfo(`onGainFocus, viewType: ${this.viewType}`);
    },
    onLoseFocus: (): void => {
      log.showInfo(`onLoseFocus, viewType: ${this.viewType}`);
      this.checkWindowShow();
    },
  };

  constructor(viewType: ViewType | string) {
    log.showInfo(`viewType:${viewType}`);
    super(viewType);
  }

  /**
   * PC状态栏二级面板统一不响应dealTouchOutSide，失焦消失
   */
  dealTouchOutSide(): boolean {
    return true;
  }

  // 响应窗口的焦点事件
  registerFocusCallback(): void {
    viewMgrPolicy.registerViewCallback(this.viewType, this.focusCallback);
  }

  unRegisterFocusCallback(): void {
    viewMgrPolicy.unRegisterViewCallback(this.viewType, this.focusCallback);
  }

  checkWindowShow(): void {
    if (!SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId)?.visibility) {
      log.showWarn(`view type :${this.viewType} has hidden, dont't handle`);
      return;
    }
    windowMgr.hideWindowWithAnimByPersistentId(this.persistentId);
    statusbarPlCtrl.changeStatusBarOrDockVisibilityInImmersive(false);
  }
}