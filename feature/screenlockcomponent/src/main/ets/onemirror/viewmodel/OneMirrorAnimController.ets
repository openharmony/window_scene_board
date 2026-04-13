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

import { LogDomain, Logger } from '@ohos/basicutils';
import { MirrorAnimState, MirrorComponent, MirrorsScene, TO_AOD_SCENE } from '../constants/MirrorToEndConst';
import MirrorAnimationUtil, { MirrorAnimateParam } from '../utils/MirrorAnimationUtil';
import { OneMirrorAnimateCallback } from '../utils/OneMirrorParaUtil';
import { slStateHelper } from '../../common/helper/SlStateHelper';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { ClockMirrorCtrl } from '../model/ClockMirrorCtrl';
import { LockIconMirrorCtrl } from '../model/LockIconMirrorCtrl';
import { DofWallpaperMirrorCtrl } from '../model/DofWallpaperMirrorCtrl';
import { ScreenLockRootMirrorCtrl } from '../model/ScreenLockRootMirrorCtrl';
import { ImmersiveListMirrorCtrl } from '../model/ImmersiveListMirrorCtrl';
import { ImmersiveCardMirrorCtrl } from '../model/ImmersiveCardMirrorCtrl';
import { ImmersiveCapsuleMirrorCtrl } from '../model/ImmersiveCapsuleMirrorCtrl';
import { SlGreetMirrorCtrl } from '../model/SlGreetMirrorCtrl';
import IComponentMirrorCtrl from '../model/IComponentMirrorCtrl';
import { FormMirrorCtrl } from '../model/FormMirrorCtrl';
import { slStateHelper as screenLockStateHelper } from '../../screenlockstate/model/helper/SlStateHelper';

const TAG = 'OneMirrorAnimController';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

export default class OneMirrorAnimController {
  // 时钟组件一镜到底状态设置
  protected clockMirrorCtrl: ClockMirrorCtrl = new ClockMirrorCtrl();
  // 锁头一镜到底状态设置
  protected lockIconMirrorCtrl: LockIconMirrorCtrl = new LockIconMirrorCtrl();
  // 锁屏通知列表一镜到底动效状态
  protected immersiveListMirrorCtrl: ImmersiveListMirrorCtrl = new ImmersiveListMirrorCtrl();
  // 锁屏通知胶囊一镜到底动效状态
  protected immersiveCapsuleMirrorCtrl: ImmersiveCapsuleMirrorCtrl = new ImmersiveCapsuleMirrorCtrl();
  // 锁屏通知沉浸卡片一镜到底动效状态
  protected immersiveCardMirrorCtrl: ImmersiveCardMirrorCtrl = new ImmersiveCardMirrorCtrl();
  // 锁屏问候一镜到底动效状态
  protected slGreetMirrorCtrl: SlGreetMirrorCtrl = new SlGreetMirrorCtrl();

  // 景深壁纸一镜到底动效状态管理
  protected dofMirrorCtrl: DofWallpaperMirrorCtrl = new DofWallpaperMirrorCtrl();
  // 时钟组件UI样式状态管理
  protected slClockBindCtrl: SlClockBindState | undefined = slStateHelper.getSlClockBindState();
  // 锁屏元素整体一镜到底动效
  protected screenLockRootCtrl: ScreenLockRootMirrorCtrl = new ScreenLockRootMirrorCtrl();

  // 锁屏服务卡片一镜到底动效管理
  protected formMirrorCtrl: FormMirrorCtrl = new FormMirrorCtrl();
  // 黑屏到锁屏
  protected isScreenOffToSl: boolean = false;
  // 当前动效场景
  protected mirrorScene: MirrorsScene | undefined = undefined;
  // 一镜到底动效管理器
  protected oneMirrorAnimHandler: Map<MirrorsScene, (isRefresh?: boolean,
    finishCallback?: OneMirrorAnimateCallback) => void> = new Map([
    [MirrorsScene.AOD_TO_DESKTOP, (isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback) => {
      this.aodToDesktop(isRefresh);
    }],
    [MirrorsScene.AOD_TO_SL, (isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback) => {
      this.aodToScreenLock(isRefresh);
    }],
    [MirrorsScene.SCREEN_OFF_TO_SL, (isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback) => {
      this.screenOffToScreenLock(isRefresh);
    }],
    [MirrorsScene.SCREEN_OFF_TO_SL_END, (isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback) => {
      this.screenOffToScreenLockEnd(isRefresh);
    }],
    [MirrorsScene.DESKTOP_TO_AOD, (isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback) => {
      this.desktopToAod(isRefresh, finishCallback);
    }],
    [MirrorsScene.SL_TO_AOD, (isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback) => {
      this.screenLockToAod(isRefresh, finishCallback);
    }],
    [MirrorsScene.SL_UNLOCKING_TO_DESKTOP, (isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback) => {
      this.slUnlockToDesktop(isRefresh);
    }],
    [MirrorsScene.SCREEN_LOCK_TO_UNLOCK, (isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback) => {
      this.screenLockToUnlock(isRefresh);
    }],
    [MirrorsScene.DESKTOP_TO_SL, (isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback) => {
      this.desktopToSl(isRefresh);
    }],
  ])

