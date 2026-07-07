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

import { LogDomain, Logger, Trace } from '@ohos/basicutils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { AnimSystemProfile, AnimSystemProfileParam } from '../manager/AnimSystemProfile';
import { bundleManager } from '@kit.AbilityKit';
import { VassistantConstants } from '@ohos/commonconstants';
import { thermal } from '@kit.BasicServicesKit';
import { ApsUtils } from '@ohos/frameworkwrapper';

const TAG = 'AiBarVEMgr';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const CCM_PARAM_FULL: string = 'full';
const CCM_PARAM_LITE: string = 'lite';
const SUPPORT_USE_LITE_EFFECT: string = 'support_anim_6_0';
const VASS_HAP_NAME: string = 'entry';
const START_SCENE: number = 1;
const COMPLETE_END_SCENE: number = 2;
const RSS_RESTYPE: number = 10025;

export interface RssDataResult {
  FLING: Fling;
}

export interface Fling {
  bundleName: string;
}

/**
 * AiBarVisualEffectManager
 *
 * @since 2025-09-08
 */
export class AiBarVisualEffectManager {
  public static mInstance: AiBarVisualEffectManager;
  private profileParam: AnimSystemProfileParam = { animationLevel: '', thermalLevel: '' };
  private overThermalLevel: thermal.ThermalLevel = thermal.ThermalLevel.HOT;
  private isFullVisualEffect: boolean = false;
  private isVassSupportNewEffect: boolean = false;

  static getInstance(): AiBarVisualEffectManager {
    if (!AiBarVisualEffectManager.mInstance) {
      AiBarVisualEffectManager.mInstance = new AiBarVisualEffectManager();
    }
    return AiBarVisualEffectManager.mInstance;
  }

  /**
   * 配置参数初始化
   */
  public init(): void {
    let result = AnimSystemProfile.loadAnimSystemProfileConfigs();
    if (!result) {
      log.showWarn(TAG, 'load ccm params failed.');
      return;
    }
    this.profileParam = result;
    log.showDebug(TAG, `init profileParam: ${JSON.stringify(this.profileParam)}`);
    this.isVassSupportNewEffect = this.checkVassMetaData();
    this.isFullVisualEffect = this.isFullDevice() && this.isVassSupportNewEffect;
    if (this.profileParam.thermalLevel && !isNaN(Number(this.profileParam.thermalLevel))) {
      this.overThermalLevel = Number.parseInt(this.profileParam.thermalLevel);
    } else {
      log.showWarn(TAG, 'load thermalLevel param failed.');
    }
    log.showInfo(TAG,
      `init profileParam: isFullVisualEffect: ${this.isFullVisualEffect}, overThermalLevel: ${this.overThermalLevel}`);
  }

  /**
   * 是否full设备
   *
   * @returns true:是 false:不是
   */
  private isFullDevice(): boolean {
    return this.profileParam.animationLevel === CCM_PARAM_FULL;
  }

  /**
   * 是否走6.0full视效
   *
   * @returns true:是 false:不是
   */
  public isFullEffect(): boolean {
    return this.isFullVisualEffect;
  }

  /**
   * 语音助手应用升级时需要重新校验
   */
  public upgradeVass(): void {
    this.isVassSupportNewEffect = this.checkVassMetaData();
    this.isFullVisualEffect = this.isFullDevice() && this.isVassSupportNewEffect;
    log.showInfo(TAG, `upgradeVass isFullVisualEffect: ${this.isFullVisualEffect}`);
  }

  /**
   * 拉起语音助手前，full机器的话需要识别是否游戏、RSS场景，如果是的话，需要走6.0lite视效
   */
  public updateFullEffect(gameSatusMapSize: number): void {
    this.isFullVisualEffect = this.isFullDevice() && this.isVassSupportNewEffect &&
      !this.isGameScene(gameSatusMapSize) && !this.isRSSScene();
    log.showInfo(TAG, `updateFullEffect isFullVisualEffect: ${this.isFullVisualEffect}`);
  }

  /**
   * 获取缓存的level字符串
   *
   * @returns 缓存的level字符串
   */
  public getEffectLevel(): string {
    return this.isFullEffect() ? CCM_PARAM_FULL : CCM_PARAM_LITE;
  }

  /**
   * 判断是否游戏场景
   *
   * @param gameSatusMapSize
   * @returns true:是 false:不是
   */
  private isGameScene(gameSatusMapSize: number): boolean {
    const isGameRunning: boolean = gameSatusMapSize > 0;
    log.showInfo(TAG, `isGameRunning: ${isGameRunning}, gameSatusMapSize: ${gameSatusMapSize}`);
    return isGameRunning;
  }

  /**
   * 判断是否RSS场景，如抛滑、应用启动
   *
   * @returns true:是 false:不是
   */
  private isRSSScene(): boolean {
    let payload: Record<string, string> = {};
    try {
      let rssData: Record<string, string> =
        sceneSessionManager.getRssData(RSS_RESTYPE, payload) as Record<string, string>;
      let rssDataResult: RssDataResult = JSON.parse(rssData.result) as RssDataResult;
      if (!rssDataResult || !rssDataResult.FLING) {
        return false;
      }
      let bundleName: string = rssDataResult.FLING.bundleName;
      log.showInfo(TAG, `isRSSScene bundleName: ${bundleName}`);
      return bundleName !== '';
    } catch (err) {
      log.error(TAG, `isRSSScene error: ${err.message}`);
    }
    return false;
  }

  /**
   * 判断是否高温场景
   *
   * @param level 当前温度档位
   * @returns true:是 false:不是
   */
  private isOverThermalScene(level: thermal.ThermalLevel): boolean {
    let isOverThermal: boolean = level >= this.overThermalLevel;
    log.showInfo(TAG, `isOverThermal: ${isOverThermal}, level: ${level}`);
    return isOverThermal;
  }

  /**
   * 高温场景下，在呼出语音助手动效开始时通过Aps开始限帧
   *
   * @param level 当前温度档位
   * @param animName 动效名称
   */
  public limitAppVsyncStart(level: thermal.ThermalLevel, animName?: string): void {
    if (this.isOverThermalScene(level)) {
      log.showInfo(TAG, 'limitAppVsyncStart');
      Trace.start(animName);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.LIGHTEFFECT_SCB_THERMAL_CONTROL, START_SCENE);
    }
  }

  /**
   * 在呼出语音助手动效结束时通过Aps结束限帧
   *
   * @param animName 动效名称
   */
  public limitAppVsyncEnd(animName?: string): void {
    // ApsUtils.setApsScene(apsManager.SceneAnimation.LIGHTEFFECT_SCB_THERMAL_CONTROL, COMPLETE_END_SCENE);
    log.showInfo(TAG, 'limitAppVsyncEnd');
    Trace.end(animName);
  }

  /**
   * 通过语音助手metadata.json中的key确认语音助手是否支持6.0新视效
   *
   * @returns true:支持 false:不支持
   */
  private checkVassMetaData(): boolean {
    try {
      let bundleInfo =
        bundleManager.getBundleInfoSync(VassistantConstants.VASSISTANT_BUNDLE_NAME,
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA |
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE);
      return bundleInfo?.hapModulesInfo?.find((hap) => {
        return hap.name === VASS_HAP_NAME;
      })?.metadata?.find((item?) => {
        return item?.name === SUPPORT_USE_LITE_EFFECT;
      })?.value === 'true';
    } catch (error) {
      log.error(TAG, 'checkVassMetaData error %{public}s', error.message);
    }
    return false;
  }
}