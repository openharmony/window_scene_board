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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { slStateHelper } from '../../common/helper/SlStateHelper';
import { MirrorAnimState, MirrorsScene } from '../constants/MirrorToEndConst';
import IComponentMirrorCtrl from './IComponentMirrorCtrl';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { SlBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { aodHardwareConfig } from '@ohos/screenlockcommon/Index';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';

const TAG = 'ScreenLockRootMirrorCtrl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ScreenLockRootMirrorCtrl implements IComponentMirrorCtrl {
  // 锁屏面板动效状态管理
  private slRootAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlRootAnimState();
  // 锁屏面板UI绑定状态管理
  private slRootUiBindCtrl: ISlState | undefined = slStateHelper.getSlBindState();
  // 时钟组件UI样式状态管理
  private slClockBindCtrl: SlClockBindState | undefined = slStateHelper.getSlClockBindState();
  // 上一次开始动效的场景
  private lastStartScene: string = '';

  setUiBindState(scene: string): void {
    log.showInfo(`setUiBindState=${scene}`);
    if (scene === MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START) {
      if (this.slClockBindCtrl?.getClockDesktopToAod()) {
        this.slRootUiBindCtrl?.setSlState(SlBindStateType.SL_ROOT_SCALE, 1);
      } else {
        this.slRootUiBindCtrl?.setSlState(SlBindStateType.SL_ROOT_SCALE,
          aodHardwareConfig.isSupportBackgroundEffect() ? 0.96 : 0.95);
      }
      return;
    }
    // 从桌面、锁屏灭屏无一镜到底场景，会有AOD存在的情况，AOD需要截图锁屏组件需要刷新缩放参数
    if (this.isEnterAod(scene) || scene === MirrorsScene.SL_TO_SCREEN_OFF ||
      scene === MirrorsScene.DESKTOP_TO_SCREEN_OFF) {
      this.slRootUiBindCtrl?.setSlState(SlBindStateType.SL_ROOT_SCALE,
        aodHardwareConfig.isSupportBackgroundEffect() ? 0.96 : 0.95);
      return;
    }
    this.slRootUiBindCtrl?.setSlState(SlBindStateType.SL_ROOT_SCALE, 1);
  }

  setAnimState(scene: string): void {
    log.showInfo(`setAnimState=${scene}`);
    if (this.isEnterAod(scene)) {
      this.slRootAnimCtrl?.setScaleX(aodHardwareConfig.isSupportBackgroundEffect() ? 0.96 : 0.95);
      this.slRootAnimCtrl?.setScaleY(aodHardwareConfig.isSupportBackgroundEffect() ? 0.96 : 0.95);
      return;
    }
    this.slRootAnimCtrl?.setScaleX(1);
    this.slRootAnimCtrl?.setScaleY(1);
  }

  setPartAodUiBindState(scene: string): void {
    log.showInfo(`setPartAodUiBindState=${scene}`);
    this.slRootUiBindCtrl?.setSlState(SlBindStateType.SL_ROOT_SCALE, 1);
  }

  setPartAodAnimState(scene: string): void {
    log.showInfo(`setPartAodAnimState=${scene}`);
    this.slRootAnimCtrl?.setScaleX(1);
    this.slRootAnimCtrl?.setScaleY(1);
  }

  startAnim(scene: string, state: MirrorAnimState, isStart: boolean): void {
    if (isStart) {
      this.lastStartScene = scene;
      this.clearAnimating();
    }

    this.slRootAnimCtrl?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: true });
  }

  clearAnimating(): void {
    let scenes = this.slRootAnimCtrl?.getSceneValues();
    log.showInfo(`now clear all anim scenes, ${scenes}`)
    scenes?.split(',').forEach((scene) => {
      this.slRootAnimCtrl?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: true });
    })
  }

  isSceneAnimating(scene: string): boolean {
    return this.slRootAnimCtrl?.isSceneAnimating(scene) ?? false;
  }

  private isEnterAod(scene: string): boolean {
    return scene === MirrorsScene.DESKTOP_TO_AOD ||
      scene === MirrorsScene.SL_TO_AOD ||
      scene === MirrorsScene.SCREEN_OFF_TO_SL ||
      scene === MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START;
  }
}