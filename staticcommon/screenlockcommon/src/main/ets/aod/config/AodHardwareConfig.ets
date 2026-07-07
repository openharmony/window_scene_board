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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CcmOption } from '../../constants/CommonConstants';
import { SlVisualConfigManager } from '../../visual/SlVisualConfigManager';

const TAG = 'AodHardwareConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AOD, TAG);
const AOD_HARDWARE_CONFIG_KEY = 'const.aod.hardware_config';

type IndexRange = [number, number];


export enum AodSupportType {
  NO = 0,
  SENSOR_HUB = 1,
  AP = 2,
}

export enum AodCommSwitchType {
  /**
   *  关闭
   */
  CLOSE = 0,
  /**
   *  开启
   */
  OPEN = 1,
}

/**
 * AOD硬件配置
 * const.aod.hardware_config是一个多位二进制数字合成的十进制数字，从右往左排列，新增时在左边插入
 * 如当前值是61，二进制表示是111101，其中第0位和第1位合起来表示是否支持AOD，第2位表示是否支持全屏AOD，第3位表示是否支持人眼注视显示AOD
 * 第4位表示是否支持模糊、赋色，第5位表示是否支持TOF靠近显示AOD, 第6位表示是否支持DDR提频，第8位表示是否显示指纹解锁黑帧
 * 第9位表示支持精细化模糊提亮,第10位表示支持全屏AOD服务卡片和胶囊通知的精细化模糊提亮
 */
class AodHardwareConfig {
  private static readonly INDEX_RANGE_SUPPORT_AOD: IndexRange = [0, 2];
  private static readonly INDEX_RANGE_SUPPORT_FULL_SCREEN_AOD: IndexRange = [2, 3];
  private static readonly INDEX_RANGE_SUPPORT_GLANCE: IndexRange = [3, 4];
  private static readonly INDEX_RANGE_SUPPORT_BACKGROUND_EFFECT: IndexRange = [4, 5];
  private static readonly INDEX_RANGE_SUPPORT_TOF: IndexRange = [5, 6];
  private static readonly INDEX_RANGE_SUPPORT_DDR: IndexRange = [6, 7];
  private static readonly INDEX_RANGE_FINGERPRINT_BLACK_FRAME: IndexRange = [8, 9];
  private static readonly INDEX_RANGE_SUPPORT_NEW_EFFECT: IndexRange = [9, 10];
  private static readonly INDEX_RANGE_SUPPORT_SL_COMPONENT_EFFECT: IndexRange = [10, 11];
  private static readonly INVALID_ITEM_VALUE: number = -1;

  private static param: string | undefined = undefined;

  public isSupportAOD(): boolean {
    return [AodSupportType.SENSOR_HUB].includes(this.getItemValue(AodHardwareConfig.INDEX_RANGE_SUPPORT_AOD));
  }

  public isSupportFullScreenAOD(): boolean {
    return this.getItemValue(AodHardwareConfig.INDEX_RANGE_SUPPORT_FULL_SCREEN_AOD) === AodCommSwitchType.OPEN;
  }

  public isSupportGlance(): boolean {
    return this.getItemValue(AodHardwareConfig.INDEX_RANGE_SUPPORT_GLANCE) === AodCommSwitchType.OPEN;
  }

  public isSupportBackgroundEffect(): boolean {
    //中低档视效不支持模糊提亮
    if (SlVisualConfigManager.getInstance().getEnable(CcmOption.SOLID) ||
      !SlVisualConfigManager.getInstance().getEnable(CcmOption.BRIGHT)) {
      log.showWarn('Not support for low visual');
      return false;
    }
    //模糊提亮依赖swing模型
    if (!this.isSupportGlance()) {
      log.showWarn('Not support swing');
      return false;
    }

    if (this.isSupportNewEffect()) {
      return true;
    }
    return this.getItemValue(AodHardwareConfig.INDEX_RANGE_SUPPORT_BACKGROUND_EFFECT) === AodCommSwitchType.OPEN;
  }

  /**
   * 是否支持全屏AOD服务卡片和通知的精细化模糊提亮
   * @returns 支持模糊提亮功能则返回true
   */

  public isSupportSlComponentEffect(): boolean {
    return this.getItemValue(AodHardwareConfig.INDEX_RANGE_SUPPORT_SL_COMPONENT_EFFECT) === AodCommSwitchType.OPEN;
  }


  public isSupportNewEffect(): boolean {
    return this.getItemValue(AodHardwareConfig.INDEX_RANGE_SUPPORT_NEW_EFFECT) === AodCommSwitchType.OPEN;
  }

  /**
   * 是否支持TOF靠近显示AOD
   * @returns 支持TOF靠近显示AOD则返回true
   */
  public isSupportTof(): boolean {
    return this.getItemValue(AodHardwareConfig.INDEX_RANGE_SUPPORT_TOF) === AodCommSwitchType.OPEN;
  }

  /**
   * 是否支持DDR提频
   * @returns 支持DDR提频则返回true
   */
  public isSupportDdr(): boolean {
    return this.getItemValue(AodHardwareConfig.INDEX_RANGE_SUPPORT_DDR) === AodCommSwitchType.OPEN;
  }

  /**
   * 是否显示指纹解锁黑帧
   * @returns 显示指纹解锁黑帧则返回true
   */
   public isFingerprintBlackFrame(): boolean {
    return this.getItemValue(AodHardwareConfig.INDEX_RANGE_FINGERPRINT_BLACK_FRAME) === AodCommSwitchType.OPEN;
  }

  private getItemValue(indexRange: IndexRange): number {
    try {
      const configValue = this.getSystemParameter();
      if (!configValue) {
        return AodHardwareConfig.INVALID_ITEM_VALUE;
      }
      const bytes = Number.parseInt(configValue).toString(2);
      const length = bytes.length;
      const itemStr = bytes.substring(length - indexRange[1], length - indexRange[0]);
      return Number.parseInt(itemStr, 2) ?? AodHardwareConfig.INVALID_ITEM_VALUE;
    } catch (e) {
      log.error('Get hardware value failed:', e);
      return AodHardwareConfig.INVALID_ITEM_VALUE;
    }
  }

  private getSystemParameter(): string {
    try {
      if (AodHardwareConfig.param === undefined) {
        AodHardwareConfig.param = systemParameterEnhance.getSync(AOD_HARDWARE_CONFIG_KEY);
      }
      return AodHardwareConfig.param;
    } catch (e) {
      log.showError('Get hardware value failed: %{public}s', e);
      return '';
    }
  }
}

const aodHardwareConfig: AodHardwareConfig = new AodHardwareConfig();

export default aodHardwareConfig;