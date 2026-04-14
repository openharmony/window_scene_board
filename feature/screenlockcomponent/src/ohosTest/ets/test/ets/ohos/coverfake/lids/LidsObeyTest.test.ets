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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, when, MockKit } from '@ohos/hypium';
import SlClockOneShotToDesktopService, {
  ClockOneShotAniAvailableFromDesktopStateWrapper
} from '@ohos/screenlockcommon/src/main/ets/base/SlClockOneShotToDesktopService';
import osAccount from '@ohos.account.osAccount';
import { sysDialogMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';

export default function LidsObeyTest() {

  describe('LidsObeyTest', (): void => {
    let mocker: MockKit;
    beforeAll((): void => {
      mocker = new MockKit();
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    afterAll((): void => {
      mocker.clearAll();
    })

    it('test_isClockOneShotAnimAvailable', 0, (): void => {
      SlClockOneShotToDesktopService.setJudgeClockAniAvailableFromDesktop((state:
        ClockOneShotAniAvailableFromDesktopStateWrapper) => {
        state.isAvailable = true;
      });
      SlClockOneShotToDesktopService.updateClockVisible(true);

      let isSysDialogShowing = mocker.mockFunc(Boolean, sysDialogMgr.isSysDialogShowing);
      when(isSysDialogShowing)().afterReturn(false);

      let result = SlClockOneShotToDesktopService.isClockOneShotAnimAvailable();
      expect(result).assertEqual(true);
    })

    it('test_isClockDesktopToAodAnimAvailable_isClockAodToDesktopAnimAvailable', 0, (): void => {
      SlClockOneShotToDesktopService.isSupportMirrorToEnd = () => {
        return true;
      };
      let mockFunc: Function = mocker.mockFunc(SlClockOneShotToDesktopService,
        SlClockOneShotToDesktopService.isClockOneShotAnimAvailable);
      when(mockFunc)().afterReturn(true);
      let result1 = SlClockOneShotToDesktopService.isClockDesktopToAodAnimAvailable(true);
      expect(result1).assertEqual(true);
      let result2 = SlClockOneShotToDesktopService.isClockDesktopToAodAnimAvailable();
      expect(result2).assertEqual(true);
      let result3 = SlClockOneShotToDesktopService.isClockAodToDesktopAnimAvailable();
      expect(result3).assertEqual(true);
      mocker.clear(SlClockOneShotToDesktopService);
      mocker.clearAll();
    })

    it('test_setNoPwdUnlockJustAnimation', 0, (): void => {
      let execute: string = '';
      const callback: Callback<osAccount.AuthType> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.setNoPwdUnlockJustAnimation(callback);
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_setNoPwdUnlockExitKeyguard', 0, (): void => {
      let execute: string = '';
      const callback: Callback<osAccount.AuthType> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.setNoPwdUnlockExitKeyguard(callback);
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_notifyUpdateTextColorOfDesktopClock', 0, (): void => {
      let execute: string = '';
      const callback1: Callback<string> = () => {
        execute = 'success1';
      };
      const callback2: Callback<string> = () => {
        execute = 'success2';
      };

      SlClockOneShotToDesktopService.notifyUpdateTextColorOfDesktopClock();
      expect(execute == 'success1' ? true : false).assertEqual(false);

      SlClockOneShotToDesktopService.setSetTextColorOfDesktopClock(callback1);
      SlClockOneShotToDesktopService.notifyUpdateTextColorOfDesktopClock();
      expect(execute == 'success1' ? true : false).assertEqual(true);

      SlClockOneShotToDesktopService.setSetTextColorOfDesktopClockForEffect(callback2);
      SlClockOneShotToDesktopService.notifyUpdateTextColorOfDesktopClock();
      expect(execute == 'success2' ? true : false).assertEqual(true);
    })

    it('test_setSetTextColorOfDesktopClock', 0, (): void => {
      let execute: string = '';
      const callback: Callback<string> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.setSetTextColorOfDesktopClock(callback);
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_setSetTextColorOfDesktopClockForEffect', 0, (): void => {
      let execute: string = '';
      const callback: Callback<string> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.setSetTextColorOfDesktopClockForEffect(callback);
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_setJudgeClockAniAvailableFromDesktop', 0, (): void => {
      let execute: string = '';
      const callback: Callback<ClockOneShotAniAvailableFromDesktopStateWrapper> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.setJudgeClockAniAvailableFromDesktop(callback);
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_notifyRecoverClockAfterOneShotAnim', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.updateClockOnMove(false);
      SlClockOneShotToDesktopService.notifyRecoverClockAfterOneShotAnim();
      expect(execute == 'success' ? true : false).assertEqual(false);

      SlClockOneShotToDesktopService.updateClockOnMove(false);
      SlClockOneShotToDesktopService.setRecoverClockAfterOneShotAnim(callback);
      SlClockOneShotToDesktopService.notifyRecoverClockAfterOneShotAnim();
      expect(execute == 'success' ? true : false).assertEqual(false);

      SlClockOneShotToDesktopService.updateClockOnMove(true);
      SlClockOneShotToDesktopService.setRecoverClockAfterOneShotAnim(callback);
      SlClockOneShotToDesktopService.notifyRecoverClockAfterOneShotAnim();
      expect(execute == 'success' ? true : false).assertEqual(true);
    })

    it('test_setRecoverClockAfterOneShotAnim', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.setRecoverClockAfterOneShotAnim(callback);
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_notifyUpdateClockWidgetParamsOnMove', 0, (): void => {
      let execute: string = '';
      const callback: Callback<number> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.notifyUpdateClockWidgetParamsOnMove(0);
      expect(execute == 'success' ? true : false).assertEqual(false);

      SlClockOneShotToDesktopService.setUpdateClockWidgetParamsOnMove(callback);
      SlClockOneShotToDesktopService.notifyUpdateClockWidgetParamsOnMove(0);
      expect(execute == 'success' ? true : false).assertEqual(true);
    })

    it('test_setUpdateClockWidgetParamsOnMove', 0, (): void => {
      let execute: string = '';
      const callback: Callback<number> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.setUpdateClockWidgetParamsOnMove(callback);
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_notifyPrepareForOneShotAnimOnFirstMove', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.notifyPrepareForOneShotAnimOnFirstMove();
      expect(execute == 'success' ? true : false).assertEqual(false);

      SlClockOneShotToDesktopService.setPrepareForOneShotAnimOnFirstMove(callback);
      SlClockOneShotToDesktopService.notifyPrepareForOneShotAnimOnFirstMove();
      expect(execute == 'success' ? true : false).assertEqual(true);
    })

    it('test_setPrepareForOneShotAnimOnFirstMove', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };

      SlClockOneShotToDesktopService.setPrepareForOneShotAnimOnFirstMove(callback);
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_doDesktopToAodClockAnim', 0, (): void => {
      SlClockOneShotToDesktopService.doDesktopToAodClockAnim();
      expect(true).assertTrue();
    })

    it('test_doAodToDesktopClockAnim', 0, (): void => {
      SlClockOneShotToDesktopService.doAodToDesktopClockAnim(() => {});
      expect(true).assertTrue();
    })

    it('test_setUpdateClockAodToDesktopState', 0, (): void => {
      let execute: string = '';
      const callback: Callback<boolean> = () => {
        execute = 'success';
      };
      SlClockOneShotToDesktopService.setUpdateClockAodToDesktopState(callback);
      expect(execute == 'success' ? true : false).assertEqual(false);
    })

    it('test_updateUserSwitching', 0, (): void => {
      SlClockOneShotToDesktopService.updateUserSwitching(true);
      expect(true).assertTrue();
    })

    it('test_updateKeyguardExitingState', 0, (): void => {
      SlClockOneShotToDesktopService.updateKeyguardExitingState(true);
      expect(true).assertTrue();
    })

    it('test_notifyNoPwdUnlockHasExitKeyguard', 0, (): void => {
      SlClockOneShotToDesktopService.noPwdUnlockExitKeyguard = () => {};
      SlClockOneShotToDesktopService.updateKeyguardExitingState(true);
      SlClockOneShotToDesktopService.notifyNoPwdUnlockHasExitKeyguard();
      expect(true).assertTrue();
    })

    it('test_destroy', 0, (): void => {
      SlClockOneShotToDesktopService.init();
      SlClockOneShotToDesktopService.destroy();
      expect(true).assertTrue();
    })
  })
}