  // 元素动效状态
  protected mirrorComponentState: Map<MirrorComponent, (state: string) => void> = new Map([
    [MirrorComponent.SL_ROOT, (state: string) => {
      this.screenLockRootCtrl.setAnimState(state)
    }],
    [MirrorComponent.LOCK_ICON, (state: string) => { this.lockIconAnimState(state) }],
    [MirrorComponent.CLOCK, (state: string) => { this.lockClockAnimState(state) }],
    [MirrorComponent.SL_GREET, (state: string) => {
      this.slGreetAnimState(state)
    }],
    [MirrorComponent.NTF_IMMERSIVE, (state: string) => {
      this.immersiveCardMirrorCtrl.setAnimState(state);
    }],
    [MirrorComponent.DOF_WALLPAPER, (state: string) => {
      this.dofMirrorCtrl.setAnimState(state);
    }],
    [MirrorComponent.FORM_CARD, (state: string) => {
      this.formMirrorCtrl.setAnimState(state);
    }],
    [MirrorComponent.NTF_LIST, (state: string) => {
      this.immersiveListMirrorCtrl.setAnimState(state);
    }],
    [MirrorComponent.QUICK_TOOL, (state: string) => { }],
    [MirrorComponent.NTF_CAPSULE, (state: string) => {
      this.immersiveCapsuleMirrorCtrl.setAnimState(state);
    }],
    [MirrorComponent.CAMERA, (state: string) => { }],
  ])

  // 元素UI状态
  protected uIComponentState: Map<MirrorComponent, (state: string) => void> = new Map([
    [MirrorComponent.SL_ROOT, (state: string) => { this.screenLockRootCtrl.setUiBindState(state) }],
    [MirrorComponent.LOCK_ICON, (state: string) => { this.lockIconUiState(state) }],
    [MirrorComponent.CLOCK, (state: string) => { this.lockClockUiState(state) }],
    [MirrorComponent.SL_GREET, (state: string) => {
      this.slGreetUiState(state)
    }],
    [MirrorComponent.NTF_IMMERSIVE, (state: string) => {
      this.immersiveCardMirrorCtrl.setUiBindState(state);
    }],
    [MirrorComponent.DOF_WALLPAPER, (state: string) => {
      this.dofMirrorCtrl.setUiBindState(state);
    }],
    [MirrorComponent.FORM_CARD, (state: string) => {
      this.formMirrorCtrl.setUiBindState(state);
    }],
    [MirrorComponent.NTF_LIST, (state: string) => {
      this.immersiveListMirrorCtrl.setUiBindState(state);
    }],
    [MirrorComponent.QUICK_TOOL, (state: string) => { }],
    [MirrorComponent.NTF_CAPSULE, (state: string) => {
      this.immersiveCapsuleMirrorCtrl.setUiBindState(state);
    }],
    [MirrorComponent.CAMERA, (state: string) => { }],
  ])

