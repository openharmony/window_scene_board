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
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { GlobalContext, sSettingsUtil } from '@ohos/frameworkwrapper';
import { sSampleManager } from '@ohos/windowscene';
import { SettingsConstants, SettingsKeyConstants, } from '@ohos/commonconstants';
import settings from '@ohos.settings';

const TAG = 'SCBSampleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class SCBSampleManager {
  private trueList: Set<string> = new Set();
  private static scbSampleManager: SCBSampleManager;

  public registerKeyObserverSample() {
    this.sampleManagerFirstCheck();
    sSampleManager.registerCheckFunction(this.isTrustListForWms)
    let result: boolean = false;
    try {
      result = settings.registerKeyObserver(GlobalContext.getContext(),
        SettingsKeyConstants.IS_SAMPLEMANAGER_CHECKED, settings.domainName.DEVICE_SHARED, () => {
          const isSampleManagerChecked = sSettingsUtil.getValueEx(settings.domainName.DEVICE_SHARED,
            SettingsKeyConstants.IS_SAMPLEMANAGER_CHECKED, '0');
          const sampleMg: boolean = isSampleManagerChecked === SettingsConstants.SAMPLE_MANAGER_CHECKED;
          log.showInfo('sampleMg: %{public}s', sampleMg);
          sSampleManager.dominateScreen(sampleMg);
        })
      log.showInfo(`isRegisterKeyObserver: %{public}s`, result);
    } catch (err) {
      log.showError('registerKeyObserver fail');
    }
  }

  public unRegisterKeyObserverSample() {
    log.showInfo(`starting unRegisterKeyObserverFirst`);
    let result: boolean = false;
    try {
      result = settings.unregisterKeyObserver(GlobalContext.getContext(), SettingsKeyConstants.IS_SAMPLEMANAGER_CHECKED,
        settings.domainName.DEVICE_SHARED);
    } catch (err) {
      log.showError('sampleUnRegisterKeyObserver fail', err);
    }
    log.showInfo(`sampleUnRegisterKeyObserver: ${result}`, result);
  }

  private initTrustlist(): void {
    this.trueList = new Set([
      'com.ohos.samplemanagement:entry:MainAbility',
      'com.ohos.startupguide:pc_startupguide:com.ohos.startupguide.MainAbility',
      'com.ohos.browser:entry:MainAbility',
      'com.ohos.browser:entry:CustomTabAbility',
      'com.ohos.inputmethod:default:MainAbility',
      'com.ohos.mmitest:pc:PcAbility',
      'com.ohos.sceneboard:pc_sceneboard:com.ohos.sceneboard.MainAbility',
      'com.openharmony.his.vpn:entry:EntryAbility',
      'com.ohos.settings:pc_settings:com.ohos.settings.MainAbility',
    ]);
    log.showInfo('initLocalTrustlist ok, size: %{public}d', this.trueList?.size);
  }

  private sampleManagerFirstCheck(): void {
    // 开机启动查询是否霸屏
    let isSampleManagerCheck =
      sSettingsUtil.getValueEx(settings.domainName.DEVICE_SHARED, SettingsKeyConstants.IS_SAMPLEMANAGER_CHECKED, '0');
    log.showInfo('sampleManagerFirstCheck: %{public}s', isSampleManagerCheck);
    let sampleMg: boolean = isSampleManagerCheck === SettingsConstants.SAMPLE_MANAGER_CHECKED;
    sSampleManager.dominateScreen(sampleMg);
  }

  public static getInstance(): SCBSampleManager {
    if (!SCBSampleManager.scbSampleManager) {
      SCBSampleManager.scbSampleManager = new SCBSampleManager();
    }
    return SCBSampleManager.scbSampleManager;
  }

  public isTrustListForWms = (bundleName: string, moduleName: string, abilityName: string): boolean => {
    if (this.trueList.size === 0) {
      this.initTrustlist();
    }
    let res: boolean = false;
    let key: string = '';
    try {
      log.showInfo('isTrustListForWms bundleName: %{public}s,moduleName: %{public}s,abilityName: %{public}s',
        bundleName, moduleName, abilityName);
      if (!bundleName || !abilityName) {
        log.showInfo('isTrustListForWms bundleName is null');
        return false;
      }
      key = `${bundleName}:${moduleName}:${abilityName}`;
      res = this.trueList.has(key);
    } catch (error) {
      log.error('isTrustListForWms error:', error);
      return true;
    }
    log.showInfo('isTrustListForWms key: %{public}s res: %{public}s', key, res);
    return res;
  }
}