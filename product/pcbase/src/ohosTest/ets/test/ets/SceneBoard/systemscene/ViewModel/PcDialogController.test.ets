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
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import { SCBFoldSceneStateManager, SCBFoldState, SCBFoldStateProperty } from '@ohos/pcmode';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { AppItemInfo, EventConstants } from '@ohos/launchercommon';
import {AppDialogController} from '../../../../../../../../../pcbase/src/main/ets/SceneBoard/systemscene/ViewModel/PcDialogController';
import {FileFolderDialogController} from '../../../../../../../../../pcbase/src/main/ets/SceneBoard/systemscene/ViewModel/PcDialogController';

export default function PcDialogControllerTest() {
  describe('PcDialogControllerTest', () => {
    let mocker: MockKit;
    let appDialogController: AppDialogController;
    let fileFolderDialogController: FileFolderDialogController;
    enum SCBFoldState {
      UNKNOWN = 0,
      HALF_FOLDED_VIRTUAL_KEYBOARD,
      HALF_FOLDED_PHYSICAL_KEYBOARD,
      HALF_FOLDED,
      UNFOLDED_VERTICAL,
      UNFOLDED_HORIZONTAL
    };
    beforeAll(() => {
    })
    beforeEach(() => {
      mocker = new MockKit();
    })
    afterEach(() => {
    })
    afterAll(() => {
      mocker.clearAll();
    })

    it('getDialogOffsetYTest', 0, () => {
      appDialogController.getDialogOffsetY();
      appDialogController.getDialogOffsetY(SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD);
      const appInfoOne: undefined = undefined
      let mockFuncIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFuncIsEmpty)(appInfoOne).afterReturn(true);
      appDialogController.getDialogOffsetY(SCBFoldState.HALF_FOLDED);
      const appInfoTwo: AppItemInfo = {
        appIconId: 2,
        abilityName: 'testAbility',
        appName: 'testApp',
        bundleName: 'testBundleName',
        page:1,
      }
      let mockFuncIsEmptyTwo: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFuncIsEmpty)(appInfoTwo).afterReturn(false);
      when(mockFuncIsEmptyTwo)(appInfoTwo).afterReturn(false);
      appDialogController.getDialogOffsetY(SCBFoldState.HALF_FOLDED);
      expect(appDialogController instanceof AppDialogController).assertTrue();
    })

    it('setDialogOffsetYTest', 0, () => {
      fileFolderDialogController.setDialogOffsetY(20,false);
      fileFolderDialogController.setDialogOffsetY(20,true);
      expect(fileFolderDialogController instanceof FileFolderDialogController).assertTrue();
    })

    it('getDialogOffsetYTwoTest', 0, () => {
      fileFolderDialogController.getDialogOffsetY(SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD);
      fileFolderDialogController.getDialogOffsetY(SCBFoldState.HALF_FOLDED);
      fileFolderDialogController.getDialogOffsetY();
      expect(fileFolderDialogController instanceof FileFolderDialogController).assertTrue();
    })

  })
}