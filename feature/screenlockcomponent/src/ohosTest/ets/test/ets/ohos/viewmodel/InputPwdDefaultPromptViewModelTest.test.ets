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
import { InputPwdDefaultPromptViewModel } from '../../../../../../main/ets/fingerprint/InputPwdDefaultPromptViewModel'
import { FingerprintConstants, CommonConstants } from '@ohos/screenlockcommon';
import TestConst from '../constants/TestConst';
import { ResUtils } from '@ohos/windowscene';

export default function InputPwdDefaultPromptViewModelTest() {
  const viewModel: InputPwdDefaultPromptViewModel = new InputPwdDefaultPromptViewModel();
  let mInputPwdDefaultPromptViewModelMode:InputPwdDefaultPromptViewModelMode = new InputPwdDefaultPromptViewModelMode();
  describe('InputPwdDefaultPromptViewModelTest', (): void =>{
    beforeAll((): void => {
    })
    beforeEach((): void => {
      viewModel.resetDefaultPrompt();
    })
    afterEach((): void => {
    })
    afterAll((): void => {
    })

    it('InputPwdDefaultPromptViewModelTest0001', TestConst.TEST_LEVEL, (): void =>{
      viewModel.changePSDDefaultPrompt(FingerprintConstants.INVALID_DURATION, $r('app.string.fp_disable_enter_psd'));
      expect(ResUtils.getInnerString(viewModel.defaultPrompt))
        .assertEqual(ResUtils.getInnerString($r('app.string.fp_disable_enter_psd')));
    })

    it('InputPwdDefaultPromptViewModelTest0002', TestConst.TEST_LEVEL, (): void =>{
      viewModel.changePSDDefaultPrompt(-1, $r('app.string.fp_disable_enter_psd'));
      expect(ResUtils.getInnerString(viewModel.defaultPrompt))
        .assertEqual(ResUtils.getInnerString($r('app.string.psd_enter_psd')));
    })

    it('InputPwdDefaultPromptViewModelTest0003', TestConst.TEST_LEVEL, (): void =>{
      viewModel.changePSDDefaultPrompt(30001, $r('app.string.fp_disable_enter_psd'));
      expect(ResUtils.getInnerString(viewModel.defaultPrompt))
        .assertEqual(ResUtils.getInnerString($r('app.string.psd_enter_psd')));
    })

    it('InputPwdDefaultPromptViewModelTest0004', TestConst.TEST_LEVEL, (): void =>{
      viewModel.changePSDDefaultPrompt(FingerprintConstants.INVALID_DURATION, $r('app.string.fp_disable_enter_psd'));
      expect(ResUtils.getInnerString(viewModel.defaultPrompt))
        .assertEqual(ResUtils.getInnerString($r('app.string.fp_disable_enter_psd')));
      viewModel.resetDefaultPrompt();
      expect(ResUtils.getInnerString(viewModel.defaultPrompt))
        .assertEqual(ResUtils.getInnerString($r('app.string.psd_enter_psd')));
    })

    it('test_setPinType_return', 0, (): void => {
      let passwordType: string = 'res';
      viewModel.setPinType(passwordType);
      expect(viewModel.pinType).assertEqual('res');
    })

    it('test_SetDefaultPrompt_return', 0, (): void => {
      viewModel.setPinType(CommonConstants.PIN_TYPE_MIX);
      let result = mInputPwdDefaultPromptViewModelMode.SetDefaultPrompt();
      expect(result).not().assertNull();
    })

    it('test_SetDefaultPrompt_return_one', 0, (): void => {
      viewModel.setPinType(CommonConstants.PIN_TYPE_PATTERN);
      let result = mInputPwdDefaultPromptViewModelMode.SetDefaultPrompt();
      expect(result).not().assertNull();
    })

    it('test_SetDefaultPrompt_return_two', 0, (): void => {
      viewModel.setPinType(CommonConstants.LOCK_STATUS_KEY);
      let result = mInputPwdDefaultPromptViewModelMode.SetDefaultPrompt();
      expect(result).not().assertNull();
    })

    it('test_changePSDDefaultPrompt', 0, (): void => {
      viewModel.changePSDDefaultPrompt(100, $r('app.string.fp_disable_enter_psd'));
      viewModel.changePSDDefaultPrompt(0, $r('app.string.fp_disable_enter_psd'));
      expect(true).assertTrue();
    })
  })
}

export class InputPwdDefaultPromptViewModelMode extends InputPwdDefaultPromptViewModel {
  constructor() {
    super();
  }

  public SetDefaultPrompt(): Resource {
    return this.setDefaultPrompt('');
  }
}