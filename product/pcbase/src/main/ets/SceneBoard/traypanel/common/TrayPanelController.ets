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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import { ViewCallback, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import { trayPanelMenuVM } from '@ohos/statusbarcomponent/src/main/ets/pc/viewmodel/TrayPanelMenuVM';
import { windowMgr } from '@ohos/windowscene';

const TAG = 'TrayPanelController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class TrayPanelController extends BaseViewController {

  private focusCallback: ViewCallback = {
    onGainFocus: (): void => {
      log.showInfo(`onGainFocus, viewType: ${this.viewType}`);
    },
    onLoseFocus: (): void => {
      log.showInfo(`onLoseFocus, viewType: ${this.viewType}`);
      if (trayPanelMenuVM.isNeedCloseTrayPanel()) {
        log.showInfo('close TrayPanel');
        windowMgr.hideWindowWithAnimByPersistentId(this.persistentId);
        statusbarPlCtrl.changeStatusBarOrDockVisibilityInImmersive(false);
      }
    },
  };

  private touchOutSide: () => boolean = () => {
    log.showWarn(`touchOutSide not init`);
    return false
  };

  constructor() {
    super(ViewType.TRAY_PANEL);
  }

  // 响应窗口的焦点事件
  registerFocusCallback(): void {
    viewMgrPolicy.registerViewCallback(this.viewType, this.focusCallback);
  }

  unRegisterFocusCallback(): void {
    viewMgrPolicy.unRegisterViewCallback(this.viewType, this.focusCallback);
  }

  registerTouchOutsideCallback(touchOutside: () => boolean): void {
    this.touchOutSide = touchOutside;
  }

  dealTouchOutSide(): boolean {
    return true;
  }
}

export const trayPanelController = SingletonHelper.getInstance(TrayPanelController, TAG);

export default trayPanelController;