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
import common from '@ohos.app.ability.common';
import { CheckEmptyUtils, FileUtils } from '@ohos/basicutils';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { DesktopParam } from '@ohos/launchercommon';
import { IconEditViewModel } from '../../../../main/ets/uiExtension/viewmodel/IconEditViewModel';
import { EditModeConstants, WantParams } from '../../../../main/ets/default/common/constants/EditModeConstants';
import IconEditPageConstants from '../../../../main/ets/default/common/constants/IconEditPageConstants';
import { i18n } from '@kit.LocalizationKit';

export function IconEditViewModelTest() {
  describe('IconEditViewModelTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_setGet', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let isLoading: boolean = true;
      iconEditViewModel.setApplyLoading(isLoading);
      iconEditViewModel.getShowNameState();
      iconEditViewModel.getIconChangeSizeData();
      iconEditViewModel.getPreviewPathData();
      iconEditViewModel.getIconEditPageData();
      expect(iconEditViewModel.isApplyLoading()).assertEqual(isLoading);
    })

    it('test_updateShowAppName', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let oriIsShowName: boolean = false;
      let isNameShow: boolean = false;
      let ret: boolean = iconEditViewModel.updateShowAppName(oriIsShowName, isNameShow, uiContext);
      expect(ret).assertFalse();
      oriIsShowName = false;
      isNameShow = true;
      ret = iconEditViewModel.updateShowAppName(oriIsShowName, isNameShow, uiContext);
      expect(ret).assertTrue();
    })

    it('test_updateIconChangeSize', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let oriSize: number = 0;
      let size: number = 0;
      let ret: boolean = iconEditViewModel.updateIconChangeSize(oriSize, size, uiContext);
      expect(ret).assertFalse();
      oriSize = 0;
      size = 1;
      ret = iconEditViewModel.updateIconChangeSize(oriSize, size, uiContext);
      expect(ret).assertTrue();
    })

    it('test_getPreviewContentWidthFoldExpanded', 0, () => {
      let isPhone = false;
      let isPad = false;
      let isLandscape = false;
      let isFoldExpanded = true;
      const gridWidth: number = 100;
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.gridWidth = gridWidth;

      const iconEditViewModel = new IconEditViewModel();
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      expect(iconEditViewModel.getPreviewContentWidth(wantParams)).assertEqual(gridWidth * 2);
      expect(iconEditViewModel.getIconArray(2, 4)).assertDeepEquals(EditModeConstants.FOLDER_EXPAND_ICONS);
    })

    it('test_getPreviewContentWidthElse', 0, () => {
      let isPhone = false;
      let isPad = false;
      let isLandscape = false;
      let isFoldExpanded = false;
      const gridWidth: number = 100;
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.gridWidth = gridWidth;

      const iconEditViewModel = new IconEditViewModel();
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      expect(iconEditViewModel.getPreviewContentWidth(wantParams)).assertEqual(gridWidth);
      expect(iconEditViewModel.getIconArray(2, 4)).assertDeepEquals(EditModeConstants.PHONE_ICONS);
    })

    it('test_getPreviewContentWidthPhone', 0, () => {
      let isPhone = true;
      let isPad = false;
      let isLandscape = false;
      let isFoldExpanded = false;
      const gridWidth: number = 100;
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.gridWidth = gridWidth;

      const iconEditViewModel = new IconEditViewModel();
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      expect(iconEditViewModel.getPreviewContentWidth(wantParams)).assertEqual(gridWidth);
      expect(iconEditViewModel.getIconArray(2, 4)).assertDeepEquals(EditModeConstants.PHONE_ICONS);
    })

    it('test_getPreviewContentWidthPad', 0, () => {
      let isPhone = false;
      let isPad = true;
      let isLandscape = false;
      let isFoldExpanded = false;
      const gridWidth: number = 100;
      const gridHeight: number = 200;
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.gridWidth = gridWidth;
      wantParams.gridHeight = gridHeight;

      const iconEditViewModel = new IconEditViewModel();
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      let rows: number = EditModeConstants.PAD_LANDSCAPE_ICONS.length;
      let columns: number = EditModeConstants.PAD_LANDSCAPE_ICONS[0].length;
      iconEditViewModel.getIconArray(rows, columns);
      expect(iconEditViewModel.getPreviewContentWidth(wantParams)).assertEqual(gridHeight);
    })

    it('test_getPreviewContentWidthPadLandScape', 0, () => {
      let isPhone = false;
      let isPad = true;
      let isLandscape = true;
      let isFoldExpanded = false;
      const gridWidth: number = 100;
      const gridHeight: number = 200;
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.gridWidth = gridWidth;
      wantParams.gridHeight = gridHeight;

      const iconEditViewModel = new IconEditViewModel();
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      let rows: number = EditModeConstants.PAD_LANDSCAPE_ICONS.length;
      let columns: number = EditModeConstants.PAD_LANDSCAPE_ICONS[0].length;
      iconEditViewModel.getIconArray(rows, columns);
      expect(iconEditViewModel.getPreviewContentWidth(wantParams)).assertEqual(gridWidth);
    })

    it('test_dealParms', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.screenHeight  = 500;
      wantParams.statusBarHeight  = 39;
      wantParams.rows  = 6;
      wantParams.columns  = 4;
      AppStorage.setOrCreate<DesktopParam>('desktopParam', wantParams);
      const pageInfos: NavPathStack = new NavPathStack();
      expect(iconEditViewModel.dealDesktopParam(pageInfos).screenHeight).assertEqual(500);
      expect(iconEditViewModel.dealDesktopParam(pageInfos).statusBarHeight).assertEqual(39);
    })

    it('test_createRelativePath', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath =
        EditModeConstants.FILE_SEPARATOR + EditModeConstants.PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
        EditModeConstants.FAKE_ICON_BACK_PATH + EditModeConstants.FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath =
        EditModeConstants.FILE_SEPARATOR + EditModeConstants.PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
        EditModeConstants.FAKE_ICON_FORE_PATH + EditModeConstants.FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + EditModeConstants.PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + EditModeConstants.FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + EditModeConstants.PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + EditModeConstants.FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
      mocker1.clear(FileUtils);
      mocker1.clearAll();
      mocker2.clear(FileUtils);
      mocker2.clearAll();
    })

    it('test_calculateIndex', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      expect(iconEditViewModel.calculateIndex(1, 2)).assertEqual(IconEditPageConstants.APP_IMAGE_SIZE_SMALL_INDEX);
      expect(iconEditViewModel.calculateIndex(2, 1)).assertEqual(IconEditPageConstants.APP_IMAGE_SIZE_LARGE_INDEX);
      expect(iconEditViewModel.calculateIndex(1, 1)).assertEqual(IconEditPageConstants.APP_IMAGE_SIZE_NORMAL_INDEX);
    })

    it('test_calculatePreviewHeight', 0, () => {
      let bottomSheetHeight: number = 10;
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.vp2pxScale = 1;
      wantParams.screenHeight  = 500;
      wantParams.statusBarHeight  = 39;
      wantParams.rows  = 6;
      wantParams.columns  = 4;
      const pageInfos: NavPathStack = new NavPathStack();
      AppStorage.setOrCreate<DesktopParam>('desktopParam', wantParams);
      iconEditViewModel.dealDesktopParam(pageInfos);
      expect(iconEditViewModel.calculateScrollHeight(wantParams, bottomSheetHeight)).assertLargerOrEqual(0);
    })

    it('test_getApplyButtonWidth', 0, () => {
      let isPhone = true;
      let isPad = false;
      let isLandscape = false;
      let isFoldExpanded = false;
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.screenWidth  = 100;

      const iconEditViewModel = new IconEditViewModel();
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      expect(iconEditViewModel.getApplyButtonWidth(wantParams)).assertEqual('100%');

      isPhone = false;
      isFoldExpanded = true;
      isPad = true;
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      iconEditViewModel.getApplyButtonWidth(wantParams);


      isPhone = false;
      isFoldExpanded = true;
      isPad = true;
      isLandscape = true;
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      iconEditViewModel.getApplyButtonWidth(wantParams);

      isPhone = false;
      isFoldExpanded = true;
      isPad = false;
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      iconEditViewModel.getApplyButtonWidth(wantParams);
    })

    it('test_getBottomSheetWidth', 0, () => {
      let isPhone = false;
      let isPad = false;
      let isLandscape = false;
      let isFoldExpanded = false;
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.screenWidth  = 100;

      const iconEditViewModel = new IconEditViewModel();
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      expect(iconEditViewModel.getBottomSheetWidth(wantParams)).assertEqual('100%');
    })

    it('test_getBottomSheetWidthPad', 0, () => {
      let isPhone = false;
      let isPad = true;
      let isLandscape = false;
      let isFoldExpanded = false;

      const wantParams: DesktopParam = new DesktopParam();
      wantParams.screenWidth  = IconEditPageConstants.GRID_LARGE_SIZE + 1;
      const iconEditViewModel = new IconEditViewModel();
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      expect(iconEditViewModel.getBottomSheetWidth(wantParams)).assertContain('px');

      wantParams.screenWidth  = IconEditPageConstants.GRID_MEDIUM_SIZE + 1;
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      expect(iconEditViewModel.getBottomSheetWidth(wantParams)).assertContain('px');

      wantParams.screenWidth  = IconEditPageConstants.GRID_SMALL_SIZE + 1;
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      expect(iconEditViewModel.getBottomSheetWidth(wantParams)).assertContain('px');

      wantParams.screenWidth  = IconEditPageConstants.GRID_SMALL_SIZE;
      iconEditViewModel.initDeviceInfo(isPhone, isPad, isLandscape, isFoldExpanded);
      expect(iconEditViewModel.getBottomSheetWidth(wantParams)).assertContain('px');
    })

    it('test_dataReceiveCallback', 0, () => {
      let data: Record<string, Object> = {
        'backEvent': true
      };
      const iconEditViewModel = new IconEditViewModel();
      iconEditViewModel.setApplyLoading(true);
      let res1 = iconEditViewModel.dataReceiveCallback(data);
      expect(res1 !== null).assertTrue();

      iconEditViewModel.setApplyLoading(false);
      let res2 = iconEditViewModel.dataReceiveCallback(data);
      expect(res2 !== null).assertTrue();
    })

    it('test_getAppInfo', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      expect(iconEditViewModel.getAppInfo('settings')).assertEqual(EditModeConstants.APP_INFOS['settings']);
      expect(iconEditViewModel.getAppInfo('')).assertEqual(EditModeConstants.APP_INFOS.settings);
    })

    it('test_getBottomSheetViewManager_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res: object = (iconEditViewModel as object)['getBottomSheetViewManager'](2000)
      expect(res !== null).assertTrue()
    })

    it('test_getBottomSheetViewManager_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res: object = (iconEditViewModel as object)['getBottomSheetViewManager'](1000)
      expect(res !== null).assertTrue()
    })

    it('test_getBottomSheetViewManager_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res: object = (iconEditViewModel as object)['getBottomSheetViewManager'](700)
      expect(res !== null).assertTrue()
    })

    it('test_getBottomSheetViewManager_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res: object = (iconEditViewModel as object)['getBottomSheetViewManager'](200)
      expect(res !== null).assertTrue()
    })

    it('test_getMixColor_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.getMixColor(1, false)
      expect(res !== null).assertTrue()
    })

    it('test_getMixColor_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.getMixColor(4, true)
      expect(res !== null).assertTrue()
    })

    it('test_getMixColor_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.getMixColor(5, true)
      expect(res !== null).assertTrue()
    })

    it('test_getMixColor_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.getMixColor(6, true)
      expect(res !== null).assertTrue()
    })

    it('test_getMixColor_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.getMixColor(8, true)
      expect(res).assertEqual('')
    })

    it('test_getMixColor_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.getMixColor(6, false)
      expect(res).assertEqual('')
    })

    it('test_getMixColor_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.getMixColor(1, true)
      expect(res).assertEqual('')
    })

    it('test_freePixmap_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let res = iconEditViewModel.freePixmap()
      expect(res !== null).assertTrue()
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.clearAll();
    })

    it('test_freePixmap_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let res = iconEditViewModel.freePixmap()
      expect(res !== null).assertTrue()
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.clearAll();
    })

    it('test_createPixmap_01', 0, async () => {
      const iconEditViewModel = new IconEditViewModel();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let res = await iconEditViewModel.createPixmap()
      expect(res !== null).assertTrue()
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.clearAll();
    })

    it('test_createPixmap_02', 0, async () => {
      const iconEditViewModel = new IconEditViewModel();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let res = await iconEditViewModel.createPixmap()
      expect(res !== null).assertTrue()
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.clearAll();
    })

    it('test_updateIconNameShadow_01', 0, async () => {
      const iconEditViewModel = new IconEditViewModel();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let res = await iconEditViewModel.updateIconNameShadow('', '')
      expect(res !== null).assertTrue()
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.clearAll();
    })

    it('test_updateIconNameShadow_02', 0, async () => {
      const iconEditViewModel = new IconEditViewModel();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let res = await iconEditViewModel.updateIconNameShadow('', '')
      expect(res !== null).assertTrue()
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.clearAll();
    })

    it('test_updateIconNameShadow_03', 0, async () => {
      const iconEditViewModel = new IconEditViewModel();
      (iconEditViewModel as object)['mDesktopParam'] = new DesktopParam();
      (iconEditViewModel as object)['mDesktopParam'].isNeedAppNameShadow = false
      let res = await iconEditViewModel.updateIconNameShadow('', '')
      expect(res !== null).assertTrue()
    })

    it('test_updateIconNameShadow_04', 0, async () => {
      const iconEditViewModel = new IconEditViewModel();
      (iconEditViewModel as object)['mDesktopParam'] = new DesktopParam();
      (iconEditViewModel as object)['mDesktopParam'].isNeedAppNameShadow = true
      let res = await iconEditViewModel.updateIconNameShadow('', '')
      expect(res !== null).assertTrue()
    })

    it('test_getDesktopParam_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.getDesktopParam()
      expect(res !== null).assertTrue()
    })

    it('test_initThemeResource_01', 0, async () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = await iconEditViewModel.initThemeResource('')
      expect(res !== null).assertTrue()
    })

    it('test_initThemeResource_02', 0, async () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = await iconEditViewModel.initThemeResource('checkedPath')
      expect(res !== null).assertTrue()
    })

    it('test_dealDesktopParam_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.isSimpleMode  = true;
      AppStorage.setOrCreate<DesktopParam>('desktopParam', wantParams);
      const pageInfos: NavPathStack = new NavPathStack();
      let res = iconEditViewModel.dealDesktopParam(pageInfos)
      expect(res !== null).assertTrue()
    })

    it('test_dealDesktopParam_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.iconChangeSize  = 5;
      AppStorage.setOrCreate<DesktopParam>('desktopParam', wantParams);
      const pageInfos: NavPathStack = new NavPathStack();
      let res = iconEditViewModel.dealDesktopParam(pageInfos)
      expect(res !== null).assertTrue()
    })

    it('test_dealDesktopParam_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: DesktopParam = new DesktopParam();
      wantParams.isFoldExpandedInLandscape  = true;
      AppStorage.setOrCreate<DesktopParam>('desktopParam', wantParams);
      const pageInfos: NavPathStack = new NavPathStack();
      let res = iconEditViewModel.dealDesktopParam(pageInfos)
      expect(res !== null).assertTrue()
    })

    it('test_getIconArray_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      (iconEditViewModel as object)['mDesktopParam'].isSimpleMode = true
      let res = iconEditViewModel.getIconArray(2,4)
      expect(res !== null).assertTrue()
    })

    it('test_updateShowAppName_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let oriIsShowName: boolean = false;
      let isNameShow: boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.setSecureValue);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let res = iconEditViewModel.updateShowAppName(oriIsShowName, isNameShow, uiContext)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.setSecureValue);
      mocker.clearAll();
    })

    it('test_updateShowAppName_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let oriIsShowName: boolean = false;
      let isNameShow: boolean = false;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.setSecureValue);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let res = iconEditViewModel.updateShowAppName(oriIsShowName, isNameShow, uiContext)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.setSecureValue);
      mocker.clearAll();
    })

    it('test_updateIconChangeSize_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.setSecureValue);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let res = iconEditViewModel.updateIconChangeSize(1, 1, uiContext)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.setSecureValue);
      mocker.clearAll();
    })

    it('test_updateIconChangeSize_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.setSecureValue);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let res = iconEditViewModel.updateIconChangeSize(1, 1, uiContext)
      expect(res !== null).assertTrue()
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.setSecureValue);
      mocker.clearAll();
    })

    it('test_getSpaceOfScreenSize_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let desktopParam: DesktopParam = new DesktopParam();
      let res: number = iconEditViewModel.getSpaceOfScreenSize(desktopParam)
      expect(res !== null).assertTrue()
    })

    it('test_dataReceiveCallback_01', 0, () => {
      let data: Record<string, Object> = {
        'backEvent': true
      };
      const iconEditViewModel = new IconEditViewModel();
      (iconEditViewModel as object)['isLoading'] = true
      let res = iconEditViewModel.dataReceiveCallback(data)
      expect(res !== null).assertTrue()
    })

    it('test_dataReceiveCallback_02', 0, () => {
      let data: Record<string, Object> = {
        'backEvent': true
      };
      const iconEditViewModel = new IconEditViewModel();
      (iconEditViewModel as object)['isLoading'] = false
      let res = iconEditViewModel.dataReceiveCallback(data)
      expect(res !== null).assertTrue()
    })

    it('test_dataReceiveCallback_03', 0, () => {
      let data: Record<string, Object> = {
        'showEvent': true
      };
      const iconEditViewModel = new IconEditViewModel();
      (iconEditViewModel as object)['isLoading'] = false
      let res = iconEditViewModel.dataReceiveCallback(data)
      expect(res !== null).assertTrue()
    })

    it('test_sendAccessibilityEvent_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      (iconEditViewModel as object)['isAccessibilityMode'] = true
      let res = iconEditViewModel.sendAccessibilityEvent('')
      expect(res !== null).assertTrue()
    })

    it('test_sendAccessibilityEvent_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      (iconEditViewModel as object)['isAccessibilityMode'] = false
      let res = iconEditViewModel.sendAccessibilityEvent('')
      expect(res !== null).assertTrue()
    })

    it('test_initIconSize_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.initIconSize(1)
      expect(res !== null).assertTrue()
    })

    it('test_onIconSizeSliderChange_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let mode:SliderChangeMode = 2;
      let res = iconEditViewModel.onIconSizeSliderChange(1,mode)
      expect(res !== null).assertTrue()
    })

    it('test_onIconSizeSliderChange_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let mode:SliderChangeMode = 2;
      (iconEditViewModel as object)['defaultIconSizeOffset'] = 1
      let res = iconEditViewModel.onIconSizeSliderChange(1,mode)
      expect(res !== null).assertTrue()
    })

    it('test_onIconSizeSliderSizeChange_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let size: SizeOptions = {};
      (iconEditViewModel as object)['mDesktopParam'].isRTL = true;
      let res = iconEditViewModel.onIconSizeSliderSizeChange(size,size,1,2)
      expect(res !== null).assertTrue()
    })

    it('test_onIconSizeSliderSizeChange_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let size: SizeOptions = {};
      (iconEditViewModel as object)['mDesktopParam'].isRTL = false;
      let res = iconEditViewModel.onIconSizeSliderSizeChange(size,size,1,2)
      expect(res !== null).assertTrue()
    })

    it('test_isNeedShadowInSpecialBg_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let desktopParam = new DesktopParam();
      let res = iconEditViewModel.isNeedShadowInSpecialBg(desktopParam)
      expect(res !== null).assertTrue()
    })

    it('test_iconEditProperty_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.iconEditProperty
      expect(res !== null).assertTrue()
    })

    it('test_getIconRadius_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      let res = iconEditViewModel.getIconRadius()
      expect(res !== null).assertTrue()
    })

    it('test_getScreenMargin_01', 0, async () => {
      const iconEditViewModel = new IconEditViewModel();
      (iconEditViewModel as object)['isFoldExpanded'] = false;
      (iconEditViewModel as object)['mDesktopParam'] = new DesktopParam();
      (iconEditViewModel as object)['mDesktopParam'].mMargin = 1;
      (iconEditViewModel as object)['mDesktopParam'].isRTL = true;
      let res1 = iconEditViewModel.getScreenMargin(2, 8)
      expect(res1.right).assertEqual(0);

      (iconEditViewModel as object)['isFoldExpanded'] = true;
      let res2 = iconEditViewModel.getScreenMargin(2, 8)
      expect(res2.right).assertEqual(0);

      let res3 = iconEditViewModel.getScreenMargin(4, 8)
      expect(res3.right).assertEqual(2);

      (iconEditViewModel as object)['mDesktopParam'].isRTL = false;
      let res4 = iconEditViewModel.getScreenMargin(4, 8)
      expect(res4.left).assertEqual(2);
    })

    it('test_getAppNameFontSize', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mDesktopParam = iconEditViewModel.getDesktopParam();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(iconEditViewModel, iconEditViewModel.getIgnoreShowZoomSize);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(10);

      mDesktopParam.isSimpleMode = true;
      expect(iconEditViewModel.getAppNameFontSize()).assertEqual('10vp');
      mDesktopParam.isSimpleMode = false;
      expect(iconEditViewModel.getAppNameFontSize()).assertEqual(10);

      mocker.clear(iconEditViewModel);
      mocker.clearAll();
    })

    it('test_getAppNameFontSize', 0, async () => {
      const iconEditViewModel = new IconEditViewModel();
      const language = i18n.System.getSystemLanguage();
      i18n.System.setSystemLanguage('ug');
      await sleep(1000);
      expect(iconEditViewModel.getScaleSize(12, 1.45)).assertEqual('15.6vp');
      i18n.System.setSystemLanguage(language);
      await sleep(1000);
      expect(iconEditViewModel.getScaleSize(12, 1.45)).assertEqual('17.4vp');
    })
  })
}

const sleep: Function = (ms: number): Promise<void> => {
  return new Promise(res => setTimeout(res, ms))
};