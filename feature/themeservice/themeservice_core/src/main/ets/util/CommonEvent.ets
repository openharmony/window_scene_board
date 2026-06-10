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
import Account from '@ohos.account.osAccount';
import CommonEventManager from '@ohos.commonEventManager';
import { TsLog } from '@ohos/themeservicebase/Index';

const TAG: string = 'CommonEvent';

export class CommonEvent {
  public static readonly UNINSTALL_THEME_APP = 'com.ohos.ThemeService.UninstallThemeApp';

  public static async publish(event: string): Promise<void> {
    TsLog.info(TAG, `publish start`);
    try {
      const publishData: CommonEventManager.CommonEventPublishData = {
        subscriberPermissions: ['ohos.permission.ACTIVATE_THEME_PACKAGE']
      }
      const userId: number = await CommonEvent.getUserId();
      await CommonEvent.publishAsUser(event, userId, publishData);
    } catch (err) {
      TsLog.error(TAG, `publish catch exception.`, err);
    }
  }

  private static async getUserId(): Promise<number> {
    let localId: number = 100;
    try {
      localId = await Account.getAccountManager().getOsAccountLocalId();
    } catch (err) {
      TsLog.error(TAG, `getUserId  exception`, err);
    }
    TsLog.info(TAG, `getUserId:${localId}`);
    return localId;
  }

  private static publishAsUser(event: string, userId: number, publishData: CommonEventManager.CommonEventPublishData):
    Promise<void> {
    return new Promise(async (resolve, reject) => {
      CommonEventManager.publishAsUser(event, userId, publishData, (err, data) => {
        if (err) {
          TsLog.error(TAG, `publish event error`, err);
          reject(err);
        } else {
          TsLog.info(TAG, `publish event success`);
          resolve(data);
        }
      })
    });
  }
}


