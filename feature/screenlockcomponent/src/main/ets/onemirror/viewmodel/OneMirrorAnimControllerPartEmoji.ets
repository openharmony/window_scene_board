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

import { LogDomain, Logger } from '@ohos/basicutils';
import { MirrorAnimState, MirrorComponent, MirrorsScene } from '../constants/MirrorToEndConst';
import MirrorAnimationUtil from '../utils/MirrorAnimationUtil';
import OneMirrorAnimController from './OneMirrorAnimController';

const TAG = 'OneMirrorAnimControllerPartEmoji';
const log: Logger = Logger.getLogHelper(LogDomain.KG);
const NORMAL_BEZIER_TIME = 400; // 一镜到底贝塞尔曲线默认时长

export default class OneMirrorAnimControllerPartEmoji extends OneMirrorAnimController {
  // 元素动效状态
  protected mirrorComponentState: Map<MirrorComponent, (state: string) => void> = new Map([
    [MirrorComponent.SL_ROOT, (state: string) => {
      this.screenLockRootCtrl.setPartAodAnimState(state);
    }],
    [MirrorComponent.LOCK_ICON, (state: string) => {
      this.lockIconMirrorCtrl.setAnimEmoji(state);
    }],
    [MirrorComponent.CLOCK, (state: string) => {
      this.clockMirrorCtrl.setAnimEmoji(state);
    }],
    [MirrorComponent.DOF_WALLPAPER, (state: string) => {
    }],
    [MirrorComponent.NTF_IMMERSIVE, (state: string) => {
      this.immersiveListMirrorCtrl.setPartAodAnimState(state);
      this.immersiveCapsuleMirrorCtrl.setPartAodAnimState(state);
    }],
  ])
  // 元素UI状态
  protected uIComponentState: Map<MirrorComponent, (state: string) => void> = new Map([
    [MirrorComponent.SL_ROOT, (state: string) => {
      this.screenLockRootCtrl.setPartAodUiBindState(state);
    }],
    [MirrorComponent.LOCK_ICON, (state: string) => {
      this.lockIconMirrorCtrl.setPartUiBindState(state);
    }],
    [MirrorComponent.CLOCK, (state: string) => {
      this.clockMirrorCtrl.setPartUiBindState(state);
    }],
    [MirrorComponent.DOF_WALLPAPER, (state: string) => {
    }],
    [MirrorComponent.NTF_IMMERSIVE, (state: string) => {
      this.immersiveListMirrorCtrl.setPartAodUiBindState(state);
      this.immersiveCapsuleMirrorCtrl.setPartAodUiBindState(state);
    }],
  ])
  private allFinish = (scene: MirrorsScene) => {
    this.sceneAnimStart(scene, false);
    log.showInfo(TAG, 'allFinish');
  }

  protected aodToDesktop(isRefresh?: boolean | undefined): void {
    log.showInfo(TAG, `now aodToDesktop isRefresh=${isRefresh}`);
    if (isRefresh) {
      // 准备亮屏，标识非AOD
      this.setComAodSt(false);
      // 刷新AOD显示状态，目标非AOD
      this.requestUpdateAodSt();
      return;
    }
    this.sceneAnimStart(MirrorsScene.AOD_TO_DESKTOP, true);
    let animCallBack = () => {
      this.mirrorComponentState.forEach((fun, key) => {
        fun?.(MirrorsScene.AOD_TO_DESKTOP);
      })
    }
    this.createAnimateTo(animCallBack, MirrorsScene.AOD_TO_DESKTOP);
  }

  protected aodToScreenLock(isRefresh?: boolean | undefined): void {
    log.showInfo(TAG, `now aodToScreenLock isRefresh=${isRefresh}`);
    if (isRefresh) {
      return;
    }
    this.sceneAnimStart(MirrorsScene.AOD_TO_SL, true);
    // 准备亮屏，标识非AOD
    this.setComAodSt(false);
    let animCallBack = () => {
      this.mirrorComponentState.forEach((fun, key) => {
        fun?.(MirrorsScene.AOD_TO_SL);
      });
      // 动效刷新AOD显示状态，目标非AOD
      this.requestUpdateAodSt();
    }
    this.createAnimateTo(animCallBack, MirrorsScene.AOD_TO_SL);
  }

  protected screenOffToScreenLock(isRefresh?: boolean | undefined): void {
  }

  protected screenOffToScreenLockEnd(isRefresh?: boolean | undefined): void {
    // 准备亮屏，标识非AOD
    this.setComAodSt(false);
    this.sceneAnimStart(MirrorsScene.SCREEN_OFF_TO_SL_END, true);
    let animCallBack = () => {
      this.mirrorComponentState.forEach((fun, key) => {
        fun?.(MirrorsScene.SCREEN_OFF_TO_SL_END);
      });
      // 动效刷新AOD显示状态，目标非AOD
      this.requestUpdateAodSt();
    }
    this.createAnimateTo(animCallBack, MirrorsScene.SCREEN_OFF_TO_SL_END);
  }

  protected desktopToAod(isRefresh?: boolean | undefined): void {
    log.showInfo(TAG, `now desktopToAod isRefresh=${isRefresh}`);
    if (isRefresh) {
      // 准备灭屏，标识AOD
      this.setComAodSt(true);
      // 刷新AOD显示状态，目标AOD
      this.requestUpdateAodSt();
      this.mirrorComponentState.get(MirrorComponent.NTF_IMMERSIVE)?.(MirrorsScene.DESKTOP_TO_AOD +
      MirrorAnimState.START);
      this.uIComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.DESKTOP_TO_AOD +
      MirrorAnimState.START);
      this.mirrorComponentState.get(MirrorComponent.ART_SIGN)?.(MirrorsScene.DESKTOP_TO_AOD +
      MirrorAnimState.START);
      return;
    }
    this.sceneAnimStart(MirrorsScene.DESKTOP_TO_AOD, true);
    let animCallBack = () => {
      this.mirrorComponentState.forEach((fun, key) => {
        fun?.(MirrorsScene.DESKTOP_TO_AOD);
      })
    }
    this.createAnimateTo(animCallBack, MirrorsScene.DESKTOP_TO_AOD);
  }

  protected screenLockToAod(isRefresh?: boolean | undefined): void {
    log.showInfo(TAG, `now screenLockToAod isRefresh=${isRefresh}`);
    if (isRefresh) {
      return;
    }
    this.sceneAnimStart(MirrorsScene.SL_TO_AOD, true);
    // 准备灭屏，标识AOD
    this.setComAodSt(true);
    let animCallBack = () => {
      this.mirrorComponentState.forEach((fun, key) => {
        fun?.(MirrorsScene.SL_TO_AOD);
      })
      // 刷新AOD显示状态，目标AOD
      this.requestUpdateAodSt();
    }
    this.createAnimateTo(animCallBack, MirrorsScene.SL_TO_AOD);
  }

  protected slUnlockToDesktop(isRefresh?: boolean): void {
  }

  private createAnimateTo(callback: Function, scene: MirrorsScene): void {
    MirrorAnimationUtil.createMirrorAnimateTo({
      delay: 0,
      duration: NORMAL_BEZIER_TIME,
      finish: () => {
        this.allFinish(scene)
      },
      callback: callback,
      scene: scene
    }, true);
  }
}