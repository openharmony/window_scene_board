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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { slClockOneShotToDesktopService } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { immersiveKgMgr, ImmersiveState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { slStateHelper } from '../../../../../../../main/ets/common/helper/SlStateHelper';
import { MirrorsScene } from '../../../../../../../main/ets/onemirror/constants/MirrorToEndConst';
import { ScreenLockRootMirrorCtrl } from '../../../../../../../main/ets/onemirror/model/ScreenLockRootMirrorCtrl';
import OneMirrorAnimController from '../../../../../../../main/ets/onemirror/viewmodel/OneMirrorAnimController';
import OneMirrorAnimControllerFull from '../../../../../../../main/ets/onemirror/viewmodel/OneMirrorAnimControllerFull';
import OneMirrorAnimControllerPart from '../../../../../../../main/ets/onemirror/viewmodel/OneMirrorAnimControllerPart';
import OneMirrorAnimControllerPartEmoji
  from '../../../../../../../main/ets/onemirror/viewmodel/OneMirrorAnimControllerPartEmoji';

/**
 * 沉浸式锁屏测试用例
 */
export default function OverrideCoverageTest() {
  describe('OverrideCoverageTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    let animCtrl: OneMirrorAnimController = new OneMirrorAnimControllerFull();

    it('OneMirrorAnimControllerFull_test_startOneMirrorAnim', Level.LEVEL0, (): void => {
      animCtrl = new OneMirrorAnimControllerPartEmoji();
      execAllFunTest(animCtrl);
      expect(animCtrl).not().assertUndefined();
    });

    it('OneMirrorAnimControllerPartFull_test_startOneMirrorAnim', Level.LEVEL0, (): void => {
      animCtrl = new OneMirrorAnimControllerPart();
      execAllFunTest(animCtrl);
      expect(animCtrl).not().assertUndefined();
    });

    it('OneMirrorAnimControllerPartFull_test_startOneMirrorAnim', Level.LEVEL0, (): void => {
      animCtrl = new OneMirrorAnimControllerPartEmoji();
      execAllFunTest(animCtrl);
      expect(animCtrl).not().assertUndefined();
    });

    it('OneMirrorAnimControllerPartFull_screenLockToAod', Level.LEVEL0, (done: Function): void => {
      let fullTest = new OneMirrorAnimControllerFullTest()
      let result = true
      try {
        fullTest.screenLockToAod(undefined)
        fullTest.screenLockToAod(false)
        fullTest.screenLockToAod(true)
      } catch (e) {
        result = false
      } finally {
        done()
      }
      expect(result).assertTrue()
    });

    it('OneMirrorAnimControllerPartFull_desktopToAod', Level.LEVEL0, (done: Function): void => {
      let fullTest = new OneMirrorAnimControllerFullTest()
      let result = true
      try {
        let mocker = new MockKit()
        fullTest.desktopToAod(undefined)

        fullTest.desktopToAod(true)
        let displayState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState()
        let isImmersiveFunc = mocker.mockFunc(displayState,displayState.isImmersive)
        let animAvailableFunc =  mocker.mockFunc(slClockOneShotToDesktopService,slClockOneShotToDesktopService.isClockOneShotAnimAvailable)
        when(isImmersiveFunc)(ArgumentMatchers.any).afterReturn(true)
        when(animAvailableFunc)(ArgumentMatchers.any).afterReturn(true)
        fullTest.desktopToAod(false)
        when(isImmersiveFunc)(ArgumentMatchers.any).afterReturn(true)
        when(animAvailableFunc)(ArgumentMatchers.any).afterReturn(false)
        fullTest.desktopToAod(false)
        when(isImmersiveFunc)(ArgumentMatchers.any).afterReturn(false)
        when(animAvailableFunc)(ArgumentMatchers.any).afterReturn(false)
        fullTest.desktopToAod(false)
        when(isImmersiveFunc)(ArgumentMatchers.any).afterReturn(false)
        when(animAvailableFunc)(ArgumentMatchers.any).afterReturn(true)
        fullTest.desktopToAod(false)
      } catch (e) {
        result = false
      } finally {
        done()
      }
      expect(result).assertTrue()
    });
    it('OneMirrorAnimControllerPartFull_aodToDesktop', Level.LEVEL0, (done: Function): void => {
      let fullTest = new OneMirrorAnimControllerFullTest()
      let result = true
      try {
        let mocker = new MockKit()
        fullTest.aodToDesktop(undefined)
        fullTest.aodToDesktop(true)
        let bindState = slStateHelper.getSlClockBindState()
        let clockOneShotFunc = mocker.mockFunc(bindState,bindState?.isInDesktopAndAodClockOneShot)
        when(clockOneShotFunc)(ArgumentMatchers.any).afterReturn(true)
        fullTest.aodToDesktop(false)
        when(clockOneShotFunc)(ArgumentMatchers.any).afterReturn(false)
        fullTest.aodToDesktop(false)
      } catch (e) {
        result = false
      } finally {
        done()
      }
      expect(result).assertTrue()
    });
    it('OneMirrorAnimControllerPartFull_screenOffToScreenLock', Level.LEVEL0, (done: Function): void => {
      let fullTest = new OneMirrorAnimControllerFullTest()
      let result = true
      try {
        fullTest.screenOffToScreenLock(undefined)
        fullTest.screenOffToScreenLock(false)
        fullTest.screenOffToScreenLock(true)
      } catch (e) {
        result = false
      } finally {
        done()
      }
      expect(result).assertTrue()
    });
    it('OneMirrorAnimControllerPartFull_aodToScreenLock', Level.LEVEL0, (done: Function): void => {
      let fullTest = new OneMirrorAnimControllerFullTest()
      let result = true
      try {
        fullTest.aodToScreenLock(undefined)
        fullTest.aodToScreenLock(false)
        fullTest.aodToScreenLock(true)
      } catch (e) {
        result = false
      } finally {
        done()
      }
      expect(result).assertTrue()
    });
    it('OneMirrorAnimControllerPartFull_screenOffToScreenLockEnd', Level.LEVEL0, (done: Function): void => {
      let fullTest = new OneMirrorAnimControllerFullTest()
      let result = true
      try {
        fullTest.screenOffToScreenLockEnd(undefined)
        fullTest.screenOffToScreenLockEnd(false)
        fullTest.screenOffToScreenLockEnd(true)
      } catch (e) {
        result = false
      } finally {
        done()
      }
      expect(result).assertTrue()
    });
  });
}

