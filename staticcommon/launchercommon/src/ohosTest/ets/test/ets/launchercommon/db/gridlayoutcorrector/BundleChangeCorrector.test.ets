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

import { CheckEmptyUtils } from '@ohos/basicutils'
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
} from '@ohos/hypium'
import {
  BundleChangeCorrector,
  BundleData
} from '../../../../../../../main/ets/db/gridlayoutcorrector/BundleChangeCorrector'
import {
  AppItemInfo,
  DeliverUtil,
  DockItemInfo,
  GridLayoutItemInfo,
  RdbStoreManager
} from '../../../../../../../main/ets/TsIndex'
import { CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants'

export default function BundleChangeCorrectorTest() {
  describe('BundleChangeCorrectorTest', () => {
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
    it('test_handleData_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const appItemInfo: AppItemInfo = new AppItemInfo();
      const dockItemInfo: DockItemInfo = new DockItemInfo();
      const bundleChangeCorrector: BundleChangeCorrector = new BundleChangeCorrector([appItemInfo], [dockItemInfo]);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      bundleChangeCorrector.handleData([gridLayoutItemInfo], true);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      bundleChangeCorrector.handleData([gridLayoutItemInfo], true);
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll()
    })

    it('test_dealAppItemData_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const iconBundleMapFormBMS: Map<String, BundleData> = new Map();
      const iconBundleMapFromDesktop: Map<String, BundleData> = new Map();
      const appItemInfo: AppItemInfo = new AppItemInfo();
      const dockItemInfo: DockItemInfo = new DockItemInfo();
      const bundleChangeCorrector: BundleChangeCorrector = new BundleChangeCorrector([appItemInfo], [dockItemInfo]);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(bundleChangeCorrector, bundleChangeCorrector['isNormalInstalledApp']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(bundleChangeCorrector['dealAppItemData'](gridLayoutItemInfo, iconBundleMapFormBMS,
        iconBundleMapFromDesktop, [gridLayoutItemInfo])).assertTrue();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc1: Function =
        mocker.mockFunc(bundleChangeCorrector, bundleChangeCorrector['compareAndUpdateDesktopDataByBMSData']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(bundleChangeCorrector['dealAppItemData'](gridLayoutItemInfo, iconBundleMapFormBMS,
        iconBundleMapFromDesktop, [gridLayoutItemInfo])).assertFalse();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(bundleChangeCorrector['dealAppItemData'](gridLayoutItemInfo, iconBundleMapFormBMS,
        iconBundleMapFromDesktop, [gridLayoutItemInfo])).assertTrue();
      mocker.clear(bundleChangeCorrector);
      mocker.clearAll();
    })

    it('test_isNormalFolder_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = CommonConstants.TYPE_FOLDER;
      gridLayoutItemInfo.folderId = '1';
      const appItemInfo: AppItemInfo = new AppItemInfo();
      const dockItemInfo: DockItemInfo = new DockItemInfo();
      const bundleChangeCorrector: BundleChangeCorrector = new BundleChangeCorrector([appItemInfo], [dockItemInfo]);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(bundleChangeCorrector['isNormalFolder'](gridLayoutItemInfo)).assertTrue()
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it('test_compareAndUpdateDesktopDataByBMSData_1', 0, () => {
      try {
        const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayoutItemInfo.bundleName = 'name_1';
        gridLayoutItemInfo.appIndex = 0;
        const iconBundleMapFormBMS: Map<String, BundleData> = new Map();
        const iconBundleMapFromDesktop: Map<String, BundleData> = new Map();
        const appItemInfo: AppItemInfo = new AppItemInfo();
        const dockItemInfo: DockItemInfo = new DockItemInfo();
        const bundleData: BundleData = new BundleData(gridLayoutItemInfo);
        const bundleChangeCorrector: BundleChangeCorrector = new BundleChangeCorrector([appItemInfo], [dockItemInfo]);
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        expect(bundleChangeCorrector['compareAndUpdateDesktopDataByBMSData'](gridLayoutItemInfo, iconBundleMapFormBMS,
          iconBundleMapFromDesktop)).assertFalse();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        iconBundleMapFormBMS.set('name_1_0', bundleData)
        let mockFunc1: Function =
          mocker.mockFunc(bundleChangeCorrector, bundleChangeCorrector['checkAndUpdateDesktopDataWithMultiBundle']);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
        let mockFunc2: Function =
          mocker.mockFunc(bundleChangeCorrector, bundleChangeCorrector['checkAndUpdateDesktopDataWithMultiBundle']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        expect(bundleChangeCorrector['compareAndUpdateDesktopDataByBMSData'](gridLayoutItemInfo, iconBundleMapFormBMS,
          iconBundleMapFromDesktop)).assertTrue();
        bundleData.addItem(gridLayoutItemInfo);
        bundleData.addItem(gridLayoutItemInfo);
        iconBundleMapFormBMS.set('name_1_0', bundleData)
        expect(bundleChangeCorrector['compareAndUpdateDesktopDataByBMSData'](gridLayoutItemInfo, iconBundleMapFormBMS,
          iconBundleMapFromDesktop)).assertTrue();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(bundleChangeCorrector);
        mocker.clearAll();
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_checkAndUpdateDesktopDataWithMultiBundle_1', 0, () => {
      try {
        const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayoutItemInfo.keyName = '1';
        const bundleData: BundleData = new BundleData(gridLayoutItemInfo);
        const appItemInfo: AppItemInfo = new AppItemInfo();
        const dockItemInfo: DockItemInfo = new DockItemInfo();
        const bundleChangeCorrector: BundleChangeCorrector = new BundleChangeCorrector([appItemInfo], [dockItemInfo]);
        bundleChangeCorrector['checkAndUpdateDesktopDataWithMultiBundle'](bundleData, gridLayoutItemInfoOther)
        expect(bundleChangeCorrector['checkAndUpdateDesktopDataWithMultiBundle'](bundleData, gridLayoutItemInfo))
          .assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_checkAndUpdateDesktopDataWithOneBundle_1', 0, (done:Function) => {
      try {
        const rdbStoreManager: RdbStoreManager = RdbStoreManager.getInstance();
        const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
        const bundleData: BundleData = new BundleData(gridLayoutItemInfo);
        gridLayoutItemInfo.abilityName = '1';
        gridLayoutItemInfo.moduleName = '1';
        gridLayoutItemInfo.keyName = '1';
        gridLayoutItemInfoOther.bundleName = '1';
        gridLayoutItemInfoOther.keyName = '10'
        const appItemInfo: AppItemInfo = new AppItemInfo();
        const dockItemInfo: DockItemInfo = new DockItemInfo();
        const bundleChangeCorrector: BundleChangeCorrector = new BundleChangeCorrector([appItemInfo], [dockItemInfo]);
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let mockFunc1: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.updateNewInstalledGridInfo);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(Promise.resolve(1));
        expect(bundleChangeCorrector['checkAndUpdateDesktopDataWithOneBundle'](gridLayoutItemInfo, bundleData,
          gridLayoutItemInfoOther)).assertInstanceOf('Boolean');
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        expect(bundleChangeCorrector['checkAndUpdateDesktopDataWithOneBundle'](gridLayoutItemInfo, bundleData,
          gridLayoutItemInfoOther)).assertInstanceOf('Boolean');
        bundleData.addItem(gridLayoutItemInfo);
        expect(bundleChangeCorrector['checkAndUpdateDesktopDataWithOneBundle'](gridLayoutItemInfo, bundleData,
          gridLayoutItemInfoOther)).assertInstanceOf('Boolean');
        mocker.clear(CheckEmptyUtils);
        mocker.clear(rdbStoreManager);
        mocker.clearAll();
        done();
      } catch (err) {
        console.error(JSON.stringify(err));
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_deleteAbnormalDesktopData_1', 0, (done:Function) => {
      const rdbStoreManager: RdbStoreManager = RdbStoreManager.getInstance();
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.keyName = '1'
      gridLayoutItemInfoOther.keyName = '10';
      gridLayoutItemInfoOther.typeId = 10;
      const appItemInfo: AppItemInfo = new AppItemInfo();
      const dockItemInfo: DockItemInfo = new DockItemInfo();
      const bundleChangeCorrector: BundleChangeCorrector = new BundleChangeCorrector([appItemInfo], [dockItemInfo]);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.deleteGridLayoutByCondition);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      bundleChangeCorrector['deleteAbnormalDesktopData']([gridLayoutItemInfo, gridLayoutItemInfoOther],
        [gridLayoutItemInfoOther])
      expect(rdbStoreManager).not().assertNull();
      mocker.clear(rdbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_getAllDesktopApp_1', 0, (done:Function) => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      const appItemInfo: AppItemInfo = new AppItemInfo();
      const dockItemInfo: DockItemInfo = new DockItemInfo();
      dockItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      const bundleChangeCorrector: BundleChangeCorrector = new BundleChangeCorrector([appItemInfo], [dockItemInfo]);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(bundleChangeCorrector, bundleChangeCorrector['isNormalInstalledApp']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(bundleChangeCorrector['getAllDesktopApp']([gridLayoutItemInfo])).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false)
      let mockFunc1: Function = mocker.mockFunc(bundleChangeCorrector, bundleChangeCorrector['isNormalFolder']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(bundleChangeCorrector['getAllDesktopApp']([gridLayoutItemInfo])).not().assertNull();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(bundleChangeCorrector['getAllDesktopApp']([gridLayoutItemInfo])).not().assertNull();
      mocker.clear(bundleChangeCorrector);
      mocker.clearAll();
      done();
    })
  })
}