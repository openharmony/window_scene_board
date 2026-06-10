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

import { CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import { settings } from '@kit.BasicServicesKit';

const TAG = 'AppIconConfigManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const NTF_CONFIG_SHOW_DESKTOP_BADGES: string = 'ntf_config_show_desktop_badges';


export class AppIconConfigManager {
  private showDesktopBadges: string = 'true';

  public static getInstance(): AppIconConfigManager {
    return SingletonHelper.getInstance(AppIconConfigManager, TAG);
  }

  /**
   * 注册一个观察者，是否显示未读角标
   */
  public registerBadgeKeyObserver(): void {
    log.showWarn('registerKeyObserver');
    settingsDataManager.registerKeyObserverWithDomain(NTF_CONFIG_SHOW_DESKTOP_BADGES, () => {
      this.showDesktopBadges = settingsDataManager.getValueWithDomain(NTF_CONFIG_SHOW_DESKTOP_BADGES, 'true',
        settings.domainName.USER_SECURITY)
      AppStorage.setOrCreate('showDesktopBadges', this.stringToBool(this.showDesktopBadges, true));
      log.showWarn('receive showDesktopBadges status change:' + this.showDesktopBadges);
    }, settings.domainName.USER_SECURITY);
  }

  /**
   * 初始化showDesktopBadges
   */
  public initShowDesktopBadges(): void {
    this.showDesktopBadges = settingsDataManager.getValueWithDomain(NTF_CONFIG_SHOW_DESKTOP_BADGES, 'true',
      settings.domainName.USER_SECURITY)
    AppStorage.setOrCreate('showDesktopBadges', this.stringToBool(this.showDesktopBadges, true));
  }

  /**
   * 进行注销监视器，是否显示未读角标
   */
  public unregisterBadgeKeyObserver(): void {
    log.showWarn('unregisterBadgeKeyObserver');
    settingsDataManager.unregisterKeyObserverWithDomain(NTF_CONFIG_SHOW_DESKTOP_BADGES,
      settings.domainName.USER_SECURITY);
  }

  /**
   * 字符串转布尔值
   *
   * @param text 需要转换的字符串
   * @param defVal 默认值
   * @returns 转换后的布尔值，默认值为false
   */
  public stringToBool(text: string, defVal: boolean = false): boolean {
    if (CommonUtils.isEmpty(text)) {
      return defVal;
    }
    return 'true' === text.trim().toLocaleLowerCase();
  }
}