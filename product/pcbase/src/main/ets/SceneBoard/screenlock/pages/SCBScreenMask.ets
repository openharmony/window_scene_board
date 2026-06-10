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

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  OobeActivatedEvent,
  ScreenLockEvent,
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  ViewArea
} from '@ohos/frameworkwrapper';
import {
  SCBScreenProperty,
  sSCBOobeManager,
  SCBScreenSessionManager,
  SCBPropertyChangeReason
} from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import LockScreenAnimationController from '../common/LockScreenAnimationController';

const TAG = 'ScreenLock-SCBScreenMask';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export struct SCBScreenMask {
  @Link screenProp: SCBScreenProperty;
  @State viewController: BaseViewController = new BaseViewController(ViewType.KEYGUARD_EXT, this.screenProp.screenId);
  persistentId: number = 0;
  private isOnLock: boolean = true;
  private isShow: boolean | undefined = undefined;
  private eventMgr: EventManager = EvtBus.createEventManager();
  @StorageLink('isLock') isLock: boolean = true;
  private maskCallback: ViewCallback = {
    onShow: () => {
      log.showInfo(`isLock:${this.isLock}`);
      if (!this.isLock) {
        setTimeout(() => {
          log.showInfo(`isLock:${this.isLock} hide`);
          if (!this.isLock) {
            this.viewController.hide();
          }
        }, 500);
      };
    }
  };

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    viewMgrPolicy.registerViewController(ViewType.KEYGUARD_EXT, this.viewController);
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD_EXT, this.maskCallback);
    this.viewController.updateId(this.persistentId);
    this.registerEventHandlers();
    if (!sSCBOobeManager.isOobeActivated()) {
      log.showInfo('oobe is activated, will not show SCBScreenMask');
      this.viewController.show();
    }
    LockScreenAnimationController.getInstance().registerCallback(
      LockScreenAnimationController.SCREEN_MASK_CALLBACK, () => {
        this.viewController.hide();
    });
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisAppear')
    viewMgrPolicy.unregisterViewController(ViewType.KEYGUARD_EXT);
    this.eventMgr.offAll();
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    LockScreenAnimationController.getInstance()
      .unregisterCallback(LockScreenAnimationController.SCREEN_MASK_CALLBACK);
  }

  onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.viewController?.updateRectInPx({
      left: 0,
      top: 0,
      width: screenProperty.width,
      height: screenProperty.height
    })
  }

  private registerEventHandlers() {
    this.eventMgr.on(ScreenLockEvent, (event: ScreenLockEvent) => {
      log.showInfo(`${this.screenProp.screenId} isOnLock ${event.isLockScreen}`)
      this.isOnLock = event.isLockScreen;
      this.updateScreenVisibilityStyle();
    })
  }

  private updateScreenVisibilityStyle() {
    let maskShouldShow = this.isOnLock;
    if (maskShouldShow !== this.isShow) {
      this.isShow = maskShouldShow;
      maskShouldShow ? this.viewController.show() : this.viewController.hide();
      if (maskShouldShow) {
        this.viewController.setOpacity(1);
      }
      log.showInfo(`SCBScreen ${this.screenProp.screenId} the mask visibility is ${maskShouldShow ? 'visible' :
        'hidden'}`);
    }
  }

  build() {
    if (this.viewController.isShowing()) {
      Column() {
      }
      .id('SCBScreenMask')
      .width('100%')
      .height('100%')
      .foregroundColor(Color.Black)
      .backgroundColor(Color.Black)
      .focusable(false)
      .hoverEffect(HoverEffect.None)
    }
  }
}