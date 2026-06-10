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
import { CardItemInfo } from '@ohos/launchercommon';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { ClockLayout, LockscreenFormConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import ScreenLockFormViewModel, { ShowFormPanelScene } from '../../src/main/ets/form/vm/ScreenLockFormViewModel';

export default function ScreenLockFormViewModelTest() {
  describe('ScreenLockFormViewModelTest',() => {
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

    it('assertFormPanelHeightWhenViewModelInit', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit([], ClockLayout.DEFAULT_CLOCK_LAYOUT, ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE);

      expect(screenLockFormViewModel.formConfigs.length).assertEqual(0);
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(0)
      expect(screenLockFormViewModel.getFormPanelHeight()).assertEqual(0)
    });

    it('assertFormPanelHeightWhenUpdateScene', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit([], ClockLayout.DEFAULT_CLOCK_LAYOUT, ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE);

      screenLockFormViewModel.updateScene(ShowFormPanelScene.ADD_SCREEN_FORM);
      expect(screenLockFormViewModel.formConfigs.length).assertEqual(0);
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(4);
      expect(screenLockFormViewModel.getFormPanelHeight()).assertEqual(1);
    });

    it('assertFormConfigEmptyWhenExistInvalidDimension', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let formConfigs: LockscreenFormConfig[] =
        [{
          positionX: 1,
          positionY: 0,
          dimensionX: 3,
          formInfo: new CardItemInfo()
        }];
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit(formConfigs, ClockLayout.DEFAULT_CLOCK_LAYOUT,
        ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE);

      expect(screenLockFormViewModel.formConfigs.length).assertEqual(0);
    });

    it('assertFormConfigEmptyWhenFormSpaceExceed4', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let formConfigs: LockscreenFormConfig[] =
        [{
          positionX: 0,
          positionY: 0,
          dimensionX: 2,
          formInfo: new CardItemInfo()
        },
          {
            positionX: 2,
            positionY: 0,
            dimensionX: 2,
            formInfo: new CardItemInfo()
          },
          {
            positionX: 1,
            positionY: 0,
            dimensionX: 1,
            formInfo: new CardItemInfo()
          }];
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit(formConfigs, ClockLayout.DEFAULT_CLOCK_LAYOUT,
        ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE);

      expect(screenLockFormViewModel.formConfigs.length).assertEqual(0);
    });

    it('assertSupportFormPositionShowResult', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let formConfigs: LockscreenFormConfig[] =
        [{
          positionX: 0,
          positionY: 0,
          dimensionX: 2,
          formInfo: new CardItemInfo()
        },
          {
            positionX: 2,
            positionY: 0,
            dimensionX: 2,
            formInfo: new CardItemInfo()
          }];
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit(formConfigs, ClockLayout.DEFAULT_CLOCK_LAYOUT,
        ShowFormPanelScene.ADD_SCREEN_FORM);

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(2);
      expect(screenLockFormViewModel.supportFormPositions[0].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[1].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[2].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[3].isShow).assertEqual(false);
    });

    it('assertSupportFormPositionShowResultWhenAddForm', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let formConfigs: LockscreenFormConfig[] =
        [{
          positionX: 0,
          positionY: 0,
          dimensionX: 1,
          formInfo: new CardItemInfo()
        }];
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit(formConfigs, ClockLayout.DEFAULT_CLOCK_LAYOUT,
        ShowFormPanelScene.ADD_SCREEN_FORM);
      let addingForm = new CardItemInfo();
      addingForm.dimension = 1;
      screenLockFormViewModel.addScreenLockForm(addingForm, 1, true);

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(2);
      expect(screenLockFormViewModel.supportFormPositions[0].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[1].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[2].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[3].isShow).assertEqual(true);
    });

    it('assertSupportFormPositionShowResultWhenDeleteForm', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let formConfigs: LockscreenFormConfig[] =
        [{
          positionX: 0,
          positionY: 0,
          dimensionX: 2,
          formInfo: new CardItemInfo()
        },
          {
            positionX: 2,
            positionY: 0,
            dimensionX: 2,
            formInfo: new CardItemInfo()
          }];
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit(formConfigs, ClockLayout.DEFAULT_CLOCK_LAYOUT,
        ShowFormPanelScene.ADD_SCREEN_FORM);
      screenLockFormViewModel.deleteScreenLockForm({
        positionX: 2,
        positionY: 0,
        dimensionX: 2,
        formInfo: new CardItemInfo()
      }, '', '');

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(2);
      expect(screenLockFormViewModel.supportFormPositions[0].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[1].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[2].isShow).assertEqual(true);
      expect(screenLockFormViewModel.supportFormPositions[3].isShow).assertEqual(true);
    });
  });
}