  // 元素动效启停
  protected mirrorComponentStart: Map<MirrorComponent,
    (scene: MirrorsScene, state: MirrorAnimState, isStart: boolean) => void> = new Map([
    [MirrorComponent.SL_ROOT, (scene: MirrorsScene, state: MirrorAnimState, isStart: boolean) => {
      this.screenLockRootCtrl.startAnim(scene, state, isStart)
    }],
    [MirrorComponent.LOCK_ICON, (scene: MirrorsScene, state: MirrorAnimState, isStart: boolean) => {
      this.lockIconAnimStart(scene, state, isStart)
    }],
    [MirrorComponent.SL_GREET, (scene: MirrorsScene, state: MirrorAnimState, isStart: boolean) => {
      this.slGreetMirrorCtrl.startAnim(scene, state, isStart)
    }],
    [MirrorComponent.CLOCK, (scene: MirrorsScene, state: MirrorAnimState, isStart: boolean) => {
      this.clockMirrorCtrl.startAnim(scene, state, isStart);
    }],
    [MirrorComponent.NTF_IMMERSIVE, (scene: string, state: MirrorAnimState, isStart: boolean) => {
      this.immersiveCardMirrorCtrl.startAnim(scene, state, isStart);
    }],
    [MirrorComponent.DOF_WALLPAPER, (scene: string, state: MirrorAnimState, isStart: boolean) => {
      this.dofMirrorCtrl.startAnim(scene, state, isStart)
    }],
    [MirrorComponent.FORM_CARD, (scene: string, state: MirrorAnimState, isStart: boolean) => {
      this.formMirrorCtrl.startAnim(scene, state, isStart);
    }],
    [MirrorComponent.NTF_LIST, (scene: string, state: MirrorAnimState, isStart: boolean) => {
      this.immersiveListMirrorCtrl.startAnim(scene, state, isStart);
    }],
    [MirrorComponent.QUICK_TOOL, (state: string) => { }],
    [MirrorComponent.NTF_CAPSULE, (scene: string, state: MirrorAnimState, isStart: boolean) => {
      this.immersiveCapsuleMirrorCtrl.startAnim(scene, state, isStart);
    }],
    [MirrorComponent.CAMERA, (state: string) => { }],
  ])

  /**
   * 开始一镜到底动效
   *
   * @param scene 动效场景
   */
  public startOneMirrorAnim(scene: MirrorsScene, isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback): void {
    this.oneMirrorAnimHandler.get(scene)?.(isRefresh, finishCallback);
  }

  /**
   * 开启一镜到底，无动效过渡
   */
  public startOneMirrorWithoutAnim(scene: MirrorsScene): void {
    // 无动效过渡时，直接刷新UI
    this.startMirrorRefreshUi(scene);
    // 区分To AOD场景、亮屏场景
    let isAod = TO_AOD_SCENE.has(scene);
    // 标识AOD状态
    this.setComAodSt(isAod);
    // 刷新AOD显示状态
    this.requestUpdateAodSt();
  }

  /**
   * 直接刷新UI
   * @param scene 动效场景
   */
  public startMirrorRefreshUi(scene: MirrorsScene): void {
    // 恢复锁屏UI显示
    this.uIComponentState?.forEach((fun: (state: string) => void, key: string) => {
      fun?.(scene);
    });

    // 恢复锁屏动效状态，以免影响下一次动效
    this.mirrorComponentState?.get(MirrorComponent.SL_ROOT)?.(scene);
    this.mirrorComponentState?.get(MirrorComponent.CLOCK)?.(scene);
    this.mirrorComponentState?.get(MirrorComponent.FORM_CARD)?.(scene);
    this.mirrorComponentState?.get(MirrorComponent.LOCK_ICON)?.(scene);
  }

  private isAod(state?: string): boolean {
    if (state === MirrorsScene.DESKTOP_TO_AOD || state === MirrorsScene.SCREEN_OFF_TO_SL ||
      state === MirrorsScene.SL_TO_AOD) {
      return true;
    }
    return false;
  }

  // 锁头动效状态设置
  private lockIconAnimState(state: string) {
    this.lockIconMirrorCtrl.setAnimState(state);
  }

  // 问候模式动效状态设置
  private slGreetAnimState(state: string) {
    this.slGreetMirrorCtrl.setAnimState(state);
  }

  // 锁头UI状态设置
  private lockIconUiState(state: string) {
    this.lockIconMirrorCtrl.setUiBindState(state);
  }

  // 问候模式UI状态设置
  private slGreetUiState(state: string) {
    this.slGreetMirrorCtrl.setUiBindState(state);
  }

  // 锁头动效启停
  private lockIconAnimStart(scene: MirrorsScene, state: MirrorAnimState, isStart: boolean) {
    this.lockIconMirrorCtrl.startAnim(scene, state, isStart);
  }

  // 时钟UI状态设置
  private lockClockUiState(state: string) {
    this.clockMirrorCtrl.setUiBindState(state);
  }

  // 时钟动效状态设置
  private lockClockAnimState(state: string) {
    this.clockMirrorCtrl.setAnimState(state);
  }



