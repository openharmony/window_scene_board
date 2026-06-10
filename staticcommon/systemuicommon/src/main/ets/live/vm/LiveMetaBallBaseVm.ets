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

import curves from '@ohos.curves';
// import { BallParams, MetaballController, MetaballAnimationParams } from '@hms.hds.Metaball';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveBaseVm } from './LiveBaseVm';
import { SysTypeCode } from '../../liveview/common/LiveConstants';
import { LiveMetaBallScene, LiveType } from '../model/LiveCommonModel';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { ResUtils } from '@ohos/windowscene';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { RotationConstants, WindowConstants } from '@ohos/commonconstants';
import { AnimationBase } from '../../animation/AnimationBase';
import { CustomPromise } from '@ohos/frameworkwrapper';
import type { LiveVmInjector } from '../LiveVmInjector';
import { ILiveMetaBallVm } from '../interface/ILiveMetaBallVm';
import { StatusBarHeightVm } from '../../statusbar/vm/StatusBarHeightVm';
import { util } from '@kit.ArkTS';
import { Singleton } from '../../utils/Singleton';
import { StatusBarCapsulePosition } from '../../statusbar/model/StatusBarCapsulePosition';
import { CapsuleTransferParam } from '../interface/ILiveCapsuleListVm';
import { LiveStyle } from '../constants/LiveStyle';
import type { Hole } from '../../statusbar/vm/CutoutVm';

const TAG = 'LiveMetaBallBaseVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 融球动效曲线
 */
const taskCurve = Curve.Linear;

@ObservedV2
export abstract class LiveMetaBallBaseVm extends LiveBaseVm implements ILiveMetaBallVm {
  /**
   * 融球动效中的状态栏高度
   */
  public abstract animStatusBarHeight: number;
  /**
   * 融球上顶位移
   * 根据挖孔位置计算，防止上移超出屏幕顶或物理挖孔下端
   */
  public abstract maxOffsetY: number;
  /**
   * 融球动效前后的状态栏高度
   */
  public readonly STATUS_BAR_HEIGHT: number = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
  public cutoutVm: CutoutVm = CutoutVm.instance;
  @Trace public scaleX: number = 1.0;
  @Trace public scaleY: number = 1.0;
  @Trace public offsetY: number = 0;

  @Singleton.decorate()
  get controller() {
    // return new MetaballController();
    return null
  }

  public sceneSet: Set<LiveMetaBallScene> = new Set();

  // protected async fusionBall(status: boolean[], colors: ResourceColor[],
  //   animateParam: MetaballAnimationParams, isUpwards?: boolean): Promise<void> {
  //   StatusBarHeightVm.getInstance().preSetShowHeight(this.animStatusBarHeight, TAG);
  //   return new Promise((resolve) => {
  //     try {
  //       animateParam.animateParam.onFinish = () => {
  //         StatusBarHeightVm.getInstance().clearShowHeight(TAG);
  //         log.info('finish fusionBall: ', status, colors, animateParam.scene, animateParam.animateParam.duration);
  //         resolve();
  //       };
  //       log.info('start to fusionBall: ', status, colors, animateParam.scene, animateParam.animateParam.duration);
  //       this.vmInjector.getMetaBallVisibleVm().setMetaBallShowState(status);
  //       this.controller.startFusionBallAnimation(status, animateParam, colors);
  //       if (isUpwards) {
  //         const metaBallUpwardsAnimation = new AnimationBase(AnimationBase.NAMES.METABALL_TRANS_ANIMATION);
  //         metaBallUpwardsAnimation.executeAnimation([
  //           {
  //             curve: curves.interpolatingSpring(0, 1, 247, 25),
  //             event: () => {
  //               this.offsetY = this.maxOffsetY;
  //             }
  //           },
  //           {
  //             curve: curves.interpolatingSpring(0, 1, 1755, 84),
  //             delay: LiveStyle.METABALL_HIGHEST_DURATION + 34,
  //             event: () => {
  //               this.offsetY = 0;
  //             }
  //           }
  //         ]);
  //       }
  //     } catch (e) {
  //       log.showError(`fusionBall error: ${e}`);
  //       resolve();
  //     }
  //   });
  // }

  public onDisappear(): void {
    StatusBarHeightVm.getInstance().clearShowHeight(TAG);
  }

