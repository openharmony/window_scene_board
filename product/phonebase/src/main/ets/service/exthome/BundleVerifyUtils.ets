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

import rpc from '@ohos.rpc';
import bundleManager from '@ohos.bundle.bundleManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'BundleVerifyUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const DEFAULT_USER_ID: number = 100;

/**
 * bundle认证工具类
 *
 * @since 2024-04-19
 */
export class BundleVerifyUtils {
  /**
   * 系统应用认证
   *
   * @param bundleName
   * @returns boolean
   */
  public static isSystemApp(bundleName: string): boolean {
    let applicationFlags: number = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
    try {
      let applicationInfo = bundleManager.getApplicationInfoSync(bundleName, applicationFlags,
        BundleVerifyUtils.getCurrentUserId());
      if (applicationInfo && applicationInfo.systemApp) {
        return true;
      }
    } catch (error) {
      log.error('call isSystemApp error', error);
    }
    return false;
  }

  /**
   * 访问权限认证
   *
   * @param bundleName
   * @param permission 权限编码
   * @returns boolean
   */
  public static hasPermission(bundleName: string, permission: string): boolean {
    let bundleFlags: number = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION;
    try {
      let bundleInfo = bundleManager.getBundleInfoSync(bundleName, bundleFlags, BundleVerifyUtils.getCurrentUserId());
      if (!bundleInfo || !bundleInfo.reqPermissionDetails || bundleInfo.reqPermissionDetails.length === 0) {
        return false;
      }
      for (const permissionDetail of bundleInfo.reqPermissionDetails) {
        if (permissionDetail.name === permission) {
          return true;
        }
      }
    } catch (error) {
      log.error('call hasPermission error', error);
    }
    return false;
  }

  /**
   * 获取bundleName
   *
   * @returns bundleName
   */
  public static getBundleName(): string {
    let bundleName: string = '';
    try {
      let callUid: number = rpc.IPCSkeleton.getCallingUid();
      bundleName = bundleManager.getBundleNameByUidSync(callUid);
    } catch (error) {
      log.error('call getBundleName error', error);
    }
    return bundleName;
  }

  private static getCurrentUserId(): number {
    let currentUserId: number | undefined = AppStorage.get<number>('mCurrentUserId');
    if (!currentUserId) {
      currentUserId = DEFAULT_USER_ID;
    }
    return currentUserId;
  }
}