/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import taskpool from '@ohos.taskpool';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import type Want from '@ohos.app.ability.Want';
import { EvtBus } from '../eventbus/EventBus';
import { AccountEvent } from '../eventbus/events/Events';
import { BusinessError } from '@ohos.base';

const TAG = 'CommonBundleManager';
const DEFAULT_USER_ID = 100;
const INVALID_ID: number = -1;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 通用包管理（可以查询桌面包、原子化服务包）
 */
class CommonBundleManager {
  private static mInstance: CommonBundleManager;
  private mUserId: number = DEFAULT_USER_ID;

  constructor() {
    EvtBus.on(AccountEvent, (event) => this.setCurrentUserID(event?.accountInfo?.localId || DEFAULT_USER_ID));
  }

  /**
   * 获取通用包管理对象
   *
   * @return 通用包管理对象单一实例
   */
  static getInstance(): CommonBundleManager {
    if (CommonBundleManager.mInstance == null) {
      CommonBundleManager.mInstance = new CommonBundleManager();
      globalThis.CommonBundleManagerInstance = CommonBundleManager.mInstance;
    }
    return CommonBundleManager.mInstance;
  }

  /**
   * 获取userId.
   *
   * @returns
   */
  getUserId(): number {
    return this.mUserId;
  }

  /**
   * 设置userID.
   *
   * @returns
   */
  setCurrentUserID(mUserId: number): void {
    if (mUserId === INVALID_ID) {
      log.showInfo('setCurrentUserId user id err');
      return;
    }
    this.mUserId = mUserId;
  }

  /**
   * 获取所有bundle信息
   *
   * @param bundleType 包类型：bundleManager.BundleType.APP:桌面app,  bundleManager.BundleType.ATOMIC_SERVICE:原子化服务
   * @param bundleFlags 查询信息的类型
   *
   * @returns 所有bundle信息
   */
  async getAllBundleList(bundleType?: bundleManager.BundleType, bundleFlags?: number): Promise<bundleManager.BundleInfo[]> {
    let bundleList: Array<bundleManager.BundleInfo> = [];
    if (!bundleFlags && bundleFlags !== 0) {
      bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;
    }
    try {
      bundleList = await taskpool.execute(getAllBundleInfoTask, bundleFlags, this.mUserId) as bundleManager.BundleInfo[];
    } catch (err) {
      log.error('getAllBundleList bundleManager.getAllBundleInfo error:', err);
    }
    if (CheckEmptyUtils.isEmptyArr(bundleList)) {
      log.showInfo('getAllBundleList Empty');
      return [];
    }
    if (CheckEmptyUtils.isEmpty(bundleType)) {
      return bundleList;
    }
    return bundleList.filter(bundle => bundle.appInfo?.bundleType === bundleType);
  }