  /**
   * AOD到桌面
   */
  protected aodToDesktop(isRefresh?: boolean): void {
    log.showInfo(TAG, 'No mirror aodToDesktop');
    // 准备亮屏，标识非AOD
    this.setComAodSt(false);
    // 刷新AOD显示状态，目标非AOD
    this.requestUpdateAodSt();
  }

  /**
   * AOD到锁屏
   */
  protected aodToScreenLock(isRefresh?: boolean): void {
    log.showInfo(TAG, 'No mirror aodToScreenLock');
    this.startMirrorRefreshUi(MirrorsScene.AOD_TO_SL);
    // 准备亮屏，标识非AOD
    this.setComAodSt(false);
    // 刷新AOD显示状态，目标非AOD
    this.requestUpdateAodSt();
  }

  protected sceneAnimStart(scene: MirrorsScene, isStart: boolean): void {
    log.showInfo(TAG, 'super sceneAnimStart');
    this.mirrorScene = scene;
    this.mirrorComponentStart.get(MirrorComponent.SL_ROOT)?.(scene, MirrorAnimState.START, isStart);
    this.mirrorComponentStart.get(MirrorComponent.CLOCK)?.(scene, MirrorAnimState.START, isStart);
    this.mirrorComponentStart.get(MirrorComponent.FORM_CARD)?.(scene, MirrorAnimState.START, isStart);
    this.mirrorComponentStart.get(MirrorComponent.LOCK_ICON)?.(scene, MirrorAnimState.START, isStart);
    this.mirrorComponentStart.get(MirrorComponent.SL_GREET)?.(scene, MirrorAnimState.START, isStart);
    this.mirrorComponentStart.get(MirrorComponent.SIGN)?.(scene, MirrorAnimState.START, isStart);
    this.mirrorComponentStart.get(MirrorComponent.ART_SIGN)?.(scene, MirrorAnimState.START, isStart);
    this.startSlNtfAnim(scene, MirrorAnimState.NONE, isStart);

    if (!isStart) {
      this.uIComponentState.get(MirrorComponent.SL_ROOT)?.(scene);
      this.uIComponentState.get(MirrorComponent.CLOCK)?.(scene);
      this.uIComponentState.get(MirrorComponent.FORM_CARD)?.(scene);
      this.uIComponentState.get(MirrorComponent.LOCK_ICON)?.(scene);
      this.uIComponentState.get(MirrorComponent.SL_GREET)?.(scene);
      this.uIComponentState.get(MirrorComponent.SIGN)?.(scene);
      this.uIComponentState.get(MirrorComponent.ART_SIGN)?.(scene);
    }
  }

  /**
   * 动画结束刷新UI
   * @param scene
   */
  protected sceneAnimFinish(scene: MirrorsScene): void {
    this.mirrorScene = undefined;
    this.refreshComponentOnFinish(this.screenLockRootCtrl, MirrorComponent.SL_ROOT, scene);
    this.refreshComponentOnFinish(this.clockMirrorCtrl, MirrorComponent.CLOCK, scene);
    this.refreshComponentOnFinish(this.lockIconMirrorCtrl, MirrorComponent.LOCK_ICON, scene);
    this.refreshComponentOnFinish(this.formMirrorCtrl, MirrorComponent.FORM_CARD, scene);
    this.refreshComponentOnFinish(this.slGreetMirrorCtrl, MirrorComponent.SL_GREET, scene);
    this.refreshComponentOnFinish(this.immersiveCardMirrorCtrl, MirrorComponent.NTF_IMMERSIVE, scene);
    this.refreshComponentOnFinish(this.immersiveCapsuleMirrorCtrl, MirrorComponent.NTF_CAPSULE, scene);
    this.refreshComponentOnFinish(this.immersiveListMirrorCtrl, MirrorComponent.NTF_LIST, scene);
  }

  private refreshComponentOnFinish(ctrl: IComponentMirrorCtrl,
    component: MirrorComponent, scene: MirrorsScene): void {
    // 如果当前场景的动画没有在播放中，就不要去刷新UI，说明动画被打断
    if (ctrl?.isSceneAnimating(scene)) {
      this.uIComponentState.get(component)?.(scene);
      this.mirrorComponentStart.get(component)?.(scene, MirrorAnimState.START, false);
    }
  }

