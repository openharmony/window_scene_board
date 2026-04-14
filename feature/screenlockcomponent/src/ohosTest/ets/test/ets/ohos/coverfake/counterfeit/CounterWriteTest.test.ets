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

import { CardItemInfo } from '@ohos/launchercommon';
import { HiSysDataScreenLockLocation } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { ScreenLockState } from '@ohos/screenlockcommon';
import ScreenLockFormViewModel, {
  ShowFormPanelScene,
  SupportFormLocation
} from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import { ClockLayout, LockscreenFormConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
}
;

export default function CounterWriteTest() {
  let mScreenLockFormViewModelMode:screenLockFormViewModelMode = new screenLockFormViewModelMode();
  let newClockLayout: ClockLayout;
  let defaultSupportPositions: SupportFormLocation[];
  let supportFormPositions: SupportFormLocation[];
  describe('CounterWriteTest', () => {
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

    it('test_onEnterHost_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let preState: ScreenLockState = ScreenLockState.HOST;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        screenLockFormViewModel.onEnterHost(preState);
        result = true;
      })
      expect(result).assertEqual(true);
    });

    it('test_onEnterThemeEditor_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let preState: ScreenLockState = ScreenLockState.THEME_EDITOR;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        screenLockFormViewModel.onEnterThemeEditor(preState);
        result = true;
      })
      expect(result).assertEqual(true);
    });

    it('test_onEnterFullEditor_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let preState: ScreenLockState = ScreenLockState.THEME_EDITOR;
      let fullState: ScreenLockState = ScreenLockState.THEME_EDITOR_FULL;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        screenLockFormViewModel.onEnterFullEditor(preState, fullState);
        result = true;
      })
      expect(result).assertEqual(true);
    });

    it('test_onEnterOtherApp_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result: boolean = false;
      getResultClass.getResult1(() => {
        screenLockFormViewModel.onEnterOtherApp();
        result = true;
      })
      expect(result).assertEqual(true);
    });

    it('test_getPanelPositionY_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.getPanelPositionY();
      expect(result).assertEqual(0);
    });

    it('test_getRealPositionY_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.getRealPositionY();
      expect(result).assertEqual(0);
    });

    it('test_getDownToClockView_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.getDownToClockView();
      expect(result).assertEqual(true);
    });

    it('test_getSupportPositionEntryDelay_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.getSupportPositionEntryDelay();
      expect(result).assertEqual(0);
    });

    it('test_getFormPanelScene_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.getFormPanelScene();
      expect(result).assertEqual(ShowFormPanelScene.POSTER_SCENE);
    });

    it('test_getIsAddingForm_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.getIsAddingForm();
      expect(result).assertEqual(false);
    });

    it('test_getIsDeletingForm_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.getIsDeletingForm();
      expect(result).assertEqual(false);
    });

    it('test_getClockLayout_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.getClockLayout();
      expect(result).assertEqual(ClockLayout.DIMENSION_4_4);
    });

    it('test_getFormConfigInfo_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.getFormConfigInfo();
      expect(result).not().assertNull();
    });

    it('test_registerRouterProxy_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result: boolean = false;
      let formId: string = 'res';
      getResultClass.getResult1(() => {
        screenLockFormViewModel.registerRouterProxy(formId);
        result = true;
      })
      expect(result).assertEqual(true);
    });

    it('test_clearAbilityQueue_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result: boolean = false;
      getResultClass.getResult1(() => {
        screenLockFormViewModel.clearAbilityQueue();
        result = true;
      })
      expect(result).assertEqual(true);
    });

    it('test_updateLayout_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let newClockLayout: ClockLayout = ClockLayout.DIMENSION_4_2;
      let clockViewPositionY: number = 2;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        screenLockFormViewModel.updateLayout(newClockLayout, clockViewPositionY);
        result = true;
      })
      expect(result).assertEqual(true);
    });

    it('test_initFormPanelSpace_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let clockViewPositionY: number = 0;
      AppStorage.set<boolean>('isPortrait',true);
      AppStorage.get<boolean>('isPortrait');
      screenLockFormViewModel.initFormPanelSpace(clockViewPositionY);
      screenLockFormViewModel.getDownToClockView();
      screenLockFormViewModel.getPanelPositionY();
      expect(screenLockFormViewModel.getDownToClockView()).assertEqual(true);
      clockViewPositionY = 3;
      screenLockFormViewModel.initFormPanelSpace(clockViewPositionY);
      screenLockFormViewModel.getDownToClockView();
      screenLockFormViewModel.getPanelPositionY();
      expect(screenLockFormViewModel.getDownToClockView()).assertEqual(false);
      AppStorage.set<boolean>('isPortrait',false);
      AppStorage.get<boolean>('isPortrait');
      clockViewPositionY = 0;
      screenLockFormViewModel.initFormPanelSpace(clockViewPositionY);
    });

    it('test_initFormPanelSpace_should_return_ON', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let clockViewPositionY: number = 20;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        screenLockFormViewModel.initFormPanelSpace(clockViewPositionY);
        result = true;
      })
      expect(result).assertEqual(true);
    });

    it('test_hasAddedCard_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.hasAddedCard();
      mScreenLockFormViewModelMode.updatePanelHeight();
      expect(result).assertEqual(false);
    });

    it('test_isScreenLockMainPage_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let result = screenLockFormViewModel.isScreenLockMainPage();
      expect(result).assertEqual(false);
    });

    it('assertFormPanelHeightViewModelInitOnScreenLock', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInitOnScreenLock([], ClockLayout.DEFAULT_CLOCK_LAYOUT,
        -1);

      expect(screenLockFormViewModel.formConfigs.length).assertEqual(0);
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(0)
      expect(screenLockFormViewModel.getFormPanelHeight()).assertEqual(0)
    });

    it('test_calculateDefaultFormPanelPositionY_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let formPanelPositionY: number = -1;
      let clockLayout: ClockLayout = ClockLayout.DIMENSION_4_4;
      let result = screenLockFormViewModel.calculateDefaultFormPanelPositionY(formPanelPositionY, clockLayout);
      expect(result).assertEqual(4);
    });

    it('test_calculateDefaultFormPanelPositionY_should_return_ON', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let formPanelPositionY: number = 1;
      let clockLayout: ClockLayout = ClockLayout.DIMENSION_4_4;
      let result = screenLockFormViewModel.calculateDefaultFormPanelPositionY(formPanelPositionY, clockLayout);
      expect(result).not().assertNull();
    });

    it('test_initFormConfigInfo_should_return', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let initFormConfigs: LockscreenFormConfig[] = [];
      screenLockFormViewModel.initFormConfigInfo(initFormConfigs);
      expect(screenLockFormViewModel.formConfigs).not().assertNull();
    });

    it('test_initFormConfigInfo_should_return_ON', 0, () => {
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      let mLockscreenFormConfig: LockscreenFormConfig = new LockscreenFormConfig();
      mLockscreenFormConfig.positionX = 1;
      mLockscreenFormConfig.positionY = 2;
      let initFormConfigs: LockscreenFormConfig[] = [mLockscreenFormConfig];
      screenLockFormViewModel.initFormConfigInfo(initFormConfigs);
      expect(screenLockFormViewModel.formConfigs).not().assertNull();
    });

    it('assertFormPanelHeightWhenViewModelInit', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit([], ClockLayout.DEFAULT_CLOCK_LAYOUT,
        ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE);

      expect(screenLockFormViewModel.formConfigs.length).assertEqual(0);
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(4)
      expect(screenLockFormViewModel.getFormPanelHeight()).assertEqual(0)
    });

    it('assertFormPanelHeightWhenUpdateScene', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit([], ClockLayout.DEFAULT_CLOCK_LAYOUT,
        ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE);

      screenLockFormViewModel.updateScene(ShowFormPanelScene.ADD_SCREEN_FORM);
      expect(screenLockFormViewModel.formConfigs.length).assertEqual(0);
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(4);
      expect(screenLockFormViewModel.getFormPanelHeight()).assertEqual(2);
    });

    it('assertFormConfigEmptyWhenExistInvalidDimension', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let formConfigs: LockscreenFormConfig[] =
        [{
          positionX: 1,
          positionY: 0,
          dimensionX: 3,
          formInfo: new CardItemInfo(),
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
          formInfo: new CardItemInfo(),
        },
          {
            positionX: 2,
            positionY: 0,
            dimensionX: 2,
            formInfo: new CardItemInfo(),
          },
          {
            positionX: 1,
            positionY: 0,
            dimensionX: 1,
            formInfo: new CardItemInfo(),
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
          formInfo: new CardItemInfo(),
        },
          {
            positionX: 2,
            positionY: 0,
            dimensionX: 2,
            formInfo: new CardItemInfo(),
          }];
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit(formConfigs, ClockLayout.DEFAULT_CLOCK_LAYOUT,
        ShowFormPanelScene.ADD_SCREEN_FORM);

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(4);
      expect(screenLockFormViewModel.supportFormPositions[0].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[1].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[2].isShow).assertEqual(true);
      expect(screenLockFormViewModel.supportFormPositions[3].isShow).assertEqual(true);
    });

    it('assertSupportFormPositionShowResultWhenAddForm', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let formConfigs: LockscreenFormConfig[] =
        [{
          positionX: 0,
          positionY: 0,
          dimensionX: 1,
          formInfo: new CardItemInfo(),
        }];
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit(formConfigs, ClockLayout.DEFAULT_CLOCK_LAYOUT,
        ShowFormPanelScene.ADD_SCREEN_FORM);
      let addingForm = new CardItemInfo();
      addingForm.dimension = FormDimension.Dimension_1_2;
      let isDrag: boolean = false;
      mScreenLockFormViewModelMode.SetUsedCardSpace(4);
      let result = screenLockFormViewModel.addScreenLockForm(addingForm, HiSysDataScreenLockLocation.LOCATION_RECOMMEND,isDrag);
      mScreenLockFormViewModelMode.SetUsedCardSpace(0);
      result = screenLockFormViewModel.addScreenLockForm(addingForm, HiSysDataScreenLockLocation.LOCATION_RECOMMEND,isDrag);
      expect(result).not().assertNull();
      isDrag = true;
      screenLockFormViewModel.addScreenLockForm(addingForm, HiSysDataScreenLockLocation.LOCATION_RECOMMEND,isDrag);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(4);
      expect(screenLockFormViewModel.supportFormPositions[0].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[1].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[2].isShow).assertEqual(true);
      expect(screenLockFormViewModel.supportFormPositions[3].isShow).assertEqual(true);
    });

    it('assertSupportFormPositionShowResultWhenDeleteForm', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let formConfigs: LockscreenFormConfig[] =
        [{
          positionX: 0,
          positionY: 0,
          dimensionX: 2,
          formInfo: new CardItemInfo(),
        },
          {
            positionX: 2,
            positionY: 0,
            dimensionX: 2,
            formInfo: new CardItemInfo(),
          }];
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.viewModelInit(formConfigs, ClockLayout.DEFAULT_CLOCK_LAYOUT,
        ShowFormPanelScene.ADD_SCREEN_FORM);
      screenLockFormViewModel.deleteScreenLockForm({
        positionX: 2,
        positionY: 0,
        dimensionX: 2,
        formInfo: new CardItemInfo(),
      }, '', '');

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(screenLockFormViewModel.supportFormPositions.length).assertEqual(4);
      expect(screenLockFormViewModel.supportFormPositions[0].isShow).assertEqual(false);
      expect(screenLockFormViewModel.supportFormPositions[1].isShow).assertEqual(true);
      expect(screenLockFormViewModel.supportFormPositions[2].isShow).assertEqual(true);
      expect(screenLockFormViewModel.supportFormPositions[3].isShow).assertEqual(true);
    });

    it('test_InitEditFormPanelParam_return', 0, (): void => {
      let scene: ShowFormPanelScene = ShowFormPanelScene.POSTER_SCENE;
      mScreenLockFormViewModelMode.InitEditFormPanelParam(scene);
      scene = ShowFormPanelScene.LOCK_SCREEN_EDIT;
      mScreenLockFormViewModelMode.InitEditFormPanelParam(scene);
      scene = ShowFormPanelScene.ADD_SCREEN_FORM;
      mScreenLockFormViewModelMode.InitEditFormPanelParam(scene);
      scene = ShowFormPanelScene.SCREEN_LOCK_MAIN_PAGE;
      mScreenLockFormViewModelMode.InitEditFormPanelParam(scene);
      mScreenLockFormViewModelMode.getFormPanelScene();
      mScreenLockFormViewModelMode.isScreenLockMainPage();
      let result = mScreenLockFormViewModelMode.getPanelPositionY();
      scene = 8;
      mScreenLockFormViewModelMode.InitEditFormPanelParam(scene);
      expect(result).not().assertNull();
    });

    it('test_getReloadFormHeight_return', 0, (): void => {
      let clockViewPositionY: number = 0;
      mScreenLockFormViewModelMode.getReloadFormHeight(newClockLayout);
      mScreenLockFormViewModelMode.ReloadFormPosition(newClockLayout);
      mScreenLockFormViewModelMode.updateLayout(newClockLayout,clockViewPositionY);
      let result = mScreenLockFormViewModelMode.getReloadFormHeight(newClockLayout);
      mScreenLockFormViewModelMode.ReloadFormPosition(newClockLayout);
      expect(result).not().assertNull();
    });

    it('test_getCurrentPanelHeight_return', 0, (): void => {
      mScreenLockFormViewModelMode.getCurrentPanelHeight();
      mScreenLockFormViewModelMode.getFormConfigInfo();
      let result = mScreenLockFormViewModelMode.getCurrentPanelHeight();
      expect(result).not().assertNull();
    });

    it('test_ResetSupportPositionEntryDelay_return', 0, (): void => {
      let scene: ShowFormPanelScene = ShowFormPanelScene.POSTER_SCENE;
      mScreenLockFormViewModelMode.ResetSupportPositionEntryDelay(scene);
      scene = ShowFormPanelScene.ADD_SCREEN_FORM;
      mScreenLockFormViewModelMode.ResetSupportPositionEntryDelay(scene);
      expect(scene).assertEqual(ShowFormPanelScene.ADD_SCREEN_FORM);
    });

    it('test_SaveFormInfo_return', 0, (): void => {
      let newFormInfo: LockscreenFormConfig = {
        positionX: 1,
        positionY: 1,
        dimensionX: 0,
        formInfo: new CardItemInfo,
      };
      let result = mScreenLockFormViewModelMode.SaveFormInfo(newFormInfo);
      expect(result).not().assertNull();
    });

    it('test_IsSupportFormPosOccupied_return', 0, (): void => {
      let form: LockscreenFormConfig = {
        positionX: 1,
        positionY: 1,
        dimensionX: 0,
        formInfo: new CardItemInfo,
      };
      let supportFormPos: SupportFormLocation = {
        isShow: false,
        positionX: 3,
        positionY: 3
      };
      let result = mScreenLockFormViewModelMode.IsSupportFormPosOccupied(supportFormPos,form);
      expect(result).assertEqual(false);
      form = {
        positionX: 1,
        positionY: 1,
        dimensionX: 1,
        formInfo: new CardItemInfo,
      };
      result = mScreenLockFormViewModelMode.IsSupportFormPosOccupied(supportFormPos,form);
      expect(result).assertEqual(false);
      form = {
        positionX: 1,
        positionY: 3,
        dimensionX: 1,
        formInfo: new CardItemInfo,
      };
      result = mScreenLockFormViewModelMode.IsSupportFormPosOccupied(supportFormPos,form);
      expect(result).assertEqual(false);
      form = {
        positionX: 3,
        positionY: 3,
        dimensionX: 1,
        formInfo: new CardItemInfo,
      };
      mScreenLockFormViewModelMode.IsSupportFormPosOccupied(supportFormPos,form);
    });
  });
}

export class screenLockFormViewModelMode extends ScreenLockFormViewModel {
  constructor() {
    super();
  }

  public InitEditFormPanelParam(scene: ShowFormPanelScene): void {
    return this.initEditFormPanelParam(scene);
  }

  public ResetSupportPositionEntryDelay(scene: ShowFormPanelScene): void {
    return this.resetSupportPositionEntryDelay(scene);
  }

  public ReloadFormPosition(newClockLayout: ClockLayout): void {
    return this.reloadFormPosition(newClockLayout);
  }

  public SetUsedCardSpace(space: number): void {
    return this.setUsedCardSpace(space);
  }

  public SaveFormInfo(newFormInfo: LockscreenFormConfig): number {
    return this.saveFormInfo(newFormInfo);
  }

  public IsSupportFormPosOccupied(supportFormPos: SupportFormLocation, form: LockscreenFormConfig): boolean {
    return this.isSupportFormPosOccupied(supportFormPos,form);
  }
}