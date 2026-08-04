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
import { AodUtil, AodViewController } from '@ohos/aod';
import { MockUtil } from '@ohos/aod/src/ohosTest/ets/test/MockUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper';

import { describe, it, expect } from '@ohos/hypium';
import {
  AodThemeFactoryAnalogClock,
  AodThemeFactoryDigitalClock,
  AodThemeFactoryFullScreen,
  AodThemeFactoryInteractive,
  AodThemeFactoryMountainSea,
  AodThemeFactorySmartSticker,
  AodThemeFactoryStereoForeImage,
  AodThemeFactoryStereoNumberClock
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/factory/AodThemeAbstractFactory';

export function AodThemeAbstractFactoryTest() {
  describe('AodThemeFactoryFullScreenTest', () => {

    it('createFullScreenAodViewControllerTest', 0, () => {
      let themeFactory = new AodThemeFactoryFullScreen();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createFullScreenAodViewControllerTest1', 0, () => {
      let themeFactory = new AodThemeFactoryFullScreen();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isSmallFoldProduct', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createFullScreenAodViewControllerTest2', 0, () => {
      let themeFactory = new AodThemeFactoryFullScreen();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isSmallFoldProduct', (): boolean => {
        return false;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

  });

  describe('AodThemeFactoryDigitalClockTest', () => {

    it('createDigitalClockAodViewControllerTest', 0, () => {
      let themeFactory = new AodThemeFactoryDigitalClock();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createDigitalClockAodViewControllerTest1', 0, () => {
      let themeFactory = new AodThemeFactoryDigitalClock();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createDigitalClockAodViewControllerTest2', 0, () => {
      let themeFactory = new AodThemeFactoryDigitalClock();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return false;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

  });

  describe('AodThemeFactoryStereoForeImageTest', () => {

    it('createStereoForeImageAodViewControllerTest', 0, () => {
      let themeFactory = new AodThemeFactoryStereoForeImage();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createStereoForeImageAodViewControllerTest1', 0, () => {
      let themeFactory = new AodThemeFactoryStereoForeImage();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createStereoForeImageAodViewControllerTest2', 0, () => {
      let themeFactory = new AodThemeFactoryStereoForeImage();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return false;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

  });

  describe('AodThemeFactoryStereoNumberClockTest', () => {

    it('createStereoNumberClockAodViewControllerTest', 0, () => {
      let themeFactory = new AodThemeFactoryStereoNumberClock();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createStereoNumberClockAodViewControllerTest1', 0, () => {
      let themeFactory = new AodThemeFactoryStereoNumberClock();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createStereoNumberClockAodViewControllerTest2', 0, () => {
      let themeFactory = new AodThemeFactoryStereoNumberClock();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return false;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

  });

  describe('AodThemeFactoryInteractiveTest', () => {

    it('createInteractiveAodViewControllerTest', 0, () => {
      let themeFactory = new AodThemeFactoryInteractive();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createInteractiveAodViewControllerTest1', 0, () => {
      let themeFactory = new AodThemeFactoryInteractive();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createInteractiveAodViewControllerTest2', 0, () => {
      let themeFactory = new AodThemeFactoryInteractive();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return false;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

  });

  describe('AodThemeFactoryMountainSeaTest', () => {

    it('createMountainSeaAodViewControllerTest', 0, () => {
      let themeFactory = new AodThemeFactoryMountainSea();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createMountainSeaAodViewControllerTest1', 0, () => {
      let themeFactory = new AodThemeFactoryMountainSea();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createMountainSeaAodViewControllerTest2', 0, () => {
      let themeFactory = new AodThemeFactoryMountainSea();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return false;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

  });

  describe('AodThemeFactoryAnalogClockTest', () => {

    it('createAnalogClockAodViewControllerTest', 0, () => {
      let themeFactory = new AodThemeFactoryAnalogClock();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createAnalogClockAodViewControllerTest1', 0, () => {
      let themeFactory = new AodThemeFactoryAnalogClock();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return true;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

    it('createAnalogClockAodViewControllerTest2', 0, () => {
      let themeFactory = new AodThemeFactoryAnalogClock();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(DeviceHelper, 'isPad', (): boolean => {
        return false;
      });
      themeFactory.createAodViewController();
      expect(true).assertTrue();
    });

  });

  describe('AodThemeFactorySmartStickerTest', () => {
    it('createSmartStickerAodViewControllerTest', 0, () => {
      let themeFactory = new AodThemeFactorySmartSticker();
      MockUtil.mockFuncForObj(AodUtil, 'isFoldDevice', (): boolean => {
        return true;
      });
      let viewController: AodViewController = themeFactory.createAodViewController();
      expect(viewController).not().assertUndefined();
      MockUtil.clearAll();
    });
  });

}