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

import { abilityAccessCtrl, bundleManager, Permissions } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { IExecutor } from '../BaseServiceStub';
import TrustListOobeManager, { TrustInfo, AddTrustListResult } from '../../trustlist/TrustListOobeManager';

const TAG: string = 'AddOobeTrustList';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 添加OOBE可拉起应用白名单
 */
export class AddOobeTrustList implements IExecutor {

  /**
   * 拥有调用该接口权限的应用
   */
  protected static readonly PERMISSION_BUNDLE: string[] = [
    'com.ohos.adminprovisioning'
  ];

  /**
   * 添加OOBE信任应用列表执行器
   * @param extra 接口入参数据, 需要是TrustInfo[]类型
   * @returns 执行结果字符串
   */
  async execute(extra?: TrustInfo[]): Promise<string> {
    const permission: boolean = await this.checkAuth();
    if (!permission) {
      log.error('No permission');
      return JSON.stringify(AddTrustListResult.FAILED_INVALID_CALLER);
    }
    if (!extra || !this.isTrustInfoList(extra)) {
      log.error('Invalid extra');
      return JSON.stringify(AddTrustListResult.FAILED_INVALID_LIST);
    }
    const trustList = extra;
    const code = TrustListOobeManager.addTrustList(trustList);
    log.info(`Result ${code}`);
    return JSON.stringify(code);
  }

  /**
   * 确认接口调用方式是否满足权限要求: bundleName在PERMISSION_BUNDLE内 && 拥有权限ohos.permission.ENTERPRISE_CONFIG
   * @returns true: 满足权限检查条件; false: 不满足权限条件
   */
  protected async checkAuth(): Promise<boolean> {
    try {
      const callerUid = rpc.IPCSkeleton.getCallingUid();
      const callerName = await bundleManager.getBundleNameByUid(callerUid);
      log.info(`Caller name: ${callerName}`);
      let isAllowBundle: boolean = false;
      for (const bundleName of AddOobeTrustList.PERMISSION_BUNDLE) {
        if (callerName === bundleName) {
          isAllowBundle = true;
          break;
        }
      }
      if (!isAllowBundle) {
        log.error('Caller not allowed');
        return false;
      }
      const callerTokenId = rpc.IPCSkeleton.getCallingTokenId();
      const accessManager = abilityAccessCtrl.createAtManager();
      const grantStatus =
        accessManager.verifyAccessTokenSync(callerTokenId,
          'ohos.permission.ACCESS_TRUST_LIST_OOBE_MANAGER' as Permissions);
      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        log.error('Permission DENIED');
        return false;
      }
      log.info('Permission PASS');
      return true;
    } catch (error) {
      log.error(`Check auth failed, Code: ${error?.code}, msg: ${error?.message}`);
      return false;
    }
  }

  /**
   * 运行时类型守卫检查是否为TrustInfo[]
   * @param input 待检查输入
   * @returns true: 输入为TrustInfo[]类型
   */
  protected isTrustInfoList(input: TrustInfo[]): boolean {
    return input !== null && typeof input === 'object' && Array.isArray(input) && input.every((value) => {
      return typeof value === 'object' &&
        typeof value.bundleName === 'string' &&
        typeof value.moduleName === 'string' &&
        typeof value.abilityName === 'string';
    });
  }
}