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
import { JSON } from '@kit.ArkTS';
import { CheckEmptyUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
// @ts-ignore
// import hagServiceability from '@ohos.atomicservicedistribution.hagCore';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { BusinessError } from '@kit.BasicServicesKit';
import dataPreferences from '@ohos.data.preferences';

const TAG = 'ASCFWindowManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const SCB_VISUAL_EFFECTS_CONFIG_FILE_PATH = 'etc/scb_effect_config/ascf_param_config.json';
const ASCF_WINDOWMODE: string = 'ascf_Windowmode';
const ASCF_WINDOWMODE_PREFERENCE = 'ascfWindowmodePreference';

export enum WindowMode {
  FLOATINGWINDOW = 0,
  COMPATIBLE_FULLSCREEN = 1,
  SPREAD_FULLSCREEN = 2
}

export interface AtomicserviceInfo {
  bundleName: string;
  modle: number;
}

interface AtomicServiceInfoParam {
  resizable: number;
  deviceTypes: string[];
  supportWindowMode: string[];
}

export interface AtomicserviceInfoSaModel {
  bundleName: string;
  moduleName: string;
  abilityName: string;
  appName: string;
  deviceTypes?: string[];
  resizable?: number;
  supportWindowMode?: string[];
}

export interface QueryAtomicServiceInfoOption {
  iconType: number;
}

interface QueryAtomicServiceInfoResp {
  errorCode: number;
  atomicServiceInfo: AtomicserviceInfoSaModel;
}

/**
 * SCBVisualEffectManager
 *
 */
export class ASCFWindowManager {
  private bundleNameParamsMap: HashMap<string, number> = new HashMap();
  private atomicserviceInfoMode: AtomicserviceInfoSaModel;
  private preference?: dataPreferences.Preferences;

  public async init(): Promise<void> {
    log.showInfo('init');
    this.loadASCFWindowManagerConfigs();
  }

  private async loadASCFWindowManagerConfigs(): Promise<void> {
    log.showInfo('loadASCFWindowManagerConfigs');
    try {
      let configFile: string | undefined = await configPolicy.getOneCfgFile(SCB_VISUAL_EFFECTS_CONFIG_FILE_PATH);
      if (!configFile) {
        log.showWarn('Can not find effect json path');
        return;
      }
      const effectJsonText: string = fs.readTextSync(configFile);
      if (!effectJsonText) {
        log.showWarn('effectJsonText is empty');
        return;
      }
      const bundleInfos: AtomicserviceInfo[] = JSON.parse(effectJsonText) as AtomicserviceInfo[];
      this.bundleNameParamsMap.clear();
      bundleInfos.forEach(bundle => {
        let key = bundle.bundleName;
        let value = bundle.modle;
        this.bundleNameParamsMap.set(key, value);
      });
    } catch (err) {
      log.showError(`Error on load effects file, error ${err.message}`);
    }
  }

  /**
   * 根据bundleName获取窗口模式
   * @param bundleName
   * @returns
   */
  public async queryWindowMode(bundleName: string): Promise<WindowMode | undefined> {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showInfo('bundleName is empty');
      return Promise.resolve(undefined);
    }
    if (this.bundleNameParamsMap.hasKey(bundleName)) {
      if (this.bundleNameParamsMap.get(bundleName) === WindowMode.FLOATINGWINDOW) {
        return Promise.resolve(WindowMode.FLOATINGWINDOW);
      } else if (this.bundleNameParamsMap.get(bundleName) === WindowMode.COMPATIBLE_FULLSCREEN) {
        return Promise.resolve(WindowMode.COMPATIBLE_FULLSCREEN);
      }
    }

    let atomicserviceInfoList = this.getAtomicserviceInfoList();
    atomicserviceInfoList = atomicserviceInfoList.filter(item => item.bundleName === bundleName);
    if (atomicserviceInfoList.length !== 0) {
      log.showInfo(`queryWindowMode use cache`);
      this.atomicserviceInfoMode = atomicserviceInfoList[0] as AtomicserviceInfoSaModel;
    } else {
      await this.getAtomicserviceInfo(bundleName);
    }
    log.showInfo(`resizable: ${this.atomicserviceInfoMode.resizable}` +
      `, supportWindowMode: ${this.atomicserviceInfoMode.supportWindowMode}` +
      `, deviceTypes: ${this.atomicserviceInfoMode.deviceTypes}`);
    if (this.atomicserviceInfoMode.resizable === 0 ||
      (this.atomicserviceInfoMode.resizable === 1 &&
      this.atomicserviceInfoMode.deviceTypes.includes(DeviceHelper.DEVICE_TYPE))) {
      return Promise.resolve(WindowMode.SPREAD_FULLSCREEN);
    }
    if (this.atomicserviceInfoMode.supportWindowMode.includes('floating')) {
      return Promise.resolve(WindowMode.FLOATINGWINDOW);
    } else if (this.atomicserviceInfoMode.resizable === 1) {
      return Promise.resolve(WindowMode.SPREAD_FULLSCREEN);
    } else {
      return Promise.resolve(WindowMode.COMPATIBLE_FULLSCREEN);
    }
  }

  public queryWindowModeSync(bundleName: string,
    atomicServiceInfoParam: AtomicServiceInfoParam): WindowMode | undefined {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showInfo('bundleName is empty');
      return undefined;
    }
    if (this.bundleNameParamsMap.hasKey(bundleName)) {
      if (this.bundleNameParamsMap.get(bundleName) === WindowMode.FLOATINGWINDOW) {
        return WindowMode.FLOATINGWINDOW;
      } else if (this.bundleNameParamsMap.get(bundleName) === WindowMode.COMPATIBLE_FULLSCREEN) {
        return WindowMode.COMPATIBLE_FULLSCREEN;
      }
    }
    if (atomicServiceInfoParam.resizable === undefined) {
      atomicServiceInfoParam.resizable = 0;
    }
    if (atomicServiceInfoParam.supportWindowMode === undefined) {
      atomicServiceInfoParam.supportWindowMode = [];
    }
    if (atomicServiceInfoParam.deviceTypes === undefined) {
      atomicServiceInfoParam.deviceTypes = [];
    }
    log.showInfo(`resizable: ${atomicServiceInfoParam.resizable}` +
      `, supportWindowMode: ${atomicServiceInfoParam.supportWindowMode}` +
      `, deviceTypes: ${atomicServiceInfoParam.deviceTypes}`);
    if (atomicServiceInfoParam.resizable === 0 ||
      (atomicServiceInfoParam.resizable === 1 &&
      atomicServiceInfoParam.deviceTypes.includes(DeviceHelper.DEVICE_TYPE))) {
      return WindowMode.SPREAD_FULLSCREEN;
    }
    if (atomicServiceInfoParam.supportWindowMode.includes('floating')) {
      return WindowMode.FLOATINGWINDOW;
    } else if (atomicServiceInfoParam.resizable === 1) {
      return WindowMode.SPREAD_FULLSCREEN;
    } else {
      return WindowMode.COMPATIBLE_FULLSCREEN;
    }
  }


  /**
   * 根据bundleName获取全屏兼容模式
   * @param bundleName
   * @returns
   */
  public async queryFullScreenMode(bundleName: string): Promise<WindowMode | undefined> {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn('bundleName is empty');
      return Promise.resolve(undefined);
    }
    if (this.bundleNameParamsMap.hasKey(bundleName)) {
      if (this.bundleNameParamsMap.get(bundleName) === WindowMode.COMPATIBLE_FULLSCREEN) {
        return Promise.resolve(WindowMode.COMPATIBLE_FULLSCREEN);
      }
    }
    let atomicserviceInfoList = this.getAtomicserviceInfoList();
    atomicserviceInfoList = atomicserviceInfoList.filter(item => item.bundleName === bundleName);
    if (atomicserviceInfoList.length !== 0) {
      log.showInfo(`queryFullScreenMode use cache`);
      this.atomicserviceInfoMode = atomicserviceInfoList[0] as AtomicserviceInfoSaModel;
    } else {
      await this.getAtomicserviceInfo(bundleName);
    }
    log.showInfo(`resizable: ${this.atomicserviceInfoMode.resizable}` +
      `, supportWindowMode: ${this.atomicserviceInfoMode.supportWindowMode}` +
      `, deviceTypes: ${this.atomicserviceInfoMode.deviceTypes}`);
    if (this.atomicserviceInfoMode.resizable === 0) {
      return Promise.resolve(WindowMode.SPREAD_FULLSCREEN);
    } else if (this.atomicserviceInfoMode.resizable === 1 &&
    this.atomicserviceInfoMode.deviceTypes.includes(DeviceHelper.DEVICE_TYPE)) {
      return Promise.resolve(WindowMode.SPREAD_FULLSCREEN);
    } else {
      return Promise.resolve(WindowMode.COMPATIBLE_FULLSCREEN);
    }
  }

  public queryFullScreenModeSync(bundleName: string,
    atomicServiceInfoParam: AtomicServiceInfoParam): WindowMode | undefined {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn('bundleName is empty');
      return undefined;
    }
    if (this.bundleNameParamsMap.hasKey(bundleName)) {
      if (this.bundleNameParamsMap.get(bundleName) === WindowMode.COMPATIBLE_FULLSCREEN) {
        return WindowMode.COMPATIBLE_FULLSCREEN;
      }
    }
    if (atomicServiceInfoParam.resizable === undefined) {
      atomicServiceInfoParam.resizable = 0;
    }
    if (atomicServiceInfoParam.supportWindowMode === undefined) {
      atomicServiceInfoParam.supportWindowMode = [];
    }
    if (atomicServiceInfoParam.deviceTypes === undefined) {
      atomicServiceInfoParam.deviceTypes = [];
    }
    log.showInfo(`resizable: ${atomicServiceInfoParam.resizable}` +
      `, supportWindowMode: ${atomicServiceInfoParam.supportWindowMode}` +
      `, deviceTypes: ${atomicServiceInfoParam.deviceTypes}`);
    if (atomicServiceInfoParam.resizable === 0) {
      return WindowMode.SPREAD_FULLSCREEN;
    } else if (atomicServiceInfoParam.resizable === 1 &&
    atomicServiceInfoParam.deviceTypes.includes(DeviceHelper.DEVICE_TYPE)) {
      return WindowMode.SPREAD_FULLSCREEN;
    } else {
      return WindowMode.COMPATIBLE_FULLSCREEN;
    }
  }

  private async getAtomicserviceInfo(bundleName: string): Promise<void> {
    this.atomicserviceInfoMode = await this.queryAtomicServiceInfo(bundleName);
    if (this.atomicserviceInfoMode.resizable === undefined) {
      this.atomicserviceInfoMode.resizable = 0;
    }
    if (this.atomicserviceInfoMode.supportWindowMode === undefined) {
      this.atomicserviceInfoMode.supportWindowMode = [];
    }
    if (this.atomicserviceInfoMode.deviceTypes === undefined) {
      this.atomicserviceInfoMode.deviceTypes = [];
    }
  }

  private async queryAtomicServiceInfo(bundleName: string): Promise<AtomicserviceInfoSaModel> {
    try {
      let option: QueryAtomicServiceInfoOption = {
        iconType: 0
      }
      /*let data = await hagServiceability.queryAtomicServiceInfo(bundleName, option);
      let queryAtomicServiceInfoResp = JSON.parse(JSON.stringify(data)) as QueryAtomicServiceInfoResp;
      return Promise.resolve(queryAtomicServiceInfoResp.atomicServiceInfo);*/
      return Promise.resolve(this.atomicserviceInfoMode);
    } catch (e) {
      log.error(`queryAtomicServiceInfo from SA failed, errCode:${e?.code},errMsg:${e?.message}`);
      return Promise.resolve(this.atomicserviceInfoMode);
    }
  }

  initPreference(): void {
    log.showInfo(`initPreference`);
    try {
      let context = GlobalContext.getContext();
      if (context) {
        this.preference = dataPreferences.getPreferencesSync(context, {
          name: ASCF_WINDOWMODE_PREFERENCE
        });
      }
    } catch (err) {
      log.showError(`getPreferencesSync error, BusinessError code is ${(err as BusinessError).code}`);
    }
  }

  public getAtomicserviceInfoList(): AtomicserviceInfoSaModel[] {
    let atomicserviceInfoList = [];
    if (this.preference?.hasSync(ASCF_WINDOWMODE)) {
      atomicserviceInfoList = this.preference?.getSync(ASCF_WINDOWMODE, []) as AtomicserviceInfoSaModel[];
      return atomicserviceInfoList;
    }
    return atomicserviceInfoList;
  }

  /**
   * updateWindowModePreference
   *
   * @param bundleName
   */
  pubilc

  async updateWindowModePreference(bundleName: string): Promise<void> {
    let atomicserviceInfoList = this.getAtomicserviceInfoList();
    log.showInfo(`updateWindowModePreference: ${atomicserviceInfoList.length}`);
    atomicserviceInfoList = atomicserviceInfoList?.filter(item => item.bundleName !== bundleName);
    let atomicserviceInfoMode = await this.queryAtomicServiceInfo(bundleName);
    if (atomicserviceInfoMode.resizable === undefined) {
      atomicserviceInfoMode.resizable = 0;
    }
    if (atomicserviceInfoMode.supportWindowMode === undefined) {
      atomicserviceInfoMode.supportWindowMode = [];
    }
    if (atomicserviceInfoMode.deviceTypes === undefined) {
      atomicserviceInfoMode.deviceTypes = [];
    }
    let option: AtomicserviceInfoSaModel = {
      bundleName: bundleName,
      moduleName: atomicserviceInfoMode.moduleName,
      abilityName: atomicserviceInfoMode.abilityName,
      appName: atomicserviceInfoMode.appName,
      deviceTypes: atomicserviceInfoMode.deviceTypes,
      resizable: atomicserviceInfoMode.resizable,
      supportWindowMode: atomicserviceInfoMode.supportWindowMode
    }
    atomicserviceInfoList.push(option);
    log.showInfo(`atomicserviceInfoList: ${atomicserviceInfoList.length}`);
    this.syncPreferencesCache();
    this.preference?.putSync(ASCF_WINDOWMODE, atomicserviceInfoList);
    this.preference?.flush();
  }

  /**
   * 同步文件中的数据到内存中
   */
  private syncPreferencesCache(): void {
    let context = GlobalContext.getContext();
    if (context) {
      dataPreferences.removePreferencesFromCacheSync(context, {
        name: ASCF_WINDOWMODE_PREFERENCE
      });
      try {
        this.preference = dataPreferences.getPreferencesSync(context, {
          name: ASCF_WINDOWMODE_PREFERENCE
        });
      } catch (err) {
        log.showError(`getPreferencesSync error: ${err.code}, ${err.message}`);
      }
    }
  }
}

// 单例
export let ASCFWindowMgr: ASCFWindowManager = SingletonHelper.getInstance(ASCFWindowManager, TAG);