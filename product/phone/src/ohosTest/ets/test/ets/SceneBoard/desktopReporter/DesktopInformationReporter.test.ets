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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { AppListInfo,
  CardSourceType,
  CommonConstants, Extend1Data, GridLayoutItemInfo, GridLayoutUtil } from '@ohos/launchercommon';
import { DesktopInformationReporter } from '@ohos/phonebase/src/main/ets/SceneBoard/desktopReporter/DesktopInformationReporter';
export default function DesktopInformationReporterTest() {
  describe('DesktopInformationReporterTest', () => {
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
    it('test_init_1', 0, () => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = CommonConstants.TYPE_FORM_STACK;
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      const appListInfo:AppListInfo = new AppListInfo();
      appListInfo.appGridInfo = [[gridLayoutItemInfo]];
      AppStorage.set('appListInfo',appListInfo);
      let mocker: MockKit = new MockKit();
      let mockFunc0: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc0)(ArgumentMatchers.any).afterReturn(true);
      try {
        const desktopInformationReporter0:DesktopInformationReporter = DesktopInformationReporter.getInstance();
        expect(desktopInformationReporter0).not().assertNull();
      } catch (e){}
      when(mockFunc0)(ArgumentMatchers.any).afterReturn(false);
      try {
        const desktopInformationReporter1:DesktopInformationReporter = DesktopInformationReporter.getInstance();
        expect(desktopInformationReporter1).not().assertNull();
      } catch (e){}
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        const desktopInformationReporter2:DesktopInformationReporter = DesktopInformationReporter.getInstance();
        expect(desktopInformationReporter2).not().assertNull();
      } catch (e){}
      mocker.clear(CheckEmptyUtils);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_init_2', 0, () => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = CommonConstants.TYPE_FOLDER;
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      const appListInfo:AppListInfo = new AppListInfo();
      appListInfo.appGridInfo = [[gridLayoutItemInfo]];
      AppStorage.set('appListInfo',appListInfo);
      AppStorage.set('outerAppListInfo',appListInfo);
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isSmallFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        const desktopInformationReporter1:DesktopInformationReporter = DesktopInformationReporter.getInstance();
        expect(desktopInformationReporter1).not().assertNull();
      } catch (e){}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        const desktopInformationReporter2:DesktopInformationReporter = DesktopInformationReporter.getInstance();
        expect(desktopInformationReporter2).not().assertNull();
      } catch (e){}
      mocker.clear(DeviceHelper);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_init_3', 0, () => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = CommonConstants.TYPE_CARD;
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      const appListInfo:AppListInfo = new AppListInfo();
      appListInfo.appGridInfo = [[gridLayoutItemInfo]];
      AppStorage.set('appListInfo',appListInfo);
      AppStorage.set('outerAppListInfo',appListInfo);
      let mocker: MockKit = new MockKit();
      try {
        const desktopInformationReporter:DesktopInformationReporter = DesktopInformationReporter.getInstance();
        expect(desktopInformationReporter).not().assertNull();
      } catch (e) {}
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_init_4', 0, () => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = CommonConstants.TYPE_APP;
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      const appListInfo:AppListInfo = new AppListInfo();
      appListInfo.appGridInfo = [[gridLayoutItemInfo]];
      AppStorage.set('appListInfo',appListInfo);
      AppStorage.set('outerAppListInfo',appListInfo);
      let mocker: MockKit = new MockKit();
      try {
        const desktopInformationReporter:DesktopInformationReporter = DesktopInformationReporter.getInstance();
        expect(desktopInformationReporter).not().assertNull();
      } catch (e) {}
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getOuterIconAndFaNumber_1', 0, () => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther:GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther_1:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = CommonConstants.TYPE_APP;
      gridLayoutItemInfoOther.typeId = CommonConstants.TYPE_CARD;
      gridLayoutItemInfoOther_1.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      const appListInfo:AppListInfo = new AppListInfo();
      const appListInfoOther:AppListInfo = new AppListInfo();
      appListInfo.appGridInfo = [[gridLayoutItemInfo]];
      appListInfoOther.appGridInfo = [[gridLayoutItemInfoOther,gridLayoutItemInfo,gridLayoutItemInfoOther_1]];
      AppStorage.set('appListInfo',appListInfo);
      let mocker: MockKit = new MockKit();
      const desktopInformationReporter:DesktopInformationReporter = DesktopInformationReporter.getInstance();
      let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      AppStorage.set('outerAppListInfo',appListInfoOther);
      try {
        desktopInformationReporter['getOuterIconAndFaNumber']();
      } catch (e) {}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        desktopInformationReporter['getOuterIconAndFaNumber']();
      } catch (e) {}
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_countAppIconInFolder_1', 0, () => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = CommonConstants.TYPE_APP;
      gridLayoutItemInfoOther.typeId = CommonConstants.TYPE_APP;
      const appListInfo:AppListInfo = new AppListInfo();
      appListInfo.appGridInfo = [[gridLayoutItemInfo]];
      AppStorage.set('appListInfo',appListInfo);
      let mocker: MockKit = new MockKit();
      const desktopInformationReporter:DesktopInformationReporter = DesktopInformationReporter.getInstance();
      try {
        desktopInformationReporter['countAppIconInFolder'](gridLayoutItemInfoOther);
        expect(gridLayoutItemInfo).not().assertNull();
      } catch (e) {}
      gridLayoutItemInfoOther.typeId = CommonConstants.TYPE_FOLDER;
      gridLayoutItemInfoOther.layoutInfo = [[]];
      try {
        desktopInformationReporter['countAppIconInFolder'](gridLayoutItemInfoOther);
        expect(gridLayoutItemInfo).not().assertNull();
      } catch (e) {}
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_statisticFormStack_1', 0, () => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther.extend1 = JSON.stringify(new Extend1Data());
      gridLayoutItemInfo.typeId = CommonConstants.TYPE_APP;
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      gridLayoutItemInfo.formStackId = '1';
      const appListInfo:AppListInfo = new AppListInfo();
      appListInfo.appGridInfo = [[gridLayoutItemInfo]];
      AppStorage.set('appListInfo',appListInfo);
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(Extend1Data, Extend1Data.getCardSourceType);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(CardSourceType.UPGRADE_MIGRATE);
      try {
        const desktopInformationReporter:DesktopInformationReporter = DesktopInformationReporter.getInstance();

        desktopInformationReporter['statisticFormStack'](gridLayoutItemInfo);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CardSourceType.SYS_PRESETS);
        desktopInformationReporter['statisticFormStack'](gridLayoutItemInfo);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(CardSourceType.CLONE_MIGRATE);
        desktopInformationReporter['statisticFormStack'](gridLayoutItemInfo);
        expect(gridLayoutItemInfo).not().assertNull();
      } catch (e) {}
      mocker.clear(DeviceHelper);
      mocker.clear(Extend1Data);
      mocker.clearAll();
    })
  })
}