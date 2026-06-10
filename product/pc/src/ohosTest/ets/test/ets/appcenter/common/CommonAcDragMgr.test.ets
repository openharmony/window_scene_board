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
import { CommonAcDragMgr } from '@ohos/appcenter/src/main/ets/default/controller/CommonAcDragMgr';
import FeatureConstants from '@ohos/appcenter/src/main/ets/default/common/constants/FeatureConstants';
import AppGridLayoutCacheManager from '@ohos/appcenter/src/main/ets/default/common/cache/AppGridLayoutCacheManager';
import {AppCenterGridStyleConfig} from '@ohos/appcenter/src/main/ets/default/common/AppCenterGridStyleConfig';
import AppGridLayoutUtil from '@ohos/appcenter/src/main/ets/default/common/util/AppGridLayoutUtil';
import { DragItemPosition, DragGridPosition } from '@ohos/componentdrag'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium'
import { AppItemInfo } from '@ohos/launchercommon'
import { DragEvent } from 'DragControllerParam'
import unifiedDataChannel from '@ohos.data.unifiedDataChannel'
import { ReflectionUtils } from '../../common/utils/ReflectionUtils'
import { SCBScreenProperty } from '@ohos/windowscene'

export default function CommonAcDragMgrTest() {
  describe('CommonAcDragMgrTest', () => {
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

    it('test_CommonAcDragMgrTest_setIconRadius', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let iconRadius: number = 20;
      instance.setIconRadius(iconRadius);
      expect(true).assertTrue();
    })

    it('test_CommonAcDragMgrTest_isInDragging', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let iid = instance.isInDragging();
      expect(iid).assertFalse();
    })

    it('test_CommonAcDragMgrTest_setDragItemInfo', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
    })

    it('test_CommonAcDragMgrTest_isDragItem', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
      let itemInfo1: AppItemInfo = new AppItemInfo();
      itemInfo1.bundleName = 'com.ohos.notepad';
      itemInfo1.appIndex = 1;
      let yes = instance.isDragItem(itemInfo1);
      expect(yes).assertFalse();
    })

    it('test_CommonAcDragMgrTest_isDragItem_suc_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
      let itemInfo2: AppItemInfo = new AppItemInfo();
      itemInfo2.bundleName = 'com.ohos.appgallery';
      itemInfo2.appIndex = 0;
      let yes2 = instance.isDragItem(itemInfo2);
      expect(yes2).assertFalse();
    })

    it('test_CommonAcDragMgrTest_isDragItem_fail_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      let no = instance.isDragItem(appItemInfo);
      expect(no).assertFalse();
    })

    it('test_CommonAcDragMgrTest_setIsSwaggingPage', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let swagging = true;
      instance.setIsSwaggingPage(swagging);
      let yes = instance.getIsSwaggingPage();
      expect(yes).assertTrue();
    })

    it('test_CommonAcDragMgrTest_isAnimating', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let yes = instance.isAnimating();
      expect(yes).assertFalse();
    })

    it('test_CommonAcDragMgrTest_getStartDragPos', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let pos: number[] = instance.getStartDragPos();
      expect(pos[0] === 0).assertTrue();
    })

    it('test_CommonAcDragMgrTest_onDragStart', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let evt: DragEvent = new MockedAcDragEvent();
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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      let screenProp: SCBScreenProperty = new SCBScreenProperty();
      instance.onDragStart(evt, appItemInfo, screenProp);
    })

    it('test_CommonAcDragMgrTest_onDragStart_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let evt: DragEvent = new MockedAcDragEvent();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(evt, evt.getWindowX);
      when(mockerFunc1)().afterReturn(undefined);
      let mockerFunc2 = mocker.mockFunc(evt, evt.getWindowY);
      when(mockerFunc2)().afterReturn(undefined);
      instance.onDragStart(evt);

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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      let screenProp: SCBScreenProperty = new SCBScreenProperty();
      mockerFunc1 = mocker.mockFunc(evt, evt.getWindowX);
      when(mockerFunc1)().afterReturn(1);
      mockerFunc2 = mocker.mockFunc(evt, evt.getWindowY);
      when(mockerFunc2)().afterReturn(1);
      screenProp.screenId = 1;
      instance.onDragStart(evt, appItemInfo, screenProp);
    })

    it('test_CommonAcDragMgrTest_onDragMove_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();

      let evt: DragEvent = new MockedAcDragEvent();
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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;

      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(evt, evt.getWindowX);
      when(mockerFunc1)().afterReturn(undefined);
      let mockerFunc2 = mocker.mockFunc(evt, evt.getWindowY);
      when(mockerFunc2)().afterReturn(undefined);

      instance.onDragMove(evt);
    })

    it('test_CommonAcDragMgrTest_onDragMove_02', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();

      let evt: DragEvent = new MockedAcDragEvent();
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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;

      ReflectionUtils.setProperty(instance, 'resetDelayForFullPage', true);

      instance.onDragMove(evt);
    })

    it('test_CommonAcDragMgrTest_updateAppCenterDragData', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isDragging', false);
      instance.updateAppCenterDragData(0, false, 200, 300);
      ReflectionUtils.setProperty(instance, 'isDragging', true);
      instance.updateAppCenterDragData(0, false, 200, 300);
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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
      const startPosition: DragItemPosition = {
        page: 1,
        row: 1,
        column: 1,
        x: 0,
        y: 0,
      };
      instance.updateAppCenterDragData(1, false, 200, 300);
    })

    it('test_CommonAcDragMgrTest_updateAppCenterLayoutInfo_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isDragging', true);
      let scene1 = FeatureConstants.AC_SCENE_APP_LIFE_PKG_ADD_INSTALLED;
      instance.updateAppCenterLayoutInfo(scene1);
      let scene2 = FeatureConstants.AC_SCENE_DFT;
      let reason2 = FeatureConstants.AC_UPDATE_PAGE_REASON_NEW_BLANK_PAGE;
      instance.updateAppCenterLayoutInfo(scene2, reason2);

      ReflectionUtils.setProperty(instance, 'isDragging', false);
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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      let cacheManager = AppGridLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(cacheManager, cacheManager.getAppGridLayoutItemList);
      when(mockerFunc1)().afterReturn([]);
      let scene3 = FeatureConstants.AC_SCENE_DFT;
      instance.updateAppCenterLayoutInfo(scene3);

    })

    it('test_CommonAcDragMgrTest_onDragEnter_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let screenProp: SCBScreenProperty = new SCBScreenProperty();
      instance.onDragEnter(screenProp);
      expect(true).assertTrue();
    })

    it('test_CommonAcDragMgrTest_onDragEnter_02', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let screenProp: SCBScreenProperty = new SCBScreenProperty();

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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
      instance.onDragEnter(screenProp);
      expect(true).assertTrue();
    })

    it('test_CommonAcDragMgrTest_setDragSnapshotRelativeRect_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let x: number = 64;
      let y: number = 30;
      let width: number = 150;
      let height: number = 263;
      let rect: Rectangle = {
        x,
        y,
        width,
        height
      };
      instance.setDragSnapshotRelativeRect(rect);
      expect(true).assertTrue();
    })

    it('test_CommonAcDragMgrTest_resetDragSnapshotRelativeRect_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let x: number = 64;
      let y: number = 30;
      let width: number = 150;
      let height: number = 263;
      let rect: Rectangle = {
        x,
        y,
        width,
        height
      };
      instance.resetDragSnapshotRelativeRect();
      expect(true).assertTrue();
    })

    it('test_CommonAcDragMgrTest_setWhiteBoxState_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let state: boolean = true;
      instance.setWhiteBoxState(state);
      state = false;
      instance.setWhiteBoxState(state);
      expect(true).assertTrue();
    })

    it('test_CommonAcDragMgrTest_setAppCenterViewShow_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let show: boolean = true;
      instance.setAppCenterViewShow(show);
      show = false;
      instance.setAppCenterViewShow(show);
      expect(true).assertTrue();
    })

    it('test_CommonAcDragMgrTest_getAppCenterViewShow_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let show: boolean = true;
      instance.setAppCenterViewShow(show);
      let show2: boolean = instance.getAppCenterViewShow();
      expect(show === show2).assertTrue();

      show = false;
      instance.setAppCenterViewShow(show);
      let show3: boolean = instance.getAppCenterViewShow();
      expect(show === show3).assertTrue();
    })

    it('test_CommonAcDragMgrTest_initCurrentMouse_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      instance.initCurrentMouse();
      expect(true).assertTrue();
    })

    it('test_CommonAcDragMgrTest_isAnimating_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let i = instance.isAnimating();
      expect(true).assertTrue();
    })

    it('test_CommonAcDragMgrTest_removeDropAnim_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isDropAnimating', false);
      instance.removeDropAnim();
      expect(true).assertTrue();
    })

    it('test_CommonAcDragMgrTest_onDragEnd_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isDropAnimating', true);
      instance.onDragEnd();
    })

    it('test_CommonAcDragMgrTest_onDragFinal_00', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let evt: DragEvent = new MockedAcDragEvent();
      ReflectionUtils.setProperty(instance, 'isDropAnimating', false);
      instance.onDragEnd();
    })

    it('test_CommonAcDragMgrTest_onDragFinal_01', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let evt: DragEvent = new MockedAcDragEvent();
      ReflectionUtils.setProperty(instance, 'isDropAnimating', false);
      let cfg: AppCenterGridStyleConfig = AppCenterGridStyleConfig.getInstance();
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginLeft', 100);
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginTop', 20);
      ReflectionUtils.setProperty(cfg, 'mGridWidth', 1800);
      ReflectionUtils.setProperty(cfg, 'mGridHeight', 1600);
      ReflectionUtils.setProperty(instance, 'mGridStyleConfig', cfg);
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(AppGridLayoutUtil, AppGridLayoutUtil.getRowAndColumn);
      let dragGridPos: DragGridPosition = {
        row: 1,
        column: 2,
        page: 0
      } ;
      when(mockerFunc1)().afterReturn(dragGridPos);
      instance.onDragEnd();
    })

    it('test_CommonAcDragMgrTest_onDragFinal_02', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let evt: DragEvent = new MockedAcDragEvent();
      ReflectionUtils.setProperty(instance, 'isDropAnimating', false);
      let cfg: AppCenterGridStyleConfig = AppCenterGridStyleConfig.getInstance();
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginLeft', 100);
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginTop', 20);
      ReflectionUtils.setProperty(cfg, 'mGridWidth', 1800);
      ReflectionUtils.setProperty(cfg, 'mGridHeight', 1600);
      ReflectionUtils.setProperty(instance, 'mGridStyleConfig', cfg);
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(AppGridLayoutUtil, AppGridLayoutUtil.getRowAndColumn);
      let dragGridPos: DragGridPosition = {
        row: 1,
        column: 2,
        page: 0
      } ;
      when(mockerFunc1)().afterReturn(dragGridPos);

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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
      instance.onDragEnd();
    })

    it('test_CommonAcDragMgrTest_onDragFinal_03', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let evt: DragEvent = new MockedAcDragEvent();
      ReflectionUtils.setProperty(instance, 'isDropAnimating', false);
      let cfg: AppCenterGridStyleConfig = AppCenterGridStyleConfig.getInstance();
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginLeft', 100);
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginTop', 20);
      ReflectionUtils.setProperty(cfg, 'mGridWidth', 1800);
      ReflectionUtils.setProperty(cfg, 'mGridHeight', 1600);
      ReflectionUtils.setProperty(instance, 'mGridStyleConfig', cfg);
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(AppGridLayoutUtil, AppGridLayoutUtil.getRowAndColumn);
      let dragGridPos: DragGridPosition = {
        row: 1,
        column: 2,
        page: 0
      } ;
      when(mockerFunc1)().afterReturn(dragGridPos);

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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);

      let startPos: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 100,
        y: 200,
        isInDock: false,
        originColumn: 1
      };
      ReflectionUtils.setProperty(instance, 'mStartPosition', startPos);
      instance.onDragEnd();
    })

    it('test_CommonAcDragMgrTest_onDragFinal_04', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      let evt: DragEvent = new MockedAcDragEvent();
      ReflectionUtils.setProperty(instance, 'isDropAnimating', false);
      let cfg: AppCenterGridStyleConfig = AppCenterGridStyleConfig.getInstance();
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginLeft', 100);
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginTop', 20);
      ReflectionUtils.setProperty(cfg, 'mGridWidth', 1800);
      ReflectionUtils.setProperty(cfg, 'mGridHeight', 1600);
      ReflectionUtils.setProperty(instance, 'mGridStyleConfig', cfg);
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(AppGridLayoutUtil, AppGridLayoutUtil.getRowAndColumn);
      let dragGridPos: DragGridPosition = {
        row: 1,
        column: 2,
        page: 0
      } ;
      when(mockerFunc1)().afterReturn(dragGridPos);

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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);

      let startPos: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 100,
        y: 200,
        isInDock: false,
        originColumn: 1
      };
      ReflectionUtils.setProperty(instance, 'mStartPosition', startPos);

      let lastMovPos: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 100,
        y: 200,
        isInDock: false,
        originColumn: 1
      };
      ReflectionUtils.setProperty(instance, 'mLastPosOnMoving', lastMovPos);

      ReflectionUtils.setProperty(instance, 'dropOnPage', false);
      instance.onDragEnd();
    })

    it('test_CommonAcDragMgrTest_onDragFinal_05', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isDropAnimating', false);
      let cfg: AppCenterGridStyleConfig = AppCenterGridStyleConfig.getInstance();
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginLeft', 100);
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginTop', 20);
      ReflectionUtils.setProperty(cfg, 'mGridWidth', 1800);
      ReflectionUtils.setProperty(cfg, 'mGridHeight', 1600);
      ReflectionUtils.setProperty(instance, 'mGridStyleConfig', cfg);
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(AppGridLayoutUtil, AppGridLayoutUtil.getRowAndColumn);
      ReflectionUtils.setProperty(instance, 'currentMouseX', 100);
      ReflectionUtils.setProperty(instance, 'currentMouseY', 120);
      ReflectionUtils.setProperty(instance, 'mDragPageIndex', 0);
      let dragGridPos = undefined;
      when(mockerFunc1)().afterReturn(dragGridPos);

      ReflectionUtils.setProperty(instance, 'needBackToOriginPage', false);
      let startPos: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 100,
        y: 200,
        isInDock: false,
        originColumn: 1
      };
      ReflectionUtils.setProperty(instance, 'mStartPosition', startPos);

      // x,y 为空
      instance.onDragEnd();
    })

    it('test_CommonAcDragMgrTest_onDragFinal_06', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isDropAnimating', false);
      let cfg: AppCenterGridStyleConfig = AppCenterGridStyleConfig.getInstance();
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginLeft', 120);
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginTop', 20);
      ReflectionUtils.setProperty(cfg, 'mGridWidth', 2120);
      ReflectionUtils.setProperty(cfg, 'mGridHeight', 1400);
      ReflectionUtils.setProperty(instance, 'mGridStyleConfig', cfg);
      let mocker: MockKit = new MockKit();
      let mockerFunc2 = mocker.mockFunc(AppGridLayoutUtil, AppGridLayoutUtil.getRowAndColumn);
      ReflectionUtils.setProperty(instance, 'currentMouseX', 100);
      ReflectionUtils.setProperty(instance, 'currentMouseY', 120);
      ReflectionUtils.setProperty(instance, 'mDragPageIndex', 0);
      let dragGridPos: DragGridPosition = {
        row: 2,
        column: 7,
        page: 0
      } ;
      when(mockerFunc2)().afterReturn(dragGridPos);

      ReflectionUtils.setProperty(instance, 'needBackToOriginPage', true);
      let startPos: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 100,
        y: 200,
        isInDock: false,
        originColumn: 1
      };
      ReflectionUtils.setProperty(instance, 'mStartPosition', startPos);

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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);

      let lastMovPos: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 100,
        y: 200,
        isInDock: false,
        originColumn: 1
      };
      ReflectionUtils.setProperty(instance, 'mLastPosOnMoving', lastMovPos);

      ReflectionUtils.setProperty(instance, 'dropOnPage', true);
      dragGridPos.page = 1;

      let cm: AppGridLayoutCacheManager = AppGridLayoutCacheManager.getInstance();

      let mockerFunc4 = mocker.mockFunc(cm, cm.getAppGridLayoutItemList);
      when(mockerFunc4)().afterReturn([]);

      let mockerFunc3 = mocker.mockFunc(cm, cm.updateItemForDifferentPage);
      when(mockerFunc3)().afterReturn(false);

      let mockerFunc5 = mocker.mockFunc(cm, cm.getAppGridLayoutItemList);
      when(mockerFunc5)().afterReturn([]);

      ReflectionUtils.setProperty(instance, 'needBackToOriginPage', true);

      // x,y 为空
      instance.onDragEnd();
    })

    it('test_CommonAcDragMgrTest_onDragFinal_07', Level.LEVEL0, (): void => {
      let instance: CommonAcDragMgr = new CommonAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isDropAnimating', false);
      let cfg: AppCenterGridStyleConfig = AppCenterGridStyleConfig.getInstance();
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginLeft', 150);
      ReflectionUtils.setProperty(cfg, 'mAppCenterMarginTop', 30);
      ReflectionUtils.setProperty(cfg, 'mGridWidth', 2180);
      ReflectionUtils.setProperty(cfg, 'mGridHeight', 1600);
      ReflectionUtils.setProperty(instance, 'mGridStyleConfig', cfg);
      let mocker: MockKit = new MockKit();
      let mockerFunc2 = mocker.mockFunc(AppGridLayoutUtil, AppGridLayoutUtil.getRowAndColumn);
      ReflectionUtils.setProperty(instance, 'currentMouseX', 111);
      ReflectionUtils.setProperty(instance, 'currentMouseY', 125);
      ReflectionUtils.setProperty(instance, 'mDragPageIndex', 0);
      let dragGridPos: DragGridPosition = {
        row: 6,
        column: 8,
        page: 0
      } ;
      when(mockerFunc2)().afterReturn(dragGridPos);

      ReflectionUtils.setProperty(instance, 'needBackToOriginPage', true);
      let startPos: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 100,
        y: 200,
        isInDock: false,
        originColumn: 1
      };
      ReflectionUtils.setProperty(instance, 'mStartPosition', startPos);

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
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);

      let lastMovPos: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 100,
        y: 200,
        isInDock: false,
        originColumn: 1
      };
      ReflectionUtils.setProperty(instance, 'mLastPosOnMoving', lastMovPos);

      ReflectionUtils.setProperty(instance, 'dropOnPage', true);
      dragGridPos.page = 1;

      let cm: AppGridLayoutCacheManager = AppGridLayoutCacheManager.getInstance();

      let mockerFunc4 = mocker.mockFunc(cm, cm.getAppGridLayoutItemList);
      when(mockerFunc4)().afterReturn([]);

      let mockerFunc3 = mocker.mockFunc(cm, cm.updateItemForDifferentPage);
      when(mockerFunc3)().afterReturn(false);

      let mockerFunc5 = mocker.mockFunc(cm, cm.getAppGridLayoutItemList);
      when(mockerFunc5)().afterReturn([]);

      ReflectionUtils.setProperty(instance, 'needBackToOriginPage', false);

      // x,y 为空
      instance.onDragEnd();
    })
  })
}

