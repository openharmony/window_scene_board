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

import bundleManager from '@ohos.bundle.bundleManager';

import util from '@ohos.util';
// import HelpsFwk from '@hms.hiviewdfx.helpsfwk';
import { SingletonHelper } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';

const TAG = 'TrustListOobeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CONFIG_FILE = 'oobe_trust.json';
const ADMIN_USERID = 100;

export class TrustListOobeManager {
  private trustlist?: Set<string>;
  private isInit: boolean = false;
  private spaceNumber: number = ADMIN_USERID;

  private static readonly OEM_PRODUCTION_APP_ID: number = 31;

  private static readonly SPLIT_DELIMITER: string = ':';

  /**
   * 检查UIAbility是否在白名单内
   * @param bundleName 应用的bundleName
   * @param abilityName 应用的abilityName
   * @param moduleName 应用的moduleName
   *
   * @return {boolean} true-在白名单内
   */
  public isTrustlistForWms(bundleName: string, moduleName: string, abilityName: string): boolean {
    let res: boolean = false;
    let key: string = '';
    try {
      log.showInfo('isTrustlistForWms bundleName: %{public}s,moduleName: %{public}s,abilityName: %{public}s', bundleName, moduleName, abilityName);
      if (!bundleName || !abilityName) {
        log.showInfo('isTrustlistForWms bundleName is null');
        return false;
      }
      key = `${bundleName}:${moduleName}:${abilityName}`;
      if (!moduleName) {
        key = `${bundleName}::${abilityName}`;
      }
      res = !!this.trustlist?.has(key);
    } catch (error) {
      log.error('isTrustlistForWms error:', error);
      return true;
    }
    log.showWarn('isTrustlistForWms key: %{public}s res: %{public}s', key, res);
    return res;
  }

  /**
   * 初始化白名单列表
   */
  public async initTrustlist(spaceNumber: number): Promise<void> {
    this.spaceNumber = spaceNumber;
    if (this.isInit) {
      log.showInfo('trust list already init');
      return;
    }
    await this.loadConfigTrustlist();
    this.isInit = true;
  }

  /**
   * 添加OOBE信任应用列表
   * @param trustList: 新增的信任应用列表
   * @returns 返回AddTrustListResult中定义结果码: 成功返回SUCCESS; 未初始化返回FAILED_OTHER; 参数异常返回FAILED_INVALID_LIST;
   */
  public addTrustList(trustList: TrustInfo[]): number {
    if (!this.isInit) {
      log.error('addTrustList error: not init');
      return AddTrustListResult.FAILED_OTHER;
    }
    if (!trustList || trustList.length === 0) {
      log.info('addTrustList error: invalid param');
      return AddTrustListResult.FAILED_INVALID_LIST;
    }
    trustList.forEach((info: TrustInfo) => {
      if (!info.bundleName || !info.abilityName) {
        log.warn('addTrustList invalid info');
        return;
      }
      if (!info.moduleName) {
        this.trustlist?.add(`${info.bundleName}::${info.abilityName}`);
        return;
      }
      this.trustlist?.add(`${info.bundleName}:${info.moduleName}:${info.abilityName}`);
    });
    log.info(`addTrustList done, list length: ${this.trustlist?.size}`);
    return AddTrustListResult.SUCCESS;
  }

  private async loadConfigTrustlist(): Promise<void> {
    log.showInfo('loadConfigTrustlist start');
    try {
      let resourceManager = GlobalContext.getContext().resourceManager;
      await resourceManager.getRawFileContent(CONFIG_FILE)
        .then((uint8Data: Uint8Array) => {
          let content = util.TextDecoder.create('utf-8', { ignoreBOM: true })
            .decodeWithStream(uint8Data, { stream: false });
          let trustInfoList = JSON.parse(content) as TrustInfoList;
          log.showInfo(`loadConfigTrustlist trust num: ${trustInfoList?.trustList?.length}`);
          this.initConfigTrustlist(trustInfoList);
        })
        .catch((err: Error) => {
          log.error('loadConfigTrustlist error:', err);
        });
    } catch (e) {
      log.error('loadConfigTrustlist exception:', e);
    }
    // 动态加载生产应用的白名单
    if (DeviceHelper.isPhone() || DeviceHelper.isPad() || DeviceHelper.isPC()) {
      Promise.resolve().then(() => {
        this.loadProAppTrustList();
      });
    }
    log.showInfo(`loadConfigTrustlist end, trust list size: ${this.trustlist?.size}`);
  }

  private initConfigTrustlist(trustInfoList: TrustInfoList): void {
    if (!trustInfoList) {
      log.showWarn('trustInfoList is null');
      return;
    }
    this.trustlist = new Set();
    trustInfoList.trustList.forEach((info: TrustInfo) => {
      if (!info.bundleName || !info.abilityName) {
        log.showWarn('bundleName is null');
        return;
      }
      if (!this.isSystemApp(info.bundleName)) {
        log.warn(`${info.bundleName} is not system app`);
        return;
      }
      if (!info.moduleName) {
        this.trustlist?.add(`${info.bundleName}::${info.abilityName}`);
        return;
      }
      this.trustlist?.add(`${info.bundleName}:${info.moduleName}:${info.abilityName}`);
    });
  }

  /**
   * 从oemInfo读出生产应用信息并加入白名单
   */
  private loadProAppTrustList(): void {
    log.showInfo('loadProAppTrustList method start');
    // try {
    //   if (!this.trustlist) {
    //     this.trustlist = new Set();
    //   }
    //   let result: string = HelpsFwk.getDeviceInfoById(TrustListOobeManager.OEM_PRODUCTION_APP_ID);
    //   HiSysEventUtil.reportReloadProductionApp(result);
    //   log.showInfo(`readProductionAppInfo success, result is ${result}`);
    //   if (result !== '' && result.includes(TrustListOobeManager.SPLIT_DELIMITER)) {
    //     let appInfoArr: string[] = result.split(TrustListOobeManager.SPLIT_DELIMITER);
    //     if (this.isSystemApp(appInfoArr[0])) {
    //       this.trustlist.add(result);
    //     }
    //   }
    // } catch (error) {
    //   log.error('getDeviceInfoById error', error);
    // }
  }

  private isSystemApp(bundleName: string): boolean {
    let applicationFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
    try {
      let applicationInfo = bundleManager.getApplicationInfoSync(bundleName, applicationFlags, this.spaceNumber);
      if (applicationInfo && applicationInfo.systemApp) {
        return true;
      }
    } catch (error) {
      log.error(`${bundleName} call isSystemApp error`, error);
    }
    return false;
  }
}

let sTrustListOobeManager = SingletonHelper.getInstance(TrustListOobeManager, TAG);

export default sTrustListOobeManager as TrustListOobeManager;

/**
 * 白名单类
 */
export class TrustInfo {
  bundleName: string = '';
  moduleName: string = '';
  abilityName: string = '';
}

/**
 * The Bean class, which contains OOBE trust app list
 */
interface TrustInfoList {
  trustList: TrustInfo[]
}

/**
 * OOBE添加信任应用接口返回结果码
 */
export enum AddTrustListResult {
  // 成功
  SUCCESS = 0,
  // 失败: 非法信任应用列表参数
  FAILED_INVALID_LIST = 1,
  // 失败: 非法调用
  FAILED_INVALID_CALLER = 2,
  // 失败: 其他原因
  FAILED_OTHER = -1,
}