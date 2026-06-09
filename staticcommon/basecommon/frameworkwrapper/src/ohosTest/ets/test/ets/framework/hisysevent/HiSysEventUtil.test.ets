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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when, ArgumentMatchers, TestType, Size, Level} from '@ohos/hypium';
import { HiSysEventUtil } from '../../../../../../main/ets/hisysevent/HiSysEventUtil'
import { MoveIconInFolderBean, DragIconIntoFolderBean, FolderSizeModifyBean,
  OuterDesktopInformation,
  EditAodParams,
  LightIconInNotHarmonyFolderBean,
  ReturnToHomeParams
} from '../../../../../../main/ets/hisysevent/ReportParams'
import { DeviceHelper, PluginSlot } from '../../../../../../main/ets/TsIndex';

export function HiSysEventUtilTest() {
  describe('HiSysEventUtilTest', () => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })
    it('getFlashLightStatus_return_nothing', 0, () => {
      HiSysEventUtil.getInstance();
      expect(HiSysEventUtil.getFlashLightStatus('') === undefined ).assertTrue();
      expect(HiSysEventUtil.getFlashLightStatus(null) === undefined ).assertTrue();
    })

    it('HiSysEventUtilTest_getFlashLightStatus', 0, () => {
      HiSysEventUtil.getInstance();
      expect(HiSysEventUtil.getFlashLightStatus(undefined) === undefined ).assertTrue();
      HiSysEventUtil.getFlashLightStatus('on');
    })

    it('reportSoundClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiSysEventUtil.reportSoundClick() === undefined).assertTrue();
    })

    it('reportSystemClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiSysEventUtil.reportSystemClick() === undefined).assertTrue();
    })

    it('reportBatteryClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiSysEventUtil.reportBatteryClick() === undefined).assertTrue();
    })

    it('reportTrayClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiSysEventUtil.reportTrayClick() === undefined).assertTrue();
    })

    it('reportSoundMenu', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let name:number = 0;
      let eventType:string = '';
      let volume:number = 0;
      expect(HiSysEventUtil.reportSoundMenu(name, eventType, volume) === undefined).assertTrue();
    })

    it('reportSystemMenu', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let name:number = 0;
      let eventType:string = '';
      expect(HiSysEventUtil.reportSystemMenu(name, eventType) === undefined ).assertTrue();
    })

    it('reportInputMethod', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let name:number = 0;
      let inputMethod:string = '';
      let language:string = '';
      expect(HiSysEventUtil.reportInputMethod(name, inputMethod, language)=== undefined ).assertTrue();
    })

    it('getInstance', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiSysEventUtil.getInstance()).not().assertFail();
    })

    it('reportEvent', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let name: string = 'testname';
      let msg: Object = new Object();
      let domain = '';
      expect(HiSysEventUtil.reportEvent( name, msg, null, domain ) === undefined).assertTrue();
      name = 'ttttttttttttttttttttttttttttttttttttttttttttttt';
      expect(HiSysEventUtil.reportEvent( name ) === undefined).assertTrue();
    })

    it('getVersionName', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let bundleName: string = 'test'
      expect(HiSysEventUtil.getVersionName( bundleName )).assertInstanceOf('String');
      expect(HiSysEventUtil.getVersionName( null )).assertEqual('');
    })

    it('getRotationMode', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiSysEventUtil.getRotationMode()).assertInstanceOf('Number');
    })

    it('reportMoveIconInFolder', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let moveIconInFolderBean = new MoveIconInFolderBean();
      expect(HiSysEventUtil.reportMoveIconInFolder( moveIconInFolderBean ) === undefined).assertTrue();
      expect(HiSysEventUtil.reportMoveIconInFolder( null ) === undefined).assertTrue();
    })

    it('reportDragIconFromFolder', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let dragIconIntoFolderBean = new DragIconIntoFolderBean();
      expect(HiSysEventUtil.reportDragIconFromFolder( dragIconIntoFolderBean ) === undefined).assertTrue();
      expect(HiSysEventUtil.reportDragIconFromFolder( null ) === undefined).assertTrue();
    })

    it('reportMenuModifyFolderSize', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let folderSizeModifyBean = new FolderSizeModifyBean();
      expect(HiSysEventUtil.reportMenuModifyFolderSize( folderSizeModifyBean ) === undefined).assertTrue();
      expect(HiSysEventUtil.reportMenuModifyFolderSize( null ) === undefined).assertTrue();
    })

    it('reportWinDragToHotarea', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let testpkg = 'testpkg';
      let changedWindowMode = 1;
      expect(HiSysEventUtil.reportWinDragToHotarea( testpkg, changedWindowMode ) === undefined).assertTrue();
      changedWindowMode = 4;
      expect(HiSysEventUtil.reportWinDragToHotarea( testpkg, changedWindowMode ) === undefined).assertTrue();
    })

    it('reportCurrentWindowNum', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let currentwindownum:number = 123;
      expect(HiSysEventUtil.reportCurrentWindowNum( currentwindownum ) === undefined).assertTrue();
      expect(HiSysEventUtil.reportCurrentWindowNum( null ) === undefined).assertTrue();
    })
    it('HiSysEventUtilTest_reportEvent', 0, (): void => {
      HiSysEventUtil.reportEvent('mTest');
      expect(HiSysEventUtil.reportEvent('mTest', null) === undefined).assertTrue();
      HiSysEventUtil.reportEvent('');
      HiSysEventUtil.reportEvent('testNameOverLong_testNameOverLong_testNameOverLong_testNameOverLong');
    })

    it('HiSysEventUtilTest_getVersionName', 0, (): void => {
      expect(HiSysEventUtil.getVersionName('')).assertEqual('');
      try {
        HiSysEventUtil.getVersionName('mTest');
      } catch (e) {
      }
    })

    it('HiSysEventUtilTest_getRotationMode', 0, (): void => {
      AppStorage.set('isPortrait', false);
      expect(HiSysEventUtil.getRotationMode()).assertEqual(1);
      AppStorage.set('isPortrait', true);
      expect(HiSysEventUtil.getRotationMode()).assertEqual(0);
    })

    it('HiSysEventUtilTest_reportMoveIconInFolder', 0, (): void => {
      let isCalled: Boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(HiSysEventUtil, HiSysEventUtil.report);
      when(mockFunc)(ArgumentMatchers.any).afterAction(() => {
        isCalled = true
      })
      HiSysEventUtil.reportMoveIconInFolder(null);
      expect(isCalled).assertFalse();
      mocker.clear(HiSysEventUtil);
      mocker.clearAll();
    })

    it('HiSysEventUtilTest_reportDragIconFromFolder', 0, (): void => {
      let isCalled: Boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(HiSysEventUtil, HiSysEventUtil.report);
      when(mockFunc)(ArgumentMatchers.any).afterAction(() => {
        isCalled = true
      })
      HiSysEventUtil.reportDragIconFromFolder(null);
      HiSysEventUtil.reportMenuModifyFolderSize(null);
      expect(isCalled).assertFalse();
      mocker.clear(HiSysEventUtil);
      mocker.clearAll();
    })

    it('HiSysEventUtilTest_reportWinDragToHotarea', 0, (): void => {
      let isCalled: Boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(HiSysEventUtil, HiSysEventUtil.report);
      when(mockFunc)(ArgumentMatchers.any).afterAction(() => {
        isCalled = true
      })
      HiSysEventUtil.reportWinDragToHotarea('mTest', 4);
      expect(isCalled).assertFalse();
      HiSysEventUtil.reportWinDragToHotarea('mTest', 1);
      expect(isCalled).assertTrue();
      mocker.clear(HiSysEventUtil);
      mocker.clearAll();
    })

    it('HiSysEventUtilTest_reportCurrentWindowNum', 0, (): void => {
      let isCalled: Boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(HiSysEventUtil, HiSysEventUtil.report);
      when(mockFunc)(ArgumentMatchers.any).afterAction(() => {
        isCalled = true
      })
      HiSysEventUtil.reportCurrentWindowNum(Number('abc'));
      expect(isCalled).assertFalse();
      HiSysEventUtil.reportCurrentWindowNum(0);
      expect(isCalled).assertTrue();
      mocker.clear(HiSysEventUtil);
      mocker.clearAll();
    })

    it('HiSysEventUtilTest_hiSysOnIconItemClick', 0, (): void => {
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_BATTERY_PANEL) === undefined).assertTrue();
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_PERSONAL) === undefined).assertTrue();
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_SOUND_PANEL) === undefined).assertTrue();
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_INPUT_PANEL) === undefined).assertTrue();
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_WIFI_PANEL) === undefined).assertTrue();
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_CLOCK_PANEL) === undefined).assertTrue();

      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) === undefined).assertTrue();
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_CONTROL_CENTER) === undefined).assertTrue();
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_SEARCH) === undefined).assertTrue();
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL) === undefined).assertTrue();
      expect(HiSysEventUtil.hiSysOnIconItemClick('test') === undefined).assertTrue();
    })

    it('HiSysEventUtilTest_hiSysReadStorage', 0, (): void => {
      expect(HiSysEventUtil.hiSysReadStorage() === undefined).assertTrue();
    })

    it('HiSysEventUtilTest_reportBrightnessDownOrUp', 0, (): void => {
      expect(HiSysEventUtil.reportBrightnessDownOrUp(0, true) === undefined).assertTrue();
      expect(HiSysEventUtil.reportBrightnessDownOrUp(0, false) === undefined).assertTrue();
    })

    it('HiSysEventUtilTest_reportDeleteSingleApp', 0, (): void => {
      let bundleName = 'com.testApp';
      expect(HiSysEventUtil.reportOpenDeleteAppDialog(bundleName) === undefined).assertTrue();
      expect(HiSysEventUtil.reportDeleteApp(bundleName) === undefined).assertTrue();
    })

    it('HiSysEventUtilTest_reportOuterDesktopInformation', 0, (): void => {
      let testDesktopInformation: OuterDesktopInformation = {
        PNAMEID: '',
        PVERSIONID: '',
        ICON: 999,
        FA: 999,
        SCREEN: 2,
        FORMSTACK: 9,
        PRESETS_CARD_NUM: 9,
        PRESETS_STACK_NUM: 2,
        SHORTCUT_NUM: 9,
      };
      expect(HiSysEventUtil.reportOuterDesktopInformation(testDesktopInformation) === undefined).assertTrue();
    })

    it('HiSysEventUtilTest_setIntelligentSceneModeId', 0, (): void => {
      let ret = HiSysEventUtil.setIntelligentSceneModeId('0');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_getIntelligentSceneModeId', 0, (): void => {
      expect(HiSysEventUtil.getIntelligentSceneModeId() == '0').assertTrue();
    })

    it('HiSysEventUtilTest_reportSwitchEnterpriseMultiSpaceEvent_003', 0, (): void => {
      let ret = HiSysEventUtil.reportSwitchEnterpriseMultiSpaceEvent(1, 1, 'test', 1);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportQuickNoteClick_005', 0, (): void => {
      let ret = HiSysEventUtil.reportQuickNoteClick();
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_hiSysOnIconItemClick_006', 0, (): void => {
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_TRAY_PANEL) === undefined).assertTrue();
      expect(HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_QUICK_NOTE) === undefined).assertTrue();
    })

    it('HiSysEventUtilTest_reportLogoL_007', 0, (): void => {
      let ret = HiSysEventUtil.reportLogoL(1);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportSwitchingDesktopEvent_008', 0, (): void => {
      let ret = HiSysEventUtil.reportSwitchingDesktopEvent('test', 1);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportIconClick_009', 0, (): void => {
      let ret = HiSysEventUtil.reportIconClick(1, 'test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_hiSysWriteStorage_010', 0, (): void => {
      let ret = HiSysEventUtil.hiSysWriteStorage(1, 'test', () => {});
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_batchReport_011', 0, (): void => {
      let ret = HiSysEventUtil.batchReport('test', 'test', 1, []);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportToggle_012', 0, (): void => {
      let ret = HiSysEventUtil.reportToggle('test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportDockMenuBundles_013', 0, (): void => {
      let ret = HiSysEventUtil.reportDockMenuBundles('test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportDockMenuOpen_014', 0, (): void => {
      let ret = HiSysEventUtil.reportDockMenuOpen();
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportDockMenuAppClick_015', 0, (): void => {
      let ret = HiSysEventUtil.reportDockMenuAppClick();
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportDockRecentAppClick_016', 0, (): void => {
      let ret = HiSysEventUtil.reportDockRecentAppClick('test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportDockAdjustSplitLine_017', 0, (): void => {
      let ret = HiSysEventUtil.reportDockAdjustSplitLine(1,1);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportDockDeleteRecentApp_018', 0, (): void => {
      let ret = HiSysEventUtil.reportDockDeleteRecentApp('test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportDockRecentMenu_019', 0, (): void => {
      let ret = HiSysEventUtil.reportDockRecentMenu('test1', 'test2');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportKey_020', 0, (): void => {
      let ret = HiSysEventUtil.reportKey('test1');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportEventById_021', 0, (): void => {
      let ret = HiSysEventUtil.reportEventById('test1', 'test2');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportReturnToHome_022', 0, (): void => {
      let params: ReturnToHomeParams = {
        PNAMEID: '',
        PVERSIONID: '',
        FROM: 'APP',
        START_POS: [],
        END_POS: [],
        DEVICE_STATUS:  0,
        ORIENTATION: 1,
        CUR_BUNDLE_NAME: '',
        SCREEN_TYPE: 0,
        IS_MIDSCENE: 0,
      }
      let ret = HiSysEventUtil.reportReturnToHome(params);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportBackEvent_023', 0, (): void => {
      let ret = HiSysEventUtil.reportBackEvent('test1');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportIntoAppCenter_024', 0, (): void => {
      let ret = HiSysEventUtil.reportIntoAppCenter('test1');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportExitAppCenter_025', 0, (): void => {
      let ret = HiSysEventUtil.reportExitAppCenter('test1');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportClearSingleAppInRecent_026', 0, (): void => {
      let ret = HiSysEventUtil.reportClearSingleAppInRecent('test1', true);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportClearAllAppInRecent_027', 0, (): void => {
      let ret = HiSysEventUtil.reportClearAllAppInRecent([]);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportGoIntoAppByTitleInRecent_028', 0, (): void => {
      let ret = HiSysEventUtil.reportGoIntoAppByTitleInRecent('test1');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportGoIntoAppInRecent_029', 0, (): void => {
      let ret = HiSysEventUtil.reportGoIntoAppInRecent('test1');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportEditAodEvent_030', 0, (): void => {
      let ret = HiSysEventUtil.reportEditAodEvent(new EditAodParams());
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_updateGameEngineValidStatus_031', 0, (): void => {
      let ret = HiSysEventUtil.updateGameEngineValidStatus(HiSysEventUtil.GAME_ENGINE_BUNDLE_NAME);
      expect(ret == null).assertTrue();

      ret = HiSysEventUtil.updateGameEngineValidStatus('test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_getVersionCode_032', 0, (): void => {
      let ret: number = (HiSysEventUtil as object)['getVersionCode']('');
      expect(ret).assertEqual(-1);

      ret = (HiSysEventUtil as object)['getVersionCode'](HiSysEventUtil.GAME_ENGINE_BUNDLE_NAME);
      expect(ret).assertInstanceOf('Number');
    })

    it('HiSysEventUtilTest_reportReverseAddInFolder_033', 0, (): void => {
      let ret = HiSysEventUtil.reportReverseAddInFolder('test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportClickAppInDock_034', 0, (): void => {
      let ret = HiSysEventUtil.reportClickAppInDock('test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportClickAppInShortcut_035', 0, (): void => {
      let ret = HiSysEventUtil.reportClickAppInShortcut('test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportPauseAppDownload_036', 0, (): void => {
      let ret = HiSysEventUtil.reportPauseAppDownload('test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportContinueAppDownload_037', 0, (): void => {
      let ret = HiSysEventUtil.reportContinueAppDownload('test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportIntoAA_038', 0, (): void => {
      let ret = HiSysEventUtil.reportIntoAA();
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportRotationChange_039', 0, (): void => {
      let ret = HiSysEventUtil.reportRotationChange('', 1, 1, 'test');
      expect(ret == null).assertTrue();

      ret = HiSysEventUtil.reportRotationChange(HiSysEventUtil.GAME_ENGINE_BUNDLE_NAME, 1, 1, 'test');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportScreenLockQuickTool_040', 0, (): void => {
      let ret = HiSysEventUtil.reportScreenLockQuickTool([], 'test', 'test');
      expect(ret == null).assertTrue();

      ret = HiSysEventUtil.reportScreenLockQuickTool([HiSysEventUtil.GAME_ENGINE_BUNDLE_NAME], 'test', 'test');
      expect(ret == null).assertTrue();

      ret = HiSysEventUtil.reportScreenLockQuickTool([HiSysEventUtil.GAME_ENGINE_BUNDLE_NAME,'test','test'], 'test', 'test');
      expect(ret == null).assertTrue();
    })

    it('reportShowDesktopGestureEventTest_01', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let isShow: boolean = true;
      let isOneFingerSlip: boolean = true;
      expect(HiSysEventUtil.reportShowDesktopGestureEvent(isShow, isOneFingerSlip) === undefined).assertTrue();
    })

    it('reportShowDesktopGestureEventTest_02', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let isShow: boolean = false;
      let isOneFingerSlip: boolean = false;
      expect(HiSysEventUtil.reportShowDesktopGestureEvent(isShow, isOneFingerSlip) === undefined).assertTrue();
    })

    it('reportRestoreDesktopGestureEventTest_01', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let isRestore: boolean = true;
      let isExitRecent: boolean = true;
      expect(HiSysEventUtil.reportRestoreDesktopGestureEvent(isRestore, isExitRecent) === undefined).assertTrue();
    })

    it('reportRestoreDesktopGestureEventTest_02', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let isRestore: boolean = true;
      let isExitRecent: boolean = false;
      expect(HiSysEventUtil.reportRestoreDesktopGestureEvent(isRestore, isExitRecent) === undefined).assertTrue();
    })

    it('reportRestoreDesktopGestureEventTest_03', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let isRestore: boolean = false;
      let isExitRecent: boolean = true;
      expect(HiSysEventUtil.reportRestoreDesktopGestureEvent(isRestore, isExitRecent) === undefined).assertTrue();
    })

    it('reportRestoreDesktopGestureEventTest_04', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let isRestore: boolean = false;
      let isExitRecent: boolean = false;
      expect(HiSysEventUtil.reportRestoreDesktopGestureEvent(isRestore, isExitRecent) === undefined).assertTrue();
    })

    it('reportToRecentGestureEventTest_01', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let isToRecent: boolean = true;
      let isOneFingerSlip: boolean = true;
      expect(HiSysEventUtil.reportToRecentGestureEvent(isToRecent, isOneFingerSlip) === undefined).assertTrue();
    })

    it('reportToRecentGestureEventTest_02', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let isToRecent: boolean = false;
      let isOneFingerSlip: boolean = false;
      expect(HiSysEventUtil.reportToRecentGestureEvent(isToRecent, isOneFingerSlip) === undefined).assertTrue();
    })

    it('HiSysEventUtilTest_reportRecentSwiper_left', 0, () => {
      let ret = HiSysEventUtil.reportRecentSwiper('left');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportRecentSwiper_right', 0, () => {
      let ret = HiSysEventUtil.reportRecentSwiper('right');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportDeleteShortcutMenu', 0, () => {
      let ret = HiSysEventUtil.reportDeleteShortcutMenu('test', 'test');
      expect(ret == null).assertTrue();
      ret = HiSysEventUtil.reportDeleteShortcutMenu('', '');
      expect(ret == null).assertTrue();
      ret = HiSysEventUtil.reportDeleteShortcutMenu(null, null);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportDragIconIntoNotHarmonyFolder', 0, () => {
      let ret = HiSysEventUtil.reportDragIconIntoNotHarmonyFolder("test", true, 'test', 'test', 1);
      expect(ret == null).assertTrue();
      ret = HiSysEventUtil.reportDragIconIntoNotHarmonyFolder("test", true, null, 'test', 1);
      expect(ret == null).assertTrue();
      ret = HiSysEventUtil.reportDragIconIntoNotHarmonyFolder("test", true, '', 'test', 1);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportLightIconInNotHarmonyFolder', 0, () => {
      let lighticonInfo: LightIconInNotHarmonyFolderBean = new LightIconInNotHarmonyFolderBean();
      let ret = HiSysEventUtil.reportLightIconInNotHarmonyFolder(lighticonInfo);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportClickDeleteAppDialog', 0, () => {
      let ret = HiSysEventUtil.reportClickDeleteAppDialog('test', 1);
      expect(ret == null).assertTrue();
      ret = HiSysEventUtil.reportClickDeleteAppDialog(null, 1);
      expect(ret == null).assertTrue();
      ret = HiSysEventUtil.reportClickDeleteAppDialog('test', null);
      expect(ret == null).assertTrue();
      ret = HiSysEventUtil.reportClickDeleteAppDialog(null, null);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportRenameNotHarmonyFolder', 0, () => {
      let ret = HiSysEventUtil.reportRenameNotHarmonyFolder(1);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportAntiPeepingSwitch', 0, () => {
      let ret = HiSysEventUtil.reportAntiPeepingSwitch('test', 'test', 0);
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportPinchOpenGestureEvent_041', 0, (): void => {
      let ret = HiSysEventUtil.reportPinchOpenGestureEvent('', 1, '');
      expect(ret == null).assertTrue();
    })

    it('HiSysEventUtilTest_reportPinchCloseGestureEvent_042', 0, (): void => {
      let ret = HiSysEventUtil.reportPinchCloseGestureEvent('', 1, '');
      expect(ret == null).assertTrue();
    })
  })
}

