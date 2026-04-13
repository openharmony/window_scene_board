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
import { EvtBus, ViewCallback, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { DisplayMgr, ResUtils, SCBSceneSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import { ScreenLockVm } from './viewmodel/ScreenLockVm';
import lazy { SCBStatusBar } from './SCBStatusBar';
import { EnvVm } from '@ohos/systemuicommon/newIndex';
import { ForbiddenGestureVm } from './viewmodel/ForbiddenGestureVm';
import { SCBSingleHandControllerAdapter } from './adapter/SCBSingleHandControllerAdapter';
import { OneMirrorServiceAdapter } from './adapter/OneMirrorServiceAdapter';
import { StatusBarEventExclusiveVm } from './viewmodel/StatusBarEventExclusiveVm';
import { sharedData } from '@ohos/systemuicommon/Index';
import { FoldExpandAniVm } from './viewmodel/FoldExpandAniVm';
import { StatusBarAvoidHeightChangeEvent } from '@ohos/systemuicommon';
import { StatusBarColorManager } from '@ohos/statusbarcomponent/src/main/ets/viewmodel/StatusBarColorManager';

const TAG = 'SCBStatusBarBuilder';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export struct SCBStatusBarBuilder {
  @StorageLink('isPwdVisible') @Watch('onIsPwdVisibleChange') isPwdVisible: boolean = false;
  @StorageLink('isExclusiveStatusBarEvent') @Watch('onIsExclusiveStatusBarEventChange') isExclusiveStatusBarEvent: boolean = false;
  @Link @Watch('onScreenProp') screenProp: SCBScreenProperty;
  persistentId: number = 0;

  private statusBarCallback: ViewCallback = {
    onShow: () => {
      log.showInfo('on statusbar show.');
      sharedData.isStatusBarShow = true;
    },
    onHide: () => {
      log.showInfo('on statusbar hide.');
      sharedData.isStatusBarShow = false;
    }
  };

  private onIsPwdVisibleChange() {
    log.showInfo(`onIsPwdVisibleChange from ${ScreenLockVm.instance.isPwdVisible} to ${this.isPwdVisible}`);
    ScreenLockVm.instance.isPwdVisible = this.isPwdVisible;
    EnvVm.instance.isPwdVisible = this.isPwdVisible;
  }

  private onIsExclusiveStatusBarEventChange() {
    log.showInfo(`onIsExclusiveStatusBarEventChange from ${StatusBarEventExclusiveVm.instance.isExclusive} to ${this.isExclusiveStatusBarEvent}`);
    StatusBarEventExclusiveVm.instance.isExclusive = this.isExclusiveStatusBarEvent;
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear begin, screenProp(width ${this.screenProp.width}, height ${this.screenProp.height})}`);
    sharedData.statusBarPersistentId = this.persistentId;
    ViewManagerPolicy.registerViewCallback(ViewType.STATUS_BAR, this.statusBarCallback);
    try {
      // set Cast+ projection filter. The window will not show on virtual display.
      let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
      systemSceneSession?.setSkipEventAndShowOnVirtualScreen(true);
      DisplayMgr.setUiContext(this.getUIContext());
      ForbiddenGestureVm.instance.init();
      this.onScreenProp();
      this.onIsPwdVisibleChange();
      SCBSingleHandControllerAdapter.init();
      OneMirrorServiceAdapter.init();
      FoldExpandAniVm.instance.initInMainForTheadCall();
      EvtBus.post(StatusBarAvoidHeightChangeEvent,
        StatusBarAvoidHeightChangeEvent.create(ResUtils.getNumber($r('app.float.status_bar_phone_height'))));
      StatusBarColorManager.instance.init(this.persistentId);
      log.showInfo('aboutToAppear end');
    } catch (e) {
      log.showError('aboutToAppear error:' + e);
    }
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    ForbiddenGestureVm.instance.unInit();
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    systemSceneSession?.setSkipEventAndShowOnVirtualScreen(false);
    ViewManagerPolicy.unRegisterViewCallback(ViewType.STATUS_BAR, this.statusBarCallback);
  }

  build() {
    SCBStatusBar({ persistentId: this.persistentId, screenProp: this.screenProp })
  }

  onScreenProp(): void {
    log.showInfo(`onScreenProp statusBarWidth(${sharedData.statusBarWidth} ${this.screenProp.width})` +
      ` statusBarHeight(${sharedData.statusBarHeight} ${this.screenProp.height})` +
      ` statusBarScreenId(${sharedData.statusBarScreenId} ${this.screenProp.screenId})`);
    sharedData.statusBarWidth = this.screenProp.width;
    sharedData.statusBarHeight = this.screenProp.height;
    sharedData.statusBarScreenId = this.screenProp.screenId;
  }
}