  /**
   * 根据bundleName获取包信息
   *
   * @param bundleName 包名
   * @param bundleType 包类型：bundleManager.BundleType.APP:桌面app,  bundleManager.BundleType.ATOMIC_SERVICE:原子化服务
   * @returns 包信息
   */
  private async getBundleInfoByBundleNameWithFlag(bundleName: string, bundleFlags: number,
    bundleType?: bundleManager.BundleType): Promise<bundleManager.BundleInfo | undefined> {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showError('getBundleInfoByBundleName reqParam bundleName is empty');
      return undefined;
    }
    let bundleInfo: bundleManager.BundleInfo = {} as bundleManager.BundleInfo;
    try {
      await bundleManager.getBundleInfo(bundleName,
        bundleFlags,
        this.mUserId)
        .then((res: bundleManager.BundleInfo) => {
          bundleInfo = res;
        })
        .catch((err: BusinessError) => {
          log.error(`bundleName:${bundleName}, getBundleInfoByBundleName error:`, err);
        });
    } catch (err) {
      log.error(`bundleName:${bundleName}, getBundleInfoByBundleName bundleManager.getBundleInfo error:`, err);
    }
    if (CheckEmptyUtils.isEmpty(bundleInfo)) {
      log.showWarn(`getBundleInfoByBundleName res length: 0 bundleName : ${bundleName} bundleType : ${bundleType} `);
      return undefined;
    }
    if (CheckEmptyUtils.isEmpty(bundleType)) {
      return bundleInfo;
    }
    return bundleInfo.appInfo.bundleType === bundleType ? bundleInfo : undefined;
  }

  /**
   * 根据bundleName获取包信息
   *
   * @param bundleName 包名
   * @param bundleType 包类型：bundleManager.BundleType.APP:桌面app,  bundleManager.BundleType.ATOMIC_SERVICE:原子化服务
   * @returns 包信息
   */
  async getBundleInfoByBundleName(bundleName: string, bundleType?: bundleManager.BundleType): Promise<bundleManager.BundleInfo | undefined> {
    let bundleFlags: number = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;
    return this.getBundleInfoByBundleNameWithFlag(bundleName, bundleFlags, bundleType);
  }

  /**
   * 根据bundleName获取包信息(包括禁用的)
   *
   * @param bundleName 包名
   * @param bundleType 包类型：bundleManager.BundleType.APP:桌面app,  bundleManager.BundleType.ATOMIC_SERVICE:原子化服务
   * @returns 包信息
   */
  async getBundleInfoByBundleIncludeDisable(bundleName: string, bundleType?: bundleManager.BundleType): Promise<bundleManager.BundleInfo | undefined> {
    let bundleFlags: number = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_DISABLE;
    return this.getBundleInfoByBundleNameWithFlag(bundleName, bundleFlags, bundleType);
  }

  /**
   * 根据abilityName获取ability信息
   *
   * @param bundleName 包名
   * @param abilityName ability名
   * @param bundleType 包类型：bundleManager.BundleType.APP:桌面app,  bundleManager.BundleType.ATOMIC_SERVICE:原子化服务
   * @returns ability信息
   */
  async getAbilityInfoByAbilityName(bundleName: string, abilityName: string,
    bundleType?: bundleManager.BundleType): Promise<bundleManager.AbilityInfo | undefined> {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName) || CheckEmptyUtils.checkStrIsEmpty(abilityName)) {
      log.showError('getAbilityInfoByAbilityName reqParam bundleName or abilityName is empty');
      return undefined;
    }
    // get from system
    let abilityList = new Array<bundleManager.AbilityInfo>();
    let want: Want = {
      bundleName: bundleName,
      abilityName: abilityName
    };
    try {
      await bundleManager.queryAbilityInfo(want, bundleManager.AbilityFlag.GET_ABILITY_INFO_WITH_APPLICATION, this.mUserId)
        .then((res: Array<bundleManager.AbilityInfo>)=>{
          if (res !== undefined) {
            abilityList = res;
          }
        })
        .catch((err: BusinessError)=>{
          log.error('getAbilityInfoByAbilityName error:', err);
        });
    } catch (err) {
      log.error('getAbilityInfoByAbilityName bundleManager.queryAbilityInfo error:', err);
    }
    if (CheckEmptyUtils.isEmptyArr(abilityList)) {
      log.showWarn(`getAbilityInfoByAbilityName res length: 0 bundleName : ${bundleName} abilityName : ${abilityName} `);
      return undefined;
    }
    if (CheckEmptyUtils.isEmpty(bundleType)) {
      return abilityList[0];
    }
    return abilityList[0].applicationInfo.bundleType === bundleType ? abilityList[0] : undefined;
  }

  async getAbilityInfoOnCurrentUser(bundleName: string, abilityName: string, bundleType?: bundleManager.BundleType,
    abilityFlags?: number): Promise<bundleManager.AbilityInfo | undefined> {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName) || CheckEmptyUtils.checkStrIsEmpty(abilityName)) {
      log.showError('getAbilityInfoOnCurrentUser reqParam bundleName or abilityName is empty');
      return undefined;
    }
    // get from system
    let abilityList = new Array<bundleManager.AbilityInfo>();
    let want: Want = {
      bundleName: bundleName,
      abilityName: abilityName
    };
    let flags = CheckEmptyUtils.isEmpty(abilityFlags) ? bundleManager.AbilityFlag.GET_ABILITY_INFO_WITH_APPLICATION : abilityFlags;
    try {
      await bundleManager.queryAbilityInfo(want, flags)
        .then((res: Array<bundleManager.AbilityInfo>) => {
          if (res !== undefined) {
            abilityList = res;
          }
        })
        .catch((err: BusinessError) => {
          log.error('getAbilityInfoOnCurrentUser error:', err);
        });
    } catch (err) {
      log.error('getAbilityInfoOnCurrentUser bundleManager.queryAbilityInfo error:', err);
    }
    if (CheckEmptyUtils.isEmptyArr(abilityList)) {
      log.showWarn(`getAbilityInfoOnCurrentUser res length: 0 bundleName : ${bundleName} abilityName : ${abilityName} `);
      return undefined;
    }
    if (CheckEmptyUtils.isEmpty(bundleType)) {
      return abilityList[0];
    }
    return abilityList[0].applicationInfo.bundleType === bundleType ? abilityList[0] : undefined;
  }

  async setAbilityEnabledByAbilityName(bundleName: string, abilityName: string, isEnabled: boolean,
    bundleType?: bundleManager.BundleType): Promise<boolean> {
    let flags = bundleManager.AbilityFlag.GET_ABILITY_INFO_WITH_DISABLE;
    let abilityInfo: bundleManager.AbilityInfo | undefined =
      await this.getAbilityInfoOnCurrentUser(bundleName, abilityName,
        bundleType, flags);
    if (CheckEmptyUtils.isEmpty(abilityInfo)) {
      log.showError('setAbilityEnabledByAbilityName failed to get valid abilityInfo');
      return false;
    }
    let result: boolean = false;
    try {
      await bundleManager.setAbilityEnabled(abilityInfo, isEnabled).then(() => {
        result = true;
        log.showInfo(`setAbilityEnabledByAbilityName success with bundleName:${bundleName}, abilityName:${abilityName}`);
      }).catch((err: BusinessError) => {
        log.error('setAbilityEnabledByAbilityName error:', err);
      });
    } catch (err) {
      log.error('setAbilityEnabledByAbilityName bundleManager.setAbilityEnabled error:', err);
    }
    return result;
  }

  /**
   * 设置指定应用的禁用或使能状态
   */
  async setApplicationEnabled(bundleName: string, isEnabled: boolean): Promise<void> {
    try {
      bundleManager.setApplicationEnabled(bundleName, isEnabled).then(() => {
        log.showInfo('setApplicationEnabled successfully');
      }).catch((err: BusinessError) => {
        log.error('setApplicationEnabled failed:', err);
      });
    } catch (err) {
      log.error('setApplicationEnabled error:', err);
    }
  }

  /**
   * 以异步的方法获取指定组件的禁用或使能状态
   */
  async isApplicationEnabled(bundleName: string): Promise<boolean> {
    try {
      bundleManager.isApplicationEnabled(bundleName, (err, data) => {
        if (err) {
          log.error('isApplicationEnabled failed:', err);
          return false;
        } else {
          log.showInfo('isApplicationEnabled successfully');
          return data;
        }
      });
    } catch (err) {
      log.error('isApplicationEnabled error:', err);
    }
    return false;
  }
}
async function getAllBundleInfoTask(flag: number, userId: number) : Promise<bundleManager.BundleInfo[]> {
  'use concurrent';
  const infos = await bundleManager.getAllBundleInfo(flag, userId) as bundleManager.BundleInfo[];
  return infos;
}

const commonBundleManager = CommonBundleManager.getInstance();
export default commonBundleManager;