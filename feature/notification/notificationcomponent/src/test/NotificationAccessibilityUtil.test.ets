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
import { bundleManager, bundleResourceManager, launcherBundleManager } from '@kit.AbilityKit';
import { notificationManager } from '@kit.NotificationKit';
import { i18n } from '@kit.LocalizationKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationConfigBaseManager } from '@ohos/systemuicommon/src/main/ets/manager/NotificationConfigBaseManager';
import { NotificationConfigEntity } from '@ohos/systemuicommon/src/main/ets/model/NotificationConfigEntity';
import {
  NotificationConfigAddEvent,
  NotificationConfigChangeIgnoreEvent,
  NotificationConfigUpdateResourceEvent,
  NotificationConfigDeleteEvent,
  NotificationConfigUpdateConfigEvent,
} from '@ohos/systemuicommon/src/main/ets/model/NotificationConfigEvent';
import { DeviceHelper, EvtBus, GlobalContext, PackageCommonEvent } from '@ohos/frameworkwrapper';
import {
  ExtAppConstants,
  SCBConstants,
  SettingsConstants,
  SettingsKeyConstants,
  VassistantConstants
} from '@ohos/commonconstants';
import { NotificationConfigSyncTaskParam, syncNotificationConfig } from '../../../main/ets/manager/NotificationConfigSyncTask';
import { taskpool } from '@kit.ArkTS';
import { notificationCcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/NotificationCcmConfig';
import { deliverSystemBundleVerity, bundleVerity } from '@ohos/systemuicommon/src/main/ets/utils/BundleVerityUtil';
import {
  BasicStatementAgreedEvent, BasicStatementAgreedSecureEvent
} from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import sSettingsUtil from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsUtil';
import { InnerEventUtil } from '@ohos/systemuicommon/src/main/ets/utils/InnerEventUtil';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../../../main/ets/maintenance/NotificationExceptionCode';
import { commonEventManager } from '@kit.BasicServicesKit';
import { HdsIconUtil } from '@ohos/systemuicommon/src/main/ets/utils/HdsIconUtil';
import { image } from '@kit.ImageKit';
import { SystemuiConstants } from '@ohos/systemuicommon';
import { NotificationManager } from '../../../main/ets/model/NotificationManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationConfigManager } from '../../../main/ets/manager/NotificationConfigManager';
export default function NotificationConfigManagerTest() {
  describe('getConfig_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_bundleName_is_null_and_config_is_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();

      let mockGetBundleInfo: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      when(mockGetBundleInfo)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber]).afterReturn(null);

      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1);
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_config_when_bundleName_is_null_and_config_is_not_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();

      let mockGetBundleInfo: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      when(mockGetBundleInfo)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber]).afterReturn(null);


      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1);
      expect(result).assertInstanceOf(NotificationConfigEntity);

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_config_when_bundleName_is_not_null_and_config_is_not_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertInstanceOf(NotificationConfigEntity);

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_not_null_and_config_is_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_null_and_config_is_null_and_getBundleInfo_throws_error', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();

      let mockGetBundleInfo: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      when(mockGetBundleInfo)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber]).afterThrow('error');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1);
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_return_config_when_bundleName_is_not_null_and_config_is_not_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertInstanceOf(NotificationConfigEntity);

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_not_null_and_config_is_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_null_and_config_is_null_and_getBundleInfo_throws_error', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();

      let mockGetBundleInfo: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      when(mockGetBundleInfo)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber]).afterThrow('error');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1);
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_return_config_when_bundleName_is_not_null_and_config_is_not_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertInstanceOf(NotificationConfigEntity);

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_not_null_and_config_is_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_null_and_config_is_null_and_getBundleInfo_throws_error', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();

      let mockGetBundleInfo: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      when(mockGetBundleInfo)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber]).afterThrow('error');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1);
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_return_config_when_bundleName_is_not_null_and_config_is_not_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertInstanceOf(NotificationConfigEntity);

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_not_null_and_config_is_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_null_and_config_is_null_and_getBundleInfo_throws_error', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();

      let mockGetBundleInfo: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      when(mockGetBundleInfo)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber]).afterThrow('error');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1);
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_return_config_when_bundleName_is_not_null_and_config_is_not_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertInstanceOf(NotificationConfigEntity);

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_not_null_and_config_is_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_null_and_config_is_null_and_getBundleInfo_throws_error', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();

      let mockGetBundleInfo: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      when(mockGetBundleInfo)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber]).afterThrow('error');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1);
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_return_config_when_bundleName_is_not_null_and_config_is_not_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertInstanceOf(NotificationConfigEntity);

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_not_null_and_config_is_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();


      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_null_and_config_is_null_and_getBundleInfo_throws_error', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();

      let mockGetBundleInfo: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      when(mockGetBundleInfo)([ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber]).afterThrow('error');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1);
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.getBundleInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_return_config_when_bundleName_is_not_null_and_config_is_not_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();
      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);
      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertInstanceOf(NotificationConfigEntity);

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_undefined_when_bundleName_is_not_null_and_config_is_null', 0, async () => {
      let notificationconfigmanager: NotificationConfigManager = new NotificationConfigManager();
      let mocker: MockKit = new MockKit();
      let mockCreateNotificationConfig: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      when(mockCreateNotificationConfig)([ArgumentMatchers.any]).afterReturn(null);

      let mockMakeSureIconIsValid: Function = mocker.mockFunc(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      when(mockMakeSureIconIsValid)([ArgumentMatchers.any, ArgumentMatchers.anyNumber, ArgumentMatchers.anyString]).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturn(null);

      const result = await notificationconfigmanager.getConfig(1, 'bundleName');
      expect(result).assertUndefined();

      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.createNotificationConfig);
      mocker.ignoreMock(notificationconfigmanager, notificationconfigmanager.makeSureIconIsValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });
}