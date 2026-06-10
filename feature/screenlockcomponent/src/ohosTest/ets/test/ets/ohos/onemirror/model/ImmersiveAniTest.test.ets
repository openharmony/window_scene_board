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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { ImmersiveAni } from '../../../../../../../main/ets/onemirror/model/ImmersiveAni';
import MirrorAniConfig from '../../../../../../../main/ets/onemirror/model/MirrorAnimationConf';
import IAodProxy from '../../../../../../../main/ets/onemirror/model/IAodProxy';
import { AodElemPosition } from '@ohos/themeservice';

/**
 * 沉浸式锁屏测试用例
 */
export default function ImmersiveAniTest() {
  describe('ImmersiveAniTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    let mirrorAniConfig: MirrorAniConfig = new MirrorAniConfig();
    let aIAodProxy: IAodProxy = {
      async checkAod(): Promise<void> {
      },
      isFingerprintEnable(): boolean {
        return true;
      },
      isPartScreenAOD(): boolean {
        return true;
      },
      isFullScreenAOD(): boolean {
        return true;
      },
      isAODEnable(): boolean {
        return true;
      },
      async start(isSupportScreenToEnd: boolean): Promise<void> {
      },
      async stop(screenStatus: number): Promise<void> {
      },
      isAodDataInValid: (): boolean => {
        return false;
      },
      updateTPState: (isOpen: boolean): void => {
        return;
      },
      isPartEmoji: (): boolean => {
        return false;
      },
      isPartAodPlayMirror: (): boolean => {
        return false;
      },
      isFullAodPlayMirror: (): boolean => {
        return false;
      },
      isOnlineMixAod: (): boolean => {
        return false;
      },
      getAodLayerInfo: (isRealtime: boolean): Promise<AodElemPosition> => {
        return new Promise((resolve, reject) => {
          resolve({ type: 0 });
        });
      }
    };
    let immersiveAni: ImmersiveAni = new ImmersiveAni(mirrorAniConfig, aIAodProxy);

    it('test_doWhenBeginSleep', Level.LEVEL0, (): void => {
      immersiveAni.doWhenBeginSleep();
    });

    it('test_doWhenEndScreenOn', Level.LEVEL0, (): void => {
      immersiveAni.doWhenEndScreenOn();
    });

    it('test_doWhenOffScreen', Level.LEVEL0, (): void => {
      immersiveAni.doWhenOffScreen();
    });

    it('test_doWhenOnScreen', Level.LEVEL0, (): void => {
      immersiveAni.doWhenOnScreen();
    });

    it('test_doWhenDesktopToAOD', Level.LEVEL0, (): void => {
      immersiveAni.doWhenDesktopToAOD();
    });

    it('test_doWhenScreenLockToAOD', Level.LEVEL0, (): void => {
      immersiveAni.doWhenScreenLockToAOD();
    });

    it('test_initScreenLock', Level.LEVEL0, (): void => {
      (immersiveAni as object)['initScreenLock']();
    });

    it('test_hide', Level.LEVEL0, (): void => {
      (immersiveAni as object)['hide']();
    });

    it('test_doWhenAODToDesktop', Level.LEVEL0, (): void => {
      immersiveAni.doWhenAODToDesktop();
    });

    it('test_doWhenAODToScreenLock', Level.LEVEL0, (): void => {
      immersiveAni.doWhenAODToScreenLock();
    });

    it('test_doWhenAODSCL2AOD', Level.LEVEL0, (): void => {
      immersiveAni.doWhenAODSCL2AOD();
    });

    it('test_doWhenOffScreen2ScreenLockEnd', Level.LEVEL0, (): void => {
      immersiveAni.doWhenOffScreen2ScreenLockEnd();
    });

    it('test_doWhenOffScreen2ScreenLockBegin', Level.LEVEL0, (): void => {
      immersiveAni.doWhenOffScreen2ScreenLockBegin();
    });
  });
}