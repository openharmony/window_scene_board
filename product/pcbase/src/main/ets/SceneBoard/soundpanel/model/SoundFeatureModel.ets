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
import { GlobalContext } from '@ohos/frameworkwrapper';
import { EarphoneDeviceConstants } from '../common/EarphoneDeviceConstants';

/**
 * 降噪或空间音频特性类型
 */
export interface SoundFeatureType {
  label: ResourceStr;
  // value: NoiseSwitch | SpatialState;
  value: number;
  icon: Resource;
  des: string;
  isSelected?: boolean;
}

/**
 * ui展示的电量信息
 */
export interface BatteryInfo {
  icon: Resource;
  iconSize: number;
  value: number;
  isCharging: boolean;
  isChargingMargin?: boolean;
  isSymbol?: boolean;
}

/**
 * 气泡toast类型
 */
export class FeaturePopupType {
  public featureDes: string = '';
  public isPopupShow: boolean = false;
  public handlePopup: PopupOptions | null = null;
}

const TAG = 'SoundPanel-SoundFeatureModel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

class SoundFeatureModel {
  public noiseControlConfig: SoundFeatureType[] = [];
  public spatialConfig: SoundFeatureType[] = [];

  /**
   * 获取噪声控制配置数据
   *
   * @param noiseControlAbility(0/2/3)  0表示不支持，2表示2态降噪，3表示3态降噪（跟随音频管家规格走）
   * @returns 噪声控制UI配置 config
   */
  public getNoiseControlConfig(noiseControlAbility: ESObject): SoundFeatureType[] {
    /*if (noiseControlAbility === NoiseControlSupportMode.NOT_SUPPORT) {
      return [];
    }*/
    if (this.noiseControlConfig.length === noiseControlAbility) {
      return this.noiseControlConfig;
    }
    this.noiseControlConfig = [
      {
        label: $r('app.string.base_none'),
        // value: NoiseSwitch.NOISE_CANCELING_OFF,
        value: 0,
        icon: $r('app.media.ic_noise_control_0'),
        des: 'noise_off',
      },
      {
        label: $r('app.string.noise_reduction'),
        // value: NoiseSwitch.NOISE_CANCELING_ON,
        value: 0,
        icon: $r('app.media.ic_noise_control_2'),
        des: 'noise_cancel',
      }
    ];
    /*if (noiseControlAbility === NoiseControlSupportMode.THREE_MODE) {
      this.noiseControlConfig.splice(1, 0, {
        label: $r('app.string.base_pass_through'),
        value: NoiseSwitch.AWARENESS,
        icon: $r('app.media.ic_noise_control_1'),
        des: 'noise_awareness',
      });
    }*/
    return this.noiseControlConfig;
  }

  /**
   * 高清空间音频UI配置
   */
  public getSpatialConfig(spatialAbility: ESObject): SoundFeatureType[] {
    /*if (spatialAbility === SpatialSupportMode.NOT_SUPPORT) {
      return [];
    }*/
    if (this.spatialConfig.length === spatialAbility + 1) {
      return this.spatialConfig;
    }
    this.spatialConfig = [
      {
        label: $r('app.string.base_none'),
        // value: SpatialState.OFF,
        value: 0,
        icon: $r('app.media.ic_audio_spatial_0'),
        des: 'spatial_off',
      },
      {
        label: $r('app.string.spatial_audio_fixed'),
        // value: SpatialState.FIX,
        value: 0,
        icon: $r('app.media.ic_audio_spatial_1'),
        des: 'spatial_fix',
      },
    ];
    /*if (spatialAbility === SpatialSupportMode.THREE_MODE) {
      this.spatialConfig.push({
        label: $r('app.string.spatial_audio_follow'),
        // value: SpatialState.TRACK,
        icon: $r('app.media.ic_audio_spatial_2'),
        des: 'spatial_track',
      });
    }*/
    return this.spatialConfig;
  }

  public getDefaultAncMode(): SoundFeatureType {
    return {
      label: '',
      // value: NoiseSwitch.NOISE_CANCELING_OFF,
      value: 0,
      icon: $r('app.media.ic_noise_control_0'),
      des: 'noise_off',
    }
  }

  public getDefaultSpatialState(): SoundFeatureType {
    return {
      label: '',
      // value: SpatialState.OFF,
      value: 0,
      icon: $r('app.media.ic_audio_spatial_0'),
      des: 'spatial_off'
    }
  }

  /**
   * 获取单电量图片
   * @param batteryValue 电量值
   * @returns 单电量Symbol图片资源
   */
  public getSingleBatteryIcon(batteryValue: number) {
    if (batteryValue <= 0 || batteryValue > 100) {
      return $r('sys.symbol.battery');
    }
    // 电量图标以5和10为单位
    const remainder: number = batteryValue % 5;
    log.showInfo(`getSingleBatteryIcon batteryValue: ${batteryValue}, remainder: ${remainder}`);
    try {
      const batteryName: string = `battery_${batteryValue - remainder}percent`;
      // 查询被5整除的值的电量图片是否存在
      GlobalContext.getContext().resourceManager.getSymbolByName(batteryName);
      return $r(`sys.symbol.${batteryName}`);
    } catch (e) {
      log.showInfo(`getSingleBatteryIcon error ${e?.code}, message: ${e?.message}`);
      // 不存在返回10整除的图片
      const value: number = batteryValue - remainder + 5;
      return $r(`sys.symbol.battery_${value}percent`);
    }
  }

  /**
   * 获取特性面板总高度
   * @param noiseLength 降噪配置长度
   * @param spatialLength 空间音频配置长度
   * @param isLast 是否
   * @returns
   */
  public getFeatureHeight(noiseLength: number, spatialLength: number, isLast: boolean): number {
    const noiseHeight = this.getFeatureContainerHeight(noiseLength);
    const spatialHeight = this.getFeatureContainerHeight(spatialLength);
    log.showInfo(`${TAG} getFeatureHeight noise: ${noiseHeight} spatial: ${spatialHeight} isLast: ${isLast}`);
    // 特性面板高度 = 降噪面板高度 + 空间音频面板高度 + 上下分割线边距
    return (noiseHeight + spatialHeight) + EarphoneDeviceConstants.DIVIDER_HEIGHT +
      (isLast ? 0 : (EarphoneDeviceConstants.DIVIDER_HEIGHT));
  }

  /**
   * 获取特性高度
   * @param buttonNum 特性按钮数量
   * @returns 特性高度
   */
  private getFeatureContainerHeight(buttonNum: number): number {
    if (buttonNum < 1) {
      return 0;
    }
    // 按钮数量 + 标题 + 按钮间距
    return (EarphoneDeviceConstants.FEATURE_ITEM_HEIGHT * buttonNum) + EarphoneDeviceConstants.FEATURE_TITLE_HEIGHT +
      (EarphoneDeviceConstants.COMPONENT_SPACE * (buttonNum - 1));
  }
}

export const soundFeatureModel: SoundFeatureModel = new SoundFeatureModel();