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
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'BundleVerityUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface BundleVerityData {
  bundleName: string;
  appIdentifier: string;
}

/**
 * 校验数据
 */
const NOTIFICATION_VERITY_BUNDLES: BundleVerityData[] = [
  {
    bundleName: 'com.ohos.ouc',
    appIdentifier: '5765880207853598259',
  },
  {
    bundleName: 'com.ohos.callui',
    appIdentifier: '5765880207853367359',
  },
  {
    bundleName: 'com.ohos.callsetting',
    appIdentifier: '5765880207853200721',
  },
  {
    bundleName: 'com.ohos.meetimeservice',
    appIdentifier: '1171817433862777600',
  },
  {
    bundleName: 'com.ohos.hiviewcare',
    appIdentifier: '1263153796607926656',
  },
  {
    bundleName: 'com.ohos.contacts',
    appIdentifier: '5765880207853624761',
  },
  {
    bundleName: 'com.ohos.hiai',
    appIdentifier: '5765880207854234745',
  },
  {
    bundleName: 'com.ohos.clock',
    appIdentifier: '5765880207853299641',
  },
  {
    bundleName: 'com.ohos.betaclub',
    appIdentifier: '1213064354656704832',
  },
  {
    bundleName: 'com.ohos.migrateclient',
    appIdentifier: '5765880207853762331',
  },
  {
    bundleName: 'com.ohos.instantshare',
    appIdentifier: '5765880207852903673',
  },
  {
    bundleName: 'com.ohos.locationdialog',
    appIdentifier: '5765880207854258395',
  },
  {
    bundleName: 'com.ohos.security.privacycenter',
    appIdentifier: '5765880207852998967',
  },
];

/**
 * 验证 bundleName 和 appIdentifier
 */
export async function bundleVerity(bundleName: string): Promise<boolean> {
  try {
    log.showInfo(`bundleVerity start: ${bundleName}`);
    const bundleInfo = await bundleManager.getBundleInfo(bundleName,
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO);
    const appIdentifier = bundleInfo?.signatureInfo?.appIdentifier;
    log.showInfo(`bundleVerity: ${bundleName} ${appIdentifier}`);

    if (!appIdentifier) {
      return false;
    }
    return NOTIFICATION_VERITY_BUNDLES.some(item => item.bundleName === bundleName &&
      item.appIdentifier === appIdentifier);
  } catch (err) {
    log.error(`bundleVerity failed, code: ${err?.code}, message: ${err?.message}`);
    return false;
  }
}
