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
/* instrument ignore file */
// import superPrivacyManager from '@ohos.security.superPrivacyManager';
import { BusinessError } from '@kit.BasicServicesKit';
import commonEventManager from '@ohos.commonEventManager';
import { AsyncCallback } from '@ohos.base';
import screenLock from '@ohos.screenLock';
import { LogDomain } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { Logger } from '@ohos/basicutils/src/main/ets/utils/Logger';
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { WindowPositionChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { PluginPosition } from '@ohos/frameworkwrapper/src/main/ets/plugin/PluginConstants';
import { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import PrivacyConstant from '../util/PrivacyConstant';
import {superPrivacyCapsuleControl} from '../util/SuperPrivacyCapsuleControl';
import SuperPrivacyUtils from '../util/SuperPrivacyUtils';
import { ScreenOffObserver } from '../util/ScreenOffObserver';
import MemoryEnvironmentVariant from '../util/MemoryEnvironmentVariant';
import { superPrivacyCacheManager } from '../util/SuperPrivacyCacheManager';

const TAG: string = 'SuperPrivacyStatusBarIcon';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const CONTENT_COLOR_WHITE: string = '#FFFFFF';

PersistentStorage.persistProp(PrivacyConstant.SUPER_PRIVACY_PADDLE_STATUS_COUNTERS, 0);
PersistentStorage.persistProp(PrivacyConstant.SUPER_PRIVACY_PADDLE_STATUS_BAR_COUNTERS, 0);

@Component
export struct SuperPrivacyStatusBarIcon {
  private screenOffObserver: ScreenOffObserver | undefined = new ScreenOffObserver();
  private isScreenLocked: boolean = false;
  private windowName: string = SuperPrivacyUtils.isPaddleDevice() ? PrivacyConstant.SLOT_STATUS_SUPER_PRIVACY_PADDLE :
  PrivacyConstant.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT;
  @StorageProp('mCurrentUserId') mCurrentUserId: number = 0;
  @Consume contentColor: string;
  @StorageProp(PrivacyConstant.SUPER_PRIVACY_PADDLE_STATUS_COUNTERS) runCount: number = 0;
  /*private currentSuperPrivacyMode: superPrivacyManager.SuperPrivacyMode =
    superPrivacyManager.SuperPrivacyMode.ALWAYS_ON;*/
  private currentSuperPrivacyMode:number = 0;
    private superPrivacyCallback: Callback<number> = (mode: ESObject) => {
    log.debug(TAG, `superPrivacyManager superPrivacyMode changed ${mode}`);
    if (this.currentSuperPrivacyMode === mode) {
      return;
    }
    this.currentSuperPrivacyMode = mode;
    /*if (mode !== superPrivacyManager.SuperPrivacyMode.ALWAYS_ON) {
      if (this.isScreenLocked) {
        // 进入锁屏状态后关闭超级隐私，再进入桌面状态，超级隐私状态栏图标直接没有，不要弹窗与动效
        superPrivacyCapsuleControl.requestStatusBar(false);
        return;
      } else {
        if (!windowMgr.isShowing(this.windowName) && !this.isScreenLocked) {
          // 在超级隐私状态栏二级弹窗不显示场景下，关闭开关，状态栏会重新拉起二级弹窗，并且播放完整消失动效
          this.openCapsulePanel();
        } else {
          return;
        }
      }
    } else {
      AppStorage.SetOrCreate(PrivacyConstant.SUPER_PRIVACY_PADDLE_STATUS_BAR_COUNTERS, `${this.runCount}`);
      log.info(TAG, `setSettingsData runCount ${this.runCount}`);
    }*/
  }
  private screenLockCallback: AsyncCallback<commonEventManager.CommonEventData> | undefined = (err, data) => {
    if (err) {
      log.error(TAG, `subscribe failed, message = ${err.message}`);
      return;
    }
    log.info(TAG, `subscribe event = ${data.event}`);
    if (data.event === commonEventManager.Support.COMMON_EVENT_SCREEN_OFF ||
      data.event === commonEventManager.Support.COMMON_EVENT_SCREEN_LOCKED) {
      this.isScreenLocked = true;
    } else if (data.event === commonEventManager.Support.COMMON_EVENT_SCREEN_UNLOCKED) {
      this.isScreenLocked = false;
    } else {
      log.warn(TAG, `unknown event.`);
    }
  }

  aboutToAppear() {
    log.debug(TAG, `aboutToAppear`);
    let superPrivacyModeChangeCount =
      (AppStorage.get<number>(PrivacyConstant.SUPER_PRIVACY_PADDLE_STATUS_BAR_COUNTERS) || 0);
    this.screenOffObserver?.register(this.screenLockCallback!);
    AppStorage.SetOrCreate(PrivacyConstant.SUPER_PRIVACY_PADDLE_STATUS_BAR_COUNTERS, `${this.runCount}`);
    log.info(TAG, `setSettingsData runCount ${this.runCount}`);
    this.isScreenLocked = screenLock.isLocked();
    log.debug(TAG, `isScreenLocked ${this.isScreenLocked}`);
    try {
      superPrivacyCacheManager.on('superPrivacyModeChange', this.superPrivacyCallback);
    } catch (err) {
      log.error(TAG, `listen superPrivacyModeChange error code is ${(err as BusinessError).code}`);
    }
    if (this.runCount > superPrivacyModeChangeCount && !this.isScreenLocked) {
      this.openCapsulePanel();
    }
  }

  aboutToDisappear(): void {
    log.debug(TAG, `aboutToDisappear`);
    this.screenOffObserver?.unregister();
    this.screenOffObserver = undefined;
    this.screenLockCallback = undefined;
    try {
      superPrivacyCacheManager.off('superPrivacyModeChange', this.superPrivacyCallback);
    } catch (err) {
      log.error(TAG, `unlisten superPrivacyModeChange error code is ${(err as BusinessError).code}`);
    }
  }

  requestOpenWindow() {
    log.info(TAG, `requestOpenWindow`);
    let position = windowMgr.getWindowPosition(this.windowName);
    EvtBus.post(WindowPositionChangeEvent, {
      windowName: this.windowName,
      position: PluginPosition.POSITION_RIGHT, area: position
    });
    windowMgr.updateDestroyWindowFlag(this.windowName, false);
    windowMgr.showWindowWithAnim(this.windowName);
  }

  async openCapsulePanel(): Promise<void> {
    if (!this.isScreenLocked && !windowMgr.isShowing(this.windowName)) {
      MemoryEnvironmentVariant.setValue(`${PrivacyConstant.SUPER_PRIVACY_PADDLE_PANEL_ANIMATION_ENABLE}${this.mCurrentUserId}`,
        'true');
      this.requestOpenWindow();
    }
  }

  private getShadow(): ShadowOptions[] | undefined {
    return this.contentColor === CONTENT_COLOR_WHITE ?
      [{
        radius: 2,
        color: '#33000000',
        offsetY: 1
      },
        {
          radius: 6,
          color: '#33000000',
          offsetY: 2
        }] : undefined;
  }

  build() {
    Text() {
      SymbolSpan($r('sys.symbol.key_shield_fill'))
        .draggable(false)
        .fontSize(`${vp2px(20)}px`)
        .fontColor([this.contentColor])
        .fontWeight(FontWeight.Medium)
    }
    .textShadow(this.getShadow())
  }
}