  /**
   * 黑屏到锁屏初始状态
   */
  protected screenOffToScreenLock(isRefresh?: boolean): void {
    log.showInfo(TAG, 'now screenOffToScreenLock');
    this.uIComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.uIComponentState.get(MirrorComponent.LOCK_ICON)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.uIComponentState.get(MirrorComponent.SIGN)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.uIComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.uIComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.uIComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.uIComponentState.get(MirrorComponent.NTF_CAPSULE)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.uIComponentState.get(MirrorComponent.NTF_LIST)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.uIComponentState.get(MirrorComponent.DOF_WALLPAPER)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.uIComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.SCREEN_OFF_TO_SL);

    this.mirrorComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.mirrorComponentState.get(MirrorComponent.LOCK_ICON)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.mirrorComponentState.get(MirrorComponent.SIGN)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.mirrorComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.mirrorComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.mirrorComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.mirrorComponentState.get(MirrorComponent.NTF_LIST)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.mirrorComponentState.get(MirrorComponent.NTF_CAPSULE)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.mirrorComponentState.get(MirrorComponent.DOF_WALLPAPER)?.(MirrorsScene.SCREEN_OFF_TO_SL);
    this.mirrorComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.SCREEN_OFF_TO_SL);
  }

  /**
   * 黑屏到锁屏结束
   */
  protected screenOffToScreenLockEnd(isRefresh?: boolean): void {
    log.showInfo(TAG, 'now screenOffToScreenLockEnd');
    this.playScreenOffToScreenLockEnd(isRefresh);
    this.createSpringAnim(MirrorsScene.SCREEN_OFF_TO_SL_END);
  }

  protected playScreenOffToScreenLockEnd(isRefresh?: boolean): void {
    this.sceneAnimStart(MirrorsScene.SCREEN_OFF_TO_SL_END, true);
    this.isScreenOffToSl = true;
    // 准备亮屏，标识非AOD
    this.setComAodSt(false);
    let creatAnimParam: MirrorAnimateParam = {
      delay: 0,
      duration: 400,
      finish: () => {
        this.isScreenOffToSl = false;
        log.showInfo(TAG, 'now screenOffToScreenLockEnd end');
        this.sceneAnimFinish(MirrorsScene.SCREEN_OFF_TO_SL_END);
        screenLockStateHelper.getOneMirrorStaticState()?.setAodShowingState(false);
      },
      callback: () => {
        this.mirrorComponentState.get(MirrorComponent.SL_ROOT)?.(MirrorsScene.SCREEN_OFF_TO_SL_END);
        this.mirrorComponentState.get(MirrorComponent.LOCK_ICON)?.(MirrorsScene.SCREEN_OFF_TO_SL_END);
        this.mirrorComponentState.get(MirrorComponent.SIGN)?.(MirrorsScene.SCREEN_OFF_TO_SL_END);
        this.mirrorComponentState.get(MirrorComponent.CLOCK)?.(MirrorsScene.SCREEN_OFF_TO_SL_END);
        this.mirrorComponentState.get(MirrorComponent.FORM_CARD)?.(MirrorsScene.SCREEN_OFF_TO_SL_END);
        this.mirrorComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(MirrorsScene.SCREEN_OFF_TO_SL_END);
        this.mirrorComponentState.get(MirrorComponent.NTF_LIST)?.(MirrorsScene.SCREEN_OFF_TO_SL_END);
        this.mirrorComponentState.get(MirrorComponent.NTF_CAPSULE)?.(MirrorsScene.SCREEN_OFF_TO_SL_END);
        this.mirrorComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.SCREEN_OFF_TO_SL_END);
        // 动效中刷新AOD显示状态，目标非AOD
        this.requestUpdateAodSt();
      },
      scene: MirrorsScene.SCREEN_OFF_TO_SL_END
    }

    MirrorAnimationUtil.createMirrorAnimateTo(creatAnimParam, true);
  }

  /**
   * 锁屏到黑屏
   */
  protected desktopToAod(isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback): void {
    log.showInfo(TAG, 'No mirror desktopToAod');
    // 准备灭屏，标识AOD
    this.setComAodSt(true);
    // 刷新AOD显示状态，目标AOD
    this.requestUpdateAodSt();
  }

  /**
   * 锁屏到AOD
   */
  protected screenLockToAod(isRefresh?: boolean, finishCallback?: OneMirrorAnimateCallback): void {
    log.showInfo(TAG, 'No mirror screenLockToAod');
    // 准备灭屏，标识AOD
    this.setComAodSt(true);
    // 刷新AOD显示状态，目标AOD
    this.requestUpdateAodSt();
  };

  /**
   * 锁屏解锁后组件下树
   */
  protected slUnlockToDesktop(isRefresh?: boolean): void {
    log.showInfo(TAG, 'No mirror slUnlockToDesktop');
  }

  /**
   * 锁屏到解锁
   */
  protected screenLockToUnlock(isRefresh?: boolean): void {
    if (this.isScreenOffToSl) {
      log.showInfo(TAG, `unlocking interrupt SCREEN_OFF_TO_SL_EDN`);
      animateToImmediately({ duration: 0, curve: Curve.Linear }, () => {
        this.sceneAnimFinish(MirrorsScene.SCREEN_OFF_TO_SL_END);
      })
    }
  }

  /**
   * 从桌面直接进入锁屏
   */
  protected desktopToSl(isRefresh?: boolean): void {
    log.showInfo(TAG, `desktopToSl isRefresh: ${isRefresh}`);
    if (isRefresh) {
      return;
    }
    // 准备亮屏，标识非AOD
    this.setComAodSt(false);
    // 刷新AOD显示状态，目标非AOD
    this.requestUpdateAodSt();

    // 无需播放锁屏动效，直接刷新UI即可
    this.uIComponentState?.forEach((fun: (state: string) => void, key: string) => {
      fun?.(MirrorsScene.DESKTOP_TO_SL);
    });
  }

  protected createSpringAnim(scene: MirrorsScene): void {
    this.mirrorComponentStart.get(MirrorComponent.DOF_WALLPAPER)?.(scene, MirrorAnimState.START, true);

    let creatAnimParam: MirrorAnimateParam = {
      delay: 0,
      duration: 0,
      finish: () => {
        log.showInfo(TAG, 'spring end ' + scene);
        if (this.dofMirrorCtrl?.isSceneAnimating(scene)) {
          this.mirrorComponentStart.get(MirrorComponent.DOF_WALLPAPER)?.(scene, MirrorAnimState.START, false);
          this.uIComponentState.get(MirrorComponent.DOF_WALLPAPER)?.(scene);
        }
      },
      callback: () => {
        log.showInfo(TAG,  'spring start ' + scene);
        this.mirrorComponentState.get(MirrorComponent.DOF_WALLPAPER)?.(scene);
      },
      scene: scene
    }

    MirrorAnimationUtil.creatMirrorSpring(creatAnimParam);
  }

  protected startSlNtfAnim(scene: MirrorsScene, state: MirrorAnimState, isStart: boolean): void {
    if (isStart) {
      this.mirrorComponentStart.get(MirrorComponent.NTF_IMMERSIVE)?.(scene, MirrorAnimState.NONE, isStart);
      this.mirrorComponentStart.get(MirrorComponent.NTF_LIST)?.(scene, MirrorAnimState.NONE, isStart);
      this.mirrorComponentStart.get(MirrorComponent.NTF_CAPSULE)?.(scene, MirrorAnimState.NONE, isStart);
      return;
    }

    if (this.immersiveCardMirrorCtrl.isSceneAnimating(scene)) {
      this.uIComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(scene);
      this.mirrorComponentStart.get(MirrorComponent.NTF_IMMERSIVE)?.(scene, state, false);
    }

    if (this.immersiveListMirrorCtrl.isSceneAnimating(scene)) {
      this.uIComponentState.get(MirrorComponent.NTF_LIST)?.(scene);
      this.mirrorComponentStart.get(MirrorComponent.NTF_LIST)?.(scene, state, false);
    }

    if (this.immersiveCapsuleMirrorCtrl.isSceneAnimating(scene)) {
      this.uIComponentState.get(MirrorComponent.NTF_CAPSULE)?.(scene);
      this.mirrorComponentStart.get(MirrorComponent.NTF_CAPSULE)?.(scene, state, false);
    }
  }

  protected setComAodSt(isAod: boolean): void {
    // 设置AOD状态，不参与动效
    screenLockStateHelper.getOneMirrorStaticState()?.setComAodSt(isAod);
  }

  protected requestUpdateAodSt(): void {
    // 请求切换AOD状态，允许参与动效
    screenLockStateHelper.getOneMirrorStaticState()?.updateAnimAodSt();
  }
}