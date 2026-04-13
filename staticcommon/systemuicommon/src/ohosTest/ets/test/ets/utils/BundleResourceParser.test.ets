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
import { image } from '@kit.ImageKit';
import { Context } from '@kit.AbilityKit';
import resourceManager from '@ohos.resourceManager';
import { taskpool } from '@kit.ArkTS';
import { LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils';
import application from '@ohos.app.ability.application';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { SystemUICommonUtil } from '../../../main/ets/utils/SystemUICommonUtil';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { BundleResourceParser } from '../../../main/ets/utils/BundleResourceParser';

export default function BundleResourceParserTest() {
  describe('parse_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });
    it('should_return_immediately_when_all_maps_are_empty', 0, async () => {
      let bundleresourceparser: BundleResourceParser = new BundleResourceParser('testBundle', new Context());
      bundleresourceparser.rawfileImageMap = new Map();
      bundleresourceparser.rawfileFdMap = new Map();
      bundleresourceparser.mediaImageMap = new Map();
      await bundleresourceparser.parse();
      expect(bundleresourceparser.bundleName).assertEqual('testBundle');
    });

    it('should_return_immediately_when_bundleName_is_null', 0, async () => {
      let bundleresourceparser: BundleResourceParser = new BundleResourceParser(null, new Context());
      bundleresourceparser.rawfileImageMap = new Map();
      bundleresourceparser.rawfileFdMap = new Map();
      bundleresourceparser.mediaImageMap = new Map();
      await bundleresourceparser.parse();
      expect(bundleresourceparser.bundleName).assertNull();
    });

    it('should_log_info_when_bundleName_is_valid', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let bundleresourceparser: BundleResourceParser = new BundleResourceParser('testBundle', new Context());
      bundleresourceparser.rawfileImageMap = new Map();
      bundleresourceparser.rawfileFdMap = new Map();
      bundleresourceparser.mediaImageMap = new Map();
      await bundleresourceparser.parse();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_parse_resource_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockError)(ArgumentMatchers.any).afterReturnNothing();

      let mockIsDarkMode: Function = mocker.mockFunc(baseStateMgr, baseStateMgr.isDarkMode);
      when(mockIsDarkMode)().afterReturn(true);

      let bundleresourceparser: BundleResourceParser = new BundleResourceParser('testBundle', new Context());
      bundleresourceparser.rawfileImageMap = new Map();
      bundleresourceparser.rawfileFdMap = new Map();
      bundleresourceparser.mediaImageMap = new Map();

      let mockTaskPool: taskpool.TaskPool = new taskpool.TaskPool(1, 1);
      let mockTask: taskpool.Task = new taskpool.Task(() => {
        throw new Error('Test Error');
      });
      when(mockTaskPool.execute)(ArgumentMatchers.any).afterReturn(mockTask);

      await bundleresourceparser.parse();

      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.isDarkMode);
    });

    it('should_process_results_correctly_when_parse_resource_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockIsDarkMode: Function = mocker.mockFunc(baseStateMgr, baseStateMgr.isDarkMode);
      when(mockIsDarkMode)().afterReturn(true);

      let mockTaskPool: taskpool.TaskPool = new taskpool.TaskPool(1, 1);
      let mockTask: taskpool.Task = new taskpool.Task(() => {
        return {
          rawfileImageList: [[1, 2, 3]],
          rawfileFdList: [[4, 5, 6]],
          mediaImageList: [[7, 8, 9]]
        } as ResourceParseResult;
      });
      when(mockTaskPool.execute)(ArgumentMatchers.any).afterReturn(mockTask);
      let bundleresourceparser: BundleResourceParser = new BundleResourceParser('testBundle', new Context());
      bundleresourceparser.rawfileImageMap = new Map();
      bundleresourceparser.rawfileFdMap = new Map();
      bundleresourceparser.mediaImageMap = new Map();
      let mockPixelMapUtil: PixelMapUtil = PixelMapUtil.INSTANCE;
      let mockSetPixelMapName: Function = mocker.mockFunc(mockPixelMapUtil, mockPixelMapUtil.setPixelMapName);
      when(mockSetPixelMapName)(ArgumentMatchers.any, ArgumentMatchers.anyString).afterReturnNothing();
      await bundleresourceparser.parse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.isDarkMode);
      mocker.ignoreMock(mockPixelMapUtil, mockPixelMapUtil.setPixelMapName);
    });

    it('should_return_correct_result_when_all_operations_succeed', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelperMock: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, 'BundleResourceParser');
      let mockContext: Context = new Context();
      let mockResMgr: resourceManager.ResourceManager = mockContext.resourceManager;
      let mockPixelMap: image.PixelMap = new image.PixelMap();
      let params: ResourceParseParams = {
        rawfileImageList: [['file1', 'file2']],
        rawfileFdList: [['file1', 'file2']],
        mediaImageList: [1, 2],
        isDark: false,
        context: mockContext,
        bundleName: 'testBundle'
      };
      let result: ResourceParseResult = await parseResource(params);
      expect(result.rawfileImageList[0][0]).assertInstanceOf(image.PixelMap);
      expect(result.rawfileFdList[0][0]).assertInstanceOf(resourceManager.RawFileDescriptor);
      expect(result.mediaImageList[0].light).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[1].light).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[0].dark).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[1].dark).assertInstanceOf(image.PixelMap);

    });

    it('should_return_correct_result_when_rawfile_image_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelperMock: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, 'BundleResourceParser');

      let mockContext: Context = new Context();
      let mockResMgr: resourceManager.ResourceManager = mockContext.resourceManager;
      let params: ResourceParseParams = {
        rawfileImageList: [['file1', 'file2']],
        rawfileFdList: [['file1', 'file2']],
        mediaImageList: [1, 2],
        isDark: false,
        context: mockContext,
        bundleName: 'testBundle'
      };
      let result: ResourceParseResult = await parseResource(params);
      expect(result.rawfileImageList[0][0]).assertInstanceOf(image.PixelMap);
      expect(result.rawfileImageList[0][1]).assertInstanceOf(image.PixelMap);
      expect(result.rawfileFdList[0][0]).assertInstanceOf(resourceManager.RawFileDescriptor);
      expect(result.rawfileFdList[0][1]).assertInstanceOf(resourceManager.RawFileDescriptor);
      expect(result.mediaImageList[0].light).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[1].light).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[0].dark).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[1].dark).assertInstanceOf(image.PixelMap);

    });

    it('should_return_correct_result_when_media_image_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelperMock: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, 'BundleResourceParser');

      let mockContext: Context = new Context();
      let mockResMgr: resourceManager.ResourceManager = mockContext.resourceManager;
      let params: ResourceParseParams = {
        rawfileImageList: [['file1', 'file2']],
        rawfileFdList: [['file1', 'file2']],
        mediaImageList: [1, 2],
        isDark: false,
        context: mockContext,
        bundleName: 'testBundle'
      };
      let result: ResourceParseResult = await parseResource(params);
      expect(result.rawfileImageList[0][0]).assertInstanceOf(image.PixelMap);
      expect(result.rawfileImageList[0][1]).assertInstanceOf(image.PixelMap);
      expect(result.rawfileFdList[0][0]).assertInstanceOf(resourceManager.RawFileDescriptor);
      expect(result.rawfileFdList[0][1]).assertInstanceOf(resourceManager.RawFileDescriptor);
      expect(result.mediaImageList[0].light).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[1].light).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[0].dark).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[1].dark).assertInstanceOf(image.PixelMap);
    });

    it('should_return_correct_result_when_isDark_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelperMock: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, 'BundleResourceParser');

      let mockContext: Context = new Context();
      let mockResMgr: resourceManager.ResourceManager = mockContext.resourceManager;
      let params: ResourceParseParams = {
        rawfileImageList: [['file1', 'file2']],
        rawfileFdList: [['file1', 'file2']],
        mediaImageList: [1, 2],
        isDark: true,
        context: mockContext,
        bundleName: 'testBundle'
      };
      let result: ResourceParseResult = await parseResource(params);
      expect(result.rawfileImageList[0][0]).assertInstanceOf(image.PixelMap);
      expect(result.rawfileImageList[0][1]).assertInstanceOf(image.PixelMap);
      expect(result.rawfileFdList[0][0]).assertInstanceOf(resourceManager.RawFileDescriptor);
      expect(result.rawfileFdList[0][1]).assertInstanceOf(resourceManager.RawFileDescriptor);
      expect(result.mediaImageList[0].light).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[1].light).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[0].dark).assertInstanceOf(image.PixelMap);
      expect(result.mediaImageList[1].dark).assertInstanceOf(image.PixelMap);
    });

    it('should_add_media_image_correctly', 0, () => {
      let bundleresourceparser: BundleResourceParser = new BundleResourceParser("testBundle", new Context());
      let callback: (result: MediaImageResult) => void = (result: MediaImageResult) => {
        expect(result.width).assertEqual(100);
        expect(result.height).assertEqual(100);
        expect(result.pixelMap).assertInstanceOf(image.PixelMap);
      };
      bundleresourceparser.addMediaImage(1, callback);
      let result: image.PixelMap =
        PixelMapUtil.createPixelMapSync(resourceManager.getSystemResourceManager(), "test.jpg");
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(image, image.createPixelMap);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber)
        .afterReturn(result);
      let task: taskpool.Task = new taskpool.Task(async () => {
        bundleresourceparser.resolveMediaImage(1, "test.jpg");
      });
      taskpool.execute(task);
      mocker.ignoreMock(image, image.createPixelMap);
    });
  });
}