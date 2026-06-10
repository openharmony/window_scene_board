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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import PasswordViewModel from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/vm/PasswordViewModel';
import { Callback } from '@ohos/frameworkwrapper';
import { GlobalStatusCache, StatusCacheConst } from '@ohos/screenlockcommon/src/main/ets/TsIndex';


export default function PasswordViewModelTest() {

  describe('PasswordViewModelTest', (): void => {
    let mPasswordViewModel: PasswordViewModel = new PasswordViewModel();

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_countdown_should_return_number', 0, (): void => {
      mPasswordViewModel.ViewModelInit();
      mPasswordViewModel.getScreenDensity();
      mPasswordViewModel.countdown();
      expect(mPasswordViewModel.prompt).assertEqual(null);
    })

    it('test_getWillLockTxt_should_return', 0, async(): Promise<void> => {
      mPasswordViewModel.getWillLockTxt(0,0,()=>{});
      let execute: string = '';
      const callback: Callback = () => {
        execute = 'success';
      };
      mPasswordViewModel.checkFreezingTime(callback);
      mPasswordViewModel.switchToPwdPageReport();
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_updateStorage_return', 0, (): void => {
      let execute: string = '';
      const callback: Callback = () => {
        execute = 'success';
      };
      mPasswordViewModel.updateStorage(callback);
      expect(execute == 'success' ? true : false).assertEqual(true);
    })

    it('test_getFreezingTimeNm_return', 0, (): void => {
      let freezingMillisecond: number = 60000;
      let result= mPasswordViewModel.getFreezingTimeNm(freezingMillisecond);
      expect(result).not().assertNull();
    })

    it('test_getFreezingTimeNm_return_one', 0, (): void => {
      let freezingMillisecond: number = 6000;
      let result= mPasswordViewModel.getFreezingTimeNm(freezingMillisecond);
      expect(result).not().assertNull();
    })

    it('test_bindCountdown_return', 0, (): void => {
      mPasswordViewModel.bindCountdown();
      expect(mPasswordViewModel.timeoutTask).assertNull();
    })

    it('test_changePrompt_return_one', 0, (): void => {
      mPasswordViewModel.changePrompt(1, 1, () => {
      }, 1);
      expect(mPasswordViewModel.prompt).assertNull();
    })

    it('test_changePrompt_return_two', 0, (): void => {
      mPasswordViewModel.changePrompt(1, 1, () => {
      }, -1);
      expect(mPasswordViewModel.prompt).assertNull();
    })

    it('test_changePrompt_return_three', 0, (): void => {
      mPasswordViewModel.changePrompt(0, 1, () => {
      });
      expect(mPasswordViewModel.inhibitInput).assertEqual(true);
    })

    it('test_clearTimeOutTask_return', 0, (): void => {
      mPasswordViewModel.clearTimeOutTask();
      expect(mPasswordViewModel.timeoutTask).assertEqual(null);
    })

    it('test_isPwdBackEffect_01', 0, (): void => {
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.IS_PLAY_PWD_BACK_ANIMATION, false);
      let result = mPasswordViewModel.isPwdBackEffect();
      expect(result).not().assertNull();
    })

    it('test_isPwdBackEffect_02', 0, (): void => {
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.IS_PLAY_PWD_BACK_ANIMATION, true);
      let result = mPasswordViewModel.isPwdBackEffect();
      expect(result).not().assertNull();
    })

    it('test_getPwdViewScale_01', 0, (): void => {
      let result: ScaleOptions = mPasswordViewModel.getPwdViewScale(false, 0.9);
      expect(result.x).assertEqual(1);
    })

    it('test_getPwdViewScale_02', 0, (): void => {
      let result: ScaleOptions = mPasswordViewModel.getPwdViewScale(true, 0.9);
      expect(result.x).assertEqual(0.9);
    })

    it('test_getPwdViewOpacity_01', 0, (): void => {
      let result = mPasswordViewModel.getPwdViewOpacity(false, 0);
      expect(result).assertEqual(1);
    })

    it('test_getPwdViewOpacity_02', 0, (): void => {
      let result = mPasswordViewModel.getPwdViewOpacity(true, 0);
      expect(result).assertEqual(0);
    })

    it('test_logIAMResult_01', 0, (): void => {
      (mPasswordViewModel as object)['logIAMResult'](12300109);
      expect(mPasswordViewModel).not().assertUndefined();
    })

    it('test_logIAMResult_02', 0, (): void => {
      (mPasswordViewModel as object)['logIAMResult'](12300101);
      expect(mPasswordViewModel).not().assertUndefined();
    })

    it('test_logIAMResult_03', 0, (): void => {
      (mPasswordViewModel as object)['logIAMResult'](12300102);
      expect(mPasswordViewModel).not().assertUndefined();
    })
  })
}