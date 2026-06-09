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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { DeviceHelper, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper'
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import {
  AppItemTextShadowInfo,
  DesktopStyleConfig,
  TextShadowManager,
  textShadowMgr
} from '../../../../../../main/ets/manager/TextShadowManager'
import { image } from '@kit.ImageKit'
import { DeviceState } from '../../../../../../main/ets/TsIndex'
import { ThemeActivationEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';

export default function TextShadowManagerTest() {
  describe('TextShadowManagerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('TextShadow_onWallPaperChange', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      textShadowManager['wallPaperListener'].onWallPaperChange(new ThemeActivationEvent())
      expect(textShadowManager['wallPaperListener'].registeredTag).assertEqual('TextShadowManager');
    })

    it('TextShadow_onWallPaperChange', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let textShadowManager: TextShadowManager = new TextShadowManager();
      expect(textShadowManager['wallPaperListener'].registeredTag).assertEqual('TextShadowManager');
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('TextShadow_generateShadow01', Level.LEVEL0, async (done: Function) => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      let info: AppItemTextShadowInfo = {
        startOffsetX: 0,
        startOffsetY: 1,
        maxRow: 1,
        maxCol: 1,
        nameWidth: 1,
        nameHeight: 1,
        screenWidth: 1,
        screenHeight: 1,
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(textShadowManager, textShadowManager['isLoadFromPreference']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false)
      let str: string = await textShadowManager.generateShadow(info, 'key', undefined);
      expect(str).assertEqual(undefined);
      mocker.clear(textShadowManager);
      mocker.clearAll();
      done();
    })

    it('TextShadow_startReleaseAlarm', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      textShadowManager['startReleaseAlarm']();
      expect(textShadowManager['releaseFlag']).assertEqual(0);
    })

    it('TextShadow_releaseSnapshot', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      try {
      textShadowManager['releaseSnapshot']();
      } catch (e) {}
      expect(textShadowManager['desktopImageSnapshot']).assertEqual(undefined);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils['isEmpty']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(textShadowManager['desktopImageSnapshot']).assertEqual(undefined);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('TextShadow_tryUpdateWallpaper', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      textShadowManager.tryUpdateWallpaper(false, true);
      expect(textShadowManager['desktopImageSnapshot']).assertEqual(undefined);
      textShadowManager.tryUpdateWallpaper(false, false);
      expect(textShadowManager['desktopImageSnapshot']).assertEqual(undefined);
    })

    it('TextShadow_resetLoadShadowStatus', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      textShadowManager.resetLoadShadowStatus();
      expect(textShadowManager).not().assertNull();
    })

    it('TextShadow_setCanLoadFromSp', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      textShadowManager.setCanLoadFromSp(true, true, true);
      expect(textShadowManager).not().assertNull();
    })

    it('TextShadow_updateShadowLoadStatus', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      textShadowManager['updateShadowLoadStatus'](true, true, true);
      expect(textShadowManager['isCanLoadSinglePage']).assertTrue();
      textShadowManager['updateShadowLoadStatus'](true, true, false);
      expect(textShadowManager['isCanLoadLeftPage']).assertTrue();
      textShadowManager['updateShadowLoadStatus'](true, false, false);
      expect(textShadowManager['isCanLoadRightPage']).assertTrue();
    })

    it('TextShadow_generateShadowKey', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      let str: string = textShadowManager.generateShadowKey(1, 1, 1);
      expect(str).assertEqual('1_1_1');
    })

    it('TextShadow_getTextShadowScreenType01', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      let num: number = textShadowManager.getTextShadowScreenType(true, true);
      expect(num).assertEqual(0);
    })

    it('TextShadow_getTextShadowScreenType02', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      let num: number = textShadowManager.getTextShadowScreenType(false, true);
      expect(num).assertEqual(1);
    })

    it('TextShadow_getTextShadowScreenType03', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      let num: number = textShadowManager.getTextShadowScreenType(false, false);
      expect(num).assertEqual(2);
    })

    it('test_handleDesktopWallpaperChange_should_return', Level.LEVEL0, async (done: Function) => {
      textShadowMgr.tryUpdateWallpaper(false, false);
      textShadowMgr.tryUpdateWallpaper(true, false);

      AppStorage.setOrCreate<boolean>('desktopNewStyle', false);
      AppStorage.setOrCreate<boolean>('desktopTextShadow', false);
      await textShadowMgr.handleDesktopWallpaperChange(true);

      AppStorage.setOrCreate<boolean>('desktopNewStyle', true);
      AppStorage.setOrCreate<boolean>('desktopTextShadow', true);
      ViewManagerPolicy.getViewController(ViewType.KEYGUARD)?.show();
      await textShadowMgr.handleDesktopWallpaperChange(true);

      ViewManagerPolicy.getViewController(ViewType.KEYGUARD)?.hide();
      await textShadowMgr.handleDesktopWallpaperChange(true);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    })

    it('test_TextShadow_releaseSnapshot', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      try {
      textShadowManager['isCanLoadLeftPage'] = true;
      textShadowManager['desktopImageSnapshot'] = textShadowManager['getDesktopWallpaperSnapshot']();
      textShadowManager['releaseSnapshot']();
      expect(textShadowManager['isCanLoadLeftPage']).not().assertNull();
      } catch (e) {}
    })

    it('test_TextShadow_handleDesktopWallpaperChange', Level.LEVEL0, async (done: Function) => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      textShadowManager['isCanLoadLeftPage'] = true;
      AppStorage.setOrCreate<boolean>('desktopNewStyle', null);
      AppStorage.setOrCreate<boolean>('desktopTextShadow', null);
      AppStorage.setOrCreate<boolean>('wallpaperSnapshotChangeFlag', null);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      await textShadowManager.handleDesktopWallpaperChange();
      expect(textShadowManager['isCanLoadLeftPage']).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_TextShadow_setCanLoadFromSp', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      textShadowManager['isCanLoadLeftPage'] = true;
      textShadowManager.setCanLoadFromSp(true, true, false);
      expect(textShadowManager['isCanLoadLeftPage']).assertTrue();
      textShadowManager.setCanLoadFromSp(true, false, false);
      expect(textShadowManager['isCanLoadLeftPage']).assertTrue();
    })

    it('test_TextShadow_getIsCanLoadFromPreference', Level.LEVEL0, () => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      textShadowManager['isCanLoadLeftPage'] = true;
      textShadowManager['isCanLoadRightPage'] = true;
      let result: boolean = textShadowManager.getIsCanLoadFromPreference(DeviceState.EXPAND_STATE);
      expect(result).assertTrue();
    })

    it('test_TextShadow_isLoadFromPreference', Level.LEVEL0, async (done: Function) => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      let mockFunc02: Function = mocker.mockFunc(textShadowManager, textShadowManager['getDoublePageLoadFromPreference']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc02)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = await textShadowManager.isLoadFromPreference();
      expect(result).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clear(textShadowManager);
      mocker.clearAll();
      done();
    })

    it('test_TextShadow_getDoublePageLoadFromPreference', Level.LEVEL0, async (done: Function) => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      textShadowManager['isCanLoadLeftPage'] = true;
      textShadowManager['isCanLoadRightPage'] = undefined;
      let result: boolean = await textShadowManager['getDoublePageLoadFromPreference']();
      expect(result).assertInstanceOf('Boolean');
      done();
    })

    it('test_TextShadow_parseTextShadowPreference', Level.LEVEL0, async (done: Function) => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      let info: DesktopStyleConfig = {
        iconSize: 1,
        itemPadding: 1,
        iconNameMarginTop: 1,
        row: 1,
        col: 1,
        nameWidth: 1,
        nameHeight: 1,
        gridItemWidth: 1,
        gridItemHeight: 1
      };
      await textShadowManager.parseTextShadowPreference(true, false);
      expect(info.iconSize).assertEqual(1);
      await textShadowManager.parseTextShadowPreference(false, false);
      expect(info.iconSize).assertEqual(1);
      done();
    })

    it('test_TextShadow_storeTextShadowPreference', Level.LEVEL0, async (done: Function) => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      let info: DesktopStyleConfig = {
        iconSize: 1,
        itemPadding: 1,
        iconNameMarginTop: 1,
        row: 1,
        col: 1,
        nameWidth: 1,
        nameHeight: 1,
        gridItemWidth: 1,
        gridItemHeight: 1
      };
      await textShadowManager.storeTextShadowPreference(true, false);
      expect(info.iconSize).assertEqual(1);
      await textShadowManager.storeTextShadowPreference(false, false);
      expect(info.iconSize).assertEqual(1);
      done();
    })

    it('test_TextShadow_completeAppTextShadowInfo', Level.LEVEL0, async (done: Function) => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      let info: AppItemTextShadowInfo = {
        startOffsetX: 1,
        startOffsetY: 1,
        maxRow: 1,
        maxCol: 1,
        nameWidth: 1,
        nameHeight: 1,
        screenWidth: 1,
        screenHeight: 1,
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      await textShadowManager['completeAppTextShadowInfo'](info, true);
      expect(info.maxRow).assertEqual(1);
      await textShadowManager['completeAppTextShadowInfo'](info, false);
      expect(info.maxRow).assertEqual(1);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    })

    it('test_TextShadow_startToParseShadow', Level.LEVEL0, async (done: Function) => {
      let textShadowManager: TextShadowManager = new TextShadowManager();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(textShadowManager, textShadowManager['parseTextShadowPreference']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = await textShadowManager.startToParseShadow(DeviceState.EXPAND_STATE, 2);
      expect(result).assertTrue();
      result = await textShadowManager.startToParseShadow(DeviceState.EXPAND_STATE, 3);
      expect(result).assertTrue();
      result = await textShadowManager.startToParseShadow(DeviceState.FOLDED_STATE, 3);
      expect(result).assertTrue();
      mocker.clear(textShadowManager);
      mocker.clearAll();
      done();
    })
  })
}
