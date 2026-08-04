/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import data_preferences from '@ohos.data.preferences';
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import Want from '@ohos.app.ability.Want';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ContextManager } from './ContextManager';
import { BusinessError } from '@ohos.base';
import contextConstant from '@ohos.app.ability.contextConstant';

const TAG: string = 'Desktop-Setting-UIExtensionAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCS, TAG);

export default class DesktopSettingUIExtAbility extends UIExtensionAbility {
  private preference?: data_preferences.Preferences;

  onCreate(): void {
    if (this.context == undefined) {
      log.showInfo(TAG, `this.context = ${undefined}`);
    }
    ContextManager.setContext(this.context);
  }

  async onSessionCreate(want: Want, session: UIExtensionContentSession) : Promise<void> {
    let para: Record<string, UIExtensionContentSession> = { 'session': session };
    let storage: LocalStorage = new LocalStorage(para);
    try {
      let context = this.context?.getApplicationContext();
      let oldArea = context.area;
      context.area = contextConstant.AreaMode.EL1;
      this.preference = await data_preferences.getPreferences(context, 'DesktopSetting');
      let hiSearchStatus = await this.preference.get('hiSearchStatus', true) as boolean;
      let autoAlignStatus = await this.preference.get('autoAlignStatus', false) as boolean;
      log.showInfo(`${TAG}, Get hiSearchStatus Value,hiSearchStatus,${hiSearchStatus},autoAlignStatus, ${autoAlignStatus}`);
      AppStorage.setOrCreate('hiSearchStatus', hiSearchStatus);
      AppStorage.setOrCreate('autoAlignStatus', autoAlignStatus);
      context.area = oldArea;
    } catch (e) {
      AppStorage.setOrCreate('hiSearchStatus', true);
      AppStorage.setOrCreate('autoAlignStatus', false);
      log.showInfo(`${TAG}, Preference Error, ${(e as BusinessError).message}`);
    }
    session.loadContent('desktopsetting/pages/DesktopSetting', storage);
  }

  async onBackground(): Promise<void> {
    log.showInfo(`${TAG}, onBackground, hiSearchStatus:${AppStorage.get('hiSearchStatus')},autoAlignStatus:${AppStorage.get('autoAlignStatus')}`);
    this.preference?.putSync('hiSearchStatus', AppStorage.get('hiSearchStatus') as boolean);
    this.preference?.putSync('autoAlignStatus', AppStorage.get('autoAlignStatus') as boolean);
    await this.preference?.flush();
  }

  async onForeground(): Promise<void> {
    if (this.preference !== undefined) {
      try {
        // 先清除缓存再创建，会直接从数据库加载开关值，避免数据库值变化，缓存未改变
        await data_preferences.removePreferencesFromCache(this.context?.getApplicationContext(), 'DesktopSetting');
        this.preference = await data_preferences.getPreferences(this.context?.getApplicationContext(), 'DesktopSetting');
        let hiSearchStatus = await this.preference.get('hiSearchStatus', true) as boolean;
        let autoAlignStatus = await this.preference.get('autoAlignStatus', false) as boolean;
        log.showInfo(`${TAG}, onForeground,hiSearchStatus,${hiSearchStatus},autoAlignStatus, ${autoAlignStatus}`);
        AppStorage.setOrCreate('hiSearchStatus', hiSearchStatus);
        AppStorage.setOrCreate('autoAlignStatus', autoAlignStatus);
      } catch (error) {
        log.error('data_preferences getPreferences error %{public}s', error?.message);
      }
    } else {
      log.showWarn(`${TAG}, onForeground,preference is null`);
    }
  }
}
