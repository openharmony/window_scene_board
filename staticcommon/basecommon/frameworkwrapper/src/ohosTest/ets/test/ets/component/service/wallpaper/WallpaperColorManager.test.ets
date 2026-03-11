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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, MockKit, when } from '@ohos/hypium';
import { WallpaperColorManager } from '../../../../../../../main/ets/service/wallpaper/WallpaperColorManager';
import {
  DeviceHelper, TextColor, WallpaperManager } from '../../../../../../../main/ets/TsIndex';
import { SCBConstants, WallpaperConstants } from '@ohos/commonconstants';
import effectKit from '@ohos.effectKit';
import { GlobalContext } from '../../../../../../../main/ets/utils/GlobalContext';

const DARK_COLOR_MODE: number = 0;

export function WallpaperColorManagerTest() {
  describe('WallpaperColorManagerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('WallpaperColorManager_test_getInstance_should_not_null', Level.LEVEL0, (): void => {
      let instance1: WallpaperColorManager = WallpaperColorManager.getInstance();
      expect(instance1).not().assertNull();

      let instance2: WallpaperColorManager = WallpaperColorManager.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('WallpaperColorManager_test_load_wallpaper_color_01', Level.LEVEL0, (): void => {
      try {
        WallpaperManager.getInstance().registerEventChange();
        WallpaperColorManager.getInstance().registerWallpaperChange();
        WallpaperColorManager.getInstance().unregisterWallPaperChange();
        WallpaperColorManager.getInstance().loadWallpaper();
        let color: string | undefined = AppStorage.get<string>('wallpaperCoverColor');
        let result = (color === WallpaperConstants.NO_WALLPAPER_COVER_COLOR
          || color === WallpaperConstants.WALLPAPER_COVER_3
          || color === WallpaperConstants.WALLPAPER_COVER_5);

        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('WallpaperColorManager_test_generate_textColorInfo', Level.LEVEL0, (): void => {
      let instance1: WallpaperColorManager = WallpaperColorManager.getInstance();
      instance1.generateTextColorInfo(WallpaperConstants.WALLPAPER_TYPE_ONE, WallpaperConstants.COLOR_WHITE_STRING, false);
      expect(instance1.mSwiperColor).assertEqual(WallpaperConstants.SWIPER_BLACK_COLOR);

      instance1.generateTextColorInfo(WallpaperConstants.WALLPAPER_TYPE_TWO, WallpaperConstants.COLOR_WHITE_STRING, false);
      expect(instance1.mSwiperColor).assertEqual(WallpaperConstants.SWIPER_WHITE_COLOR);

      instance1.generateTextColorInfo(WallpaperConstants.WALLPAPER_TYPE_THREE, WallpaperConstants.COLOR_WHITE_STRING, false);
      expect(instance1.mSwiperColor).assertEqual(WallpaperConstants.SWIPER_WHITE_COLOR);

      instance1.generateTextColorInfo(WallpaperConstants.WALLPAPER_TYPE_FOUR, WallpaperConstants.COLOR_WHITE_STRING, false);
      expect(instance1.mSwiperColor).assertEqual(WallpaperConstants.SWIPER_WHITE_COLOR);

      instance1.generateTextColorInfo(WallpaperConstants.WALLPAPER_TYPE_FIVE, WallpaperConstants.COLOR_WHITE_STRING, false);
      expect(instance1.mSwiperColor).assertEqual(WallpaperConstants.SWIPER_WHITE_COLOR);

      instance1.generateTextColorInfo(WallpaperConstants.WALLPAPER_TYPE_SIX, WallpaperConstants.COLOR_WHITE_STRING, false);
      expect(instance1.mSwiperColor).assertEqual(WallpaperConstants.SWIPER_WHITE_COLOR);

      instance1.generateTextColorInfo(0, WallpaperConstants.COLOR_WHITE_STRING, true);
      expect(instance1.mOuterSwiperColor).assertEqual(WallpaperConstants.SWIPER_WHITE_COLOR);
    })

    it('WallpaperColorManager_test_isLightWallpaper1', Level.LEVEL0, (): void => {
      let manager: WallpaperColorManager = new WallpaperColorManager();
      expect(manager.isLightWallpaper()).assertFalse();
      manager.mTextColor = new TextColor('#FFFFFF', 0, 0, 0, '', 0);
      expect(manager.isLightWallpaper()).assertFalse();
      manager.mTextColor = new TextColor('#000000', 0, 0, 0, '', 0);
      expect(manager.isLightWallpaper()).assertTrue();
    })

    it('WallpaperColorManager_test_isLightWallpaper2', Level.LEVEL0, (): void => {
      let manager: WallpaperColorManager = new WallpaperColorManager();
      expect(manager.isLightWallpaper(true)).assertFalse();
      manager.mOuterTextColor = new TextColor('#FFFFFF', 0, 0, 0, '', 0);
      expect(manager.isLightWallpaper(true)).assertFalse();
    })

    it('WallpaperColorManager_test_getRegionAvgColor1', Level.LEVEL0, async () => {
      try {
        let manager: WallpaperColorManager = WallpaperColorManager.getInstance();
        const mocker: MockKit = new MockKit();
        const mockFunc: Function = mocker.mockFunc(manager, manager.getRegionAvgColor);
        when(mockFunc)([0, 0, 1, 1]).afterReturnNothing();
        let result = await manager.getRegionAvgColor([0, 0, 1, 1]);
        expect(result).assertUndefined();
        mocker.clear(manager);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('WallpaperColorManager_test_getRegionAvgColor2', Level.LEVEL0, async () => {
      try {
        let manager: WallpaperColorManager = WallpaperColorManager.getInstance();
        const mocker: MockKit = new MockKit();
        const mockFunc: Function = mocker.mockFunc(manager, manager.getRegionAvgColor);
        when(mockFunc)().afterReturn(1);
        let result = await manager.getRegionAvgColor();
        expect(result).assertEqual(1);
        mocker.clear(manager);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('WallpaperColorManager_test_updateBrightness', Level.LEVEL0, () => {
      let instance1: WallpaperColorManager = WallpaperColorManager.getInstance();
      let mode: number =
        AppStorage.get<number>('currColorMode') ?? GlobalContext.getContext().config.colorMode as number;
      instance1.wallpaperDegree = WallpaperConstants.WALLPAPER_TYPE_FOUR;
      instance1['updateBrightness']();
      let result1: number = (mode === DARK_COLOR_MODE) ? SCBConstants.BACK_PLANE_BRIGHTNESS_UP_FIFTEEN_PERCENT :
      SCBConstants.BACK_PLANE_BRIGHTNESS_UP_TEN_PERCENT;
      expect(instance1.brightness).assertEqual(result1);

      instance1.wallpaperDegree = WallpaperConstants.WALLPAPER_TYPE_ONE;
      instance1['updateBrightness']();
      let result2: number = (mode === DARK_COLOR_MODE) ? SCBConstants.BACK_PLANE_BRIGHTNESS_DEFAULT :
      SCBConstants.BACK_PLANE_BRIGHTNESS_DOWN_EIGHT_PERCENT;
      expect(instance1.brightness).assertEqual(result2);

      instance1.wallpaperDegree = WallpaperConstants.WALLPAPER_TYPE_TWO;
      instance1['updateBrightness']();
      let result3: number = (mode === DARK_COLOR_MODE) ? SCBConstants.BACK_PLANE_BRIGHTNESS_DOWN_FIVE_PERCENT :
      SCBConstants.BACK_PLANE_BRIGHTNESS_UP_TEN_PERCENT;
      expect(instance1.brightness).assertEqual(result3);
    });

    it('WallpaperColorManager_test_updateBrightness', Level.LEVEL0, () => {
      let instance1: WallpaperColorManager = WallpaperColorManager.getInstance();
      let mode: number =
        AppStorage.get<number>('currColorMode') ?? GlobalContext.getContext().config.colorMode as number;
      instance1.wallpaperDegree = WallpaperConstants.WALLPAPER_TYPE_FOUR;
      instance1['updateBrightness']();
      let result1: number = (mode === DARK_COLOR_MODE) ? SCBConstants.BACK_PLANE_BRIGHTNESS_UP_FIFTEEN_PERCENT :
      SCBConstants.BACK_PLANE_BRIGHTNESS_UP_TEN_PERCENT;
      expect(instance1.brightness).assertEqual(result1);

      instance1.wallpaperDegree = WallpaperConstants.WALLPAPER_TYPE_ONE;
      instance1['updateBrightness']();
      let result2: number = (mode === DARK_COLOR_MODE) ? SCBConstants.BACK_PLANE_BRIGHTNESS_DEFAULT :
      SCBConstants.BACK_PLANE_BRIGHTNESS_DOWN_EIGHT_PERCENT;
      expect(instance1.brightness).assertEqual(result2);

      instance1.wallpaperDegree = WallpaperConstants.WALLPAPER_TYPE_TWO;
      instance1['updateBrightness']();
      let result3: number = (mode === DARK_COLOR_MODE) ? SCBConstants.BACK_PLANE_BRIGHTNESS_DOWN_FIVE_PERCENT :
      SCBConstants.BACK_PLANE_BRIGHTNESS_UP_TEN_PERCENT;
      expect(instance1.brightness).assertEqual(result3);
    });
  })
}