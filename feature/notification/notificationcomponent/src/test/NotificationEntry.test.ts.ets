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
import { NotificationEntryEvent, UnifiedGroupUpdateEvent } from '../../../main/ets/common/event/NotificationEvent';
import NtfMgr from '@ohos.notificationManager';
import {
  ArrayUtils,
  CommonUtils,
  Equality,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { DeviceHelper, EvtBus } from '@ohos/frameworkwrapper';
import { MemoryUtils } from '@ohos/basicutils';
import { BaseNotification,
  getIsInEmergencyOrThermalSafeMode,
  IComponentData,
  IImmersiveData,
  ImmersiveKgParserCtrlType,
  LiveBaseTemplate,
  LiveSystemTemplate,
  LiveType,
  LiveViewCommonConstants,
  NotificationAction, NotificationBaseContent,
  notificationCcmConfig,
  NotificationCreatorType,
  NtfLongTextContent,
  NtfMultiLineContent,
  NtfPictureContent,
  NtfReminderConfig,
  ObservedItem,
  OverlayIconStyle,
  ParserController,
  parserCtrlMgr,
  SystemuiConstants,
  SysTypeCode} from '@ohos/systemuicommon';
import { SINGLE_APP_LIMIT } from '../../../main/ets/model/NotificationListLimiter';
import { image } from '@kit.ImageKit';
import { Context } from '@kit.AbilityKit';
import resourceManager from '@ohos.resourceManager';
import notificationManager from '@ohos.notificationManager';
import dataParserController from '@ohos/systemuicommon/src/main/ets/liveview/parse/DataParserController';
import { bundleManager } from '@kit.AbilityKit';
import { DeviceModeEnum } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { NotificationType } from '../../../main/ets/common/NotificationType';
import { LiveFlightTemplate } from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveFlightTemplate';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { getAppName } from '../../../main/ets/model/NotificationEntry';
export default function getAppNameTest() {
  describe('getAppName_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_appName_when_moduleName_is_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = 'testModule';
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateModuleContext: Function = mocker.mockFunc(context, context.createModuleContext);
      when(mockCreateModuleContext)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createModuleContext);
    });

    it('should_return_appName_when_moduleName_is_not_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = undefined;
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateBundleContext: Function = mocker.mockFunc(context, context.createBundleContext);
      when(mockCreateBundleContext)(ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createBundleContext);
    });

    it('should_return_appName_when_moduleName_is_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = 'testModule';
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateModuleContext: Function = mocker.mockFunc(context, context.createModuleContext);
      when(mockCreateModuleContext)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createModuleContext);
    });

    it('should_return_appName_when_moduleName_is_not_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = undefined;
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateBundleContext: Function = mocker.mockFunc(context, context.createBundleContext);
      when(mockCreateBundleContext)(ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createBundleContext);
    });

    it('should_return_appName_when_moduleName_is_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = 'testModule';
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateModuleContext: Function = mocker.mockFunc(context, context.createModuleContext);
      when(mockCreateModuleContext)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createModuleContext);
    });

    it('should_return_appName_when_moduleName_is_not_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = undefined;
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateBundleContext: Function = mocker.mockFunc(context, context.createBundleContext);
      when(mockCreateBundleContext)(ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createBundleContext);
    });

    it('should_return_appName_when_moduleName_is_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = 'testModule';
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateModuleContext: Function = mocker.mockFunc(context, context.createModuleContext);
      when(mockCreateModuleContext)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createModuleContext);
    });

    it('should_return_appName_when_moduleName_is_not_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = undefined;
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateBundleContext: Function = mocker.mockFunc(context, context.createBundleContext);
      when(mockCreateBundleContext)(ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createBundleContext);
    });

    it('should_return_appName_when_moduleName_is_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = 'testModule';
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateModuleContext: Function = mocker.mockFunc(context, context.createModuleContext);
      when(mockCreateModuleContext)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createModuleContext);
    });

    it('should_return_appName_when_moduleName_is_not_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = undefined;
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateBundleContext: Function = mocker.mockFunc(context, context.createBundleContext);
      when(mockCreateBundleContext)(ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createBundleContext);
    });

    it('should_return_appName_when_moduleName_is_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = 'testModule';
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateModuleContext: Function = mocker.mockFunc(context, context.createModuleContext);
      when(mockCreateModuleContext)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createModuleContext);
    });

    it('should_return_appName_when_moduleName_is_not_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = undefined;
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateBundleContext: Function = mocker.mockFunc(context, context.createBundleContext);
      when(mockCreateBundleContext)(ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createBundleContext);
    });

    it('should_return_appName_when_moduleName_is_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = 'testModule';
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateModuleContext: Function = mocker.mockFunc(context, context.createModuleContext);
      when(mockCreateModuleContext)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createModuleContext);
    });

    it('should_return_appName_when_moduleName_is_not_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = undefined;
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateBundleContext: Function = mocker.mockFunc(context, context.createBundleContext);
      when(mockCreateBundleContext)(ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createBundleContext);
    });

    it('should_return_appName_when_moduleName_is_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = 'testModule';
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateModuleContext: Function = mocker.mockFunc(context, context.createModuleContext);
      when(mockCreateModuleContext)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createModuleContext);
    });

    it('should_return_appName_when_moduleName_is_not_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = undefined;
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateBundleContext: Function = mocker.mockFunc(context, context.createBundleContext);
      when(mockCreateBundleContext)(ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createBundleContext);
    });

    it('should_return_appName_when_moduleName_is_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = 'testModule';
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateModuleContext: Function = mocker.mockFunc(context, context.createModuleContext);
      when(mockCreateModuleContext)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createModuleContext);
    });

    it('should_return_appName_when_moduleName_is_not_provided', 0, () => {
      let context: Context = new Context();
      let res: resourceManager.Resource = new resourceManager.Resource();
      res.moduleName = undefined;
      res.bundleName = 'testBundle';
      res.id = 1;

      let mocker: MockKit = new MockKit();
      let mockCreateBundleContext: Function = mocker.mockFunc(context, context.createBundleContext);
      when(mockCreateBundleContext)(ArgumentMatchers.anyString).afterReturn(new Context());

      let mockResManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      when(mockResManager.getStringSync)(ArgumentMatchers.anyNumber).afterReturn('TestAppName');

      when(mockResManager.getImageSync)(ArgumentMatchers.anyNumber).afterReturn(new image.PixelMap());

      const result = getAppName(context, res);
      expect(result).assertEqual('TestAppName');

      mocker.ignoreMock(context, context.createBundleContext);
    });
  });
}