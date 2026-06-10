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
import { AppStorageUtil,
  DataProperty,
  DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { LiveProgressData } from './data/extend/LiveProgressData';
import { ProgressCapsuleWaveState } from './info/capsule/ProgressCapsuleWaveState';
import { curves } from '@kit.ArkUI';

const TAG = 'ProgressCapsuleAnimMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const CORE_METHOD_PROGRESS_CAPSULE_WAVE_MOVE = 'ProgressCapsuleWaveMove';
const CORE_METHOD_PROGRESS_CAPSULE_WAVE_SWEEP = 'ProgressCapsuleWaveSweep';

const WAVE_MARGIN_ANIM_DURATION = 1000;
const WAVE_OPACITY_ANIM_DELAY = 900;
const FIRST_ANIM_DELAY = 500;

/**
 * 进度类胶囊动效控制
 */
export class ProgressCapsuleAnimMgr {
  /**
   * 进度胶囊波浪组件状态
   */
  private waveState: ProgressCapsuleWaveState = new ProgressCapsuleWaveState();
  private isFullProgress: boolean = false;
  private needStopShow: boolean = false;
  private waveMoving: boolean = false;
  /**
   * 扫光动效计数，一个完整的扫光只会依次进行2次动效
   */
  private moveWaveAnimCount: number = 0;

  /**
   * 获取波浪状态
   * @returns 波浪组件状态
   */
  public getWaveState(): ProgressCapsuleWaveState {
    return this.waveState;
  }

  /**
   * 刷新进度波浪位置
   * @param capsuleWidth 胶囊宽度
   * @param typeData 胶囊进度数据
   */
  public refreshProgressWaveMarginLeft(capsuleWidth: number,
                                       typeData: LiveProgressData): void {
    if (this.needStopShow) {
      return;
    }
    let currentValue: number = typeData?.currentValue ?? 0;
    let maxValue: number = typeData?.maxValue ?? 1;
    let radio: number = Math.min(Math.max(currentValue / maxValue, 0), 1);

    // 更新是否进度已满
    this.isFullProgress = radio === 1;
    let marginLeft: number = radio * capsuleWidth - this.waveState.getWaveWidth();
    if (this.waveState.processWaveMarginLeft !== marginLeft) {
      log.showInfo(`do ProgressWaveMarginLeft anim, waveMoving: ${this.waveMoving}`);
      TraceUtil.startTrace(DomainName.SYS_UI, CORE_METHOD_PROGRESS_CAPSULE_WAVE_MOVE);
      animateTo({
        duration: WAVE_MARGIN_ANIM_DURATION,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
        delay: !this.waveMoving ? FIRST_ANIM_DELAY : 0,
        onFinish: () => {
          TraceUtil.endTrace(DomainName.SYS_UI, CORE_METHOD_PROGRESS_CAPSULE_WAVE_MOVE);
          if (!this.waveMoving) {
            AppStorageUtil.setOrCreate('canEnableStatusBarComponentRenderGroup', false, new DataProperty(true, false));
            this.doWaveMove();
          }
        }
      }, () => {
        this.waveState.processWaveMarginLeft = marginLeft;
      })
    }
  }

  /**
   * 进行波浪扫光动效
   */
  public doWaveMove(): void {
    // 已完成状态、暂停动效状态、和已有进行中动效状态不进行波浪动效
    if (this.isFullProgress || this.needStopShow || this.moveWaveAnimCount !== 0) {
      AppStorageUtil.setOrCreate('canEnableStatusBarComponentRenderGroup', true, new DataProperty(true, false));
      this.waveMoving = false;
      return;
    }
    this.waveMoving = true;
    TraceUtil.startTrace(DomainName.SYS_UI, CORE_METHOD_PROGRESS_CAPSULE_WAVE_SWEEP);
    animateTo({
      duration: WAVE_MARGIN_ANIM_DURATION,
      curve: Curve.Linear,
      onFinish: () => {
        this.moveWaveAnimCount--;
        if (this.moveWaveAnimCount === 0) {
          TraceUtil.endTrace(DomainName.SYS_UI, CORE_METHOD_PROGRESS_CAPSULE_WAVE_SWEEP);
          this.waveState.resetMoveWaveParm();
          this.doWaveMove();
        }
      }
    }, () => {
      this.moveWaveAnimCount++;
      this.waveState.moveWaveMarginLeft = this.waveState.processWaveMarginLeft;
    })
    animateTo({
      duration: WAVE_MARGIN_ANIM_DURATION - WAVE_OPACITY_ANIM_DELAY,
      curve: Curve.Linear,
      delay: WAVE_OPACITY_ANIM_DELAY,
      onFinish: () => {
        this.moveWaveAnimCount--;
        if (this.moveWaveAnimCount === 0) {
          TraceUtil.endTrace(DomainName.SYS_UI, CORE_METHOD_PROGRESS_CAPSULE_WAVE_SWEEP);
          this.waveState.resetMoveWaveParm();
          this.doWaveMove();
        }
      }
    }, () => {
      this.moveWaveAnimCount++;
      this.waveState.moveWaveOpacity = 0;
    })
  }

  /**
   * 暂停显示跟进度波浪有关的动效或组件
   */
  public stopShowProgressWave(): void {
    this.needStopShow = true;
    this.waveState.processWaveMarginLeft = -this.waveState.getWaveWidth();
  }

  public showProgressWave(capsuleWidth: number, typeData: LiveProgressData): void {
    this.needStopShow = false;
    this.refreshProgressWaveMarginLeft(capsuleWidth, typeData);
  }
}