function execAllFunTest(animCtrl: OneMirrorAnimController) {
  execOneFunTest(animCtrl, MirrorsScene.SCREEN_ON);
  execOneFunTest(animCtrl, MirrorsScene.END_SCREEN_ON);
  execOneFunTest(animCtrl, MirrorsScene.SCREEN_OFF);
  execOneFunTest(animCtrl, MirrorsScene.BEGIN_SLEEP);
  execOneFunTest(animCtrl, MirrorsScene.AOD_TO_DESKTOP);
  execOneFunTest(animCtrl, MirrorsScene.AOD_TO_SL);
  execOneFunTest(animCtrl, MirrorsScene.SCREEN_OFF_TO_SL);
  execOneFunTest(animCtrl, MirrorsScene.SCREEN_OFF_TO_SL_END);
  execOneFunTest(animCtrl, MirrorsScene.DESKTOP_TO_AOD);
  execOneFunTest(animCtrl, MirrorsScene.DESKTOP_TO_SLEEP);
  execOneFunTest(animCtrl, MirrorsScene.SL_TO_SLEEP);
  execOneFunTest(animCtrl, MirrorsScene.SL_TO_AOD);
  execOneFunTest(animCtrl, MirrorsScene.THEME_EDITOR_TO_SL);
  execOneFunTest(animCtrl, MirrorsScene.AOD_TO_DEFAULT);
}

function execOneFunTest(animCtrl: OneMirrorAnimController, scene: MirrorsScene) {
  animCtrl.startOneMirrorAnim(scene, true);
  animCtrl.startOneMirrorAnim(scene, false);
}
export class OneMirrorAnimControllerFullTest extends OneMirrorAnimControllerFull {
  // 锁屏元素整体一镜到底动效
  public screenLockRootCtrl: ScreenLockRootMirrorCtrl = new ScreenLockRootMirrorCtrl();
  public screenLockToAod(isRefresh?: boolean | undefined): void {
    super.screenLockToAod(isRefresh)
  }
  public desktopToAod(isRefresh?: boolean | undefined): void {
    super.desktopToAod(isRefresh)
  }
  public aodToDesktop(isRefresh?: boolean | undefined): void {
    super.aodToDesktop(isRefresh)
  }
  public screenOffToScreenLock(isRefresh?: boolean | undefined): void {
    super.screenOffToScreenLock(isRefresh)
  }
  public aodToScreenLock(isRefresh?: boolean | undefined): void {
    super.aodToScreenLock(isRefresh)
  }
  public screenOffToScreenLockEnd(isRefresh?: boolean | undefined): void {
    super.screenOffToScreenLockEnd(isRefresh)
  }
}