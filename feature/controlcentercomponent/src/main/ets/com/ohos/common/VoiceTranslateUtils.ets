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
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'VoiceTranslateUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const MODULE_NAME: string = 'entry';
const SUPPORT_TRANSLATE_AGENT_METADATA_KEY: string = 'isSupportTranslateAgent';
const TRANSLATE_AGENT_URI: string = 'translateAgent://com.ohos.vassistant/agent';
const TRANSLATE_TOOL_URI: string = 'translateTool://com.ohos.vassistant/text';

export class VoiceTranslateUtils {

  // 语音助手翻译包名
  public static readonly BUNDLE_NAME: string = 'com.ohos.vassistant';

  /**
   * 获取不同版本语音助手翻译助手对应的uri链接地址
   */
  public static getTranslateUri(): string {
    if (VoiceTranslateUtils.isSupportTranslateAgent()) {
      log.showInfo(`use translateAgent`);
      return TRANSLATE_AGENT_URI;
    } else {
      log.showInfo(`use translateTool`);
      return TRANSLATE_TOOL_URI;
    }
  }

  private static isSupportTranslateAgent(): boolean {
    let bundleFlags: number = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA |
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
    try {
      let bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoSync(
        VoiceTranslateUtils.BUNDLE_NAME, bundleFlags);
      let isSupportTranslateAgent: string | undefined = bundleInfo?.appInfo?.metadataArray?.find((value) => {
        return value?.moduleName === MODULE_NAME
      })?.metadata?.find((value) => {
        return value?.name === SUPPORT_TRANSLATE_AGENT_METADATA_KEY
      })?.value;

      let isSupport: boolean = (isSupportTranslateAgent !== undefined) && ('true' === isSupportTranslateAgent);
      return isSupport;
    } catch (error) {
      log.showError(`get isSupportTranslateAgent failed with ${error}`);
      return false;
    }
  }
}