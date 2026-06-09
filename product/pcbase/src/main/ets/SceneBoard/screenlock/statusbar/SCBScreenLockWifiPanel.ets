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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { WindowConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { ViewType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SCBScreenProperty } from '@ohos/windowscene';
import { SCBSystemScene, SystemSceneBuilderParam } from '@ohos/windowscene/Index';
import { AbilityRootComponent } from '../../../pluginPanel/pages/AbilityRootComponent';
import { SCBDefaultZIndex } from '../../scenemanager/SCBScreen';
import { SCBSystemSceneLayout } from '../../statusbar/SCBSceneLayout';
import {
  SCBScreenLockWifiPanelViewModel,
  SCB_SCREEN_LOCK_WIFI_PANEL_COMP_ID,
} from '../vm/SCBScreenLockWifiPanelViewModel';

const TAG = 'SCBScreenLockWifiPanel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@Component
export struct SCBScreenLockWifiPanel {
  vm: SCBScreenLockWifiPanelViewModel = new SCBScreenLockWifiPanelViewModel();
  @Link screenProp: SCBScreenProperty;

  aboutToAppear() {
    this.vm.aboutToAppear();
  }

  aboutToDisappear() {
    this.vm.aboutToDisappear();
  }

  @Builder
  screenLockWifiPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      // 套一层容器, 捕获从 UIExtensionComponent 冒泡上来的 KeyEvent
      Row() {
        AbilityRootComponent({
          pluginViewType: ViewType.LOCK_SCREEN_WIFI_PANEL,
          persistentId: $$.persistentId,
          pluginParams: this.vm.pluginParams,
        });
      }
      .id(SCB_SCREEN_LOCK_WIFI_PANEL_COMP_ID)
      .onKeyEvent((keyEvent: KeyEvent) => this.vm.onKeyEvent(keyEvent));
    };
  }

  build() {
    SCBSystemScene({
      contextBuilder: (param: SystemSceneBuilderParam) => {
        this.screenLockWifiPanelBuilder(param);
      },
      systemSessionInfo: {
        systemType: sceneSessionManager.SessionType.TYPE_SYSTEM_TOAST,
        sceneName: WindowConstants.WINDOW_NAME_LOCK_SCREEN_WIFI_PANEL,
        sceneZIndex: SCBDefaultZIndex.SCREEN_LOCK,
        isFocusable: this.vm.systemSceneOptions.focusable,
        isBlockingFocus: this.vm.systemSceneOptions.blockingFocus,
        isTouchable: this.vm.systemSceneOptions.touchable,
        privacyMode: this.vm.systemSceneOptions.privacyMode,
        hitTestMode: this.vm.systemSceneOptions.hitTestMode,
        isRotatable: this.vm.systemSceneOptions.rotatable,
        visibility: this.vm.systemSceneOptions.visibility,
        scbKeepKeyboardFlag: this.vm.systemSceneOptions.scbKeepKeyboardFlag,
        systemBarType: this.vm.systemSceneOptions.systemBarType,
        sceneType: this.vm.systemSceneOptions.sceneType,
      },
      screenProperty: this.screenProp,
      transitionCallBack: () => this.vm.getFullTransitionEffect(),
    });
  }
}