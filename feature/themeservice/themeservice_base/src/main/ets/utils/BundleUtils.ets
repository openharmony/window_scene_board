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
import { bundleManager } from '@kit.AbilityKit';
import { TsLog } from '../log/TsLog';
import { Nullable } from './Types';

const TAG: string = 'BundleUtils';

/**
 * bundle工具类
 */
export class BundleUtils {
  /**
   * 根据uid获取bundleName
   * @param uid uid
   * @returns bundleName
   */
  public static async getBundleNameByUid(uid: number): Promise<Nullable<string>> {
    try {
      return await bundleManager.getBundleNameByUid(uid);
    } catch (error) {
      TsLog.error(TAG, `getBundleNameByUid(${uid}) catch exception.`, error);
    }
    return undefined;
  }

  public static async getBundleSignature(bundleName: string): Promise<Nullable<bundleManager.SignatureInfo>> {
    try {
      let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfo(bundleName, bundleManager.BundleFlag
        .GET_BUNDLE_INFO_WITH_SIGNATURE_INFO);
      return bundleInfo?.signatureInfo;
    } catch (err) {
      TsLog.error(TAG, `getBundleSignature catch exception.`, err);
    }
    return undefined;
  }
}