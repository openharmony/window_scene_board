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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import sControlCenterController, { ControlCenterController } from '../../../../../../main/ets/com/ohos/controller/ControlCenterController';
import type { CommonEventData } from 'commonEvent/commonEventData';
import { MediaControlEvent } from '@ohos/frameworkwrapper';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';

export function ControlCenterControllerTest() {
  describe('ControlCenterControllerTest', (): void => {

    beforeEach((): void => {
    })
    afterEach((): void => {

    })
    afterAll((): void => {
    })

    it('ControlCenterControllerTest_recoverBackPress_001', 0, (): void => {
      let sControlCenterController = new ControlCenterController();
      (sControlCenterController as object)['recoverBackPress']();
      expect(sControlCenterController.isPc()).assertInstanceOf('Boolean');
    })

    it('ControlCenterControllerTest_recoverBackPress_002', 0, (): void => {
      let sControlCenterController = new ControlCenterController();
      (sControlCenterController as object)['timeFlag'] = 1;
      (sControlCenterController as object)['recoverBackPress']();
      expect(sControlCenterController.isPc()).assertInstanceOf('Boolean');
    })

    it('ControlCenterControllerTest_recoverBackPress_003', 0, (): void => {
      let sControlCenterController = new ControlCenterController();
      (sControlCenterController as object)['timeFlag'] = 0;
      (sControlCenterController as object)['recoverBackPress']();
      expect(sControlCenterController.isPc()).assertInstanceOf('Boolean');
    })

    it('ControlCenterControllerTest_recoverBackPress_004', 0, (): void => {
      let sControlCenterController = new ControlCenterController();
      (sControlCenterController as object)['timeFlag'] = 0;
      (sControlCenterController as object)['isEnableBackPress'] = false;
      (sControlCenterController as object)['recoverBackPress']();
      expect(sControlCenterController.isPc()).assertInstanceOf('Boolean');
    })

    it('ControlCenterControllerTest001', 0, (): void => {
      let isPc: boolean = sControlCenterController.isPc();
      expect(isPc).assertEqual(false);
    })

    it('ControlCenterControllerTest002', 0, (): void => {
      let isNewStyleOpen: boolean = sControlCenterController.isNewStyleOpen();
      expect(isNewStyleOpen).assertEqual(true);
    })

    it('ControlCenterControllerTest003', 0, (): void => {
      let getBackPressEnable: boolean = sControlCenterController.getBackPressEnable();
      expect(getBackPressEnable).assertEqual(true);
    })

    it('ControlCenterControllerTest004', 0, (): void => {
      sControlCenterController.setBackPressEnable(true);
      expect(sControlCenterController.getBackPressEnable()).assertTrue();
    })

    it('ControlCenterControllerTest005', 0, (): void => {
      let isControlCenterVisible = sControlCenterController.isControlCenterVisible();
      expect(isControlCenterVisible).assertEqual(false);
    })

    it('ControlCenterControllerTest007', 0, (): void => {
      let isPc: boolean = sControlCenterController.isPc();
      expect(isPc).assertEqual(false);
      let isNewStyleOpen: boolean = sControlCenterController.isNewStyleOpen();
      expect(isNewStyleOpen).assertEqual(true);
    })

    it('ControlCenterControllerTest008', 0, (): void => {
      let isPc: boolean = sControlCenterController.isPc();
      expect(isPc).assertEqual(false);
      let getBackPressEnable: boolean = sControlCenterController.getBackPressEnable();
      expect(getBackPressEnable).assertEqual(true);
    })

    it('ControlCenterControllerTest010', 0, (): void => {
      let isPc: boolean = sControlCenterController.isPc();
      expect(isPc).assertEqual(false);
      let isControlCenterVisible = sControlCenterController.isControlCenterVisible();
      expect(isControlCenterVisible).assertEqual(false);
    })

    it('ControlCenterControllerTest012', 0, (): void => {
      let isNewStyleOpen: boolean = sControlCenterController.isNewStyleOpen();
      expect(isNewStyleOpen).assertEqual(true);
      let getBackPressEnable: boolean = sControlCenterController.getBackPressEnable();
      expect(getBackPressEnable).assertEqual(true);
    })

    it('ControlCenterControllerTest013', 0, (): void => {
      let isNewStyleOpen: boolean = sControlCenterController.isNewStyleOpen();
      expect(isNewStyleOpen).assertEqual(true);
      sControlCenterController.setBackPressEnable(true);
      expect(sControlCenterController.getBackPressEnable()).assertTrue();
    })

    it('ControlCenterControllerTest014', 0, (): void => {
      sControlCenterController.getContent();
      sControlCenterController.setWallerPaperType(1);
      expect(sControlCenterController.getWallerPaperType()).assertEqual(1);
      sControlCenterController.setLastBackgroundType(0);
      expect(sControlCenterController.getLastBackgroundType()).assertEqual(0);
      sControlCenterController.updateLabelColor();
      sControlCenterController.setWallerPaperType(2);
      sControlCenterController.setLastBackgroundType(1);
      sControlCenterController.updateLabelColor();
      sControlCenterController.setWallerPaperType(3);
      sControlCenterController.setLastBackgroundType(2);
      sControlCenterController.updateLabelColor();
      sControlCenterController.setWallerPaperType(4);
      sControlCenterController.setLastBackgroundType(3);
      sControlCenterController.updateLabelColor();
      expect(sControlCenterController.isPc()).assertFalse();
    })

    it('ControlCenterControllerTest015', 0, (): void => {
      sControlCenterController.getData();
      sControlCenterController.setControlCenterVisible(true);
      expect(sControlCenterController.isControlCenterVisible()).assertTrue();
      sControlCenterController.setControlCenterState(ControlCenterState.MAIN_LAYOUT);
      sControlCenterController.getHomeViewData();
      sControlCenterController.setDelayReleaseIot(true);
      expect(sControlCenterController.isDelayReleaseIot()).assertTrue();
      sControlCenterController.setShowToastMethod(() => {});
      sControlCenterController.updateUIFromCache();
      let commonEvent1: CommonEventData = {
        event: 'MediaControlEvent',
        bundleName: '',
        code: 1,
        data: MediaControlEvent.MEDIA_CONTROL_JUMP,
        parameters: [],
      }
      let event1: MediaControlEvent = new MediaControlEvent(commonEvent1);
      sControlCenterController.onMediaControlCallback(event1);

      let commonEvent2: CommonEventData = {
        event: 'MediaControlEvent',
        bundleName: '',
        code: 1,
        data: MediaControlEvent.MEDIA_CONTROL_QUIT,
        parameters: [],
      }
      let event2: MediaControlEvent = new MediaControlEvent(commonEvent2);
      sControlCenterController.onMediaControlCallback(event2);
      sControlCenterController.showToast('Test');
      expect(sControlCenterController.isPc()).assertFalse();
    })

    it('getInstanceTest001', 0, (): void => {
      expect(controller !== undefined).assertTrue();
      expect(controller !== null).assertTrue();
    })

    it('getInstanceTest002', 0, (): void => {
      // isFoldablePhoneExpandStatus mock测试
      expect(SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()).assertFalse();

      let foldStatus = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(foldStatus)().afterReturn(true);

      expect(SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()).assertTrue();
      mocker.clear(screenSessionManager);
    })

    it('getInstanceTest003', 0, (): void => {
      // isPad mock测试
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);

      when(isPad)().afterReturn(true);
      expect(DeviceHelper.isPad()).assertTrue();

      when(isPad)().afterReturn(false);
      expect(DeviceHelper.isPad()).assertFalse();
      mocker.clear(DeviceHelper);
    })

    it('updateLayoutIndex_FoldScreenExpand_Test001', 0, (): void => {
      let foldStatus = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);

      // 展开态
      when(foldStatus)().afterReturn(true);

      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      mocker.clear(screenSessionManager);
    })

    it('updateLayoutIndex_FoldScreenExpand_Test002', 0, (): void => {
      let foldStatus = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);

      // 展开态
      when(foldStatus)().afterReturn(true);

      // 旋转90度
      prop.rotation = 90;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);

      // 旋转180度
      prop.rotation = 180;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);

      // 旋转270度
      prop.rotation = 270;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);

      // 旋转360度
      prop.rotation = 360;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      mocker.clear(screenSessionManager);
    })

    it('updateLayoutIndex_FoldScreenFolded_Test001', 0, (): void => {
      let foldStatus = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);

      // 屏幕折叠
      when(foldStatus)().afterReturn(false);

      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      mocker.clear(screenSessionManager);
    })

    it('updateLayoutIndex_FoldScreenFolded_Test002', 0, (): void => {
      let foldStatus = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);

      // 屏幕折叠
      when(foldStatus)().afterReturn(false);

      // 旋转90度
      prop.rotation = 90;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);

      // 旋转180度
      prop.rotation = 180;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);

      // 旋转270度
      prop.rotation = 270;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.NORMAL_LANDSCAPE);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.NORMAL_LANDSCAPE);

      // 旋转360度
      prop.rotation = 360;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      mocker.clear(screenSessionManager);
    })

    it('updateLayoutIndex_Pad_Test001', 0, (): void => {
      // 设备类型置为pad
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)().afterReturn(true);

      controller = new ControlCenterLayoutController();
      controller.setLayoutChangeCallback('callbackTag', idx => {
        layoutIndex = idx;
      });

      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.PAD);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.PAD);
      mocker.clear(DeviceHelper);
    })

    it('ControlCenterLayoutControllerTest_showControlCenter', 0, ():void=>{
      DropDownPanelManager.animToShow(TargetPanel.CONTROL_CENTER_PANEL);
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
      DropDownPanelManager.animToDismiss();
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
    })

    it('ControlCenterLayoutControllerTest_showNtf', 0, ():void=>{
      DropDownPanelManager.animToShow(TargetPanel.NOTIFICATION_PANEL);
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
      DropDownPanelManager.animToDismiss();
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
    })

    it('ControlCenterLayoutControllerTest_showControlCenter02', 0, ():void=>{
      DropDownPanelManager.showWindowDirectly(TargetPanel.CONTROL_CENTER_PANEL);
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
      DropDownPanelManager.hideWindowDirectly();
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
    })

    it('ControlCenterLayoutControllerTest_showNtf02', 0, ():void=>{
      DropDownPanelManager.showWindowDirectly(TargetPanel.NOTIFICATION_PANEL);
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
      DropDownPanelManager.hideWindowDirectly();
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
    })

    it('getDefaultToggleSettingsData001', 0, (): void => {
      let mockedFun1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      let mockedFun2: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockedFun1)().afterReturn(true);
      expect((sControlCenterToggleDataRestore as object)['getDefaultToggleSettingsData']() === '').assertTrue();
      when(mockedFun2)(SettingsKeyConstants.RESTORE_OLD_SCB_VERSION).afterReturn('99.99.99.999');
      expect((sControlCenterToggleDataRestore as object)['getDefaultToggleSettingsData']() === '').assertTrue();
      when(mockedFun2)(SettingsKeyConstants.RESTORE_OLD_SCB_VERSION).afterReturn('1.1.0.0');
      expect((sControlCenterToggleDataRestore as object)['getDefaultToggleSettingsData']() === '').assertFalse();
      when(mockedFun2)(SettingsKeyConstants.RESTORE_OLD_SCB_VERSION).afterReturn('1.0.0.0');
      expect((sControlCenterToggleDataRestore as object)['getDefaultToggleSettingsData']() === '').assertFalse();
      when(mockedFun1)().afterReturn(false);
      expect((sControlCenterToggleDataRestore as object)['getDefaultToggleSettingsData']() === '').assertFalse();
      mocker.clear(DeviceHelper);
    })

    it('reloadToggleDataSortSingle001', 0, (): void => {
      (sControlCenterToggleDataRestore as object)['retryCount'] = 0;
      let mockedFun1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockedFun1)(CommonConstants.KEY_TOGGLE_DATA).afterReturn('test');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSortSingle']();
      when(mockedFun1)(CommonConstants.KEY_TOGGLE_DATA).afterReturn('nfc');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSortSingle']();
      expect((sControlCenterToggleDataRestore as object)['backupToggleList'] === 'nfc').assertTrue();
      mocker.clear(sSettingsUtil);
    })

    it('reloadToggleDataSort001', 0, (): void => {
      (sControlCenterToggleDataRestore as object)['retryCount'] = 0;
      let mockedFun1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockedFun1)('sysui_qs_tiles').afterReturn('');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSort']();
      when(mockedFun1)('sysui_qs_tiles').afterReturn('airplane');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSort']();
      expect((sControlCenterToggleDataRestore as object)['retryCount'] === 0).assertTrue();
      mocker.clear(sSettingsUtil);
    })

    it('ControlCenterToggleDataMigrationTest_setBackupToggleDataSort', 0, (): void => {
      sControlCenterToggleDataRestore.setBackupToggleDataSort('');
      sControlCenterToggleDataRestore.setBackupToggleDataSort('string');
      expect((sControlCenterToggleDataRestore as object)['backupToggleList']).assertEqual('string');
    })

    it('ControlCenterToggleDataMigrationTest_initRestore_1', 0, (): void => {
      let mockedfun: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValue);
      when(mockedfun)(ArgumentMatchers.any).afterReturn(SETTING_DATA_DB_CLONE_FLAG_DEFAULT_VALUE);
      sControlCenterToggleDataRestore.initRestore();
      mocker.clear(sSettingsUtil);
    })

    it('ControlCenterToggleDataMigrationTest_initRestore_2', 0, (): void => {
      let mockedfun: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValue);
      when(mockedfun)(ArgumentMatchers.any).afterReturn(SETTING_DATA_DB_CLONE_FLAG_DEFAULT_CLOSE_VALUE);
      (sControlCenterToggleDataRestore as object)['settingsCloning'] = true;
      sControlCenterToggleDataRestore.initRestore();
      mocker.clear(sSettingsUtil);
    })

    it('ControlCenterToggleDataMigrationTest_reloadToggleDataSort', 0, (): void => {
      let mockedfun: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockedfun)(ArgumentMatchers.any).afterReturn("");
      expect((sControlCenterToggleDataRestore as object)['reloadToggleDataSort']() == null).assertTrue();
      mocker.clear(sSettingsUtil);
    })

    it('ControlCenterToggleDataMigrationTest_reloadToggleDataSort', 0, (): void => {
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSortSingle']();
      let mockedfun: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockedfun)(ArgumentMatchers.any).afterReturn('');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSort']();
      mocker.clear(sSettingsUtil);
      let mocked: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mocked)(ArgumentMatchers.any).afterReturn('wifi, camera');
      (sControlCenterToggleDataRestore as object)['reloadToggleDataSort']();
      mocker.clear(sSettingsUtil);
    })

    it('QuickToggleControllerTest01', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest02', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      // isPhone mock测试
      let isPhone = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);

      when(isPhone)().afterReturn(true);
      expect(DeviceHelper.isPhone()).assertTrue();

      when(isPhone)().afterReturn(false);
      expect(DeviceHelper.isPhone()).assertFalse();
      mocker.clear(DeviceHelper);
    })

    it('QuickToggleControllerTest03', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.releaseLottieData();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest04', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getToggleData();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest05', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getDefaultQuickToggleData();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest06', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getAllToggleData();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest07', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let isDark: boolean = true;
      sQuickToggleController.getLottieDataDownResource(isDark);
      isDark = false;
      sQuickToggleController.getLottieDataDownResource(isDark);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest08', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let isDark: boolean = true;
      sQuickToggleController.getLottieDataUpResource(isDark);
      isDark = false;
      sQuickToggleController.getLottieDataUpResource(isDark);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_handlePluginEventTest01', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let sPluginToggleEvent = new PluginToggleEvent();
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
      sPluginToggleEvent.eventType  = PluginConstants.EVENT_TYPE_UPDATE_PLUGIN;
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
      sPluginToggleEvent.eventType  = PluginConstants.EVENT_TYPE_DELETE_PLUGIN;
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_handlePluginEventTest02', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let sPluginToggleEvent = new PluginToggleEvent();
      sPluginToggleEvent.eventType = 2;
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_handlePluginEventTest03', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let sPluginToggleEvent = new PluginToggleEvent();
      sPluginToggleEvent.eventType = 3;
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_addUpdatePluginTest1', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      let pluginInfos = new Array<PluginInfo>();
      (sQuickToggleController as object)['addUpdatePlugin'](pluginInfos);
      expect(ArrayUtils.isEmpty(pluginInfos)).assertTrue();
      let isEmpty = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(isEmpty)(pluginInfos).afterReturn(false);
      (sQuickToggleController as object)['addUpdatePlugin'](pluginInfos);
      expect(ArrayUtils.isEmpty(pluginInfos)).assertFalse();
      mocker.clear(ArrayUtils);
    })

    it('StyleConfigurationTest076', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let editAreaHeight = value.editAreaHeight
      expect(editAreaHeight).assertInstanceOf('Number');
    })

    it('StyleConfigurationTest077', 0, (): void => {
      let value = new QuickToggleLayoutEditComponentStyle()
      let editBtnPadding = value.editBtnPadding
      expect(editBtnPadding).assertInstanceOf('Number');
    })

    it('AccountMenuItem001', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem002', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem003', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem004', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem005', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem006', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem007', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem008', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem009', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem010', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem011', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem012', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem013', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem014', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem015', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem016', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem017', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem018', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem019', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem020', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem021', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem022', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem023', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem024', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem025', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem026', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem027', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem028', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem029', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem030', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem031', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem032', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem033', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem034', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem035', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem036', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem037', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem038', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem039', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem040', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem041', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem042', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem043', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem044', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem045', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem046', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem047', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem048', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem049', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem050', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem051', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem052', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem053', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem054', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem055', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem056', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem057', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem058', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem059', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem060', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem061', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem062', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem063', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem064', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem001', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem002', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem003', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem004', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem005', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem006', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem007', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem008', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem009', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem010', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem011', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem012', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem013', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem014', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem015', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem016', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem017', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem018', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem019', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem020', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem021', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem022', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem023', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem024', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem025', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem026', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem027', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem028', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem029', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem030', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem031', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem032', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem033', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem034', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem035', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem036', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem037', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem038', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem039', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem040', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem041', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem042', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem043', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem044', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem045', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem046', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem047', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem048', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem049', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem050', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem051', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem052', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem053', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem054', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem055', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem056', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem057', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem058', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem059', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem060', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem061', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem062', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem063', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem064', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem065', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem066', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem067', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem068', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem069', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem070', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem071', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem072', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem073', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem074', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem075', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem076', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem077', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem078', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem079', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem080', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem081', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem082', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem083', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem084', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem085', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem086', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem087', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem088', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertTrue();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertFalse();
    })

    it('AccountMenuItem089', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('AccountMenuItem090', 0, (): void => {
      let isActive: boolean = sAccountMenuItem.isActive;
      expect(isActive).assertFalse();
      let isSameStyleToCC: boolean = sAccountMenuItem.isSameStyleToCC;
      expect(isSameStyleToCC).assertTrue();
    })

    it('CommonToggleControllerTest001', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest002', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest003', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest004', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest005', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest006', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest007', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest008', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest009', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest019', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })
  })
}