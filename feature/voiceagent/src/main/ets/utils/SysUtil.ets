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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import { osAccount } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { i18n } from '@kit.LocalizationKit';

const TAG: string = 'SysUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AA, TAG);

export default class SysUtil {

  /**
   * 销毁UIAbility
   */
  public static terminateSelf(context: common.UIAbilityContext): void {
    if (!context) {
      log.showError(`terminateSelf, context is null`);
      return;
    }
    try {
      log.showInfo('terminateSelf in file:SysUtil>terminateSelf');
      context?.terminateSelf((err: BusinessError) => {
        if (err?.code) {
          log.showError(`terminateSelf, error code: ${err?.code}, message: ${err?.message}`);
        }
      });
    } catch (err) {
      log.showError(`terminateSelf, error code: ${(err as BusinessError)?.code},
      message: ${(err as BusinessError)?.message}`);
    }
  }

  public static async getForegroundOsAccountLocalId(): Promise<number | null> {
    try {
      let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      return await accountManager.getForegroundOsAccountLocalId();
    } catch (err) {
      log.showError(`getForegroundOsAccountLocalId error, error code: ${err?.code}, message: ${err?.message}`);
      return null;
    }
  }

  public static showToast(message: string | Resource) {
    if (!message) {
      return;
    }
    try {
      promptAction.showToast({
        message: message
      });
    } catch (err) {
      log.showError(`showToast, error code: ${(err as BusinessError)?.code}, message: ${(err as BusinessError)?.message}`);
    }
  }

  /**
   * 获取运行时的上下文
   * @returns UIAbilityContext || ServiceExtensionContext || UIExtensionContext || UIExtensionContext
   */
  public static getRuntimeContext():
  common.UIAbilityContext | common.ServiceExtensionContext | common.UIExtensionContext {
    let context = globalThis.uiAbilityCtx as common.UIAbilityContext ||
      globalThis.serviceAbilityCtx as common.ServiceExtensionContext ||
      globalThis.pryUiAbilityCtx as common.UIExtensionContext ||
      globalThis.settingUiAbilityCtx as common.UIExtensionContext;
    return context;
  }

  /**
   * 获取当前支持的多语言语种
   * @returns
   */
  public static getSysLanguageForHiboard(): string {
    // 兜底语言
    const DEFAULT_LANG = 'zh_CN';
    let context: common.UIAbilityContext | common.ServiceExtensionContext | common.UIExtensionContext =
      SysUtil.getRuntimeContext();
    let configLang: string | undefined = context?.config?.language;
    let systemLang: string | undefined = i18n.System.getSystemLanguage();
    let lang: string | undefined = configLang || systemLang;
    if (!lang) {
      return DEFAULT_LANG;
    }
    // 中文简体
    if (lang.indexOf('zh-Hans') >= 0) {
      return 'zh_CN';
    }
    // 英文
    if (lang.indexOf('en-Latn') >= 0) {
      return 'en_US';
    }
    // 藏文
    if (lang.indexOf('bo') >= 0) {
      return 'bo_CN';
    }
    // 维语
    if (lang.indexOf('ug') >= 0) {
      return 'ug_CN';
    }
    // 中文繁体
    if (lang.indexOf('zh-Hant') >= 0) {
      let local = SysUtil.getSysLocale();
      if (local.indexOf('HK') >= 0) {
        return 'zh_HK';
      }
      if (local.indexOf('TW') >= 0) {
        return 'zh_TW';
      }
      return 'zh_HK';
    }
    return DEFAULT_LANG;
  }

  /**
   * 获取地区
   *
   * @return sysLocale
   */
  public static getSysLocale(): string {
    let sysLocale: string = i18n.System.getSystemLocale() || 'zh-Hant-CN';
    return sysLocale;
  }

}