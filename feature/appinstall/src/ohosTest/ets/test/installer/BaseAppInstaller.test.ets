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

import { CommonEvent } from '@ohos/frameworkwrapper';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
} from '@ohos/hypium';
import { AppGalleryEventStatus, InstallType } from '../../../../main/ets/default/constants/AppInstallConstants';
import { AppGalleryData } from '../../../../main/ets/default/data/AppGalleryData';
import { AppNewInstaller } from '../../../../main/ets/default/installer/AppNewInstaller';
import { BaseAppInstaller } from '../../../../main/ets/default/installer/BaseAppInstaller';

const BUNDLE_NAME = 'com.ohos.appgallery';

export default function BaseAppInstallerTest() {

  describe('BaseAppInstallerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('getInstallType', 0, () => {
      let installer: BaseAppInstaller = new AppNewInstaller();
      expect(installer.getInstallType()).assertEqual(InstallType.NEW_INSTALLER);
    })

    it('should_call_downloadStatusChange_when_event_is_not_undefined', 0, () => {
      let installer: BaseAppInstaller = new AppNewInstaller();
      let event: CommonEvent = AppInstallerTestUtils.getCommonEventData(AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT);
      installer.dealWithDownloadStatusChange(event);
    })

    it('downloadStatusChange_502', 0, () => {
      let codeArr: AppGalleryEventStatus[] =
        [AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT, AppGalleryEventStatus.DOWNLOAD_WAIT_EVENT,
          AppGalleryEventStatus.DOWNLOAD_PAUSE_EVENT, AppGalleryEventStatus.DOWNLOAD_RESUME_EVENT,
          AppGalleryEventStatus.DOWNLOAD_WLAN_EVENT, AppGalleryEventStatus.DOWNLOAD_FAILED_EVENT,
          AppGalleryEventStatus.DOWNLOAD_SUCCEED_EVENT, AppGalleryEventStatus.DOWNLOAD_CANCEL_EVENT,
          AppGalleryEventStatus.DOWNLOAD_PROGRESS_EVENT, AppGalleryEventStatus.INSTALL_START_EVENT,
          AppGalleryEventStatus.INSTALL_FAILED_EVENT, AppGalleryEventStatus.INSTALL_SUCCEED_EVENT,
          AppGalleryEventStatus.COMPANY_APP_RESET_EVENT];
      let installer: BaseAppInstaller = new AppNewInstaller();
      codeArr.forEach((code: AppGalleryEventStatus) => {
        let event: CommonEvent = AppInstallerTestUtils.getCommonEventData(code);
        installer.dealWithDownloadStatusChange(event);
      });
    })
  })
}

export class AppInstallerTestUtils {
  static getCommonEventData(code: AppGalleryEventStatus): CommonEvent {
    let event: CommonEvent = {
      event: '',
      bundleName: BUNDLE_NAME,
      code: code,
      parameters: {
        bundleName: BUNDLE_NAME,
        updateStatus: 0,
      },
    };
    return event;
  }
}