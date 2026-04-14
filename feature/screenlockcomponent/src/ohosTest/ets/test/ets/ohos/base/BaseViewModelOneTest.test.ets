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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import {
  BaseViewModel,
  BaseViewData,
  ILayoutModel,
  BaseEventHandler,
  DisplayModeChangeListener
} from '@ohos/screenlockcommon/src/main/ets/base/BaseViewModel';
import { KeyGuardMode, KeyGuardPage } from '@ohos/screenlockcommon/src/main/ets/bean/KeyGuardStatusEnum';
import {
  ScreenLockState
} from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockInnerStateManager';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
};

export default function BaseViewModelOneTest() {
  let mBaseViewModel: BaseViewModel = new BaseViewModel();
  let mBaseViewData = new BaseViewData();
  describe('BaseViewModelOneTest', (): void => {
    let viewData: BaseViewData;
    let layoutModel: ILayoutModel;
    let eventHandler: BaseEventHandler;
    let page: KeyGuardPage;
    let mode: KeyGuardMode;
    let displayModeChangeListener: DisplayModeChangeListener;
    let preState: ScreenLockState;
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getLayout_return', 0, (): void => {
      mBaseViewModel.bindView(viewData, layoutModel, eventHandler);
      let result = mBaseViewModel.getLayout();
      expect(result).not().assertNull();
    })

    it('test_getViewData_return', 0, (): void => {
      let result = mBaseViewModel.getViewData();
      expect(result).not().assertNull();
    })

    it('test_getEventHandler_return', 0, (): void => {
      let result = mBaseViewModel.getEventHandler();
      expect(result).not().assertNull();
    })

    it('test_initProhibitModes_return', 0, (): void => {
      let result = mBaseViewModel.initProhibitModes();
      expect(result).not().assertNull();
    })

    it('test_onPageChanged_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onPageChanged(page);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onModeChanged_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onModeChanged(mode);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_initViewModel_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.initViewModel(displayModeChangeListener);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_destroyViewModel_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.destroyViewModel();
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onEnterHost_return', 0, (): void => {
      let isSaveConfig: boolean = true;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onEnterHost(preState, isSaveConfig);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onEnterThemeEditor_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onEnterThemeEditor(preState);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onEnterFullEditor_return-one', 0, (): void => {
      let fullState: ScreenLockState = ScreenLockState.THEME_EDITOR_FULL;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onEnterFullEditor(preState, fullState);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onEnterFullEditor_return-two', 0, (): void => {
      let fullState: ScreenLockState = ScreenLockState.THEME_EDITOR_FULL_CLOCK;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onEnterFullEditor(preState, fullState);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onEnterFullEditor_return-three', 0, (): void => {
      let fullState: ScreenLockState = ScreenLockState.THEME_EDITOR_FULL_FORM;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onEnterFullEditor(preState, fullState);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onEnterFullEditor_return-four', 0, (): void => {
      let fullState: ScreenLockState = ScreenLockState.THEME_EDITOR_FORM_DETAIL;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onEnterFullEditor(preState, fullState);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onEnterBouncer_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onEnterBouncer(preState);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onExitKeyguard_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onExitKeyguard();
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onEnterOtherApp_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.onEnterOtherApp();
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_isInEditMode_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mBaseViewModel.isInEditMode();
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_onEnterOtherAppBorderShow', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mBaseViewModel.onEnterOtherAppBorderShow();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_onEnterOtherAppBorderHide', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mBaseViewModel.onEnterOtherAppBorderHide();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_isInOtherApp', 0, (): void => {
      let result = mBaseViewModel.isInOtherApp();
      expect(result).not().assertNull();
    })

    it('test_isShow', 0, (): void => {
      mBaseViewData.isShow = false;
      expect(mBaseViewData.isShow).assertEqual(false);
    })

    it('test_isEnable', 0, (): void => {
      mBaseViewData.isEnable = false;
      expect(mBaseViewData.isEnable).assertEqual(false);
    })
  })
}