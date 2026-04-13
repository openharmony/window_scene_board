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

import { FingerprintConstants } from '@ohos/screenlockcommon';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import TemporaryPromptViewModel, { HidePromptCode } from '../../../../../../main/ets/fingerprint/TemporaryPromptViewModel';
import TestConst from '../constants/TestConst';
import { ResUtils } from '@ohos/windowscene';

export default function TemporaryPromptViewModelTest() {
  const viewModel = new TemporaryPromptViewModel(false);

  describe('TemporaryPromptViewModelTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
      viewModel.temporaryPrompt = undefined;
      viewModel.isShowTemporaryPrompt = false;
    })
    afterEach((): void => {
    })
    afterAll((): void => {
    })

    it('TemporaryPromptViewModelTest0001', TestConst.TEST_LEVEL, (): void => {
      viewModel.isShowTemporaryPrompt = true;
      viewModel.countdown(1, 10, false, true, (remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<string> => {
        return new Promise((resolve) =>{
          resolve(ResUtils.getInnerString($r('app.string.fp_disable_forever')));
        });
      })
      expect(viewModel.temporaryPrompt === undefined).assertTrue();

      viewModel.countdown(0, 0, false, true, (remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<string> => {
        return new Promise((resolve) =>{
          resolve(ResUtils.getInnerString($r('app.string.fp_disable_forever')));
        });
      })
      expect(viewModel.temporaryPrompt === undefined).assertTrue();

      viewModel.countdown(0, FingerprintConstants.INVALID_DURATION, false, true, (remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<string> => {
        return new Promise((resolve) =>{
          resolve(ResUtils.getInnerString($r('app.string.fp_disable_forever')));
        });
      })
      expect(viewModel.temporaryPrompt === undefined).assertTrue();
    })

    it('TemporaryPromptViewModelTest0002', TestConst.TEST_LEVEL, (): void => {
      viewModel.countdown(0, 10, false, true, (remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<string> => {
        return new Promise((resolve) =>{
          resolve(ResUtils.getInnerString($r('app.string.fp_disable_forever')));
        });
      })
      expect(viewModel.temporaryPrompt === undefined).assertTrue();
    })

    it('TemporaryPromptViewModelTest0003', TestConst.TEST_LEVEL, (): void => {
      viewModel.showTemporaryPrompt(ResUtils.getInnerString($r('app.string.fp_hold_finger')))
      expect(viewModel.isShowTemporaryPrompt === true).assertTrue();
    })

    it('TemporaryPromptViewModelTest0004', TestConst.TEST_LEVEL, (): void => {
      viewModel.isShowTemporaryPrompt = true;
      viewModel.countdown(0, 10000, false, false, (remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<string> => {
        return new Promise((resolve) =>{
          resolve(ResUtils.getInnerString($r('app.string.fp_disable_forever')));
        });
      })

      viewModel.countdown(0, 10000, false, false, (remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<string> => {
        return new Promise((resolve) =>{
          resolve(ResUtils.getInnerString($r('app.string.fp_disable_forever')));
        });
      })
      viewModel.countdown(0, 10000, false, false, (remainTimes: number, freezingTime: number, isPsdFreezing: boolean): Promise<string> => {
        return new Promise((resolve) =>{
          resolve(ResUtils.getInnerString($r('app.string.fp_disable_forever')));
        });
      })
      expect(viewModel.temporaryPrompt === undefined).assertTrue();
    })

    it('test_hideTemporaryPrompt', TestConst.TEST_LEVEL, (): void => {
      viewModel.hideTemporaryPrompt(HidePromptCode.FINGERPRINT_ANTI_TOUCH_CAMERA);
    })
  })
}