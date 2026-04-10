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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  EventManager,
  viewMgrPolicy,
  ViewType,
  EvtBus,
  OobeActivatedEvent } from '@ohos/frameworkwrapper';
import {
  SCBPropertyChangeReason,
  SCBScreenProperty,
  SCBScreenSessionManager,
  sSCBOobeManager
} from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';

const TAG = 'SCBScreenMaskOobe';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export struct SCBScreenMaskOobe {
  @Link screenProp: SCBScreenProperty;
  @State viewController: BaseViewController = new BaseViewController(ViewType.OOBE_EXT, this.screenProp.screenId);
  private dockViewController = viewMgrPolicy.getViewController(ViewType.SMART_DOCK_EXT_SCREEN);
  private eventMgr: EventManager = EvtBus.createEventManager();
  persistentId: number = 0;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    viewMgrPolicy.registerViewController(ViewType.OOBE_EXT, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.eventMgr.on(OobeActivatedEvent, this.onOobeChangeEvent);
    if (sSCBOobeManager.isOobeActivated()) {
      this.showOobeMask(true);
    }
  }

  onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.viewController?.updateRectInPx({
      left: 0,
      top: 0,
      width: screenProperty.width,
      height: screenProperty.height
    })
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisAppear');
    viewMgrPolicy.unregisterViewController(ViewType.OOBE_EXT);
    this.eventMgr.offAll();
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
  }

  private onOobeChangeEvent = (event: OobeActivatedEvent) => {
    log.showInfo(`onOobeActiveEvent: ${event?.isActivated}`);
    if (event.isActivated === undefined) {
      log.showInfo('event is undefined, will return');
      return;
    }
    this.showOobeMask(event.isActivated);
  }

  private showOobeMask(isActivated: boolean): void {
    if (isActivated) {
      log.showInfo(`SCBScreen ${this.screenProp.screenId} the oobe mask visibility is show`);
      this.viewController.show();
      this.dockViewController?.hide();
    } else {
      this.viewController.hide();
      this.dockViewController?.show();
      log.showInfo('oobe is not enable, will hide SCBScreenMaskOobe');
    }
  }

  build() {
    if (this.viewController.isShowing()) {
      Column() {
      }
      .id('SCBScreenMaskOobe')
      .width('100%')
      .height('100%')
      .foregroundColor(Color.Black)
      .backgroundColor(Color.Black)
      .focusable(false)
      .hoverEffect(HoverEffect.None)
    }
  }
}