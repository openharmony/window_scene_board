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
  when
} from '@ohos/hypium';
import { DeviceHelper, FileUtils } from '@ohos/basiccommon';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import {
  IconEditViewModel,
  FOLDER_EXPAND_ICONS,
  PATH_ICONS,
  FORMAT_PNG,
  FORMAT_WEBP
} from '../../../../main/ets/uiExtension/viewmodel/IconEditViewModel';
import { EditModeConstants, WantParams } from '../../../../main/ets/default/common/constants/EditModeConstants';
import IconEditPageConstants from '../../../../main/ets/default/common/constants/IconEditPageConstants';
import { AppIconrelative } from '../../../../main/ets/default/viewmodel/AppIconrelative';

export function AppIconrelativeTest() {
  describe('AppIconrelativeTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('fake_rest_getIconArray_01', 0, () => {
      const iconEditViewModel = new AppIconrelative();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_01', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_02', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_03', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_04', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_05', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_06', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_07', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_08', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_08', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_08', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_08', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_08', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_09', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_09', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_09', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_09', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_09', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_10', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_10', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_10', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_10', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_10', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_11', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_11', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_11', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_11', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_11', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_12', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_12', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_12', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_12', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_12', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_13', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_13', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_13', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_13', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_13', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_14', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_14', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_14', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_14', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_14', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_15', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_15', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_15', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_15', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_15', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_16', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_16', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_16', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_16', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_16', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_17', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_17', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_17', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_17', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_17', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_18', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_18', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_18', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_18', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_18', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_19', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_19', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_19', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_19', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_19', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_20', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_20', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_20', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_20', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_20', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_21', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_21', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_21', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_21', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_21', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_22', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_22', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_22', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_22', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_22', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_23', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_23', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_23', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_23', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_23', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_24', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_24', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_24', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_24', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_24', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })

    it('fake_rest_getIconArray_25', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      expect(iconEditViewModel.getIconArray(true)).assertDeepEquals(FOLDER_EXPAND_ICONS);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_getPreviewContentWidth_25', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      const wantParams: WantParams = new WantParams();
      wantParams.gridWidth = 1;
      expect(iconEditViewModel.getPreviewContentWidth(wantParams, true)).assertEqual(2);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('fake_rest_dealWantParms_25', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const pageInfos: NavPathStack = new NavPathStack();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(pageInfos, pageInfos.getParamByName);
      const wantParams: WantParams = new WantParams();
      wantParams.rows = 0;
      wantParams.columns = 0;
      wantParams.session = {} as UIExtensionContentSession;
      when(mockFunc)(EditModeConstants.PATH_ICON).afterReturn([wantParams]);
      const newWantParams: WantParams = new WantParams();
      newWantParams.session = {} as UIExtensionContentSession;
      expect(iconEditViewModel.dealWantParams(pageInfos)).assertDeepEquals(newWantParams);
      mocker.clear(pageInfos);
      mocker.clearAll();
    })

    it('fake_rest_calculatePreviewHeight_25', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const wantParams: WantParams = new WantParams();
      wantParams.screenHeight = IconEditPageConstants.ICON_EDIT_TITLE_HEIGHT;
      expect(iconEditViewModel.calculatePreviewHeight(wantParams, 0)).assertEqual(0);
    })

    it('fake_rest_createRelativePath_25', 0, () => {
      const iconEditViewModel = new IconEditViewModel();
      const uri = 'file://com.ohos.sceneboard';
      const mocker1: MockKit = new MockKit();
      const mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      let backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_PNG;
      when(mockFunc1)(backPath).afterReturn(true);
      const mocker2: MockKit = new MockKit();
      const mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.getUriFromPath);
      let backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      let forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_PNG;
      when(mockFunc1)(forePath).afterReturn(true);
      let foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);

      when(mockFunc1)(backPath).afterReturn(false);
      backPath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_BACK_PATH + FORMAT_WEBP;
      backUri = uri + backPath;
      when(mockFunc2)(backPath).afterReturn(backUri);
      when(mockFunc1)(forePath).afterReturn(false);
      forePath = EditModeConstants.FILE_SEPARATOR + PATH_ICONS + EditModeConstants.FILE_SEPARATOR +
      EditModeConstants.FAKE_ICON_FORE_PATH + FORMAT_WEBP;
      foreUri = uri + forePath;
      when(mockFunc2)(forePath).afterReturn(foreUri);
      expect(iconEditViewModel.createRelativePath('', '')).assertDeepEquals([backUri, foreUri]);
    })
  })
}