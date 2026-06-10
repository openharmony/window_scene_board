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
import { AppStorageUtil, DataProperty, LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { ColorUtil } from '../../utils/ColorUtil';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { ILiveCapsuleWaveVm } from '../interface/ILiveCapsuleWaveVm';
import { LiveCapsuleProgressModel } from '../model/LiveCapsuleProgressModel';
import { LiveItemBaseVm } from './LiveBaseVm';

const TAG = 'LiveCapsuleWaveVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const CORE_METHOD_PROGRESS_CAPSULE_WAVE_MOVE = 'ProgressCapsuleWaveMove';
const CORE_METHOD_PROGRESS_CAPSULE_WAVE_SWEEP = 'ProgressCapsuleWaveSweep';

const WAVE_MARGIN_ANIM_DURATION = 1000;
const WAVE_OPACITY_ANIM_DELAY = 900;
const FIRST_ANIM_DELAY = 1000;

@ObservedV2
export class LiveCapsuleWaveVm extends LiveItemBaseVm implements ILiveCapsuleWaveVm {
  private animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.PROGRESS_CAPSULE_WAVE_ANIMATION, true);
  private waveMoving: boolean = false;
  @Trace protected isFullProgress: boolean = false;
  @Trace public processWaveMarginLeft: number = -LiveStyle.WAVE_WIDTH;
  @Trace public moveWaveMarginLeft: number = -LiveStyle.WAVE_WIDTH;
  @Trace public moveWaveOpacity: number = LiveStyle.MOVE_WAVE_OPACITY;
  @Trace public isVisible: boolean = false;

  @Computed
  public get capsuleVm(): ILiveCapsuleVm {
    return this.vmInjector.getCapsuleVm(this.live);
  }

  @Computed
  public get waveImageResource(): Resource {
    return ColorUtil.checkUseLightColor(this.live.capsule?.backgroundColor ?? LiveStyle.CAPSULE_CONTENT_COLOR)
      ? $r('app.media.week_wave')
      : $r('app.media.strong_wave');
  }

  @Computed
  public get capsuleWidth(): number {
    return this.capsuleVm.width;
  }

  @Computed
  public get capsuleProgressRadio(): number {
    const progressData = (this.live.capsule as LiveCapsuleProgressModel).progress;
    const currentValue: number = progressData?.currentValue ?? 0;
    const maxValue: number = progressData?.maxValue ?? 1;
    const radio: number = Math.min(Math.max(currentValue / maxValue, 0), 1);

    // 更新是否进度已满
    this.isFullProgress = radio === 1;
    return radio;
  }

  /**
   * 刷新进度波浪位置
   * @param capsuleWidth 胶囊宽度
   */
  public refreshProgressWaveMarginLeft(): void {
    // 中孔宽度：2 + 孔宽度 + 2
    const holeWidth = CutoutVm.instance.isMiddleCutout() ? CutoutVm.instance.width + 4 : 0;
    const showAreaWidth = this.capsuleWidth - holeWidth;
    const marginLeft: number = this.capsuleProgressRadio * showAreaWidth - LiveStyle.WAVE_WIDTH;
    if (this.processWaveMarginLeft !== marginLeft) {
      // 不可见时不需要动效
      if (this.isFullProgress || this.capsuleWidth < LiveStyle.CAPSULE_WIDTH) {
        this.processWaveMarginLeft = marginLeft;
        this.isVisible = false;
      } else {
        log.showInfo(`refreshProgressWaveMarginLeft with anim, ${this.waveMoving}`);
        this.processWaveMarginLeft = -LiveStyle.WAVE_WIDTH;
        this.isVisible = true;
        this.animationBase.executeAnimation([{
          duration: WAVE_MARGIN_ANIM_DURATION,
          curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
          delay: !this.waveMoving ? FIRST_ANIM_DELAY : 0,
          onFinish: () => {
            if (!this.waveMoving) {
              AppStorageUtil.setOrCreate('canEnableStatusBarComponentRenderGroup', false,
                new DataProperty(true, false));
              this.doWaveMove();
            }
          },
          event: () => {
            this.processWaveMarginLeft = marginLeft;
          }
        }], CORE_METHOD_PROGRESS_CAPSULE_WAVE_MOVE);
      }
    }
  }

  /**
   * 进行波浪扫光动效
   */
  private doWaveMove(): void {
    // 已完成状态、暂停动效状态、和已有进行中动效状态不进行波浪动效
    if (!this.isVisible) {
      log.showInfo(`stop doWaveMove`);
      AppStorageUtil.setOrCreate('canEnableStatusBarComponentRenderGroup', true, new DataProperty(true, false));
      this.waveMoving = false;
      return;
    }
    this.waveMoving = true;
    const cmds: AnimateParams[] = [];
    cmds.push({
      duration: WAVE_MARGIN_ANIM_DURATION,
      curve: Curve.Linear,
      event: () => {
        this.moveWaveMarginLeft = this.processWaveMarginLeft;
      }
    });
    cmds.push({
      duration: WAVE_MARGIN_ANIM_DURATION - WAVE_OPACITY_ANIM_DELAY,
      curve: Curve.Linear,
      delay: WAVE_OPACITY_ANIM_DELAY,
      event: () => {
        this.moveWaveOpacity = 0;
      }
    });
    this.animationBase.executeAnimation(cmds, CORE_METHOD_PROGRESS_CAPSULE_WAVE_SWEEP)
      .then(() => this.resetAndRemoveWave());
  }

  private resetMoveWaveParm(): void {
    this.moveWaveMarginLeft = -LiveStyle.WAVE_WIDTH;
    this.moveWaveOpacity = LiveStyle.MOVE_WAVE_OPACITY;
  }

  private resetAndRemoveWave(): void {
    // 显示动画立即下发，重置首帧为初始值，防止后续动效无效
    animateToImmediately({ duration: 0 }, () => {
      this.resetMoveWaveParm();
    });
    this.doWaveMove();
  }

  public destroy(): void {
    this.isVisible = false;
  }
}
