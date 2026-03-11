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


import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { osAccount } from '@kit.BasicServicesKit';
import { FingerprintConstants } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { CustomizePromptViewModel } from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/vm/CustomizePromptViewModel';
import { PromptShowType } from '@ohos/screenlockcomponent/src/main/ets/fingerprint/BasePromptViewModel';

export default function CustomizePromptViewModelTest() {
  describe('CustomizePromptViewModelTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('init', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      customizePromptVM.init($r('app.string.TestAbility_label'));
      expect(customizePromptVM.prompt).assertEqual('test label');
      customizePromptVM.init(undefined);
    })

    it('showPrompt', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      customizePromptVM.showPrompt('test', PromptShowType.TEMPORARY);
      customizePromptVM.showPrompt('test', PromptShowType.PERMANENT);
      expect(customizePromptVM.prompt).assertEqual('test');
    })

    it('changePrompt', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      customizePromptVM.setGetPromptCallback((remainTimes: number,
                                              freezingTime: number,
                                              isPsdFreezing: boolean): string => {
        return 'test';
      })
      customizePromptVM.changePrompt(5, -1, false);
      customizePromptVM.changePrompt(2, -1, false);
      customizePromptVM.changePrompt(0, 3000, true);
    })

    it('refreshVM', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      customizePromptVM.refreshVM();
      expect(customizePromptVM.isShowPrompt).assertFalse();
    })

    it('refreshStartTime', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      customizePromptVM.refreshStartTime();
    })

    it('checkFreezingTime', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      customizePromptVM.checkFreezingTime();
    })

    it('authCallback', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      let properties: osAccount.ExecutorProperty = {} as osAccount.ExecutorProperty;
      customizePromptVM.authCallback(properties, true);
      properties = {
        remainTimes: 0,
        freezingTime: 3000
      } as osAccount.ExecutorProperty;
      customizePromptVM.authCallback(properties, true);
      customizePromptVM.authCallback(properties, false);

      properties = {
        remainTimes: 0,
        freezingTime: FingerprintConstants.INVALID_DURATION
      } as osAccount.ExecutorProperty;
      customizePromptVM.setGetPsdFreezingTimeCallback(() => {
        return 3000;
      })
      customizePromptVM.authCallback(properties, true);
    })

    it('countdown', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      customizePromptVM.setGetPromptCallback((remainTimes: number,
                                              freezingTime: number,
                                              isPsdFreezing: boolean): string => {
        return 'test';
      })
      customizePromptVM.countdown(0, -1, false, true);
      customizePromptVM.countdown(0, FingerprintConstants.INVALID_DURATION, false, true);
      customizePromptVM.countdown(0, 3000, false, true);
    })

    it('setGetPromptCallback', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      customizePromptVM.setGetPromptCallback((remainTimes: number,
                                              freezingTime: number,
                                              isPsdFreezing: boolean): string => {
        return 'test';
      })
    })

    it('setGetPsdFreezingTime', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      customizePromptVM.setGetPsdFreezingTimeCallback(() => {
        return 3000;
      })
    })

    it('clearCountDownTimer', 0, () => {
      let customizePromptVM = new CustomizePromptViewModel();
      customizePromptVM.countdown(0, 30000, false, true)
      customizePromptVM.clearCountDownTimer();
    })
  })
}
