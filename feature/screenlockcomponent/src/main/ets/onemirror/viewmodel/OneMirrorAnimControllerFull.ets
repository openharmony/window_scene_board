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
import { ImmersiveAodStyle, immersiveKgMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { slStateHelper as screenLockStateHelper } from '../../screenlockstate/model/helper/SlStateHelper';
import {
  interruptMgr
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { InterruptName } from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/common/ImmersiveInterruptName';
import { OneMirrorAnimateCallback } from '../utils/OneMirrorParaUtil';

const TAG = 'OneMirrorAnimControllerFull';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const SMALL_FOLD_OUT_SCREEN_IMMERSIVE_TIME_SL_TO_AOD = 150; // 灭屏时，堆叠展示的沉浸通知大图动效时长
const SMALL_FOLD_OUT_SCREEN_IMMERSIVE_TIME_AOD_TO_SL = 350; // 亮屏时，堆叠展示的沉浸通知大图动效时长
const SMALL_FOLD_OUT_SCREEN_IMMERSIVE_DELAY_SL_TO_AOD = 100; // 灭屏时，堆叠展示的沉浸通知大图动效delay
const SMALL_FOLD_OUT_SCREEN_IMMERSIVE_DELAY_AOD_TO_SL = 50; // 亮屏时，堆叠展示的沉浸通知大图动效delay
const SMALL_FOLD_OUT_SCREEN_IMMERSIVE_SCENE_AOD_TO_SL = MirrorsScene.AOD_TO_SL + '_IMMERSIVE';
const SMALL_FOLD_OUT_SCREEN_IMMERSIVE_SCENE_SL_TO_AOD = MirrorsScene.SL_TO_AOD + '_IMMERSIVE';

export default class OneMirrorAnimControllerFull extends OneMirrorAnimController {
  private aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);

  // 当前是否正在AOD过渡锁屏动效中
  private isAodToSl: boolean = false;

  /**
   * AOD到桌面
   */
  protected aodToDesktop(isRefresh?: boolean): void {
    log.showInfo(`now aodToDesktop: ${isRefresh}`);
    if (isRefresh) {
      // 准备亮屏，标识非AOD
      this.setComAodSt(false);
      // 刷新AOD显示状态，目标非AOD
      this.requestUpdateAodSt();
      this.mirrorComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START);
      return;
    }
    if (!slStateHelper.getSlClockBindState()?.isInDesktopAndAodClockOneShot()) {
      // 已经设置的状态需要及时清理
      this.clockMirrorCtrl.clearAnimating();
      this.uIComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.AOD_TO_DESKTOP);
      this.mirrorComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.AOD_TO_DESKTOP);
      this.mirrorComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.AOD_TO_DESKTOP);
      this.mirrorComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.AOD_TO_DESKTOP);
      this.mirrorComponentState.get(MirrorComponent.SL_GREET)?.(MirrorsScene.AOD_TO_DESKTOP);
      this.mirrorComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.AOD_TO_DESKTOP);
      return;
    }
    // AOD到桌面时钟一镜到底场景, 需要将时钟颜色从压暗恢复
    this.mirrorComponentStart.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.AOD_TO_DESKTOP, MirrorAnimState.START, true);
    this.mirrorComponentStart.get(MirrorComponent.CLOCK)?.(MirrorsScene.AOD_TO_DESKTOP, MirrorAnimState.START, true);
    this.mirrorComponentStart.get(MirrorComponent.FORM_CARD)
    ?.(MirrorsScene.AOD_TO_DESKTOP, MirrorAnimState.START, true);
    this.mirrorComponentStart.get(MirrorComponent.SL_GREET)?.(MirrorsScene.AOD_TO_DESKTOP, MirrorAnimState.START, true);
    let creatAnimParam: MirrorAnimateParam = {
      delay: this.getDelay(),
      duration: this.getDuration(),
      finish: () => {
        log.showInfo('now aodToDesktop end');
        if (this.screenLockRootCtrl?.isSceneAnimating(MirrorsScene.AOD_TO_DESKTOP)) {
          this.mirrorComponentStart.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.AOD_TO_DESKTOP,
            MirrorAnimState.START, false);
          this.uIComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.AOD_TO_DESKTOP);
        }
        if (this.clockMirrorCtrl?.isSceneAnimating(MirrorsScene.AOD_TO_DESKTOP)) {
          this.mirrorComponentStart.get(MirrorComponent.CLOCK)?.(MirrorsScene.AOD_TO_DESKTOP,
            MirrorAnimState.START, false);
          this.uIComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.AOD_TO_DESKTOP);
        }
        if (this.formMirrorCtrl?.isSceneAnimating(MirrorsScene.AOD_TO_DESKTOP)) {
          this.mirrorComponentStart.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.AOD_TO_DESKTOP,
            MirrorAnimState.START, false);
          this.uIComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.AOD_TO_DESKTOP);
        }
        if (this.slGreetMirrorCtrl?.isSceneAnimating(MirrorsScene.AOD_TO_DESKTOP)) {
          this.mirrorComponentStart.get(MirrorComponent.SL_GREET)?.(MirrorsScene.AOD_TO_DESKTOP,
            MirrorAnimState.START, false);
          this.uIComponentState.get(MirrorComponent.SL_GREET)?.(MirrorsScene.AOD_TO_DESKTOP);
        }
        screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(false);
      },
      callback: () => {
        this.mirrorComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.AOD_TO_DESKTOP);
        this.mirrorComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.AOD_TO_DESKTOP);
        this.mirrorComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.AOD_TO_DESKTOP);
        this.mirrorComponentState.get(MirrorComponent.SL_GREET)?.(MirrorsScene.AOD_TO_DESKTOP);
      },
      scene: MirrorsScene.AOD_TO_DESKTOP
    }
    MirrorAnimationUtil.createMirrorAnimateTo(creatAnimParam);
  }

  /**
   * 锁屏到解锁
   */
  protected screenLockToUnlock(isRefresh?: boolean | undefined): void {
    log.showInfo(`screenLockToUnlock  isRefresh:${isRefresh}  state:${this.isAodToSl}`);
    slClockOneShotToDesktopService.setTextColorOfDesktopClock(
      slClockOneShotToDesktopService.getTextColorOfDesktopClock());
    // 正在AOD过渡锁屏动效时，打断
    if (this.isAodToSl) {
      this.sceneAnimFinish(MirrorsScene.AOD_TO_SL);
      screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(false);
      this.isAodToSl = false;
    }
    if (this.mirrorScene === MirrorsScene.SL_TO_AOD) {
      log.showInfo('screenLockToUnlock interrupt SL_TO_AOD');
      this.sceneAnimFinish(MirrorsScene.SL_TO_AOD);
      screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(true);
      screenLockStateHelper.getOneMirrorStaticState()?.setOneMirrorState(false);
    }
    super.screenLockToUnlock();
  }

  /**
   * AOD到锁屏
   */
  protected aodToScreenLock(isRefresh?: boolean): void {
    if (this.mirrorScene === MirrorsScene.SL_TO_AOD) {
      log.showInfo('aodToScreenLock interrupt SL_TO_AOD');
      this.sceneAnimFinish(MirrorsScene.SL_TO_AOD);
      screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(true);
      screenLockStateHelper.getOneMirrorStaticState()?.setOneMirrorState(false);
    }
    log.showInfo('now aodToScreenLock');
    this.sceneAnimStart(MirrorsScene.AOD_TO_SL, true);
    // 标识动效中
    this.isAodToSl = true;
    // 准备亮屏，标识非AOD
    this.setComAodSt(false);
    let creatAnimParam: MirrorAnimateParam = {
      delay: this.getDelay(),
      duration: this.getDuration(),
      finish: () => {
        log.showInfo(`now aodToScreenLock end`);
        this.sceneAnimFinish(MirrorsScene.AOD_TO_SL);
        this.isAodToSl = false;
        screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(false);
      },
      callback: () => {
        this.mirrorComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.AOD_TO_SL);
        this.mirrorComponentState.get(MirrorComponent.LOCK_ICON)?.(MirrorsScene.AOD_TO_SL);
        this.mirrorComponentState.get(MirrorComponent.SIGN)?.(MirrorsScene.AOD_TO_SL);
        this.mirrorComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.AOD_TO_SL);
        this.mirrorComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.AOD_TO_SL);
        this.mirrorComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.AOD_TO_SL);
          this.mirrorComponentState.get(MirrorComponent.SL_GREET)?.(MirrorsScene.AOD_TO_SL);
          this.mirrorComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(MirrorsScene.AOD_TO_SL);
          this.mirrorComponentState.get(MirrorComponent.NTF_LIST)?.(MirrorsScene.AOD_TO_SL);
          this.mirrorComponentState.get(MirrorComponent.NTF_CAPSULE)?.(MirrorsScene.AOD_TO_SL);

        // 动效刷新AOD显示状态，目标非AOD
        this.requestUpdateAodSt();
      },
      scene: MirrorsScene.AOD_TO_SL
    }

    MirrorAnimationUtil.createMirrorAnimateTo(creatAnimParam, true);
    this.createSpringAnim(MirrorsScene.AOD_TO_SL);
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
    // AOD默认沉浸态场景需要提前判定时钟展开状态和初始化动效参数
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
   * 桌面到AOD
   */
  protected desktopToAod(isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback): void {
    log.showInfo(`now desktopToAod isRefresh=${isRefresh}`);
    if (isRefresh) {
      if (this.aodStyle) {
        this.aodStyle.isAod = true;
      }
      // 准备灭屏，标识AOD
      this.setComAodSt(true);
      // 刷新AOD显示状态，目标AOD
      this.requestUpdateAodSt();
      interruptMgr.getInterrupt(InterruptName.NTF_DATA_CHANGE).requestInterrupt();
      this.checkShouldShowImmersiveDefault();
      this.lockIconMirrorCtrl.clearAnimating();
      this.uIComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.uIComponentState.get(MirrorComponent.LOCK_ICON)?.(MirrorsScene.DESKTOP_TO_AOD);
      this.uIComponentState.get(MirrorComponent.SL_GREET)?.(MirrorsScene.DESKTOP_TO_AOD);
      this.uIComponentState.get(MirrorComponent.SIGN)?.(MirrorsScene.DESKTOP_TO_AOD);
      this.uIComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.uIComponentState.get(MirrorComponent.NTF_LIST)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.uIComponentState.get(MirrorComponent.NTF_CAPSULE)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.uIComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.uIComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.uIComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.uIComponentState.get(MirrorComponent.DOF_WALLPAPER)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(MirrorsScene.DESKTOP_TO_AOD +
      MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.NTF_LIST)?.(MirrorsScene.DESKTOP_TO_AOD +
      MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.NTF_CAPSULE)?.(MirrorsScene.DESKTOP_TO_AOD +
      MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.DOF_WALLPAPER)?.(MirrorsScene.DESKTOP_TO_AOD +
      MirrorAnimState.START);
      return;
    }

    this.startSlNtfAnim(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.NONE, true);
    this.mirrorComponentStart.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.START, true);
    this.mirrorComponentStart.get(MirrorComponent.CLOCK)?.(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.START, true);
    this.mirrorComponentStart.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.DESKTOP_TO_AOD,
      MirrorAnimState.START, true);
    this.mirrorComponentStart.get(MirrorComponent.SL_GREET)?.(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.START, true);
    this.mirrorComponentStart.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.START, true);

    let immersiveDelay = CommonConstants.DESKTOP_TO_AOD_DELAY;
    let clockDelay = CommonConstants.DESKTOP_TO_AOD_DELAY;
    if (immersiveKgMgr.getImmersiveDisplayState().isImmersive()) {
      MirrorAnimationUtil.setImmCapAlpha(0);
      if (!slClockOneShotToDesktopService.isClockDesktopToAodAnimAvailable()) {
        MirrorAnimationUtil.createMirrorImmersiveAnimateToWithoutClock(clockDelay);
      } else {
        MirrorAnimationUtil.createMirrorImmersiveAnimateTo();
      }
    } else {
      MirrorAnimationUtil.setImmCardScale(undefined);
      MirrorAnimationUtil.setImmCardAlpha(undefined);
    }
    let immersiveAnimParam: MirrorAnimateParam = {
      delay: immersiveDelay,
      duration: this.getDuration(),
      finish: () => {
        this.startSlNtfAnim(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.NONE, false);
        finishCallback?.finish();
      },
      callback: () => {
        this.mirrorComponentState.get(MirrorComponent.NTF_LIST)?.(MirrorsScene.DESKTOP_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(MirrorsScene.DESKTOP_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.NTF_CAPSULE)?.(MirrorsScene.DESKTOP_TO_AOD);
        finishCallback?.animateStart();
      },
      scene: MirrorsScene.DESKTOP_TO_AOD
    }
    let clockAnimParam: MirrorAnimateParam = {
      delay: clockDelay,
      duration: this.getDuration(),
      finish: () => {
        log.showInfo('now desktopToAod end');
        interruptMgr.getInterrupt(InterruptName.NTF_DATA_CHANGE).releaseInterrupt();
        if (this.screenLockRootCtrl?.isSceneAnimating(MirrorsScene.DESKTOP_TO_AOD)) {
          this.mirrorComponentStart.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.START,
            false);
          this.uIComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.DESKTOP_TO_AOD);
        }

        if (this.clockMirrorCtrl?.isSceneAnimating(MirrorsScene.DESKTOP_TO_AOD)) {
          this.mirrorComponentStart.get(MirrorComponent.CLOCK)?.(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.START,
            false);
          this.uIComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.DESKTOP_TO_AOD);
        }
        if (this.formMirrorCtrl?.isSceneAnimating(MirrorsScene.DESKTOP_TO_AOD)) {
          this.mirrorComponentStart.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.START,
            false);
          this.uIComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.DESKTOP_TO_AOD);
        }
        if (this.slGreetMirrorCtrl?.isSceneAnimating(MirrorsScene.DESKTOP_TO_AOD)) {
          this.mirrorComponentStart.get(MirrorComponent.SL_GREET)?.(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.START,
            false);
          this.uIComponentState.get(MirrorComponent.SL_GREET)?.(MirrorsScene.DESKTOP_TO_AOD);
        }
        finishCallback?.finish();
      },
      callback: () => {
        finishCallback?.animateStart();
        this.mirrorComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.DESKTOP_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.DESKTOP_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.DESKTOP_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.SL_GREET)?.(MirrorsScene.DESKTOP_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.DESKTOP_TO_AOD);
      },
      scene: MirrorsScene.DESKTOP_TO_AOD
    }

    MirrorAnimationUtil.createMirrorAnimateTo(clockAnimParam, true);
    MirrorAnimationUtil.createMirrorAnimateTo(immersiveAnimParam, true);
    this.createSpringAnim(MirrorsScene.DESKTOP_TO_AOD);
  }

  /**
   * 锁屏到AOD
   */
  protected screenLockToAod(isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback): void {
    log.showInfo('now screenLockToAod isRefresh=' + isRefresh);
    if (isRefresh) {
      return;
    }
    // 准备灭屏，标识AOD
    this.setComAodSt(true);
    this.sceneAnimStart(MirrorsScene.SL_TO_AOD, true);
    screenLockStateHelper.getOneMirrorStaticState()?.setOneMirrorState(true);
    let creatAnimParam: MirrorAnimateParam = {
      delay: this.getDelay(MirrorsScene.SL_TO_AOD),
      duration: this.getDuration(),
      finish: () => {
        log.showInfo(`now screenLockToAod end`);
        this.sceneAnimFinish(MirrorsScene.SL_TO_AOD);
        screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(true);
        screenLockStateHelper.getOneMirrorStaticState()?.setOneMirrorState(false);
        finishCallback?.finish();
      },
      callback: () => {
        log.showInfo('screenLockToAod start');
        finishCallback?.animateStart();
        this.mirrorComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.SL_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.LOCK_ICON)?.(MirrorsScene.SL_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.SIGN)?.(MirrorsScene.SL_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.SL_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.SL_TO_AOD);
        this.mirrorComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.SL_TO_AOD);
          this.mirrorComponentState.get(MirrorComponent.NTF_LIST)?.(MirrorsScene.SL_TO_AOD);
          this.mirrorComponentState.get(MirrorComponent.SL_GREET)?.(MirrorsScene.SL_TO_AOD);
          this.mirrorComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(MirrorsScene.SL_TO_AOD);
          this.mirrorComponentState.get(MirrorComponent.NTF_CAPSULE)?.(MirrorsScene.SL_TO_AOD);
        // 动效刷新AOD显示状态，目标AOD
        this.requestUpdateAodSt();
      },
      scene: MirrorsScene.SL_TO_AOD
    }

    MirrorAnimationUtil.createMirrorAnimateTo(creatAnimParam, true);
    this.createSpringAnim(MirrorsScene.SL_TO_AOD);
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
    if (scene === SMALL_FOLD_OUT_SCREEN_IMMERSIVE_SCENE_AOD_TO_SL) {
      // 小外屏灭屏动效，沉浸大图渐隐时长
      return SMALL_FOLD_OUT_SCREEN_IMMERSIVE_TIME_AOD_TO_SL;
    }

    if (scene === SMALL_FOLD_OUT_SCREEN_IMMERSIVE_SCENE_SL_TO_AOD) {
      // 小外屏亮屏动效，沉浸大图渐显时长
      return SMALL_FOLD_OUT_SCREEN_IMMERSIVE_TIME_SL_TO_AOD;
    }

    return MirrorToEndConst.NORMAL_BEZIER_TIME;
  }

  private getDelay(scene?: string): number {
    if (scene === SMALL_FOLD_OUT_SCREEN_IMMERSIVE_SCENE_AOD_TO_SL) {
      // 小外屏灭屏动效，沉浸大图渐隐时长
      return SMALL_FOLD_OUT_SCREEN_IMMERSIVE_DELAY_AOD_TO_SL;
    }
    return 0;
  }

  private getAnimParmByImmersive(scene: string, animScene: MirrorsScene): MirrorAnimateParam {
    return {
      duration: this.getDuration(scene),
      delay: this.getDelay(scene === SMALL_FOLD_OUT_SCREEN_IMMERSIVE_SCENE_AOD_TO_SL ? scene : ''),
      finish: () => {
        this.startSlNtfAnim(animScene, MirrorAnimState.NONE, false);
        log.showInfo(`${scene} anim end.`);
      },
      callback: () => {
        log.showInfo(`${scene} anim start.`);
        this.mirrorComponentState.get(MirrorComponent.NTF_LIST)?.(animScene);
        this.mirrorComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(animScene);
        this.mirrorComponentState.get(MirrorComponent.NTF_CAPSULE)?.(animScene);
      },
      scene: scene,
    }
  }
}