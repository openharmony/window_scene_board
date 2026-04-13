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

import configPolicy from '@ohos.configPolicy';
import fs from '@ohos.file.fs';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SysTypeCode } from '@ohos/systemuicommon';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG = 'CcmConfigHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const MAX_APP_LOCK_PATH_NUM: number = 500;

// ccm配置项，沉浸锁屏V2开关
const IS_IMM_KG_V2: string = 'persist.screenlock.immkg_v2';

// 应用锁CCM配置回调
export interface AppLockConfigListener {
  /**
   * 应用锁通用通知配置表
   *
   * @param comConfig 配置表集(应用包名)
   */
  onAppLockComConfigChange(comConfig: Set<string>): void;

  /**
   * 应用锁实况通知配置表
   *
   * @param liveConfig 配置表集(应用包名_系统实况类型)
   */
  onAppLockLiveConfigChange(liveConfig: Set<string>): void;
}

/**
 * CCM配置读取类
 */
export class CcmConfigHelper {
  private static instance: CcmConfigHelper;

  // 应用锁配置监听
  private appLockListeners: Set<AppLockConfigListener> = new Set();

  private appLockNormalNtfConfigSet: Set<string> = new Set();

  private appLockLiveNtfConfigSet: Set<string> = new Set();

  // 沉浸锁屏V2开关
  private _isImmKgV2?: boolean;

  public static getInstance(): CcmConfigHelper {
    if (CcmConfigHelper.instance == null) {
      CcmConfigHelper.instance = new CcmConfigHelper();
    }
    return CcmConfigHelper.instance;
  }

  private constructor() {
  }

  /**
   * 沉浸锁屏V2开关是否开启
   *
   * @returns true开启
   */
  public isImmKgV2Enable(): boolean {
    if (this._isImmKgV2 === undefined) {
      try {
        this._isImmKgV2 = systemParameterEnhance.getSync(IS_IMM_KG_V2, 'false') === 'true';
      } catch (e) {
        log.showError('isImmKgV2Enable get enable fail.');
      }
    }
    return this._isImmKgV2 ?? false;
  }

  /**
   * 注册应用锁配置监听
   *
   * @param li 监听器
   */
  public registerAppLockListener(li: AppLockConfigListener): void {
    if (li) {
      this.appLockListeners.add(li);
      // 初始化回调
      li.onAppLockComConfigChange(this.appLockNormalNtfConfigSet);
      li.onAppLockLiveConfigChange(this.appLockLiveNtfConfigSet);
    }
  }

  /**
   * 注销应用锁配置监听
   *
   * @param li 监听器
   */
  public unregisterAppLockListener(li: AppLockConfigListener): void {
    if (li) {
      this.appLockListeners.delete(li);
    }
  }

  /**
   * 初始化
   */
  public async init(): Promise<void> {
    log.showInfo('CcmConfigHelper init');
    await this.loadAppLockExemptLiveNtf();
  }

  /**
   * 去初始化
   */
  public releaseData(): void {
    log.showInfo('CcmConfigHelper releaseData');
    this.appLockLiveNtfConfigSet.clear();
    this.appLockNormalNtfConfigSet.clear();
    // 状态回调
    this.appLockListeners.forEach((li) => li?.onAppLockComConfigChange(this.appLockNormalNtfConfigSet));
    this.appLockListeners.forEach((li) => li?.onAppLockLiveConfigChange(this.appLockLiveNtfConfigSet));
  }

  /**
   * 判断实况通知是否豁免
   *
   * @param bundleName 包名
   * @param sysTypeCode 实况type
   * @returns true 豁免, false未豁免
   */
  public isExemptLiveNtf(bundleName: string, sysTypeCode?: SysTypeCode): boolean {
    let entryTag: string = `${bundleName}_${sysTypeCode}`;
    return this.appLockLiveNtfConfigSet.has(entryTag);
  }

  /**
   * 判断普通通知是否豁免
   *
   * @param bundleName 包名
   * @returns true 豁免, false未豁免
   */
  public isExemptNormalNtf(bundleName: string): boolean {
    return this.appLockNormalNtfConfigSet.has(bundleName);
  }

