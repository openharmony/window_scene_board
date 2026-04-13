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
import { ViewCallback, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import lazy { SystemUIView, EnvVm } from '@ohos/systemuicommon/newIndex';
import lazy { BannerPanelView } from './view/BannerPanelView';
import { BannerPanelVm } from './vm/BannerPanelVm';
import { baseStateMgr, SceneSessionAdapter } from '@ohos/systemuicommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sharedData } from '@ohos/systemuicommon/Index';
import { SCBScreenProperty } from '@ohos/windowscene';
import { RecentGestureEvent } from '../recent/common/constants/RecentGestureConstants';
import { RecentGestureCallback, RecentGestureEventManager } from '../recent/common/RecentGestureEventManager';
import { IBaseStateChangeListener, SlImmBindStPt } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { slImmBindSt } from '@ohos/immersivekeyguard';

const TAG = 'SCBBannerBuilder';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export struct SCBBannerBuilder {
  @Prop persistentId: number = 0;
  @Prop @Watch('onScreenChange') screenProp: SCBScreenProperty;

  private recentGestureCallback: RecentGestureCallback = {
    onGestureEvent: () => {
      log.showInfo('onRecentGestureEvent');
      BannerPanelVm.instance.onRecentGestureEvent();
    }
  };

  private bannerCallback: ViewCallback = {
    onShow: () => {
      log.showInfo('on banner show.');
      sharedData.isBannerShow = true;
    },
    onHide: () => {
      log.showInfo('on banner hide.');
      sharedData.isBannerShow = false;
    }
  };

  private onScreenLockStateChange: IBaseStateChangeListener = {
    listenerName: 'SCBBannerBuilder_secure_locked_state_listener',
    onStateChange: (stateType, stateId, property): void => {
      if (property === SlImmBindStPt.PT_SECURE_LOCKED) {
        this.updateSecureAndLockedFlag();
        return;
      }
    }
  };

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    sharedData.bannerPersistentId = this.persistentId;
    ViewManagerPolicy.registerViewCallback(ViewType.NOTIFICATION_BANNER, this.bannerCallback);
    this.onScreenChange();
    this.initSceneSession();
    baseStateMgr.init();
    RecentGestureEventManager.getInstance().subscribeGestureEvent(RecentGestureEvent.CLEAR_ALL_MISSIONS_START,
      this.recentGestureCallback);
    this.updateSecureAndLockedFlag();
    slImmBindSt.registerStateChangeListener(this.onScreenLockStateChange);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisAppear');
    SceneSessionAdapter.setSkipEventAndShowOnVirtualScreen(this.persistentId, false);
    RecentGestureEventManager.getInstance().unSubScribeGestureEvent(RecentGestureEvent.CLEAR_ALL_MISSIONS_START,
      this.recentGestureCallback);
    ViewManagerPolicy.unRegisterViewCallback(ViewType.NOTIFICATION_BANNER, this.bannerCallback);
    slImmBindSt.unregisterStateChangeListener(this.onScreenLockStateChange);
  }

  onScreenChange(): void {
    sharedData.bannerScreenId = this.screenProp.screenId;
    sharedData.bannerScreenWidth = this.screenProp.width;
  }

  build() {
    Stack() {
      SystemUIView()
      BannerPanelView()
    }.id(TAG)
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

  private updateSecureAndLockedFlag() {
    EnvVm.instance.isSecureAndLocked = slImmBindSt.isSecureAndLocked();
    log.showInfo(`update lock status flag: ${EnvVm.instance.isSecureAndLocked}`);
  }
}