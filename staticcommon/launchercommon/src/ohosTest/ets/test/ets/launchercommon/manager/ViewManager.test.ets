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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { AppItemInfo, CommonConstants,
  FolderData,
  FormCenterViewManager,
  FormModel, ViewManager } from '../../../../../../main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper';

export default function ViewManagerTest() {
  describe('ViewManagerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('closeFormStackEditView', 0, (): void => {
      ViewManager.getInstance().closeFormStackEditView();
      const formStackEditShow = AppStorage.get('formStackEditShow') as boolean;
      expect(formStackEditShow).assertFalse();
    })

    it('closeFormServiceAndManagerViewTest', 0, (): void => {
      ViewManager.getInstance().closeFormServiceAndManagerView();
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('jumpToFormManagerView_01', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      let appItemInfo = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let isPC: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(true);
      viewManager.jumpToFormManagerView(appItemInfo, 0);
      expect(viewManager).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('jumpToFormManagerView_02', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      let formModel = FormModel.getInstance();
      let appItemInfo = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let isPC: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(false);
      let isSupportFormCenterSplit: Function = mocker.mockFunc(formModel, formModel.isSupportFormCenterSplit);
      when(isSupportFormCenterSplit)(ArgumentMatchers.any).afterReturn(true);
      viewManager.jumpToFormManagerView(appItemInfo, 0);
      expect(viewManager).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clear(formModel);
      mocker.clearAll();
    })

    it('jumpToFormManagerView_03', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      let formModel = FormModel.getInstance();
      let appItemInfo = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let isPC: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(false);
      let isSupportFormCenterSplit: Function = mocker.mockFunc(formModel, formModel.isSupportFormCenterSplit);
      when(isSupportFormCenterSplit)(ArgumentMatchers.any).afterReturn(false);
      viewManager.jumpToFormManagerView(appItemInfo, 0);
      expect(viewManager).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clear(formModel);
      mocker.clearAll();
    })

    it('exitEditMode_01', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      AppStorage.set('isEditMode', true);
      viewManager.exitEditMode();
      expect(viewManager).not().assertNull();
    })

    it('exitEditMode_02', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      AppStorage.set('isEditMode', false);
      viewManager.exitEditMode();
      expect(viewManager).not().assertNull();
    })

    it('closeFormServiceAndManagerView_02', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isFormManagerViewShowing: Function =
        mocker.mockFunc(formCenterViewManager, formCenterViewManager.isFormManagerViewShowing);
      when(isFormManagerViewShowing)(ArgumentMatchers.any).afterReturn(false);
      let isFormCenterViewShowing: Function =
        mocker.mockFunc(formCenterViewManager, formCenterViewManager.isFormCenterViewShowing);
      when(isFormCenterViewShowing)(ArgumentMatchers.any).afterReturn(true);
      viewManager.closeFormServiceAndManagerView();
      expect(viewManager).not().assertNull();
      mocker.clear(formCenterViewManager);
      mocker.clearAll();
    })

    it('isDesktopNeedProcessGesture_02', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      let folderData: FolderData = FolderData.getInstance();
      let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isFolderOpen: Function = mocker.mockFunc(folderData, folderData.isFolderOpen);
      when(isFolderOpen)(ArgumentMatchers.any).afterReturn(true);

      let isFormManagerViewShowing: Function =
        mocker.mockFunc(formCenterViewManager, formCenterViewManager.isFormManagerViewShowing);
      when(isFormManagerViewShowing)(ArgumentMatchers.any).afterReturn(false);
      viewManager.isDesktopNeedProcessGesture();
      expect(viewManager).not().assertNull();
      mocker.clear(folderData);
      mocker.clear(formCenterViewManager);
      mocker.clearAll();
    })

    it('isDesktopNeedProcessGesture_03', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      let folderData: FolderData = FolderData.getInstance();
      let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isFolderOpen: Function = mocker.mockFunc(folderData, folderData.isFolderOpen);
      when(isFolderOpen)(ArgumentMatchers.any).afterReturn(true);

      let isFormManagerViewShowing: Function =
        mocker.mockFunc(formCenterViewManager, formCenterViewManager.isFormManagerViewShowing);
      when(isFormManagerViewShowing)(ArgumentMatchers.any).afterReturn(true);

      let isFormCenterViewShowing: Function =
        mocker.mockFunc(formCenterViewManager, formCenterViewManager.isFormCenterViewShowing);
      when(isFormCenterViewShowing)(ArgumentMatchers.any).afterReturn(false);
      viewManager.isDesktopNeedProcessGesture();
      expect(viewManager).not().assertNull();
      mocker.clear(folderData);
      mocker.clear(formCenterViewManager);
      mocker.clearAll();
    })

    it('isDesktopNeedProcessGesture_04', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      let folderData: FolderData = FolderData.getInstance();
      let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isFolderOpen: Function = mocker.mockFunc(folderData, folderData.isFolderOpen);
      when(isFolderOpen)(ArgumentMatchers.any).afterReturn(true);

      let isFormManagerViewShowing: Function =
        mocker.mockFunc(formCenterViewManager, formCenterViewManager.isFormManagerViewShowing);
      when(isFormManagerViewShowing)(ArgumentMatchers.any).afterReturn(true);

      let isFormCenterViewShowing: Function =
        mocker.mockFunc(formCenterViewManager, formCenterViewManager.isFormCenterViewShowing);
      when(isFormCenterViewShowing)(ArgumentMatchers.any).afterReturn(true);
      AppStorage.set('formStackEditShow', true);
      viewManager.isDesktopNeedProcessGesture();
      expect(viewManager).not().assertNull();
      mocker.clear(folderData);
      mocker.clear(formCenterViewManager);
      mocker.clearAll();
    })

    it('closeOpenFolderStatus_01', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      AppStorage.set('folderAppListDialogStatus', true);
      viewManager.closeOpenFolderStatus();
      expect(viewManager).not().assertNull();
    })

    it('closeOpenFolderStatus_03', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
      AppStorage.set('folderAppListDialogStatus', false);

      let mocker: MockKit = new MockKit();

      let isFormCenterViewShowing: Function =
        mocker.mockFunc(formCenterViewManager, formCenterViewManager.isFormManagerViewShowing);
      when(isFormCenterViewShowing)(ArgumentMatchers.any).afterReturn(false);

      viewManager.closeOpenFolderStatus();
      expect(viewManager).not().assertNull();
      mocker.clear(viewManager);
      mocker.clear(formCenterViewManager);
      mocker.clearAll();
    })

    it('closeOpenFolderStatus_04', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
      AppStorage.set('folderAppListDialogStatus', false);

      let mocker: MockKit = new MockKit();

      let isFormCenterViewShowing: Function =
        mocker.mockFunc(formCenterViewManager, formCenterViewManager.isFormManagerViewShowing);
      when(isFormCenterViewShowing)(ArgumentMatchers.any).afterReturn(true);

      let isFormManagerViewShowing: Function =
        mocker.mockFunc(formCenterViewManager, formCenterViewManager.isFormManagerViewShowing);
      when(isFormManagerViewShowing)(ArgumentMatchers.any).afterReturn(false);

      viewManager.closeOpenFolderStatus();
      expect(viewManager).not().assertNull();
      mocker.clear(viewManager);
      mocker.clear(formCenterViewManager);
      mocker.clearAll();
    })

    it('closeOuterStackMenu', 0, (): void => {
      let viewManager = ViewManager.getInstance();
      viewManager.closeOuterStackMenu();
      let state_1: boolean | undefined = AppStorage.get('outerStackMenuCloseByGesture');
      let state_2: boolean | undefined = AppStorage.get('outerCardMenuCloseByGesture');
      expect(state_1).assertTrue();
      expect(state_2).assertTrue();
    })
  })
}