  protected getAnimateParam(duration?: number): AnimateParam {
    return {
      curve: taskCurve,
      duration: duration ?? 777,
      finishCallbackType: FinishCallbackType.LOGICALLY
    };
  }

  public async toggleState(capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    const scene = this.getScene();
    const isUpwards = capsuleTransferParam?.isUpwards;
    const duration = capsuleTransferParam?.metaBallToggleDuration;
    log.showInfo(`toggleState, scene: ${scene}`);
    if (scene === LiveMetaBallScene.DESKTOP) {
      // 回到桌面场景
      await this.toggleToDeskTop(isUpwards, duration);
    } else if (scene === LiveMetaBallScene.HEADS_UP) {
      await this.toggleToHeadUp(duration);
    } else if (scene === LiveMetaBallScene.LIVE_PANEL) {
      // 胶囊展开卡片
      await this.toggleToLiveList(duration);
    } else if (scene === LiveMetaBallScene.DROPDOWN) {
      await this.toggleToPanel(duration);
    } else if (scene === LiveMetaBallScene.SCREEN_LOCK) {
      await this.toggleToPanel(duration);
    } else if (scene === LiveMetaBallScene.STATUSBAR_HIDE) {
      // 隐藏状态栏，比如：进入多任务中心
      await this.toggleToPanel(duration);
    } else if (scene === LiveMetaBallScene.REMIND) {
      await this.toggleToRemind(duration);
    } else if (scene === LiveMetaBallScene.IMMERSIVE) {
      await this.toggleToImmersive(duration);
    }
  }

  setScene(scene: LiveMetaBallScene, isAdd: boolean): void {
    log.showInfo(`Set scene: ${scene}, isAdd: ${isAdd}`);
    if (isAdd) {
      this.sceneSet.add(scene);
    } else {
      this.sceneSet.delete(scene);
    }
  }

  protected getScene(): LiveMetaBallScene {
    if (this.sceneSet.has(LiveMetaBallScene.REMIND)) {
      return LiveMetaBallScene.REMIND;
    }
    if (this.sceneSet.has(LiveMetaBallScene.SCREEN_LOCK)) {
      return LiveMetaBallScene.SCREEN_LOCK;
    }
    if (this.sceneSet.has(LiveMetaBallScene.STATUSBAR_HIDE) && this.cutoutVm.isMiddleCutout()) {
      return LiveMetaBallScene.STATUSBAR_HIDE;
    }
    if (this.sceneSet.has(LiveMetaBallScene.DROPDOWN)) {
      return LiveMetaBallScene.DROPDOWN;
    }
    if (this.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)) {
      return LiveMetaBallScene.LIVE_PANEL;
    }
    if (this.sceneSet.has(LiveMetaBallScene.HEADS_UP)) {
      return LiveMetaBallScene.HEADS_UP;
    }
    return LiveMetaBallScene.DESKTOP;
  }

  public updateProperty(vm: ILiveMetaBallVm): void {
    this.sceneSet = vm.sceneSet;
  }

  /**
   * 桌面场景触发融球
   *
   * @param isUpwards 融球是否向上形变
   * @returns Promise
   */
  abstract toggleToDeskTop(isUpwards?: boolean, duration?: number): Promise<void>;

  /**
   * 横幅场景触发融球
   * @returns Promise
   */
  abstract toggleToHeadUp(duration?: number): Promise<void>;

  /**
   * 实况卡片展开场景触发融球
   * @returns Promise
   */
  abstract toggleToLiveList(duration?: number): Promise<void>;

  /**
   * 面板场景，如下拉双中心，锁屏等
   * @returns Promise
   */
  abstract toggleToPanel(duration?: number): Promise<void>;

  /**
   * 强提醒触发融球
   * @returns Promise
   */
  abstract toggleToRemind(duration?: number): Promise<void>;

  /**
   * 沉浸态触发融球
   * @returns Promise
   */
  abstract toggleToImmersive(duration?: number): Promise<void>;

  abstract getWidth(capsulePosition: StatusBarCapsulePosition): number;

  abstract getHeight(capsulePosition: StatusBarCapsulePosition): number;

  abstract getPosition(capsulePosition: StatusBarCapsulePosition): LocalizedEdges | Edges;

  // abstract getBallParam(capsulePosition: StatusBarCapsulePosition): BallParams[];

  abstract getMiddleHole(): Hole;
}