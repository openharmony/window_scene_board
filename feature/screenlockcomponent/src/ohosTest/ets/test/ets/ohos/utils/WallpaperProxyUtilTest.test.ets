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
import TestConst from '../constants/TestConst';
import MirrorAniConfig from '../../../../../../main/ets/onemirror/model/MirrorAnimationConf';
import WallpaperProxy from '../../../../../../main/ets/onemirror/utils/WallpaperProxyUtil';

export default function WallpaperProxyUtilTest() {

  describe('WallpaperProxyUtilTest', (): void => {

    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {

    });

    afterAll((): void => {

    });

    it('test_WallpaperProxy_playScreenLock2AodAnimation_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      const callback: Function = () => {
        result = true;
      };
      WallpaperProxy.getInstance().playScreenLock2AodAnimation(true, true, callback);
      setTimeout(() => {
        expect(result).not().assertNull();
      }, 50);
    });

    it('test_WallpaperProxy_playDesktop2AodAnimation_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      const callback: Function = () => {
        result = true;
      };
      WallpaperProxy.getInstance().playDesktop2AodAnimation(true, true, callback);
      setTimeout(() => {
        expect(result).not().assertNull();
      }, 50);
    });

    it('test_WallpaperProxy_playDesktop2SleepAnimation_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      const callback: Function = () => {
        result = true;
      };
      WallpaperProxy.getInstance().playDesktop2SleepAnimation(true, true, callback);
      setTimeout(() => {
        expect(result).not().assertNull();
      }, 50);
    });

    it('test_WallpaperProxy_playScreenLock2SleepAnimation_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      const callback: Function = () => {
        result = true;
      };
      WallpaperProxy.getInstance().playScreenLock2SleepAnimation(true, true, callback);
      setTimeout(() => {
        expect(result).not().assertNull();
      }, 50);
    });

    it('test_playAod2ScreenLockAnimation', TestConst.TEST_LEVEL, (): void => {
      WallpaperProxy.getInstance().playAod2ScreenLockAnimation(true);
      WallpaperProxy.getInstance().playAod2ScreenLockAnimation(true, false);
      WallpaperProxy.getInstance().playAod2ScreenLockAnimation(false, false);
      expect(WallpaperProxy.getInstance()).not().assertNull();
    });

    it('test_playDesktop2AodAnimation', TestConst.TEST_LEVEL, (): void => {
      WallpaperProxy.getInstance().playDesktop2AodAnimation(true, true);
      WallpaperProxy.getInstance().playDesktop2AodAnimation(true, false);
      WallpaperProxy.getInstance().playDesktop2AodAnimation(false, true);
      WallpaperProxy.getInstance().playDesktop2AodAnimation(false, false);
      expect(WallpaperProxy.getInstance()).not().assertNull();
    });

    it('test_playScreenOff2ScreenLockAnimation', TestConst.TEST_LEVEL, (): void => {
      WallpaperProxy.getInstance().playScreenOff2ScreenLockAnimation(true, true);
      WallpaperProxy.getInstance().playScreenOff2ScreenLockAnimation(true, false);
      WallpaperProxy.getInstance().playScreenOff2ScreenLockAnimation(false, true);
      WallpaperProxy.getInstance().playScreenOff2ScreenLockAnimation(false, false);
      expect(WallpaperProxy.getInstance()).not().assertNull();
    });

    it('test_playScreenOff2DesktopAnimation', TestConst.TEST_LEVEL, (): void => {
      WallpaperProxy.getInstance().playScreenOff2DesktopAnimation(true, true);
      WallpaperProxy.getInstance().playScreenOff2DesktopAnimation(true, false);
      WallpaperProxy.getInstance().playScreenOff2DesktopAnimation(false, true);
      WallpaperProxy.getInstance().playScreenOff2DesktopAnimation(false, false);
      expect(WallpaperProxy.getInstance()).not().assertNull();
    });

    it('test_playAod2DefaultAnimation', TestConst.TEST_LEVEL, (): void => {
      WallpaperProxy.getInstance().playAod2DefaultAnimation(true, true);
      WallpaperProxy.getInstance().playAod2DefaultAnimation(true, false);
      WallpaperProxy.getInstance().playAod2DefaultAnimation(false, true);
      WallpaperProxy.getInstance().playAod2DefaultAnimation(false, false);
      expect(WallpaperProxy.getInstance()).not().assertNull();
    });
  });
}