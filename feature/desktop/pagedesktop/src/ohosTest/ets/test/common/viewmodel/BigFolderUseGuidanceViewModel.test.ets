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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from "@ohos/hypium";
import { AppListInfo, GridLayoutItemInfo } from "@ohos/launchercommon";
import {
  BigFolderUseGuidanceDialog
} from "../../../../../main/ets/default/common/components/folder/BigFolderUseGuidanceDialog";
import {
  BigFolderUseGuidanceViewModel
} from "../../../../../main/ets/default/common/viewmodel/BigFolderUseGuidanceViewModel";


export default function BigFolderUseGuidanceViewModelTest() {
  describe('BigFolderUseGuidanceViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('canStart', 0, () => {
      let instance: BigFolderUseGuidanceViewModel = BigFolderUseGuidanceViewModel.getInstance();
      instance.canStart();
      expect(instance).not().assertNull();
    });

    it('setRemindAlreadyState', 0, () => {
      let instance: BigFolderUseGuidanceViewModel = BigFolderUseGuidanceViewModel.getInstance();
      instance.setRemindAlreadyState();
      expect(instance).not().assertNull();
    });

    it('closeBigFolderUseGuidanceDialog', 0, () => {
      let instance: BigFolderUseGuidanceViewModel = BigFolderUseGuidanceViewModel.getInstance();
      instance.closeBigFolderUseGuidanceDialog();
      expect(instance).not().assertNull();
    });

    it('clearGuidanceTimeOut', 0, () => {
      let instance: BigFolderUseGuidanceViewModel = BigFolderUseGuidanceViewModel.getInstance();
      instance.clearGuidanceTimeOut();
      expect(instance).not().assertNull();
    });

    it('setDialogTimeout', 0, () => {
      let instance: BigFolderUseGuidanceViewModel = BigFolderUseGuidanceViewModel.getInstance();
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appListInfo: AppListInfo = new AppListInfo();
      let appGridInfo: GridLayoutItemInfo[][] = [];
      let gridList: GridLayoutItemInfo[] = [];
      gridList.push(gridLayoutItemInfo);
      appGridInfo.push(gridList);
      appListInfo.appGridInfo = appGridInfo;
      let bigFolderUseGuidanceDialogController: CustomDialogController = new CustomDialogController({
        builder: BigFolderUseGuidanceDialog({
          bigFolderUseGuidanceViewModel: instance,
        }),
        autoCancel: false,
        showInSubWindow: false,
        alignment: DialogAlignment.Center,
      });
      instance.setDialogTimeout(0, appListInfo, bigFolderUseGuidanceDialogController);
      expect(instance).not().assertNull();
    });

    it('registerWindowDropDownEvent', 0, () => {
      let instance: BigFolderUseGuidanceViewModel = BigFolderUseGuidanceViewModel.getInstance();
      instance.registerWindowDropDownEvent();
      expect(instance).not().assertNull();
    });

    it('unRegisterWindowDropDownEvent', 0, () => {
      let instance: BigFolderUseGuidanceViewModel = BigFolderUseGuidanceViewModel.getInstance();
      instance.unRegisterWindowDropDownEvent();
      expect(instance).not().assertNull();
    });

  })
}
