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

import { describe, beforeAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { DeviceHelper,WallpaperManager, WallpaperType } from '@ohos/frameworkwrapper';
import { image } from '@kit.ImageKit';
import { dtWallpaperStateMgr } from '../../../../main/ets/wallpaper/model/DesktopWallpaperModel';
import { DesktopWallpaperState } from '../../../../main/ets/wallpaper/viewmodel/DesktopWallpaperState';

export function DesktopWallpaperModelTest() {
  describe('DesktopWallpaperModelTest', (): void => {
    beforeAll((): void => {

    });

    it('DesktopWallpaperModel_test_getDtWallpaperState_should_not_null', Level.LEVEL0, (): void => {
      let wallpaperState0: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
      expect(wallpaperState0).not().assertNull();
    });

    it('DesktopWallpaperModel_test_screedId_getDtWallpaperState_should_equal', Level.LEVEL0, (): void => {
      let wallpaperState0: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
      let wallpaperState1: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState();
      expect(wallpaperState0).not().assertNull();
      expect(wallpaperState1).not().assertNull();
      expect(wallpaperState1).assertEqual(wallpaperState0);
    });

    it('DesktopWallpaperModel_test_screedId_getDtWallpaperState_should_not_equal', Level.LEVEL0, (): void => {
      let wallpaperState0: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
      let wallpaperState1: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(1);
      expect(wallpaperState0).not().assertNull();
      expect(wallpaperState1).not().assertNull();
      expect(wallpaperState1).not().assertEqual(wallpaperState0);
    });

    it('DesktopWallpaperModel_test_setShowDefaultsWallpaper_false_should_false', Level.LEVEL0, (): void => {
      let wallpaperState: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
      expect(wallpaperState).not().assertNull();
      wallpaperState.setShowDefaultsWallpaper(false);
      let isShow = wallpaperState.isShowDefaultsWallpaper();
      expect(isShow).assertFalse();
    });

    it('DesktopWallpaperModel_test_setShowDefaultsWallpaper_true_should_true', Level.LEVEL0, (): void => {
      let wallpaperState: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
      expect(wallpaperState).not().assertNull();
      wallpaperState.setShowDefaultsWallpaper(true);
      let isShow = wallpaperState.isShowDefaultsWallpaper();
      expect(isShow).assertTrue();
    });

    it('DesktopWallpaperModel_test_removeDtWallpaperState', Level.LEVEL0, (): void => {
      dtWallpaperStateMgr.getDtWallpaperState(0);
      dtWallpaperStateMgr.removeDtWallpaperState(0);
      expect(true).assertTrue();
    });

    it('DesktopWallpaperModel_test_setDefaultsWallpaper_for_all', Level.LEVEL0, (): void => {
      let wallpaperState: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
      wallpaperState.setShowDefaultsWallpaper(true);
      let wallpaperState1: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(1);
      wallpaperState.setShowDefaultsWallpaper(true);
      let wallpaper: image.PixelMap | string | undefined = undefined;
      WallpaperManager.getInstance().getWallpaper(WallpaperType.DESKTOP, 'DesktopWallpaperModelTest').then((wallpaperTmp: image.PixelMap) => {
        wallpaper = wallpaperTmp;
        dtWallpaperStateMgr.setDefaultsWallpaper(wallpaperTmp);
      });
      expect(wallpaperState.getDefaultsWallpaperImg()).assertEqual(wallpaper);
      expect(wallpaperState.getDefaultsWallpaperImg()).assertEqual(wallpaperState1.getDefaultsWallpaperImg());
    });

    it('DesktopWallpaperModel_test_setDefaultsWallpaper_for_screenId', Level.LEVEL0,
      async (): Promise<void> => {
        let wallpaperState0: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
        wallpaperState0.setShowDefaultsWallpaper(true);
        let wallpaperState1: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(1);
        wallpaperState1.setShowDefaultsWallpaper(true);
        let color = `#${Math.floor(Math.random() * 16777215).toString(16)}`;
        let buffer = new ArrayBuffer(color.length);
        let bufferView = new Uint8Array(buffer);
        for (let i = 0; i < color.length; i++) {
          bufferView[i] = color.charCodeAt(i);
        }
        let wallpaper = await image.createPixelMap(bufferView, { size: { width: 100, height: 100 } });
        dtWallpaperStateMgr.setDefaultsWallpaper(wallpaper, 0);
        if (wallpaper === undefined) {
          expect(wallpaperState1.getDefaultsWallpaperImg()).assertEqual(wallpaperState0.getDefaultsWallpaperImg());
        } else {
          expect(wallpaperState1.getDefaultsWallpaperImg())
            .not()
            .assertEqual(wallpaperState0.getDefaultsWallpaperImg());
        }
      });

    it('DesktopWallpaperModel_test_setDefaultsWallpaperPath', Level.LEVEL0, (): void => {
      let wallpaperPath: string = '/data/theme/public/a/';
      let wallpaperState: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
      wallpaperState.setShowDefaultsWallpaper(true);
      dtWallpaperStateMgr.setDefaultsWallpaperPath(wallpaperPath);
      let mocker: MockKit = new MockKit();
      let mockFuc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFuc1)().afterReturn(true);
      expect(wallpaperState.getDefaultsWallpaperImg()).assertEqual(wallpaperPath);
    });

    it('DesktopWallpaperModel_test_setEmptyWallpaperPath', Level.LEVEL0, (): void => {
      let wallpaperPath: string = '';
      let wallpaperState: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
      wallpaperState.setShowDefaultsWallpaper(true);
      dtWallpaperStateMgr.setDefaultsWallpaperPath(wallpaperPath);
      let mocker: MockKit = new MockKit();
      let mockFuc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFuc1)().afterReturn(true);
      expect(wallpaperState.getDefaultsWallpaperImg()).assertUndefined();
    });

    it('DesktopWallpaperModel_test_setDesktopWallpaperMode_false', Level.LEVEL0, (): void => {
      let wallpaperState: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
      dtWallpaperStateMgr.setDesktopWallpaperMode(false, 0);
      expect(wallpaperState.isShowDefaultsWallpaper()).assertTrue();
    });

    it('DesktopWallpaperModel_test_setDesktopWallpaperMode_true', Level.LEVEL0, (): void => {
      let wallpaperState: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(0);
      dtWallpaperStateMgr.setDesktopWallpaperMode(true);
      expect(wallpaperState.isShowDefaultsWallpaper()).assertFalse();
    });

  });
}

