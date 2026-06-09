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

import {
  MirrorAnimState,
  MirrorComponent,
  MirrorsScene,
  MirrorToEndConst
} from '../constants/MirrorToEndConst';
import MirrorAnimationUtil, { MirrorAnimateParam } from '../utils/MirrorAnimationUtil';
import OneMirrorAnimController from './OneMirrorAnimController';
import IComponentMirrorCtrl from '../model/IComponentMirrorCtrl';
import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { slStateHelper } from '@ohos/screenlockwidget/src/main/ets/common/utils/SlStateHelper';
import { slStateHelper as screenLockStateHelper } from '../../screenlockstate/model/helper/SlStateHelper';
import { slClockOneShotToDesktopService } from '@ohos/screenlockcommon';

const TAG = 'OneMirrorAnimControllerPart';
const log: Logger = Logger.getLogHelper(LogDomain.KG);
const SL_ELEM_DELAY_TIME = 100; // 锁屏原始动效延迟
const DOF_WALLPAPER_SHOW_DELAY = 700;
const DOF_WALLPAPER_SHOW_DURATION = 100;

/**
 * 局部AOD一镜到底动效控制器：各种场景分别需要做出适配
 */
export default class OneMirrorAnimControllerPart extends OneMirrorAnimController {

  // 当前是否正在AOD过渡锁屏动效中
  private isAodToSl: boolean = false;

  /**
   * 直接刷新UI
   * @param scene 动效场景
   */
  public startMirrorRefreshUi(scene: MirrorsScene): void {
    log.showInfo(TAG, `startMirrorRefreshUi ${scene}`);
    // 恢复锁屏UI显示;
    this.clockMirrorCtrl.setPartAodAnimState(scene);
    this.clockMirrorCtrl.setPartAodUiBindState(scene);
    this.setSLElemUIBind(scene);
    this.setSlElemAnim(scene);
    this.setDofWallpaper(scene);
  }

  /**
   * AOD到桌面
   */
  protected aodToDesktop(isRefresh?: boolean): void {
    log.showInfo(TAG, `aodToDesktop isRefresh: ${isRefresh}`);
    if (isRefresh) {
      // 准备亮屏，标识非AOD
      this.setComAodSt(false);
      // 刷新AOD显示状态，目标非AOD
      this.requestUpdateAodSt();
      return;
    }
    this.setSLElemUIBind(MirrorsScene.AOD_TO_DESKTOP);
    this.setSlElemAnim(MirrorsScene.AOD_TO_DESKTOP);
    screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(false);
    if (!slStateHelper.getSlClockBindState()?.isInDesktopAndAodClockOneShot()) {
      this.clockMirrorCtrl.clearAnimating();
      this.clockMirrorCtrl.setPartAodAnimState(MirrorsScene.AOD_TO_DESKTOP);
      return;
    }
    this.playClockAnim(MirrorsScene.AOD_TO_DESKTOP);
  }

  /**
   * AOD到锁屏
   */
  protected aodToScreenLock(isRefresh?: boolean): void {
    log.showInfo(TAG, `aodToScreenLock ${isRefresh}`);
    if (isRefresh) {
      return;
    }
    this.isAodToSl = true;

    this.playClockAnim(MirrorsScene.AOD_TO_SL, 0, () => {
      this.isAodToSl = false;
    });
    this.playSlOtherAnim(MirrorsScene.AOD_TO_SL, SL_ELEM_DELAY_TIME);
    this.playDofWallpaper(MirrorsScene.AOD_TO_SL, DOF_WALLPAPER_SHOW_DELAY);
  }

  /**
   * 黑屏到锁屏初始状态
   */
  protected screenOffToScreenLock(isRefresh?: boolean): void {
    super.screenOffToScreenLock(isRefresh);
    this.setDofWallpaper(MirrorsScene.SCREEN_OFF_TO_SL);
  }

  /**
   * 黑屏到锁屏结束
   */
  protected screenOffToScreenLockEnd(isRefresh?: boolean): void {
    super.playScreenOffToScreenLockEnd(isRefresh);
    this.playDofWallpaper(MirrorsScene.SCREEN_OFF_TO_SL_END, DOF_WALLPAPER_SHOW_DELAY);
  }

