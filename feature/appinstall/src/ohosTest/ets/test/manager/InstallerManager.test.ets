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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it} from '@ohos/hypium'
import { AppInstallConstants, InstallType } from '../../../../main/ets/default/constants/AppInstallConstants'
import { AppGalleryData } from '../../../../main/ets/default/data/AppGalleryData'
import { AppNewInstaller } from '../../../../main/ets/default/installer/AppNewInstaller'
import { AppUpdater } from '../../../../main/ets/default/installer/AppUpdater'
import { BaseAppInstaller } from '../../../../main/ets/default/installer/BaseAppInstaller'
import { EnterpriseAppNewInstaller } from '../../../../main/ets/default/installer/EnterpriseAppNewInstaller'
import { EnterpriseAppUpdater } from '../../../../main/ets/default/installer/EnterpriseAppUpdater'
import { InstallerManager } from '../../../../main/ets/default/manager/InstallerManager'

const BUNDLE_NAME = 'com.ohos.appgallery';

export default function InstallerManagerTest() {
  describe('InstallerManagerTest', (): void => {

    beforeAll((): void => {

    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('getInstaller_new', 0, () => {
      let installerManager: InstallerManager = InstallerManager.getInstance();
      installerManager.addInstaller(new AppNewInstaller());
      installerManager.addInstaller(new AppUpdater());
      installerManager.addInstaller(new EnterpriseAppNewInstaller());
      installerManager.addInstaller(new EnterpriseAppUpdater());

      let appGalleryData: AppGalleryData = {
        bundleName: '',
        updateStatus: 0,
        distributeType: '',
        status: 0
      };
      let installer: BaseAppInstaller = installerManager.findInstaller(appGalleryData, BUNDLE_NAME, true);
      expect(installer.getInstallType()).assertEqual(InstallType.NEW_INSTALLER);
    })

    it('getInstaller_update', 0, () => {
      let installerManager: InstallerManager = InstallerManager.getInstance();
      installerManager.addInstaller(new AppNewInstaller());
      installerManager.addInstaller(new AppUpdater());
      installerManager.addInstaller(new EnterpriseAppNewInstaller());
      installerManager.addInstaller(new EnterpriseAppUpdater());

      let appGalleryData: AppGalleryData = {
        bundleName: '',
        updateStatus: 0,
        distributeType: '',
        status: 0
      };
      let installer: BaseAppInstaller = installerManager.findInstaller(appGalleryData, BUNDLE_NAME, true);
      expect(installer.getInstallType()).assertEqual(InstallType.NEW_INSTALLER);
    })

    it('getInstaller_enterprise_new', 0, () => {
      let installerManager: InstallerManager = InstallerManager.getInstance();
      installerManager.addInstaller(new AppNewInstaller());
      installerManager.addInstaller(new AppUpdater());
      installerManager.addInstaller(new EnterpriseAppNewInstaller());
      installerManager.addInstaller(new EnterpriseAppUpdater());

      let appGalleryData: AppGalleryData = {
        bundleName: '',
        updateStatus: 0,
        distributeType: AppInstallConstants.TYPE_ENTERPRISE,
        status: 0
      };
      let installer: BaseAppInstaller = installerManager.findInstaller(appGalleryData, BUNDLE_NAME, true);
      expect(installer.getInstallType()).assertEqual(InstallType.ENTERPRISE_INSTALLER);
    })


    it('getInstaller_enterprise_update', 0, () => {
      let installerManager: InstallerManager = InstallerManager.getInstance();
      installerManager.addInstaller(new AppNewInstaller());
      installerManager.addInstaller(new AppUpdater());
      installerManager.addInstaller(new EnterpriseAppNewInstaller());
      installerManager.addInstaller(new EnterpriseAppUpdater());

      let appGalleryData: AppGalleryData = {
        bundleName: '',
        updateStatus: 1,
        distributeType: AppInstallConstants.TYPE_ENTERPRISE,
        status: 0
      };
      let installer: BaseAppInstaller = installerManager.findInstaller(appGalleryData, BUNDLE_NAME, true);
      expect(installer.getInstallType()).assertEqual(InstallType.ENTERPRISE_UPDATER);
    })

  })
}