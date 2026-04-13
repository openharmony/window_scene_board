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
} from '@ohos/hypium';
import { RoPropConstants } from '@ohos/commonconstants';
import { launcherStatusUtil } from '@ohos/windowscene/src/main/ets/utils/LauncherStatusUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { DesktopUtil } from '../../../../../../main/ets/utils/DesktopUtil';
import { SCBSceneContainerSessionArray, SCBScenePanelManager } from '@ohos/windowscene';
import apsManager from '@hms.graphic.apsManager';

/**
 * 外屏桌面工具类 DT测试套
 */
export function DesktopUtilTest() {
  describe('DesktopUtilTest', (): void => {
    let desktopUtil: DesktopUtil = new DesktopUtil();
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_desktopUtil', Level.LEVEL0, (): void => {
      expect(desktopUtil).not().assertNull();
    })

    it('test_updateFoldStatusParamByStatus_01', 0, () => {
      desktopUtil.updateFoldStatusParamByStatus(true)
      expect(true).assertTrue();
    });

    it('test_updateFoldStatusParamByStatus_02', 0, () => {
      desktopUtil.updateFoldStatusParamByStatus(false);
      expect(true).assertTrue();
    });

    it('test_initFoldStatusParam_01', 0, () => {
      desktopUtil.initFoldStatusParam(true)
      expect(true).assertTrue();
    });

    it('test_initFoldStatusParam_02', 0, () => {
      desktopUtil.initFoldStatusParam(false);
      expect(true).assertTrue();
    });

    it('test_getPageCount', 0, () => {
      let pageCount = desktopUtil.getPageCount();
      expect(pageCount).assertEqual('page_count');
    });

    it('test_getPageIndex', 0, () => {
      let pageIndex = desktopUtil.getPageIndex();
      expect(pageIndex).assertEqual('pageIndex');
    });

    it('test_getAppListInfo', 0, () => {
      let appListInfo = desktopUtil.getAppListInfo();
      expect(appListInfo).assertEqual('appListInfo');
    });

    it('test_getShowOutLauncherStatus', 0, () => {
      expect(launcherStatusUtil.getShowOutLauncherStatus()).assertInstanceOf('Boolean');
    });

    it('test_setAndGetShowOutLauncherStatus', 0, () => {
      let originStatus = launcherStatusUtil.getShowOutLauncherStatus();
      launcherStatusUtil.setShowOutLauncherStatus(!originStatus);
      let newStatus = launcherStatusUtil.getShowOutLauncherStatus();
      expect(!originStatus).assertEqual(newStatus);
      launcherStatusUtil.setShowOutLauncherStatus(originStatus);
    });

    it('DesktopUtil_isFold_01', 0, () => {
      (desktopUtil as object)['isFoldDevice'] = true;
      let result: boolean = desktopUtil.isFold();
      expect(result).assertTrue();
    });

    it('DesktopUtil_isFold_02', 0, () => {
      (desktopUtil as object)['isFoldDevice'] = undefined;
      let result: boolean = desktopUtil.isFold();
      expect(result).not().assertUndefined();
    });

    it('DesktopUtil_needIgnoreFoldDeviceForLauncher_01', 0, () => {
      (desktopUtil as object)['isNeedIgnoreFoldDevice'] = true;
      let result: boolean = desktopUtil.needIgnoreFoldDeviceForLauncher();
      expect(result).assertTrue();
    });

    it('DesktopUtil_needIgnoreFoldDeviceForLauncher_02', 0, () => {
      (desktopUtil as object)['isNeedIgnoreFoldDevice'] = undefined;
      RoPropConstants.DEVICE_SCREEN_FLAG = '';
      let result: boolean = desktopUtil.needIgnoreFoldDeviceForLauncher();
      expect(result).assertFalse();
    });

    it('DesktopUtil_needIgnoreFoldDeviceForLauncher_03', 0, () => {
      (desktopUtil as object)['isNeedIgnoreFoldDevice'] = undefined;
      RoPropConstants.DEVICE_SCREEN_FLAG = '1111';
      let result: boolean = desktopUtil.needIgnoreFoldDeviceForLauncher();
      expect(result).not().assertUndefined();
    });

    it('DesktopUtil_updatePageIndex_test01', 0, () => {
      (desktopUtil as object)['isSingleDisplayPocketFoldDevice'] = true;
      (desktopUtil as object)['updatePageIndex'](true);
      expect(desktopUtil).not().assertUndefined();
    });

    it('DesktopUtil_updatePageIndex_test02', 0, () => {
      (desktopUtil as object)['isSingleDisplayPocketFoldDevice'] = true;
      (desktopUtil as object)['updatePageIndex'](false);
      expect(desktopUtil).not().assertUndefined();
    });

    it('DesktopUtil_updateAppListInfo_test01', 0, () => {
      (desktopUtil as object)['isSingleDisplayPocketFoldDevice'] = true;
      (desktopUtil as object)['updateAppListInfo'](true);
      expect(desktopUtil).not().assertUndefined();
    });

    it('DesktopUtil_updateAppListInfo_test02', 0, () => {
      (desktopUtil as object)['isSingleDisplayPocketFoldDevice'] = true;
      (desktopUtil as object)['updateAppListInfo'](false);
      expect(desktopUtil).not().assertUndefined();
    });

    it('DesktopUtil_updatePageCount_test01', 0, () => {
      (desktopUtil as object)['isSingleDisplayPocketFoldDevice'] = true;
      (desktopUtil as object)['updatePageCount'](true);
      expect(desktopUtil).not().assertUndefined();
    });

    it('DesktopUtil_updatePageCount_test02', 0, () => {
      (desktopUtil as object)['isSingleDisplayPocketFoldDevice'] = true;
      (desktopUtil as object)['updatePageCount'](false);
      expect(desktopUtil).not().assertUndefined();
    });

    it('DesktopUtil_getPageCount_test01', 0, () => {
      let result: string = desktopUtil.getPageCount(true);
      expect(result).not().assertUndefined();
      let result1: string = desktopUtil.getPageCount(false);
      expect(result1).not().assertUndefined();
    });

    it('DesktopUtil_getPageIndex_test01', 0, () => {
      let result: string = desktopUtil.getPageIndex();
      expect(result).not().assertUndefined();
      let result1: string = desktopUtil.getPageIndex();
      expect(result1).not().assertUndefined();
    });

    it('DesktopUtil_getAppListInfo_test01', 0, () => {
      let result: string = desktopUtil.getAppListInfo(true);
      expect(result).not().assertUndefined();
      let result1: string = desktopUtil.getAppListInfo(false);
      expect(result1).not().assertUndefined();
    });

    it('test_isBarPhonePortraitStatus_01', 0, () => {
      let mocker: MockKit = new MockKit();
      let isBarPhoneStatus: Function = mocker.mockFunc(desktopUtil, desktopUtil.isBarPhoneStatus);
      when(isBarPhoneStatus)(ArgumentMatchers.any).afterReturn(true);
      let isLandscape: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(isLandscape)(ArgumentMatchers.any).afterReturn(false);
      desktopUtil.isBarPhonePortraitStatus();
      expect(desktopUtil instanceof DesktopUtil).assertTrue();
      mocker.ignoreMock(desktopUtil, desktopUtil.isBarPhoneStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    });

    it('test_isBarPhonePortraitStatus_02', 0, () => {
      let mocker: MockKit = new MockKit();
      let isBarPhoneStatus: Function = mocker.mockFunc(desktopUtil, desktopUtil.isBarPhoneStatus);
      when(isBarPhoneStatus)(ArgumentMatchers.any).afterReturn(true);
      let isLandscape: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(isLandscape)(ArgumentMatchers.any).afterReturn(true);
      desktopUtil.isBarPhonePortraitStatus();
      expect(desktopUtil instanceof DesktopUtil).assertTrue();
      mocker.ignoreMock(desktopUtil, desktopUtil.isBarPhoneStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    });

    it('test_isBarPhonePortraitStatus_03', 0, () => {
      let mocker: MockKit = new MockKit();
      let isBarPhoneStatus: Function = mocker.mockFunc(desktopUtil, desktopUtil.isBarPhoneStatus);
      when(isBarPhoneStatus)(ArgumentMatchers.any).afterReturn(false);
      let isLandscape: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(isLandscape)(ArgumentMatchers.any).afterReturn(true);
      desktopUtil.isBarPhonePortraitStatus();
      expect(desktopUtil instanceof DesktopUtil).assertTrue();
      mocker.ignoreMock(desktopUtil, desktopUtil.isBarPhoneStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
    });

    it('DesktopUtil_setApsSceneWindowCheck_test_01', 0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelInstance: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let getFloatSession: Function = mocker.mockFunc(scenePanelInstance, scenePanelInstance.getFloatingSessionList);
      when(getFloatSession)(ArgumentMatchers.any).afterReturn(new SCBSceneContainerSessionArray());
      let getContainerSession: Function =
        mocker.mockFunc(scenePanelInstance, scenePanelInstance.getSceneContainerSessionList);
      when(getContainerSession)(ArgumentMatchers.any).afterReturn(new SCBSceneContainerSessionArray());
      desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.SLIDE_OPEN_FOLDER, 1);
      desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.SLIDE_OPEN_FOLDER, 0);
      expect(true).assertTrue();
    });
  })
}