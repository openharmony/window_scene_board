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
import adminManager from '@ohos.enterprise.adminManager';
import { BusinessError, systemParameter } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';

const TAG = 'ScreenLock-AdminManagerModel';
const SYSTEM_PARAM_ENTERPRISE_DEVICE: string = 'const.edm.is_enterprise_device';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class AdminManagerModel {
  private static instance: AdminManagerModel | null = null;
  private isEnterpriseDevice: string = 'false';

  private constructor() {
  }

  public static getInstance(): AdminManagerModel {
    if (AdminManagerModel.instance == null) {
      AdminManagerModel.instance = new AdminManagerModel();
    }
    return AdminManagerModel.instance;
  }

  public async getEnterpriseDeviceSignatureText(): Promise<string> {
    let isSuperAdmin: boolean = false;
    let adminWant: Want = {
      abilityName: '',
      bundleName: ''
    };
    await adminManager.getSuperAdmin().then((data) => {
      if (data.bundleName !== '' && data.abilityName !== '') {
        adminWant = data;
        isSuperAdmin = true;
      }
    }).catch((err: BusinessError) => {
      log.showError(`get super Admin fail. err.code : ${err.code}`);
    });

    let isEnterpriseDevice = systemParameter.getSync(SYSTEM_PARAM_ENTERPRISE_DEVICE);
    if (this.isEnterpriseDevice !== isEnterpriseDevice) {
      log.showInfo(`SetEnterpriseDeviceSignatureText isEnterpriseDevice : ${isEnterpriseDevice}`);
    }
    this.isEnterpriseDevice = isEnterpriseDevice;
    let signatureText: string = '';
    if (isSuperAdmin && isEnterpriseDevice === 'true') {
      signatureText = getContext(this).resourceManager.getStringSync($r('app.string.EnterpriseDeviceDefaultText'));
      await adminManager.getEnterpriseInfo(adminWant).then((enterpriseInfo) => {
        if (typeof enterpriseInfo.name === 'string' && enterpriseInfo.name !== '') {
          signatureText = getContext(this).resourceManager.getStringSync($r('app.string.EnterpriseDeviceText'), enterpriseInfo.name);
          log.showInfo(`SetEnterpriseDeviceSignatureText this.signatureText : ${signatureText}`);
        }
      }).catch((err: BusinessError) => {
        log.showError(`get enterprise info fail. err.code : ${err.code}`);
      });
    }
    return signatureText;
  }
}