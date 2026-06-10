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

import fs from '@ohos.file.fs';
import HashMap from '@ohos.util.HashMap';
import configPolicy from '@ohos.configPolicy';
import { power } from '@kit.BasicServicesKit';
import thermal from '@ohos.thermal';
import { JSON } from '@kit.ArkTS';
import {
  ArrayUtils,
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { StartExitMotionLevel } from '@ohos/commonconstants/src/main/ets/constants/VisualEffectConstants';

const TAG = 'SCBVisualEffectManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const SCB_VISUAL_EFFECTS_CONFIG_FILE_PATH = 'etc/scb_effect_config/scb_visual_effects_config.json';
const SCB_MULTI_WINDOW_EFFECTS_CONFIG_FILE_PATH = 'etc/multiwindow/multiwindow_effects_config.json';
const MAX_RETRIES = 3;
const DELAY = 500;

/**
 * hdc shell scb_debug SCBVisualEffectManager visualFeatureParams
 */
const DUMP_SCB_VISUAL_FEATURE_PARAMS: string = 'visualFeatureParams';

export interface VisualEffectListener {
  notifyAnimationPolicyUpdate?(visualFeatureData: VisualFeatureData): Function;
}

export enum ListenerType {
  TEMPERATURE = 'temperature',
  BATTERY = 'battery'
}

/**
 * 视效关键参数信息
 */
export interface VisualFeatureData {
  /**
   * level 热档位
   */
  level: thermal.ThermalLevel,

  /**
   * powerMode 电源模式
   */
  powerMode: number
}

export interface ScbVisualEffectInfo {
  /**
   * 视效配置参数版本号
   */
  version: string;

  /**
   * 领域级别视效档位 (low/mid/high)
   */
  domainEffectLevel: string;

  /**
   * 特性参数
   */
  featureParameters: string[];
}

class VisualConfig {
  /**
   * 视效配置参数版本号
   */
  configVersion?: string;

  /**
   * 领域级别视效档位 (low/mid/high)
   */
  domainEffectLevel?: string;

  /**
   * 特性参数
   */
  featureParamsMap?: HashMap<string, string>;

  /**
   * 特性配置路径
   */
  configPath?: string;
}

/**
 * SCBVisualEffectManager
 *
 * @since 2024-11-28
 */
export class SCBVisualEffectManager {
  private static readonly sLowLevelDefaultParams: Map<string, string> = new Map([
    [VisualEffectConstants.NTF_BLUR_EFFECT_DISABLE, 'true'],
    [VisualEffectConstants.NTF_SHADOW_DISABLE, 'true'],
    [VisualEffectConstants.NTF_BRIGHTENS_DISABLE, 'true'],
    [VisualEffectConstants.NTF_BRIGHTENS_CENTRALIZED, 'false'],
    [VisualEffectConstants.CC_BRIGHTNESS_DISABLE, 'true'],
    [VisualEffectConstants.CC_SOLID_COLOR_ENABLE, 'true'],
    [VisualEffectConstants.IMMERSIVE_CARD_BRIGHTNESS_DISABLE, 'true'],
    [VisualEffectConstants.CC_PIXEL_STRETCH_EFFECT_DISABLE, 'true'],
    [VisualEffectConstants.CC_HEAD_BLUR_EFFECT_DISABLE, 'true'],
    [VisualEffectConstants.CC_DROPDOWN_PANEL_FORCE_CLOSE_HDR_ENABLE, 'true'],
    [VisualEffectConstants.ICON_START_EXIT_BLUR_DISABLE, 'true'],
    [VisualEffectConstants.ICON_CARD_SHADOW_DISABLE, 'true'],
    [VisualEffectConstants.IS_RECENT_BLUR_DISABLED, 'true'],
    [VisualEffectConstants.ICON_START_EXIT_BLUR_DISABLE, 'true'],
    [VisualEffectConstants.IS_NEGATIVESCREEN_BLUR_DISABLED, 'true'],
    [VisualEffectConstants.AIBAR_BLUR_INVERT_EFFECT_DISABLE, 'true'],
    [VisualEffectConstants.FOLDER_BLUR_EFFECT_DISABLE, 'true'],
    [VisualEffectConstants.FOLDER_SENSE_OF_ORDER_DISABLE, 'true'],
    [VisualEffectConstants.LAUNCHER_SWIPER_CUSTOM_ENABLED, 'true'],
    [VisualEffectConstants.MOTION_BLUR_DISABLE, 'true'],
    [VisualEffectConstants.GLOBAL_SEARCH_BLUR_EFFECT_DISABLE, 'true'],
    [VisualEffectConstants.FOLDER_SOLID_COLOR_DISABLE, 'true'],
    [VisualEffectConstants.SCREEN_CLOCK_ONE_SHOT_ANIM_ENABLE, 'false'],
    [VisualEffectConstants.FOREGROUND_BLUR_DISABLE, 'true'],
    [VisualEffectConstants.SCREEN_LOCK_EFFECT_DISABLE, 'true'],
    [VisualEffectConstants.SCREEN_LOCK_BRIGHT_DISABLE, 'true'],
    [VisualEffectConstants.SCREEN_LOCK_SOLID_ENABLE, 'true'],
    [VisualEffectConstants.DOCK_BLUR_DISABLE, 'true'],
    [VisualEffectConstants.CARD_VISUAL_EFFECT_LEVEL, 'low'],
    [VisualEffectConstants.HIGHEST_MOTION_BLUR_ENABLE, '-1'],
    [VisualEffectConstants.AOD_VISUAL_EFFECT_LEVEL, 'low'],
  ]);

  private static readonly sHighLevelDefaultParams: Map<string, string> = new Map([
    [VisualEffectConstants.NTF_BLUR_EFFECT_DISABLE, 'false'],
    [VisualEffectConstants.NTF_SHADOW_DISABLE, 'false'],
    [VisualEffectConstants.NTF_BRIGHTENS_DISABLE, 'false'],
    [VisualEffectConstants.NTF_BRIGHTENS_CENTRALIZED, 'false'],
    [VisualEffectConstants.CC_BRIGHTNESS_DISABLE, 'false'],
    [VisualEffectConstants.CC_SOLID_COLOR_ENABLE, 'false'],
    [VisualEffectConstants.IMMERSIVE_CARD_BRIGHTNESS_DISABLE, 'false'],
    [VisualEffectConstants.CC_PIXEL_STRETCH_EFFECT_DISABLE, 'false'],
    [VisualEffectConstants.CC_HEAD_BLUR_EFFECT_DISABLE, 'false'],
    [VisualEffectConstants.CC_DROPDOWN_PANEL_FORCE_CLOSE_HDR_ENABLE, 'false'],
    [VisualEffectConstants.ICON_START_EXIT_BLUR_DISABLE, 'false'],
    [VisualEffectConstants.ICON_CARD_SHADOW_DISABLE, 'false'],
    [VisualEffectConstants.IS_RECENT_BLUR_DISABLED, 'false'],
    [VisualEffectConstants.ICON_START_EXIT_BLUR_DISABLE, 'false'],
    [VisualEffectConstants.IS_NEGATIVESCREEN_BLUR_DISABLED, 'false'],
    [VisualEffectConstants.AIBAR_BLUR_INVERT_EFFECT_DISABLE, 'false'],
    [VisualEffectConstants.GLOBAL_SEARCH_BLUR_EFFECT_DISABLE, 'false'],
    [VisualEffectConstants.FOLDER_BLUR_EFFECT_DISABLE, 'false'],
    [VisualEffectConstants.FOLDER_SENSE_OF_ORDER_DISABLE, 'false'],
    [VisualEffectConstants.LAUNCHER_SWIPER_CUSTOM_ENABLED, 'false'],
    [VisualEffectConstants.MOTION_BLUR_DISABLE, 'false'],
    [VisualEffectConstants.FOLDER_SOLID_COLOR_DISABLE, 'false'],
    [VisualEffectConstants.SCREEN_CLOCK_ONE_SHOT_ANIM_ENABLE, 'true'],
    [VisualEffectConstants.SCREEN_LOCK_EFFECT_DISABLE, 'false'],
    [VisualEffectConstants.SCREEN_LOCK_BRIGHT_DISABLE, 'false'],
    [VisualEffectConstants.SCREEN_LOCK_SOLID_ENABLE, 'false'],
    [VisualEffectConstants.DOCK_BLUR_DISABLE, 'false'],
    [VisualEffectConstants.CARD_VISUAL_EFFECT_LEVEL, 'high'],
    [VisualEffectConstants.HIGHEST_MOTION_BLUR_ENABLE, '-1'],
    [VisualEffectConstants.AOD_VISUAL_EFFECT_LEVEL, 'high'],
  ]);

  private static readonly startExitMotionLevelMap: Map<string, StartExitMotionLevel> = new Map([
    [StartExitMotionLevel.NORMAL_BLUR, StartExitMotionLevel.NORMAL_BLUR],
    [StartExitMotionLevel.WALLPAPER_BLUR, StartExitMotionLevel.WALLPAPER_BLUR],
    [StartExitMotionLevel.REMOVE_BLUR, StartExitMotionLevel.REMOVE_BLUR],
  ]);

  private static readonly configFilePaths: string[] = [
    SCB_VISUAL_EFFECTS_CONFIG_FILE_PATH,
    SCB_MULTI_WINDOW_EFFECTS_CONFIG_FILE_PATH
  ]

  private visualConfigs: VisualConfig[] = new Array<VisualConfig>();
  private visualEffectListenerMap = new Map<ListenerType, Map<string, VisualEffectListener>>();

  private registerDebugCommands(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: DUMP_SCB_VISUAL_FEATURE_PARAMS,
        callback: (args: string[]): string => {
          return this.onFeatureParamsDump(args);
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  /**
   * 视效配置参数初始化
   */
  public async init(): Promise<void> {
    log.showInfo('init');
    this.loadScbVisualEffectConfigs();
    this.thermalLevelChange();
    this.registerDebugCommands();
  }
  private async loadScbVisualEffectConfigs(): Promise<void> {
    log.showInfo('loadScbVisualEffectConfigs');
    for (let configFilePath of SCBVisualEffectManager.configFilePaths) {
      let visualConfig: VisualConfig = new VisualConfig();
      visualConfig.configPath = configFilePath;
      this.visualConfigs.push(visualConfig);
      try {
        let configFile: string | undefined = await configPolicy.getOneCfgFile(configFilePath);
        if (!configFile) {
          log.showWarn('Can not find effect json path');
          continue;
        }
        if (!fs.accessSync(configFile)) {
          log.showWarn('Can not access effect json file');
          continue;
        }
        const effectJsonText: string = fs.readTextSync(configFile);
        if (!effectJsonText) {
          log.showWarn('effectJsonText is empty');
          continue;
        }
        let configInfo: ScbVisualEffectInfo = JSON.parse(effectJsonText) as ScbVisualEffectInfo;
        let featureParamsMap: HashMap<string, string> = new HashMap();
        if (configInfo.version) {
          visualConfig.configVersion = configInfo.version;
          log.showInfo(`loadScbVisualEffectsConfigs, version: ${visualConfig.configVersion}}`);
        } else {
          log.showInfo(`loadScbVisualEffectsConfigs version err, configInfo.version: ${configInfo.version}}`);
        }
        if (configInfo.domainEffectLevel) {
          visualConfig.domainEffectLevel = configInfo.domainEffectLevel;
          log.showInfo(`loadScbVisualEffectsConfigs, level: ${visualConfig.domainEffectLevel}`);
        } else {
          log.showInfo(`loadScbVisualEffectsConfigs level err, configInfo.domainEffectLevel: ${configInfo.domainEffectLevel}}`);
        }
        visualConfig.configPath = configFilePath;
        for (const jsonEle of configInfo.featureParameters) {
          let key = Object.keys(jsonEle)[0] as string;
          let value = jsonEle[Object.keys(jsonEle)[0]] as string;
          featureParamsMap.set(key, value);
        }
        visualConfig.featureParamsMap = featureParamsMap;
      } catch (err) {
        log.showError(`Error on load effects file, error ${err.message}`);
      }
    }
  }

  /**
   * 获取模块特性配置参数
   *
   * @param feature 特性名称
   * @returns 特性参数值
   */
  public getFeatureParam(feature: string): string | undefined {
    if (!feature || feature === '') {
      log.showWarn('feature is empty');
      return undefined;
    }
    let featureParam: string | undefined = undefined;
    this.visualConfigs.forEach(visualConfig => {
      if (visualConfig.featureParamsMap?.hasKey(feature)) {
        featureParam = visualConfig.featureParamsMap.get(feature);
      }
      if (visualConfig.configPath === SCB_VISUAL_EFFECTS_CONFIG_FILE_PATH && featureParam === undefined) {
        if (visualConfig.domainEffectLevel === VisualEffectConstants.DOMAIN_EFFECT_LEVEL_LOW) {
          featureParam = SCBVisualEffectManager.sLowLevelDefaultParams.has(feature) ?
          SCBVisualEffectManager.sLowLevelDefaultParams.get(feature) : undefined;
        } else {
          featureParam = SCBVisualEffectManager.sHighLevelDefaultParams.has(feature) ?
          SCBVisualEffectManager.sHighLevelDefaultParams.get(feature) : undefined;
        }
      }
    })
    return featureParam;
  }

  /**
   * 获取模块特性配置参数的布尔值
   *
   * @param feature 特性名称
   * @returns 特性参数布尔值
   */
  public isFeatureParamTrue(feature: string): boolean {
    let featureParam: string | undefined = this.getFeatureParam(feature);
    log.showDebug(`isFeatureParamTrue, feature: ${feature}, featureParam: ${featureParam}`);
    return featureParam === 'true';
  }

  /**
   * 获取启动退出模糊时效级别
   * @param feature
   * @returns
   */
  public getStartExitMotionLevel(feature: string): StartExitMotionLevel {
    const key: string = this.getFeatureParam(feature) ?? '';
    let featureParam: StartExitMotionLevel = SCBVisualEffectManager.startExitMotionLevelMap.get(key) ??
      StartExitMotionLevel.NORMAL_BLUR;
    log.showInfo(`getStartExitMotionLevel, feature: ${feature}, featureParam: ${featureParam}`);
    return featureParam;
  }

  /**
   * 获取模块特性配置参数的数值
   *
   * @param feature 特性名称
   * @returns 特性参数布尔值,如果无配置默认为-1
   */
  public getFeatureParamNumber(feature: string): number {
    let featureParam: string | undefined = this.getFeatureParam(feature);
    log.showWarn(`getFeatureParamNumber, feature: ${feature}, featureParam: ${featureParam}`);
    if (featureParam && !isNaN(Number(featureParam))) {
      return Number.parseInt(featureParam);
    }
    return -1;
  }

  /**
   * 是否在省电模式
   *
   * @returns 省电模式布尔值
   */
  public isPowerSaveMode(): boolean {
    const powerMode = power.getPowerMode();
    return (power.DevicePowerMode.MODE_POWER_SAVE === powerMode) ||
      (power.DevicePowerMode.MODE_EXTREME_POWER_SAVE === powerMode);
  }

  /**
   * 获取文件夹是否是纯色模式配置项
   *
   * @returns 是否文件夹是纯色模式配置项
   */
  public isFolderSolidColor(): boolean {
    return this.isFeatureParamTrue(VisualEffectConstants.FOLDER_SOLID_COLOR_DISABLE);
  }

  /**
   * 订阅热档位变化时的回调提醒,重试三次
   */
  private thermalLevelChange(): void {
    let retries = 0;
    // 辅助函数，用于尝试注册回调
    const attemptRegister = (): void => {
      try {
        this.registerThermalLevel();
      } catch (err) {
        // 如果捕获到错误，并且没有达到最大重试次数，则安排下一次重试
        if (retries < MAX_RETRIES) {
          retries++;
          log.showError(`Register thermal level callback failed, err: ${err.message}. Retrying...`);
          // 安排下一次重试
          setTimeout(attemptRegister, DELAY);
        } else {
          // 如果达到最大重试次数，则记录最终错误
          log.showError(`Failed to register thermal level callback after ${MAX_RETRIES} attempts.`);
        }
      }
    };
    // 开始注册过程
    attemptRegister();
  }

  /**
   * 订阅热档位变化时的回调提醒
   */
  private registerThermalLevel(): void {
    thermal.registerThermalLevelCallback((level: thermal.ThermalLevel) => {
      log.showInfo(`thermal level is: ${level}`);
      this.visualEffectCallback(ListenerType.TEMPERATURE, level);
    });
    log.showInfo('register thermal level callback completed');
  }

  private visualEffectCallback(listenerType: ListenerType, level?: number, powerMode?: number): void {
    if (!this.visualEffectListenerMap.has(listenerType)) {
      return;
    }
    if (!level) {
      level = thermal.getLevel();
    }
    if (!powerMode) {
      powerMode = power.getPowerMode();
    }
    const featureData: VisualFeatureData = {
      level: level,
      powerMode: powerMode
    };
    const innerMap = this.visualEffectListenerMap.get(listenerType);
    innerMap?.forEach((callback: VisualEffectListener) => {
      if (callback && typeof callback.notifyAnimationPolicyUpdate === 'function') {
        callback?.notifyAnimationPolicyUpdate(featureData);
      }
    });
  }

  /**
   * 注册视效参数变化
   *
   * @param listenerTypes 监听类型
   * @param key 监听标识
   * @param callback 视效回调函数
   */
  public registerVisualEffectLevelChange(listenerTypes: ListenerType[], key: string,
    callback: VisualEffectListener): void {
    if (ArrayUtils.isEmpty(listenerTypes)) {
      log.showError('Invalid types:Types must be non-empty array.');
      return;
    }
    if (CheckEmptyUtils.isEmpty(key)) {
      log.showError('Invalid key:Key must be a non-empty string');
      return;
    }
    log.showInfo(`register key: ${key},type:${JSON.stringify(listenerTypes)}`);
    listenerTypes.forEach(listenerType => {
      if (this.visualEffectListenerMap.has(listenerType)) {
        const innerMap = this.visualEffectListenerMap.get(listenerType);
        innerMap?.set(key, callback);
      } else {
        const innerMap = new Map<string, VisualEffectListener>();
        innerMap?.set(key, callback);
        this.visualEffectListenerMap.set(listenerType, innerMap);
      }
    });
  }

  /**
   * 注销视效参数变化
   *
   * @param listenerTypes 监听类型
   * @param key 注销标识
   */
  public unregisterVisualEffectLevelChange(listenerTypes: ListenerType[], key: string): void {
    if (ArrayUtils.isEmpty(listenerTypes)) {
      log.showError('Invalid types:Types must be non-empty array.');
      return;
    }
    if (!key) {
      log.showError('Invalid key:Key must be a non-empty string');
      return;
    }
    listenerTypes.forEach((listenerType: ListenerType) => {
      if (!this.visualEffectListenerMap.has(listenerType)) {
        return;
      }
      const innerMap = this.visualEffectListenerMap.get(listenerType);
      if (!innerMap?.has(key)) {
        return;
      }
      innerMap?.delete(key);
      if (innerMap?.size === 0) {
        this.visualEffectListenerMap.delete(listenerType);
      }
    });
  }

  /**
   * dump输出视效参数
   *
   * @param args 传入参数
   * @returns 展示的字串
   */
  private onFeatureParamsDump(args?: string[]): string {
    let responseText = 'SCBVisualEffectManager dump enter \n';
    responseText += '  -- featureParamsMap: \n';
    this.visualConfigs.forEach(visualConfig => {
      visualConfig.featureParamsMap?.forEach((value, key) => {
        responseText += `  -- key: ${key}, value: ${value} ` + '\n';
      });
    })
    return responseText;
  }
}

// 单例
export let SCBVisualEffectMgr: SCBVisualEffectManager = SingletonHelper.getInstance(SCBVisualEffectManager, TAG);