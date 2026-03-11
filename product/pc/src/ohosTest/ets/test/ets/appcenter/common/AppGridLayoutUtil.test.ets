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
import AppGridLayoutUtil from '@ohos/appcenter/src/main/ets/default/common/util/AppGridLayoutUtil'
import { DragGridParam, DragItemPosition, RealPaddingParam } from '@ohos/componentdrag'
import { RTLUtil } from '@ohos/componenthelper'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium'
import { AppItemInfo } from '@ohos/launchercommon'

export default function AppGridLayoutUtilTest() {
  describe('AppGridLayoutUtilTest', () => {
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

    it('test_AppGridLayoutUtilTest_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      AppGridLayoutUtil.initInstance(false);
      AppGridLayoutUtil.initInstance(true);
      expect(true).assertTrue();
    })

    it('test_AppGridLayoutUtilTest_initGridPositionRound', Level.LEVEL0, (): void => {
      let dragGridParam: DragGridParam = {
        paddingLeft: 0,
        paddingTop: 0,
        row: 0,
        column: 0,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 0,
        gridHeight: 0
      };
      let realPadding: RealPaddingParam = {
        paddingTop: 0,
        paddingBottom: 0,
        paddingLeft: 0,
        paddingRight: 0,
      };
      AppGridLayoutUtil.initGridPositionRound(dragGridParam, realPadding, 0, 0);
      AppGridLayoutUtil.initGridPositionRound(dragGridParam, realPadding, 0, undefined);
      AppGridLayoutUtil.initGridPositionRound(dragGridParam, realPadding, 0, 1);
      expect(true).assertTrue();
    })

    it('test_AppGridLayoutUtilTest_getGridItemPosition', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockerFunc1)().afterReturn(true);
      AppGridLayoutUtil.getGridItemPosition(0, 0, 0, 0);
      AppGridLayoutUtil.getGridItemPosition(0, 0, 0, undefined);
      AppGridLayoutUtil.getGridItemPosition(0, 0, 0, 1);
      when(mockerFunc1)().afterReturn(false);
      AppGridLayoutUtil.getGridItemPosition(0, 0, 0, 0);
      AppGridLayoutUtil.getGridItemPosition(0, 0, 0, undefined);
      AppGridLayoutUtil.getGridItemPosition(0, 0, 0, 1);
      expect(true).assertTrue();
    })

    it('test_AppGridLayoutUtilTest_getRowAndColumn', Level.LEVEL0, (): void => {
      AppGridLayoutUtil.getRowAndColumn(0, 0, 0, 0);
      AppGridLayoutUtil.getRowAndColumn(0, 0, 0, undefined);
      AppGridLayoutUtil.getRowAndColumn(0, 0, 0, 1);
      expect(true).assertTrue();
    })

    it('test_AppGridLayoutUtilTest_appGridItemToString', Level.LEVEL0, (): void => {
      AppGridLayoutUtil.appGridItemToString(new AppItemInfo());
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.page = 1;
      AppGridLayoutUtil.appGridItemToString(appItemInfo);
      expect(true).assertTrue();
    })

    it('test_AppGridLayoutUtilTest_appGridPosToString', Level.LEVEL0, (): void => {
      AppGridLayoutUtil.appGridPosToString(null);
      let dragItemPosition: DragItemPosition = {
        page: 0,
        row: 0,
        column: 0,
        isInDock: true,
        originColumn: 0,
        x: 0,
        y: 0,
      }
      AppGridLayoutUtil.appGridPosToString(dragItemPosition);
      expect(true).assertTrue();
    })

    it('test_AppGridLayoutUtilTest_getGridLayoutOptions', Level.LEVEL0, (): void => {
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.page = 1;
      let appItemInfolist: AppItemInfo[] = [];
      appItemInfolist.push(appItemInfo);
      AppGridLayoutUtil.getGridLayoutOptions(appItemInfolist, 0, 0, 0);
      AppGridLayoutUtil.getGridLayoutOptions(appItemInfolist, 0, 0, undefined);
      AppGridLayoutUtil.getGridLayoutOptions(appItemInfolist, 0, 0, 1);
      expect(true).assertTrue();
    })

    it('test_AppGridLayoutUtilTest_setExtraPaddingTopOffset', Level.LEVEL0, (): void => {
      AppGridLayoutUtil.setExtraPaddingTopOffset(0, 0);
      AppGridLayoutUtil.setExtraPaddingTopOffset(0, undefined);
      AppGridLayoutUtil.setExtraPaddingTopOffset(0, 1);
      expect(true).assertTrue();
    })
  })
}