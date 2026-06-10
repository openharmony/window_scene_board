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

import { ArrayUtils, CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants, LiveFormSupportMgr } from '@ohos/launchercommon';
import { OverflowConstants } from '@ohos/commonconstants';

const SPLIT_CHAR: string = ',';
// value是一个number数组，存放宽、高宽溢出区域的放大系数
const OVERFLOW_SCALE_RATIO_MAP: Map<number, number[]> =
  new Map([[CommonConstants.CARD_DIMENSION_1x2, [1.5, 2.0]], [CommonConstants.CARD_DIMENSION_2x2, [1.5, 1.5]],
    [CommonConstants.CARD_DIMENSION_2x4, [1.25, 1.5]], [CommonConstants.CARD_DIMENSION_4x4, [1.25, 1.25]],
    [CommonConstants.CARD_DIMENSION_6x4, [1.25, 1.1]]]);
const LIVE_FORM_SCALE_RATION_ARRAY_LENGTH = 4;

const TAG = 'OverflowThresholdConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 读取配置文件，确认参数
 */
export class OverflowThresholdConfig {
  private overflowMaxAnimationDuration: number = OverflowConstants.MAX_ANIMATION_DURATION_DEFAULT;
  private overflowScaleRatio: Map<number, number[]> = OVERFLOW_SCALE_RATIO_MAP;
  private longOverflowProtectedDuration: number = OverflowConstants.LONG_OVERFLOW_DURATION_DEFAULT;
  private static instance: OverflowThresholdConfig | undefined = undefined;

  /**
   * 获取实例
   * @returns 实例
   */
  public static getInstance(): OverflowThresholdConfig {
    if (!OverflowThresholdConfig.instance) {
      OverflowThresholdConfig.instance = new OverflowThresholdConfig();
    }
    return OverflowThresholdConfig.instance;
  }

  private constructor() {
    this.getOverflowThresholdConfig();
  }

  private getOverflowThresholdConfig(): void {
    let liveFormMaxAnimationDuration: number = LiveFormSupportMgr.getInstance().getLiveFormMaxAnimationDuration();
    let liveFormScaleRatioString: string = LiveFormSupportMgr.getInstance().getLiveFormScaleRatio();
    let longOverflowProtectedDuration: number = LiveFormSupportMgr.getInstance().getLongOverflowRequestDuration();
    this.setOverflowMaxDuration(liveFormMaxAnimationDuration ?? OverflowConstants.MAX_ANIMATION_DURATION_DEFAULT);
    this.setOverflowScaleRatio(liveFormScaleRatioString ?? '');
    log.showInfo(`getOverflowThresholdConfig, liveFormMaxAnimationDuration: ${liveFormMaxAnimationDuration}` +
      `liveFormScaleRatioString: ${liveFormScaleRatioString}`);
  }

  /**
   * 设置最大溢出时延
   * @param liveFormMaxAnimationDuration 最大溢出时延
   */
  private setOverflowMaxDuration(liveFormMaxAnimationDuration: number): void {
    this.overflowMaxAnimationDuration = liveFormMaxAnimationDuration;
  }

  /**
   * 设置溢出区域缩放系数
   * @param liveFormScaleRatioString 溢出区域的放大系数
   */
  private setOverflowScaleRatio(liveFormScaleRatioString: string): void {
    if (CheckEmptyUtils.isEmpty(liveFormScaleRatioString)) {
      this.overflowScaleRatio = OVERFLOW_SCALE_RATIO_MAP;
    } else {
      this.overflowScaleRatio = this.convertOverflowScaleRatio(liveFormScaleRatioString);
    }
  }

  private convertOverflowScaleRatio(liveFormScaleRatioString: string): Map<number, number[]> {
    let overflowScaleRatioMap: Map<number, number[]> = new Map();
    let liveFormScaleRatio: number[] = [0, 0, 0, 0];
    let liveFormScaleRatioArray: string[] = liveFormScaleRatioString.split(SPLIT_CHAR);
    log.showInfo(`convertOverflowScaleRatio, liveFormScaleRatioArray: ${liveFormScaleRatioArray}`);
    if (liveFormScaleRatioArray.length !== LIVE_FORM_SCALE_RATION_ARRAY_LENGTH) {
      return OVERFLOW_SCALE_RATIO_MAP;
    }
    for (let i = 0; i < liveFormScaleRatioArray.length; i++) {
      let value = Number.parseFloat(liveFormScaleRatioArray[i]);
      if (isNaN(value)) {
        return OVERFLOW_SCALE_RATIO_MAP;
      }
      ArrayUtils.updateByIndex(liveFormScaleRatio, i, value);
    }
    overflowScaleRatioMap.set(CommonConstants.CARD_DIMENSION_1x2, [liveFormScaleRatio[1], liveFormScaleRatio[0]]);
    overflowScaleRatioMap.set(CommonConstants.CARD_DIMENSION_2x2, [liveFormScaleRatio[1], liveFormScaleRatio[1]]);
    overflowScaleRatioMap.set(CommonConstants.CARD_DIMENSION_2x4, [liveFormScaleRatio[2], liveFormScaleRatio[1]]);
    overflowScaleRatioMap.set(CommonConstants.CARD_DIMENSION_4x4, [liveFormScaleRatio[2], liveFormScaleRatio[2]]);
    overflowScaleRatioMap.set(CommonConstants.CARD_DIMENSION_6x4, [liveFormScaleRatio[2], liveFormScaleRatio[3]]);
    return overflowScaleRatioMap;
  }

  /**
   * 获取最大溢出时延
   * @returns 最大溢出时延
   */
  public getOverflowMaxDuration(): number {
    return this.overflowMaxAnimationDuration;
  }

  /**
   * 获取溢出区域缩放系数：溢出后区域大小 / 卡片大小
   * @param dimension 卡片宫格占用信息
   * @returns 宽，高放大的比例系数数组
   */
  public getOverflowScaleRatio(dimension: number): number[] | undefined {
    return this.overflowScaleRatio.get(dimension) ?? undefined;
  }

  /**
   * 获取长时溢出请求保护期时长
   * @returns 长时溢出请求保护期时长
   */
  public getLongOverflowProtectedDuration(): number {
    log.showInfo('getLongOverflowProtectedDuration, longOverflowProtectedDuration: %{public}d',
      this.longOverflowProtectedDuration);
    return this.longOverflowProtectedDuration;
  }
}