  /**
   * 加载所有的应用锁实况通知配置项
   *
   * @returns void
   */
  public async loadAppLockExemptLiveNtf(): Promise<void> {
    // 获取所有优先级的配置文件path, 优先级从低到高
    let appLockConfigPaths: string[] = [];
    try {
      appLockConfigPaths = await configPolicy.getCfgFiles('etc/lock_screen/ntf_app_lock_config.json');
    } catch (err) {
      log.showError(`get appLockConfigPaths failed: code: ${err?.code}`);
    }
    if (CommonUtils.containerIsEmpty(appLockConfigPaths) || appLockConfigPaths.length > MAX_APP_LOCK_PATH_NUM) {
      log.showWarn('not get any appLockConfigPaths');
      return;
    }
    // 读取所有优先级的配置文件内容
    let configMap: Map<number, AppLockExemptLiveNtfConfig[]> = await this.readCcmConfigPath(appLockConfigPaths);
    // 按照优先级合并配置文件
    let configs: AppLockExemptLiveNtfConfig[] = this.mergeAppLockConfigs(configMap);
    if (CommonUtils.containerIsEmpty(configs)) {
      log.showInfo('load loadAppLockExemptLiveNtf config is empty');
      return;
    }
    // 把配置信息解析到对应的set中
    this.parseConfigs(configs);
  }

  /**
   * 根据CCM配置path读取对应的配置内容
   *
   * @param appLockConfigPaths CCM配置path数组
   * @returns
   */
  private async readCcmConfigPath(appLockConfigPaths: string[]): Promise<Map<number, AppLockExemptLiveNtfConfig[]>> {
    let configMap: Map<number, AppLockExemptLiveNtfConfig[]> = new Map();
    for (let i = 0; i < appLockConfigPaths.length; i++) {
      let appLockConfig: AppLockExemptLiveNtfConfig[] = [];
      try {
        appLockConfig = JSON.parse(await fs.readText(appLockConfigPaths[i])) as AppLockExemptLiveNtfConfig[];
      } catch (err) {
        log.showError(`read appLockConfig failed: code: ${err?.code}`);
      }
      if (CommonUtils.containerIsEmpty(appLockConfig)) {
        log.showWarn('read empty configs');
        continue;
      }
      configMap.set(i, appLockConfig);
    }
    return configMap;
  }

  private parseConfigs(configs: AppLockExemptLiveNtfConfig[]): void {
    this.appLockNormalNtfConfigSet.clear();
    this.appLockLiveNtfConfigSet.clear();
    configs.forEach(item => {
      if (this.isLockExemptConfigInvalid(item)) {
        log.showWarn('current config is undefined');
        return;
      }
      if (item.isLiveType) {
        this.appLockLiveNtfConfigSet.add(`${item?.bundleName}_${item?.typeCode}`);
      } else {
        this.appLockNormalNtfConfigSet.add(item?.bundleName);
      }
    });
    // 状态回调
    this.appLockListeners.forEach((li) => li?.onAppLockComConfigChange(this.appLockNormalNtfConfigSet));
    this.appLockListeners.forEach((li) => li?.onAppLockLiveConfigChange(this.appLockLiveNtfConfigSet));
  }

  /**
   * 按照优先级合并配置文件, 高优先覆盖底优先
   *
   * @param configMap key: 优先级, 数字越大优先级越高; value: 配置内容
   * @returns 合并结果
   */
  private mergeAppLockConfigs(configMap: Map<number, AppLockExemptLiveNtfConfig[]>): AppLockExemptLiveNtfConfig[] {
    let resultConfigs: AppLockExemptLiveNtfConfig[] = [];
    let mapSize: number = configMap.size;
    for (let i = 0; i < mapSize; i++) {
      const config: AppLockExemptLiveNtfConfig[] | undefined = configMap.get(i);
      if (config === undefined || CommonUtils.containerIsEmpty(config)) {
        log.showWarn('mergeAppLockConfigs get empty config');
        continue;
      }
      this.mergeConfigs(resultConfigs, config);
    }
    return resultConfigs;
  }

  private mergeConfigs(result: AppLockExemptLiveNtfConfig[], ntfConfig: AppLockExemptLiveNtfConfig[]): void {
    for (let index = 0; index < ntfConfig.length; index++) {
      if (index < result.length) {
        result[index] = ntfConfig[index];
      } else {
        result.push(ntfConfig[index]);
      }
    }
  }

  /**
   * 校验数据是否是无效的
   *
   * @param item 读取到的配置
   * @returns boolean
   */
  private isLockExemptConfigInvalid(item: AppLockExemptLiveNtfConfig | undefined): boolean {
    return !item || !item?.bundleName || item?.isLiveType === undefined || item?.isLiveType === null ||
      typeof item?.isLiveType !== 'boolean';
  }

}

export class AppLockExemptLiveNtfConfig {
  public bundleName: string;
  public isLiveType: boolean;
  public typeCode: number;

  constructor(bundleName: string, isLiveType: boolean, typeCode: number) {
    this.bundleName = bundleName;
    this.isLiveType = isLiveType;
    this.typeCode = typeCode;
  }
}