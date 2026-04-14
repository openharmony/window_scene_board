/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { AppGalleryEventStatus } from '../../../../main/ets/default/constants/AppInstallConstants';
import { AppDownloadInfo } from '../../../../main/ets/default/data/AppGalleryData';
import { AppUpdater } from '../../../../main/ets/default/installer/AppUpdater';
import { BaseAppInstaller } from '../../../../main/ets/default/installer/BaseAppInstaller';
import { AppInstallerTestUtils } from './BaseAppInstaller.test';

export default function AppUpdaterTest() {
  describe('AppUpdaterTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('dealWithDownloadStatusChange', 0, () => {
      let installer: BaseAppInstaller = new AppUpdater();
      let event: CommonEvent = AppInstallerTestUtils.getCommonEventData(AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT);
      let mocker = new MockKit();
      let func_1 = mocker.mockFunc(installer, installer.dealWithDownloadStatusChange);
      when(func_1)(ArgumentMatchers.anyNumber).afterReturnNothing();
      installer.dealWithDownloadStatusChange(event);
      mocker.verify('dealWithDownloadStatusChange', [event]).times(1);
      mocker.clear(func_1);
      mocker.clearAll();
    })

    it('dealWithInstallStatusChange', 0, () => {
      let installer: BaseAppInstaller = new AppUpdater();
      let event: CommonEvent = AppInstallerTestUtils.getCommonEventData(AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT);
      let mocker = new MockKit();
      let func_1 = mocker.mockFunc(installer, installer.dealWithInstallStatusChange);
      when(func_1)(ArgumentMatchers.anyNumber).afterReturnNothing();
      installer.dealWithInstallStatusChange(event);
      mocker.verify('dealWithInstallStatusChange', [event]).times(1);
      mocker.clear(func_1);
      mocker.clearAll();
    })

    it('dealWithDownloadProgressChange', 0, () => {
      let installer: BaseAppInstaller = new AppUpdater();
      let eventData: AppDownloadInfo = {
        bundleName: '',
        totalSize: 100,
        downloadedSize: 10
      };
      let mocker = new MockKit();
      let func_1 = mocker.mockFunc(installer, installer.dealWithDownloadProgressChange);
      when(func_1)(ArgumentMatchers.anyNumber).afterReturnNothing();
      installer.dealWithDownloadProgressChange(eventData);
      mocker.verify('dealWithDownloadProgressChange', [eventData]).times(1);
      mocker.clear(func_1);
      mocker.clearAll();
    })
  })
}