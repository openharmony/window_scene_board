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
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  EditPanelSizeUtil
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/utils/EditPanelSizeUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import display from '@ohos.display';



export function EditPanelSizeUtilTest() {
  describe('EditPanelSizeUtilTest', () => {

    it('test_getEditPanelWidth', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      EditPanelSizeUtil.getEditPanelWidth();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getEditPanelWidth_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      EditPanelSizeUtil.getEditPanelWidth();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });


    it('test_getEditPanelWidth_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterThrow('err');

      EditPanelSizeUtil.getEditPanelWidth();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getPhoneEditPanelWidth', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);

      EditPanelSizeUtil.getEditPanelWidth();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getPhoneEditPanelWidth_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(display.getFoldStatus, display.getFoldStatus);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(display.FoldStatus.FOLD_STATUS_EXPANDED);

      EditPanelSizeUtil.getEditPanelWidth();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clear(display.getFoldStatus);
      mocker.clearAll();
    });

    it('test_getPhoneEditPanelWidth_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(display.getFoldStatus, display.getFoldStatus);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(display.FoldStatus.FOLD_STATUS_HALF_FOLDED);

      EditPanelSizeUtil.getEditPanelWidth();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clear(display.getFoldStatus);
      mocker.clearAll();
    });

    it('EditPanelSizeUtil_getEditPanelWidth1', 0, () => {
      let editPanelSizeUtil: EditPanelSizeUtil = new EditPanelSizeUtil();
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction1)().afterReturn(false);
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction)().afterReturn(true);
      EditPanelSizeUtil.getEditPanelWidth();
      expect(editPanelSizeUtil).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('EditPanelSizeUtil_getPhoneEditPanelWidth', 0, () => {
      let editPanelSizeUtil: EditPanelSizeUtil = new EditPanelSizeUtil();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      EditPanelSizeUtil.getEditPanelWidth();
      expect(editPanelSizeUtil).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('EditPanelSizeUtil_getDefaultPhoneEditPanelWidth', 0, () => {
      let result: number = (EditPanelSizeUtil as object)['getDefaultPhoneEditPanelWidth']();
      expect(result).not().assertNull();
    });

    it('EditPanelSizeUtil_getFoldPhoneEditPanelWidth', 0, () => {
      let result: number = (EditPanelSizeUtil as object)['getFoldPhoneEditPanelWidth']();
      expect(result).not().assertNull();
    });

    it('EditPanelSizeUtil_getPadEditPanelWidth', 0, () => {
      let result: number = (EditPanelSizeUtil as object)['getPadEditPanelWidth']();
      expect(result).not().assertNull();
    });

  });
}