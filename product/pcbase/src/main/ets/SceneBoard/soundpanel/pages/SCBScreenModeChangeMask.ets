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

import screenSessionManager from '@ohos.screenSessionManager';
import { LogDomain, Logger } from '@ohos/basicutils';
import { ViewCallback, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { SCBScreenProperty, SCBScreenSessionManager, SCBPropertyChangeReason } from '@ohos/windowscene';
import { MultiScreenModeChangeListenerList } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { BaseViewController } from '@ohos/frameworkcommon';

const TAG = 'SCBScreenModeChangeMask_';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

@Component
export struct SCBScreenModeChangeMask {
  @Link screenProp: SCBScreenProperty;
  @State viewController: BaseViewController = new BaseViewController(ViewType.KEYGUARD_EXT, this.screenProp.screenId);
  persistentId: number = 0;
  private tag: string = TAG;
  private autoCancelTimer: number | undefined;
  private isShow: boolean | undefined = undefined;
  @StorageLink('isScreenModeChanging') @Watch('motionChange') isMotionChanging: boolean = false;
  private maskCallback: ViewCallback = {
    onShow: () => {
      log.showInfo(this.tag, `isMotionChanging:${this.isMotionChanging}-${this.screenProp.screenId}`);
      if (!this.isMotionChanging) {
        setTimeout(() => {
          log.showInfo(this.tag, `isMotionChanging:${this.isMotionChanging}-${this.screenProp.screenId} hide`);
          if (!this.isMotionChanging) {
            this.isShow = false;
            this.viewController.hide();
          }
        }, 500);
      };
    }
  };

  aboutToAppear() {
    this.tag = TAG + this.screenProp.screenId;
    log.showInfo(this.tag, 'aboutToAppear');
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    SCBScreenSessionManager.getInstance().registerMultiScreenModeChangeListener(this.multiScreenModeChangeListenerList);
    viewMgrPolicy.registerViewController(ViewType.KEYGUARD_EXT, this.viewController);
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD_EXT, this.maskCallback);
    this.viewController.updateId(this.persistentId);
    if (this.isMotionChanging) {
      this.updateScreenVisibilityStyle(true);
      this.delayCloseMask();
    }
  }

  aboutToDisappear() {
    log.showInfo(this.tag, 'aboutToDisAppear')
    viewMgrPolicy.unregisterViewController(ViewType.KEYGUARD_EXT);
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    SCBScreenSessionManager.getInstance()
      .unRegisterMultiScreenModeChangeListener(this.multiScreenModeChangeListenerList);
  }

  onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.tag = TAG + this.screenProp.screenId;
    let width: number = screenProperty.width;
    let height: number = screenProperty.height;
    this.viewController?.updateRectInPx({
      left: -width / 2,
      top: -height / 2,
      width: width * 2,
      height: height * 2
    });
    log.showInfo(this.tag, `onScreenPropertyChange callback info: ${width} - ${height}`)
  }

  multiScreenModeChangeListenerList: MultiScreenModeChangeListenerList = {
    onMultiScreenModeChange: (screenModeChangeEvent: screenSessionManager.ScreenModeChangeEvent) => {
      log.showInfo(this.tag, `Expansion screen onMultiScreenModeChange: ` +
        `${screenModeChangeEvent}-[${this.screenProp.screenId}]-${this.isMotionChanging}-${this.isShow}`);
      this.isMotionChanging =
        screenModeChangeEvent === screenSessionManager.ScreenModeChangeEvent.SCREEN_MODE_CHANGE_EVENT_BEGIN;
    }
  }

  private motionChange(): void {
    if (this.isMotionChanging) {
      this.updateScreenVisibilityStyle(true);
      this.delayCloseMask();
    } else {
      // 拓展屏模式切换结束后，若存在稳定性安全自动关闭计时，清空，防止影响下次拉起蒙层业务
      if (this.autoCancelTimer !== undefined) {
        clearTimeout(this.autoCancelTimer);
        this.autoCancelTimer = undefined;
      }
      // 拓展屏模式切换结束后，额外延时遮挡300ms，避免用户体验认为蒙层闪烁
      setTimeout(() => {
        this.updateScreenVisibilityStyle(false);
      }, 300);
    }
  }

  private delayCloseMask(): void {
    // 出于稳定性安全考虑，由拓展屏模式切换触发的蒙层，3S后必须自动关闭
    this.autoCancelTimer = setTimeout(() => {
      this.isMotionChanging = false;
      log.showInfo(this.tag, `Expansion screen motion change auto close: ` +
        `[${this.screenProp.screenId}]-${this.isMotionChanging}-${this.isShow}`);
      this.updateScreenVisibilityStyle(false);
      this.autoCancelTimer = undefined;
    }, 3000);
  }

  private updateScreenVisibilityStyle(maskShouldShow: boolean) {
    if (maskShouldShow !== this.isShow) {
      this.isShow = maskShouldShow;
      maskShouldShow ? this.viewController.show() : this.viewController.hide();
      if (maskShouldShow) {
        this.viewController.setOpacity(1);
      }
      log.showInfo(this.tag, `SCBScreen ${this.screenProp.screenId} the mask visibility is ` +
        `${maskShouldShow ? 'visible' : 'hidden'}`);
    }
  }

  build() {
    if (this.viewController.isShowing()) {
      Column() {
      }
      .id('SCBScreenModeChangeMask')
      .width('100%')
      .height('100%')
      .blendMode(BlendMode.SRC_OVER)
      .foregroundColor(Color.Black)
      .backgroundColor(Color.Black)
      .focusable(false)
      .hoverEffect(HoverEffect.None)
    }
  }
}