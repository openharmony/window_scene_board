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

import { BusinessError, settings } from '@kit.BasicServicesKit';
import { Log } from '../../aigcServiceAbility/IdlService/Log';
import DesktopSettingPage from '../../pages/desktopSetting/DesktopSettingPage';

const TAG = 'DesktopSettingPageController';
const INTELLIGENT_IS_SIGN_PRIVACY = 'intelligent_is_sign_privacy';
const INTELLIGENT_SWITCH_STATUS_DESKTOP = 'intelligent_switch_status';
const INTELLIGENT_OOBE_SWITCH = 'settings.intelligent.privacy_switch';

export class DesktopSettingPageController {
  private desktopSettingPage?: DesktopSettingPage;

  private static INSTANCE: DesktopSettingPageController = new DesktopSettingPageController();

  public static getInstance(): DesktopSettingPageController {
    return DesktopSettingPageController.INSTANCE;
  }

  public setDesktopSettingPage(page: DesktopSettingPage): void {
    this.desktopSettingPage = page;
  }

  public getIsIntelligentSignPrivacy(): void {
    try {
      settings.getValue(getContext(),
        INTELLIGENT_IS_SIGN_PRIVACY, settings.domainName.USER_SECURITY)
        .then((value: string) => {
          Log.info(TAG, `getIsIntelligentSignPrivacy, is_sign_privacy: ${value}`);
          if (this.desktopSettingPage) {
            this.desktopSettingPage.isIntelligentSignPrivacy = value === 'true';
          }
        })
        .catch((err: BusinessError) => {
          // 兜底逻辑，大概率是旧版本settings数据库没有赋值该字段
          Log.error(TAG, `getIsIntelligentSignPrivacy, is_sign_privacy getValue` +
            ` err code: ${err?.code}, msg: ${err?.message}`);
          settings.getValue(getContext(),
            INTELLIGENT_SWITCH_STATUS_DESKTOP, settings.domainName.USER_SECURITY).then((value: string) => {
            Log.info(TAG, `getIsIntelligentSignPrivacy, switch_status: ${value}`);
            if (this.desktopSettingPage) {
              this.desktopSettingPage.isIntelligentSignPrivacy = value === 'true';
            }
          })
            .catch((err: BusinessError) => {
              Log.error(TAG, `getIsIntelligentSignPrivacy, switch_status getValue` +
                ` err code: ${err?.code}, msg: ${err?.message}`);
              settings.getValue(getContext(),
                INTELLIGENT_OOBE_SWITCH, settings.domainName.USER_SECURITY).then((value: string) => {
                Log.info(TAG, `getIsIntelligentSignPrivacy, OOBE_switch: ${value}`);
                if (this.desktopSettingPage) {
                  this.desktopSettingPage.isIntelligentSignPrivacy = value === '1';
                }
              })
                .catch((err: BusinessError) => {
                  if (this.desktopSettingPage) {
                    this.desktopSettingPage.isIntelligentSignPrivacy = false;
                  }
                  Log.error(TAG, `getIsIntelligentSignPrivacy, OOBE_switch getValue` +
                    ` err code: ${err?.code}, msg: ${err?.message}`);
                });
            });
        });
    } catch (err) {
      Log.error(TAG, `getIsIntelligentSignPrivacy, try getValue err code: ${err?.code}, msg: ${err?.message}`);
    }
  }

  public registerIsSignPrivacyObserver(): void {
    let result: boolean = false;
    try {
      result = settings.registerKeyObserver(getContext(),
        INTELLIGENT_IS_SIGN_PRIVACY, settings.domainName.USER_SECURITY, (err, value) => {
          this.getIsIntelligentSignPrivacy();
        });
    } catch (err) {
      Log.error(TAG, `registerIsSignPrivacyObserver, catch err code: ${err?.code}, msg: ${err?.message}`);
    }
    Log.info(TAG, `registerIsSignPrivacyObserver, register result: ${result}`);
  }

  public unRegisterIsSignPrivacyObserver(): void {
    let result: boolean = false;
    try {
      result = settings.unregisterKeyObserver(getContext()
        , INTELLIGENT_IS_SIGN_PRIVACY, settings.domainName.USER_SECURITY);
    } catch (err) {
      Log.error(TAG, `unRegisterIsSignPrivacyObserver, try err code: ${err?.code}, msg: ${err?.message}`);
    }
    Log.info(TAG, `unRegisterIsSignPrivacyObserver, unregister result: ${result}`);
  }
}