  /**
   * 桌面到AOD
   */
  protected desktopToAod(isRefresh?: boolean): void {
    log.showInfo(TAG, `now desktopToAod isRefresh=${isRefresh}`);
    if (isRefresh) {
      // 准备灭屏，标识AOD
      this.setComAodSt(true);
      // 刷新AOD显示状态，目标AOD
      this.requestUpdateAodSt();
      this.clockMirrorCtrl.setPartAodUiBindState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.clockMirrorCtrl.setPartAodAnimState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.setDofWallpaper(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      this.setSLElemUIBind(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      return;
    }
    this.setSLElemUIBind(MirrorsScene.DESKTOP_TO_AOD);
    screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(true);
    this.playClockAnim(MirrorsScene.DESKTOP_TO_AOD, SL_ELEM_DELAY_TIME);
  }

  /**
   * 锁屏到AOD
   */
  protected screenLockToAod(isRefresh?: boolean): void {
    log.showInfo(TAG, 'now screenLockToAod isRefresh=' + isRefresh);
    if (isRefresh) {
      return;
    }
    this.setDofWallpaper(MirrorsScene.SL_TO_AOD);
    screenLockStateHelper.getOneMirrorStaticState()?.setOneMirrorState(true);
    this.playAllSlAnim(MirrorsScene.SL_TO_AOD);
  }

  protected sceneAnimStartPart(scene: MirrorsScene, isStart: boolean): void {
    if (isStart) {
      this.screenLockRootCtrl.startAnim(scene, MirrorAnimState.START, isStart);
      this.lockIconMirrorCtrl.startAnim(scene, MirrorAnimState.START, isStart);
      this.formMirrorCtrl.startAnim(scene, MirrorAnimState.START, isStart);
      this.immersiveListMirrorCtrl.startAnim(scene, MirrorAnimState.START, isStart);
      this.immersiveCapsuleMirrorCtrl.startAnim(scene, MirrorAnimState.START, isStart);
      this.immersiveCardMirrorCtrl.startAnim(scene, MirrorAnimState.START, isStart);
      this.slGreetMirrorCtrl.startAnim(scene, MirrorAnimState.START, isStart);
      return;
    }

    this.refreshComOnFinish(this.screenLockRootCtrl, scene);
    this.refreshComOnFinish(this.lockIconMirrorCtrl, scene);
    this.refreshComOnFinish(this.formMirrorCtrl, scene);
    this.refreshComOnFinish(this.immersiveCapsuleMirrorCtrl, scene);
    this.refreshComOnFinish(this.immersiveListMirrorCtrl, scene);
    this.refreshComOnFinish(this.slGreetMirrorCtrl, scene);
  }

  /**
   * 锁屏解锁后组件下树
   * @param isRefresh
   */
  protected slUnlockToDesktop(isRefresh?: boolean | undefined): void {
    log.showInfo(TAG, 'slUnlockToDesktop');
    this.setSLElemUIBind(MirrorsScene.SL_UNLOCKING_TO_DESKTOP);
  }

  private playDofWallpaper(scene: MirrorsScene, delay: number = 0): void {
    this.dofMirrorCtrl.startAnim(scene,  MirrorAnimState.START, true);
    let creatAnimParam: MirrorAnimateParam = {
      delay: delay,
      duration: DOF_WALLPAPER_SHOW_DURATION,
      finish: () => {
        log.showInfo(TAG, 'dofMirrorCtrl sceneAnimStartPart false');
        this.refreshComOnFinish(this.dofMirrorCtrl, scene);
      },
      callback: () => {
        this.dofMirrorCtrl.setPartAodAnimState(scene);
      },
      scene: scene,
    }
    MirrorAnimationUtil.createMirrorAnimateTo(creatAnimParam, false);
  }

  /**
   * 播放时钟位移整体动效
   * @param scene MirrorsScene
   * @param pos ElementPosition
   */
  private playClockAnim(scene: MirrorsScene, delay: number = 0,
    callback: () => void = () => {}): void {
    this.clockMirrorCtrl.startAnim(scene, MirrorAnimState.START, true);
    let creatAnimParam: MirrorAnimateParam = {
      delay: delay,
      duration: 300,
      finish: () => {
        callback?.();
        this.refreshComOnFinish(this.clockMirrorCtrl, scene);
      },
      callback: () => {
        this.clockMirrorCtrl.setPartAodAnimState(scene);
      },
      scene: scene,
    }
    MirrorAnimationUtil.createMirrorAnimateTo(creatAnimParam, true);
  }

  /**
   * 播放其他元素动效
   * @param scene MirrorsScene
   * @param delay number
   * @param isAod boolean
   */
  private playSlOtherAnim(scene: MirrorsScene, delay: number, isAod: boolean = false): void {
    this.sceneAnimStartPart(scene, true);
    // 准备亮屏，默认标识非AOD
    this.setComAodSt(isAod);
    let creatAnimParam: MirrorAnimateParam = {
      delay: delay,
      duration: 0,
      finish: () => {
        log.showInfo(TAG, 'playSlOtherAnim sceneAnimStartPart false');
        this.sceneAnimStartPart(scene, false);
        screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(isAod);
      },
      callback: () => {
        this.setSlElemAnim(scene);
        // 动效刷新AOD显示状态，目标非AOD
        this.requestUpdateAodSt();
      },
      scene: scene,
    }
    MirrorAnimationUtil.creatMirrorSpring(creatAnimParam, true);
  }

  /**
   * 锁屏到解锁
   */
  protected screenLockToUnlock(isRefresh?: boolean | undefined): void {
    log.showInfo(TAG, `screenLockToUnlock  isRefresh:${isRefresh}  state:${this.isAodToSl}`);
    slClockOneShotToDesktopService.setTextColorOfDesktopClock(
      slClockOneShotToDesktopService.getTextColorOfDesktopClock());
    // 正在AOD过渡锁屏动效时，打断
    if (this.isAodToSl) {
      this.refreshComOnFinish(this.clockMirrorCtrl, MirrorsScene.AOD_TO_SL);
      this.sceneAnimStartPart(MirrorsScene.AOD_TO_SL, false);
      screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(false);
      this.isAodToSl = false;
    }
    if (this.mirrorScene === MirrorsScene.SL_TO_AOD) {
      log.showInfo(TAG, 'screenLockToUnlock interrupt SL_TO_AOD');
      this.refreshComOnFinish(this.clockMirrorCtrl, MirrorsScene.AOD_TO_SL);
      this.sceneAnimStartPart(MirrorsScene.AOD_TO_SL, false);
      screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(true);
      screenLockStateHelper.getOneMirrorStaticState()?.setOneMirrorState(false);
    }
    super.screenLockToUnlock();
  }

  private playAllSlAnim(scene: MirrorsScene, isAod: boolean = true): void {
    this.clockMirrorCtrl.startAnim(scene, MirrorAnimState.START, true);
    this.sceneAnimStartPart(scene, true);
    // 准备灭屏，默认标识AOD
    this.setComAodSt(isAod);
    let creatAnimParam: MirrorAnimateParam = {
      delay: 0,
      duration: 0,
      finish: () => {
        this.refreshComOnFinish(this.clockMirrorCtrl, scene);
        this.sceneAnimStartPart(scene, false);
        screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(isAod);
        screenLockStateHelper.getOneMirrorStaticState()?.setOneMirrorState(false);
      },
      callback: () => {
        this.clockMirrorCtrl.setPartAodAnimState(scene);
        this.setSlElemAnim(scene);
        // 动效刷新AOD显示状态，目标AOD
        this.requestUpdateAodSt();
      },
      scene: scene
    }

    MirrorAnimationUtil.creatMirrorSpring(creatAnimParam, true);
  }

  private setSLElemUIBind(scene: string): void {
    this.screenLockRootCtrl.setPartAodUiBindState(scene);
    this.lockIconMirrorCtrl.setPartAodUiBindState(scene);
    this.formMirrorCtrl.setPartAodUiBindState(scene);
    this.immersiveListMirrorCtrl.setPartAodUiBindState(scene);
    this.immersiveCapsuleMirrorCtrl.setPartAodUiBindState(scene);
    this.slGreetMirrorCtrl.setPartAodUiBindState(scene);
  }

  private setSlElemAnim(scene: string): void {
    this.screenLockRootCtrl.setPartAodAnimState(scene);
    this.lockIconMirrorCtrl.setPartAodAnimState(scene);
    this.formMirrorCtrl.setPartAodAnimState(scene);
    this.immersiveListMirrorCtrl.setPartAodAnimState(scene);
    this.immersiveCapsuleMirrorCtrl.setPartAodAnimState(scene);
    this.slGreetMirrorCtrl.setPartAodAnimState(scene);
  }

  private setDofWallpaper(scene: string): void {
    this.dofMirrorCtrl.clearAnimating();
    this.dofMirrorCtrl.setPartAodAnimState(scene);
    this.dofMirrorCtrl.setPartAodUiBindState(scene);
  }

  private refreshComOnFinish(ctrl: IComponentMirrorCtrl, scene: MirrorsScene): void {
    // 如果当前场景的动画没有在播放中，就不要去刷新UI，说明动画被打断
    if (ctrl.isSceneAnimating(scene)) {
      ctrl.setPartAodUiBindState(scene);
      ctrl.startAnim(scene, MirrorAnimState.START, false);
    }
  }
}