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
import { ArgumentMatchers, MockKit, when } from '@ohos/hypium';
import { BundleUtils, CallerInfo, TsLog } from '@ohos/themeservicebase/Index';
import { openharmony_APP, RETAIL_APP } from '../../../main/ets/remote/callee/TrustCallerInfo';
const TAG: string = 'BundleMocker';
export class BundleMocker {
  public static mockRetailApp(): MockKit {
    return BundleMocker.mock(RETAIL_APP);
  }

  public static mockHwApp(): MockKit {
    return BundleMocker.mock(openharmony_APP);
  }

  public static mock(callerInfo: CallerInfo): MockKit {
    TsLog.debug(TAG, `mock ${callerInfo.bundleName}`);
    let mocker: MockKit = new MockKit()
    let getBundleNameByUidFun: Function = mocker.mockFunc(BundleUtils, BundleUtils.getBundleNameByUid)
    when(getBundleNameByUidFun)(ArgumentMatchers.any).afterReturn(Promise.resolve(callerInfo.bundleName));
    let getBundleSignatureFun: Function = mocker.mockFunc(BundleUtils, BundleUtils.getBundleSignature)
    let signatureInfo: bundleManager.SignatureInfo = {
      appId: callerInfo.appId ?? '',
      fingerprint: callerInfo.fingerprint ?? '',
      appIdentifier: callerInfo.appIdentifier ?? ''
    };
    when(getBundleSignatureFun)(ArgumentMatchers.any).afterReturn(Promise.resolve(signatureInfo));
    return mocker;
  }

  public static clear(mocker: MockKit): void {
    TsLog.debug(TAG, `clear`);
    mocker.clear(BundleUtils);
    mocker.clearAll();
  }
}