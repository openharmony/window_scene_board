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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  MirrorAnimState,
  MirrorComponent,
  MirrorsScene,
  MirrorToEndConst
} from '../constants/MirrorToEndConst';
import { slStateHelper } from '../../common/helper/SlStateHelper';
import OneMirrorAnimController from './OneMirrorAnimController';
import MirrorAnimationUtil, { MirrorAnimateParam } from '../utils/MirrorAnimationUtil';
import {
  CommonConstants,
  slClockOneShotToDesktopService,
} from '@ohos/screenlockcommon';
import { immersiveKgMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { slStateHelper as screenLockStateHelper } from '../../screenlockstate/model/helper/SlStateHelper';
import {
  interruptMgr
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { InterruptName } from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/common/ImmersiveInterruptName';
import { OneMirrorAnimateCallback } from '../utils/OneMirrorParaUtil';

const TAG = 'OneMirrorAnimControllerFull';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);


export default class OneMirrorAnimControllerFull extends OneMirrorAnimController {

  /**
   * 锁屏到解锁
   */
  protected screenLockToUnlock(isRefresh?: boolean | undefined): void {
    log.showInfo(`screenLockToUnlock  isRefresh:${isRefresh}`);
    slClockOneShotToDesktopService.setTextColorOfDesktopClock(
      slClockOneShotToDesktopService.getTextColorOfDesktopClock());
    super.screenLockToUnlock();
  }

  /**
   * 黑屏到锁屏初始状态
   */
  protected screenOffToScreenLock(isRefresh?: boolean): void {
    super.screenOffToScreenLock(isRefresh);
  }

  /**
   * 黑屏到锁屏结束
   */
  protected screenOffToScreenLockEnd(isRefresh?: boolean): void {
    super.screenOffToScreenLockEnd(isRefresh);
  }

  private checkShouldShowImmersiveDefault(): void {
    if (!immersiveKgMgr.getDefaultImmersiveSwitch()) {
      return;
    }
    // 校验是否默认沉浸态
    let res = MirrorAnimationUtil.checkShouldDefaultImmersive();
    if (res && (MirrorAnimationUtil.isV2() ||
      screenLockStateHelper.getOneMirrorStaticState()?.getIsNeedToShowImmersive())) {
      // 沉浸态设置时钟为非展开态
      if (!MirrorAnimationUtil.isV2()) {
        slStateHelper.getSlClockStaticState()?.setClockForceCollapseState(false);
      }
      MirrorAnimationUtil.setImmCardScale(1.1);
      MirrorAnimationUtil.setImmCardAlpha(0);
    }
  }

  /**
   * 锁屏解锁后组件下树
   */
  protected slUnlockToDesktop(isRefresh?: boolean): void {
    log.showInfo(`slUnlockToDesktop isRefresh: ${isRefresh}`);
    if (isRefresh) {
      this.uIComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.SL_UNLOCKING_TO_DESKTOP);
      this.uIComponentState.get(MirrorComponent.LOCK_ICON)?.(MirrorsScene.SL_UNLOCKING_TO_DESKTOP);
    }
  }

  private getDuration(scene?: string): number {
    return MirrorToEndConst.NORMAL_BEZIER_TIME;
  }

  private getDelay(scene?: string): number {
    return 0;
  }
}