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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import FoldablePSDViewModel, {
  FoldablePSDModel
} from '../../../../../../main/ets/password/viewmodel/FoldablePSDViewModel';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { SlMainStateType, SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { DisplayStateListener, DisplayUtils } from '@ohos/screenlockcommon';
import { display } from '@kit.ArkUI';

export default function FoldablePSDViewModelTest() {
  let foldablePSDViewModel:FoldablePSDViewModel = new FoldablePSDViewModel();

  describe('FoldablePSDViewModelTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterEach((): void => {
    })
    afterAll((): void => {
    })

    it('test_viewModelInit_should_return_false', TestConst.TEST_LEVEL, (): void => {
      let model: FoldablePSDModel = new FoldablePSDModel();
      foldablePSDViewModel.viewModelInit(model);
      expect(foldablePSDViewModel.foldablePSDModel.isUltraScreenGState).assertEqual(false);
    })

    it('test_doInit_doRelease_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isUltraScreenProduct);
      when(mockFunc1)().afterReturn(false);
      foldablePSDViewModel.doInit();
      foldablePSDViewModel.doRelease();
      when(mockFunc1)().afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isGState);
      when(mockFunc2)().afterReturn(true);
      foldablePSDViewModel.doInit();
      foldablePSDViewModel.doRelease();
      const isExpand: boolean = DisplayUtils.getFoldStatus() !== display.FoldStatus.FOLD_STATUS_UNKNOWN &&
        DisplayUtils.getFoldStatus() !== display.FoldStatus.FOLD_STATUS_FOLDED
      expect(foldablePSDViewModel.foldablePSDModel.isExpand).assertEqual(isExpand);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_updateUltraScreenGState_should_assertEqual', TestConst.TEST_LEVEL, (): void => {
      let updateUltraScreenGState: ISlStateChangeListener = (foldablePSDViewModel as object)['updateUltraScreenGState'];
      updateUltraScreenGState.onSlStateChange?.(SlMainStateType.SL_STATIC_STATE, SlStaticStateType.SCREEN_BP);
      expect(foldablePSDViewModel.foldablePSDModel.isUltraScreenGState).assertEqual(DisplayUtils.isUltraScreenGStatus());
    })

    it('test_displayStateListener_should_assertFalse', TestConst.TEST_LEVEL, (): void => {
      let displayStateListener: DisplayStateListener = (foldablePSDViewModel as object)['displayStateListener'];
      displayStateListener.onFoldStatusChange?.(display.FoldStatus.FOLD_STATUS_FOLDED);
      expect(foldablePSDViewModel.foldablePSDModel.isExpand).assertFalse();
    })
  })
}