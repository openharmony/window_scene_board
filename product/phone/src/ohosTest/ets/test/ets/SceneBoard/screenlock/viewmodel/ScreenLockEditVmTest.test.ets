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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import { ScreenLockState } from '@ohos/screenlockcommon';
import { DisplayModeChangeListener } from '@ohos/screenlockcommon/Index';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import { ScreenLockEditVm } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/viewmodel/ScreenLockEditVm';
import { EDIT_CLOCK_DRAG, EDIT_FORM_DRAG } from '@ohos/screenlockcommon/src/main/ets/base/BaseViewModel';

/**
 * 锁屏编辑管理类测试用例
 */
export function ScreenLockEditVmTest() {
  const mEditViewModel: ScreenLockEditVm = new ScreenLockEditVm(new ScreenLockFormViewModel(), new AnyClock());
  describe('ScreenLockEditVmTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });
    it('test_initViewModel', Level.LEVEL0, (): void => {
      let displayModeChangeListener: DisplayModeChangeListener = {
        onDisplayModeChange: (displayMode: number): void => {}
      };
      mEditViewModel.initViewModel(0);
      mEditViewModel.initViewModel(1);
      expect(mEditViewModel).not().assertNull();
    });
    it('test_onEnterThemeEditor', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['onEnterThemeEditor'](ScreenLockState.HOST, ScreenLockState.THEME_EDITOR);
      (mEditViewModel as object)['onEnterThemeEditor'](ScreenLockState.BOUNCER, ScreenLockState.THEME_EDITOR);
      (mEditViewModel as object)['onEnterThemeEditor'](ScreenLockState.THEME_EDITOR_FULL_CLOCK, ScreenLockState.THEME_EDITOR);
      (mEditViewModel as object)['onEnterThemeEditor'](ScreenLockState.ENTER_OTHER_APP, ScreenLockState.THEME_EDITOR);
      expect(mEditViewModel).not().assertNull();
    });
    it('test_onEnterHost', Level.LEVEL0, (): void => {
      mEditViewModel.isSaveConfig = true;
      (mEditViewModel as object)['shouldRevert'] = true;
      (mEditViewModel as object)['onEnterHost'](ScreenLockState.THEME_EDITOR, ScreenLockState.HOST);
      (mEditViewModel as object)['onEnterHost'](ScreenLockState.BOUNCER, ScreenLockState.HOST);
      mEditViewModel.isSaveConfig = true;
      (mEditViewModel as object)['shouldRevert'] = false;
      (mEditViewModel as object)['onEnterHost'](ScreenLockState.THEME_EDITOR, ScreenLockState.HOST);
      (mEditViewModel as object)['onEnterHost'](ScreenLockState.BOUNCER, ScreenLockState.HOST);
      mEditViewModel.isSaveConfig = false;
      (mEditViewModel as object)['shouldRevert'] = true;
      (mEditViewModel as object)['onEnterHost'](ScreenLockState.THEME_EDITOR, ScreenLockState.HOST);
      (mEditViewModel as object)['onEnterHost'](ScreenLockState.BOUNCER, ScreenLockState.HOST);
      mEditViewModel.isSaveConfig = false;
      (mEditViewModel as object)['shouldRevert'] = false;
      (mEditViewModel as object)['onEnterHost'](ScreenLockState.THEME_EDITOR, ScreenLockState.HOST);
      (mEditViewModel as object)['onEnterHost'](ScreenLockState.BOUNCER, ScreenLockState.HOST);
      expect(mEditViewModel).not().assertNull();
    });
    it('test_useSendAccessibility', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['useSendAccessibility'](ScreenLockState.HOST, ScreenLockState.THEME_EDITOR);
      (mEditViewModel as object)['useSendAccessibility'](ScreenLockState.BOUNCER, ScreenLockState.HOST);
      (mEditViewModel as object)['useSendAccessibility'](ScreenLockState.THEME_EDITOR, ScreenLockState.HOST);
      (mEditViewModel as object)['useSendAccessibility'](ScreenLockState.THEME_EDITOR_FULL_CLOCK, ScreenLockState.THEME_EDITOR);
      expect(mEditViewModel).not().assertNull();
    });
    it('test_onEnterFullEditor', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['onEnterFullEditor'](ScreenLockState.THEME_EDITOR, ScreenLockState.THEME_EDITOR_FULL_CLOCK);
      expect(mEditViewModel).not().assertNull();
    });
    it('test_onEnterOtherApp', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['onEnterOtherApp']();
      expect(mEditViewModel).not().assertNull();
    });
    it('test_onEnterOtherAppBorderShow', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['onEnterOtherAppBorderShow']();
      expect(mEditViewModel).not().assertNull();
    });
    it('test_onEnterOtherAppBorderHide', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['onEnterOtherAppBorderHide']();
      expect(mEditViewModel).not().assertNull();
    });
    it('test_onExitKeyguard', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['shouldRevert'] = true;
      (mEditViewModel as object)['onExitKeyguard']();
      (mEditViewModel as object)['shouldRevert'] = false;
      (mEditViewModel as object)['onExitKeyguard']();
      expect(mEditViewModel).not().assertNull();
    });
    it('test_cancelEdit', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['currentMode'] = EDIT_CLOCK_DRAG;
      (mEditViewModel as object)['cancelEdit']();
      (mEditViewModel as object)['currentMode'] = 0;
      (mEditViewModel as object)['cancelEdit']();
      expect(mEditViewModel).not().assertNull();
    });
    it('test_isDragMode01', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['currentMode'] = EDIT_CLOCK_DRAG;
      let result = mEditViewModel.isDragMode();
      expect(result).assertTrue();
    });
    it('test_isDragMode02', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['currentMode'] = EDIT_FORM_DRAG;
      let result = mEditViewModel.isDragMode();
      expect(result).assertTrue();
    });
    it('test_isDragMode03', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['currentMode'] = 0;
      let result = mEditViewModel.isDragMode();
      expect(result).assertFalse();
    });
    it('test_revertThemeInfo', Level.LEVEL0, (): void => {
      mEditViewModel.revertThemeInfo();
      expect(mEditViewModel).not().assertNull();
    });
    it('test_applyThemeConfig', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['currentMode'] = EDIT_CLOCK_DRAG;
      mEditViewModel.applyThemeConfig();
      (mEditViewModel as object)['currentMode'] = 0;
      mEditViewModel.applyThemeConfig();
      expect(mEditViewModel).not().assertNull();
    });
    it('test_clearEditor', Level.LEVEL0, (): void => {
      mEditViewModel.clearEditor();
      expect(mEditViewModel).not().assertNull();
    });
    it('test_saveOriginThemeInfo', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['shouldRevert'] = true;
      (mEditViewModel as object)['saveOriginThemeInfo']();
      (mEditViewModel as object)['shouldRevert'] = false;
      (mEditViewModel as object)['saveOriginThemeInfo']();
      expect(mEditViewModel).not().assertNull();
    });
    it('test_getCardsLength', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['getCardsLength']();
      expect(mEditViewModel).not().assertNull();
    });
    it('test_updateThemeStyle', Level.LEVEL0, (): void => {
      (mEditViewModel as object)['updateThemeStyle']();
      expect(mEditViewModel).not().assertNull();
    });
  });
}