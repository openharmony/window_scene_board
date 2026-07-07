/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { LogHelper, LogDomain, } from '@ohos/basicutils';
import { localEventManager, ViewArea, viewMgrPolicy, ViewType, GlobalContext } from '@ohos/frameworkwrapper';
import {
  SCBScreenProperty,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBPropertyChangeReason
} from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import EventConstants from '@ohos/multiinput/src/main/ets/default/common/constants/EventConstants';
import { LayoutViewModel } from '@ohos/launchercommon';
import { multiInputManager } from '@ohos/multiinput';
import { FoldSceneKeyboardStateChangeMgr } from '../../common/manager/FoldSceneKeyboardStateChangeMgr';
import { DesktopSwitchController, VmStateCallBack } from '../virtualmachine/DesktopSwitchController';

const TAG = 'SCBSmartDockMask';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DOCK_MASK_HEIGHT = 10;

@Component
export struct SCBSmartDockMask {
  @Link screenProp: SCBScreenProperty;
  private smartDockController: BaseViewController =
    new BaseViewController(ViewType.SMART_DOCK_MASK, this.screenProp.screenId);
  persistentId: number = 0;
  private visibleInfo: VisibleInfo = new VisibleInfo();
  private isMainScreen = this.screenProp.screenId === SCBSceneSessionManager.getInstance().mainScreenId;
  @StorageLink('isLock') isLock: boolean = true;
  private isVmDesktop: boolean = false;
  private dockMaskVisibleState: boolean = false;

  aboutToAppear(): void {
    viewMgrPolicy.registerViewController(ViewType.SMART_DOCK_MASK, this.smartDockController);
    this.smartDockController.updateId(this.persistentId);
    this.updateDockArea(this.screenProp);
    SCBSceneSessionManager.getInstance().registerDockMaskVisibleCallback((isShow: boolean) => {
      log.showInfo(`SCBSmartDockMask fullscreen-${this.screenProp.screenId}-${isShow}-${this.isMainScreen} ` +
        `this.isVmDesktop: ${this.isVmDesktop}`);
      this.dockMaskVisibleState = isShow;
      if (isShow && !this.isVmDesktop) {
        this.smartDockController.show();
      } else if (!isShow) {
        this.smartDockController.hide();
      } else {
        log.showInfo(`Not to show or hide, isShow: ${isShow}, this.isVmDesktop: ${this.isVmDesktop}`);
      }
    }, this.screenProp.screenId);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    DesktopSwitchController.getInstance().registerVmStateCallback(this.vmStateCallback);
  }

  private vmStateCallback: VmStateCallBack = (isVm: boolean, tarVmScreenId: number) => {
    let isVmDesktop = isVm && tarVmScreenId === this.screenProp.screenId;
    log.showInfo(`vmStateCallback SCBSmartDockMask, dockMaskVisibleState: ${this.dockMaskVisibleState}, ` +
      `isVmDesktop:${isVmDesktop}, screenId: ${this.screenProp.screenId}`);
    this.isVmDesktop = isVmDesktop;
    if (isVmDesktop) {
      log.showInfo(`vmStateCallback SCBSmartDockMask,  screenId: ${this.screenProp.screenId}, hide`);
      this.smartDockController.hide();
    } else if (this.dockMaskVisibleState) {
      log.showInfo(`vmStateCallback SCBSmartDockMask,  screenId: ${this.screenProp.screenId}, show`);
      this.smartDockController.show();
    }
  }

  updateDockArea(screenProp: SCBScreenProperty): void {
    const vpRect: ViewArea = {
      left: 0,
      top: px2vp(screenProp.height - DOCK_MASK_HEIGHT),
      width: px2vp(screenProp.width),
      height: px2vp(DOCK_MASK_HEIGHT)
    };
    this.smartDockController.updateArea(vpRect);
    this.smartDockController.updateRectInPx({
      left: 0,
      top: screenProp.height - DOCK_MASK_HEIGHT,
      width: screenProp.width,
      height: DOCK_MASK_HEIGHT + 1
    })
  }

  private onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (FoldSceneKeyboardStateChangeMgr.getInstance().isNoNeedUpdateDockArea(
      screenProperty, this.smartDockController, DOCK_MASK_HEIGHT, this.getUIContext())) {
      return;
    }
    this.updateDockArea(screenProperty);
  }

  aboutToDisappear(): void {
    log.showInfo('unregisterDockMaskVisibleCallback');
    SCBSceneSessionManager.getInstance().unregisterDockMaskVisibleCallback(this.screenProp.screenId);
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    DesktopSwitchController.getInstance().unregisterVmStateCallback(this.vmStateCallback);
  }

  build() {
    Row() {
    }
    .id('SCBSmartDockMask')
    .width(px2vp(this.screenProp.width))
    .height(DOCK_MASK_HEIGHT + 'px')
    .focusable(false)
    .opacity(0)
    .onHover((isHover) => {
      log.showInfo(`SCBSmartDockMask onHover: ${isHover}, screenId: ${this.screenProp.screenId}`);
      if (isHover) {
        // 鼠标悬停时显示dock栏
        AppStorage.setOrCreate('clearDelayHideDock', {
          isHover: true,
          screenId: this.screenProp.screenId
        });
        // 触发dock栏显示
        if (GlobalContext.getInstance().hasObject('showDockViewWithAnimation')) {
          let showDockViewWithAnimation = (GlobalContext.getInstance()
            .getObject('showDockViewWithAnimation')) as Function;
          showDockViewWithAnimation();
        }
      } else {
        // 鼠标离开时隐藏dock栏
        AppStorage.setOrCreate('clearDelayHideDock', {
          isHover: false,
          screenId: this.screenProp.screenId
        });
      }
    })
  }
}

export class VisibleInfo {
  public isHover: boolean = false;
  public screenId: number = 1;
}