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
  expect,
  it,
  Level,
  MockKit,
  when,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll
} from '@ohos/hypium';
import { EditModeViewManager } from '../../../../main/ets/default/manager/EditModeViewManager';
import { EditModeViewAnimate } from '../../../../main/ets/default/viewmodel/EditModeViewAnimate';
import { EditModeViewEvent } from '../../../../main/ets/default/viewmodel/EditModeViewEvent';
import { EditModeGridSwiperViewData } from '../../../../main/ets/default/data/EditModeGridSwiperViewData';
import { EditModeSingePageViewData } from '../../../../main/ets/default/data/EditModeSingePageViewData';
import { EditModeWallpaperViewData } from '../../../../main/ets/default/data/EditModeWallpaperViewData';
import { IconEditWantData } from '../../../../main/ets/default/data/IconEditWantData';
import { EditModeExtensionData } from '../../../../main/ets/default/data/EditModeExtensionData';
import IconEditPageConstants from '../../../../main/ets/default/common/constants/IconEditPageConstants';
import { GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { CommonConstants, CardItemInfo } from '@ohos/launchercommon';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { SCBScreenSessionManager } from '@ohos/windowscene';

export function EditModeViewManagerTest() {
  describe('EditModeViewManagerTest', (): void => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_EditModeViewManagerTest_01', Level.LEVEL0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeViewAni = editModeViewManager.getEditModeViewAnimate();
      expect(editModeViewAni instanceof EditModeViewAnimate).assertTrue();

      const editModeGridSwiperViewData = editModeViewManager.getEditModeGridSwiperViewData();
      expect(editModeGridSwiperViewData instanceof EditModeGridSwiperViewData).assertTrue();

      const event = editModeViewManager.getEditModeViewEvent();
      expect(event instanceof EditModeViewEvent).assertTrue();

      const editModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
      expect(editModeSingePageViewData instanceof EditModeSingePageViewData).assertTrue();

      const editModeWallpaperViewData = editModeViewManager.getEditModeWallpaperViewData();
      expect(editModeWallpaperViewData instanceof EditModeWallpaperViewData).assertTrue();
    })

    it('test_EditModeViewManagerTest_02', Level.LEVEL0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.uninstallApp()).assertFalse();
      const g = new GridLayoutItemInfo();
      g.bundleName = 'key';
      g.isUninstallAble = true;
      expect(editModeViewManager.uninstallApp(g)).assertTrue();
    })

    it('test_EditModeViewManagerTest_03', Level.LEVEL0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.findItem()).assertUndefined();
      const g = new GridLayoutItemInfo();
      g.id = 123;
      g.typeId = CommonConstants.TYPE_APP;
      g.keyName = "keyName";
      expect(editModeViewManager.findItem(g)).assertUndefined();
    })

    it('test_EditModeViewManagerTest_04', Level.LEVEL0, () => {
      const editModeViewManager = new EditModeViewManager();
      editModeViewManager.onDesktopModeChange();
      expect(editModeManager.getDesktopMode()).assertEqual(0);
      AppStorage.setOrCreate('screenWidth', 100);
      editModeManager.changeDesktopMode(1);
      editModeViewManager.onDesktopModeChange();
      expect(editModeManager.getDesktopMode()).assertEqual(1);
      AppStorage.clear();
    })

    it('test_getIconEditWantData', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_01', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_02', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_03', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_03', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_03', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_03', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_03', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_03', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_03', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_04', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_04', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_04', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_04', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_04', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_04', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_04', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_05', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_05', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_05', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_05', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_05', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_05', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_05', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_06', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_06', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_06', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_06', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_06', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_06', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_06', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_07', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_07', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_07', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_07', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_07', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_07', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_07', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_08', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_08', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_08', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_08', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_08', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_08', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_08', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_09', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_09', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_09', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_09', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_09', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_09', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_09', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_10', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_10', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_10', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_10', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_10', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_10', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_10', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_11', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_12', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_12', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_12', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_12', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_12', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_12', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_12', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_13', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_13', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_13', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_13', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_13', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_13', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_13', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_14', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_14', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_14', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_14', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_14', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_14', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_14', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_15', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_15', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_15', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_15', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_15', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_15', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_15', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_16', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_16', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_16', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_16', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_16', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_16', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_16', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_17', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_17', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_17', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_17', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_17', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_17', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_17', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_18', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_18', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_18', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_18', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_18', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_18', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_18', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_19', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_19', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_19', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_19', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_19', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_19', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_19', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_20', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_20', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_20', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_20', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_20', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_20', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_20', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_21', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_21', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_21', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_21', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_21', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_21', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_21', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_22', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_22', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_22', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_22', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_22', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_22', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_22', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_23', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_23', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_23', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_23', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_23', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_23', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_23', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_24', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_24', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_24', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_24', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_24', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_24', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_24', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_25', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_25', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_25', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_25', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_25', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_25', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_25', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_26', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_26', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_26', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_26', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_26', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_26', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_26', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_27', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_27', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_27', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_27', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_27', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_27', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_27', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_28', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_28', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_28', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_28', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_28', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_28', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_28', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })

    it('test_getIconEditWantData_29', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
      expect(iconEditWantData).assertEqual(editModeViewManager.getIconEditWantData());
    })

    it('test_getEditModeExtensionData_29', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
      expect(editModeExtensionData).assertEqual(editModeViewManager.getEditModeExtensionData());
    })

    it('test_notifyWhiteBoxShowOrHide_29', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const SCBScreenSessionManagerInstance = SCBScreenSessionManager.getInstance();
      const mockFunc: Function =
        mocker.mockFunc(SCBScreenSessionManagerInstance, SCBScreenSessionManagerInstance.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(editModeViewManager.notifyWhiteBoxShowOrHide(true) === undefined).assertTrue();
      mocker.clear(SCBScreenSessionManagerInstance);
      mocker.clearAll();
    })

    it('test_isShowUIExtension_29', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.isShowUIExtension()).assertFalse();
    })

    it('test_openUIExtension_29', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      expect(editModeViewManager.openUIExtension() === undefined).assertTrue();
    })

    it('test_exitUIExtension_29', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const mocker: MockKit = new MockKit();
      const iconEditWantData = editModeViewManager.getIconEditWantData();
      const mockFunc: Function = mocker.mockFunc(iconEditWantData, iconEditWantData.getExtensionWant);
      when(mockFunc)().afterReturn({
        bundleName: 'com.ohos.security.privacycenter',
        abilityName: IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME,
      });
      expect(editModeViewManager.exitUIExtension(false) === undefined).assertTrue();
      expect(editModeViewManager.exitUIExtension(true) === undefined).assertTrue();
      mocker.clear(iconEditWantData);
      mocker.clearAll();
    })

    it('it_getAddFormPosition_29', 0, () => {
      const editModeViewManager = new EditModeViewManager();
      const formInfo = new CardItemInfo();
      formInfo.page = 0;
      formInfo.column = 0;
      formInfo.row = 0;
      formInfo.area = [1, 1];
      expect(editModeViewManager.getAddFormPosition(formInfo))
        .assertDeepEquals([54.08571428571429, 143.47211822660097]);
    })
  })
}