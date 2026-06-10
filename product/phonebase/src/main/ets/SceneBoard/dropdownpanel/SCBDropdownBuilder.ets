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
import { GlobalContext, ViewCallback, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import {
  NotificationBridgeEventManager
} from '@ohos/notificationcomponent/src/main/ets/manager/NotificationBridgeEventManager';
import lazy { SCBDropdownPanel } from './SCBDropdownPanel';
import { SceneSessionAdapter } from '@ohos/systemuicommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sharedData } from '@ohos/systemuicommon/Index';
import { SCBScreenProperty } from '@ohos/windowscene';
import { CardMediaController } from '@ohos/mediacontrolcomponent';
import { SettingSearchManager } from '@ohos/notificationcomponent/src/main/ets/manager/SettingSearchManager';
import { notificationConfigManager } from '@ohos/notificationcomponent/src/main/ets/manager/NotificationConfigManager';

const TAG = 'SCBDropdownBuilder';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export struct SCBDropdownBuilder {
  @Prop persistentId: number = 0;
  @ObjectLink screenProp: SCBScreenProperty;

  private dropdownCallback: ViewCallback = {
    onShow: () => {
      log.showInfo('on dropdown show.');
      sharedData.isDropDownShow = true;
    },
    onHide: () => {
      log.showInfo('on dropdown hide.');
      sharedData.isDropDownShow = false;
    }
  };

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear: ${this.persistentId}`);
    sharedData.dropdownPersistentId = this.persistentId;
    ViewManagerPolicy.registerViewCallback(ViewType.DROPDOWN, this.dropdownCallback);
    this.initSceneSession();
    this.initMainThreadNotificationConfig();
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
    SceneSessionAdapter.setSkipEventAndShowOnVirtualScreen(this.persistentId, false);
    ViewManagerPolicy.unRegisterViewCallback(ViewType.DROPDOWN, this.dropdownCallback);
  }

  build() {
    SCBDropdownPanel({ persistentId: this.persistentId, screenProp: this.screenProp })
  }

  private initSceneSession(): void {
    // 零层透明异常处理
    SceneSessionAdapter?.registerContextTransparentCallback({
      persistentId: this.persistentId,
      callback: () => {
        log.showInfo('Window is transparency!!');
      }
    }, TAG + '_ContextTransparent');
    // set Cast+ projection filter. The window will not show on virtual display.
    SceneSessionAdapter?.setSkipEventAndShowOnVirtualScreen(this.persistentId, true);
  }

  private initMainThreadNotificationConfig() {
    // 初始化通知中心与其他模块的通知数据桥接，需要在主线程做
    NotificationBridgeEventManager.get().init();

    // 播控中心controller初始化
    CardMediaController.getInstance();

    // 智能提醒开关去使能搜索项
    SettingSearchManager.disableSmartReminderSearchItem(GlobalContext.getContext());

    // PC模式特殊搜索项去使能
    SettingSearchManager.handlePCModeSpecialSearchItem(GlobalContext.getContext());

    // 状态栏使能开关动态使能
    SettingSearchManager.enableStatusBarSearchItem(GlobalContext.getContext());

    // 通知协同开关使能监听
    notificationConfigManager.subscribeDistributionChangeEvent(SettingSearchManager.onDistributionButtonChange);
  }
}