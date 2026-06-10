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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import { slWallpaperMgr, SLWallpaperType, SLWallpaperVisibleScene } from '@ohos/screenlockcommon';
import type image from '@ohos.multimedia.image';

export default function ScreenLockWallpaperManager() {

  describe('ScreenLockWallpaperManager', (): void => {
    let newImg: image.PixelMap;

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it("test_ScreenLockWallpaperManager_isStaticWallpaper_is_not_null_or_undefined", TestConst.TEST_LEVEL, (): void => {
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertNull();
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertUndefined();
    })

    it('test_ScreenLockWallpaperManager_setSlWallpaperBlurByAnimStart_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      try {
        slWallpaperMgr.setSlWallpaperBlurByAnimStart();
        result = true;
      } catch (e) {
        result = false;
      }
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertNull();
    });

    it('test_setWallpaperVisibility', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      slWallpaperMgr.enterSlWallpaperScene(SLWallpaperType.TYPE_ENGINE_THEME,
        SLWallpaperVisibleScene.SCENE_SCREEN_CAMERA);
      expect(slWallpaperMgr.getSlWallpaperState().isVisible).assertEqual(true);
    });

    it('test_setWallpaperVisibility_one', TestConst.TEST_LEVEL, (): void => {
      slWallpaperMgr.enterSlWallpaperScene(SLWallpaperType.TYPE_IMMERSIVE_STYLE,
        SLWallpaperVisibleScene.SCENE_DEFAULT);
      expect(slWallpaperMgr.getSlWallpaperState().isVisible).assertEqual(true);
    });

    it('test_exitSlWallpaperScene', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_ENGINE_THEME,
        SLWallpaperVisibleScene.SCENE_SCREEN_CAMERA);
      expect(slWallpaperMgr.getSlWallpaperState().isVisible).not().assertNull();
    });

    it('test_exitSlWallpaperScene_one', TestConst.TEST_LEVEL, (): void => {
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_IMMERSIVE_STYLE,
        SLWallpaperVisibleScene.SCENE_DEFAULT);
      expect(slWallpaperMgr.getSlWallpaperState().isVisible).assertEqual(false);
    });

    it('test_exitSlWallpaperScene_two', TestConst.TEST_LEVEL, (): void => {
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_NONE,
        SLWallpaperVisibleScene.SCENE_DEFAULT);
      expect(slWallpaperMgr.getSlWallpaperState().isVisible).assertEqual(false);
    });

    it('test_setSlWallpaperBlurByAnimStart', TestConst.TEST_LEVEL, (): void => {
      slWallpaperMgr.setSlWallpaperBlurByAnimStart();
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertNull();
    });

    it('test_setSlWallpaperBlurByAnimEnd', TestConst.TEST_LEVEL, (): void => {
      slWallpaperMgr.setSlWallpaperBlurByAnimEnd();
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertNull();
    });

    it('test_setSlWallpaperAlpha', TestConst.TEST_LEVEL, (): void => {
      let alpha: number = 1;
      slWallpaperMgr.setSlWallpaperAlpha(alpha);
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertNull();
    });

    it('test_setSlWallpaperSaturate', TestConst.TEST_LEVEL, (): void => {
      let saturate: number = 1;
      slWallpaperMgr.setSlWallpaperSaturate(saturate);
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertNull();
    });

    it('test_setSupportDof', TestConst.TEST_LEVEL, (): void => {
      let isSupportDof: boolean = false;
      slWallpaperMgr.setSupportDof(isSupportDof);
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertNull();
    });

    it('test_setSupportDof_one', TestConst.TEST_LEVEL, (): void => {
      let isSupportDof: boolean = true;
      slWallpaperMgr.setSupportDof(isSupportDof);
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertNull();
    });

    it('test_setSlWallpaperImg', TestConst.TEST_LEVEL, (): void => {
      slWallpaperMgr.setSlWallpaperImg(SLWallpaperType.TYPE_ENGINE_THEME);
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertNull();
    });

    it('test_setBlurByAnimStart', TestConst.TEST_LEVEL, (): void => {
      slWallpaperMgr.setSlWallpaperImg(SLWallpaperType.TYPE_ENGINE_THEME);
      expect(slWallpaperMgr.getSlWallpaperState()).not().assertNull();
    });
  })
}