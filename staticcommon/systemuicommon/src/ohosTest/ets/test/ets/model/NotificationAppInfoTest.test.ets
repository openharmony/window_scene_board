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
import { image } from '@kit.ImageKit';
import { resourceManager } from '@kit.LocalizationKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ArrayUtils } from '@ohos/basicutils';
import Want from '@ohos.app.ability.Want';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationAppInfo } from '../../../main/ets/model/NotificationAppInfo';
export default function NotificationAppInfoTest() {
  describe('parse_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_appInfo_when_parse_success', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = 'testSound';
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertInstanceOf(image.ImageSource);
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parse_success_without_sound', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = undefined;
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parse_fails', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterThrow('Parse error');

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = 'testSound';
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parseLiveImages_fails', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterThrow('Parse error');

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = undefined;
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_sound_is_null', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = null;
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parse_success', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = 'testSound';
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertInstanceOf(image.ImageSource);
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parse_success_without_sound', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = undefined;
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parse_fails', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterThrow('Parse error');

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = 'testSound';
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parseLiveImages_fails', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterThrow('Parse error');

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = undefined;
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_sound_is_null', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = null;
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parse_success', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = 'testSound';
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertInstanceOf(image.ImageSource);
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parse_success_without_sound', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = undefined;
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parse_fails', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterThrow('Parse error');

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = 'testSound';
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parseLiveImages_fails', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterThrow('Parse error');

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = undefined;
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_sound_is_null', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = null;
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parse_success', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = 'testSound';
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertInstanceOf(image.ImageSource);
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_return_appInfo_when_parse_success_without_sound', 0, async () => {
      let resManager: resourceManager.ResourceManager = new resourceManager.ResourceManager();
      let mocker: MockKit = new MockKit();
      let mockParseLiveImages: Function = mocker.mockFunc(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      when(mockParseLiveImages)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturn(undefined);

      let param: NotificationAppInfoParseParam = new NotificationAppInfoParseParam();
      param.bundleName = 'testBundle';
      param.sound = undefined;
      param.liveImagesRes = { 'image1': ['res1', 'res2'] };

      const result = await NotificationAppInfo.parse(resManager, param);
      expect(result).assertInstanceOf(NotificationAppInfo);
      expect(result.soundDescriptor).assertUndefined();
      expect(result.resManager).assertEqual(resManager);

      mocker.ignoreMock(NotificationAppInfo, NotificationAppInfo.parseLiveImages);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

  }