/**
 * 模拟拖拽事件，用于事件注入
 */
class MockedAcDragEvent implements DragEvent {
  dragBehavior: DragBehavior = DragBehavior.COPY;
  useCustomDropAnimation: boolean = false;
  displayX: number = 0;
  displayY: number = 0;

  enableInternalDropAnimation(configuration: string): void {
    throw new Error('Method not implemented.')
  }
  getModifierKeyState?(keys: string[]): boolean {
    return true;
  }

  getData(): unifiedDataChannel.UnifiedData {
    let data = new unifiedDataChannel.UnifiedRecord()
    return new unifiedDataChannel.UnifiedData(data);
  }

  getSummary(): unifiedDataChannel.Summary {
    return new unifiedDataChannel.Summary();
  }

  setResult(dragResult: DragResult): void {
  }

  getResult(): DragResult {
    return DragResult.DRAG_SUCCESSFUL;
  }

  getPreviewRect(): Rectangle {
    return {};
  }

  getVelocityX(): number {
    return 0;
  }

  getVelocityY(): number {
    return 0;
  }

  getVelocity(): number {
    return 0;
  }

  executeDropAnimation(customDropAnimation: Callback<void, void>): void {
  }

  setData(unifiedData: unifiedDataChannel.UnifiedData): void {
  }

  getX(): number {
    return 0;
  }

  getY(): number {
    return 0;
  }

  getWindowX(): number {
    return 0;
  }

  getWindowY(): number {
    return 0;
  }

  getDisplayX(): number {
    return this.displayX;
  }

  getDisplayY(): number {
    return this.displayY;
  }
}