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
import { WallpaperManager, WallpaperType } from '@ohos/frameworkwrapper';

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';

import { image } from '@kit.ImageKit';
import { WallpaperModel } from '../../../../main/ets/wallpaper/model/WallpaperModel';

export function WallpaperModelTest() {
  describe('WallpaperModelTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })
    it('test_setWallpaper_01', 0, async () => {
      const wallpaperModel = new WallpaperModel();
      let wallpaperType: WallpaperType = 0;
      let res = await wallpaperModel.setWallpaper(wallpaperType)
      expect(res !== null).assertTrue()
    })

    it('test_setWallpaper_02', 0, async () => {
      const wallpaperModel = new WallpaperModel();
      let wallpaperType: WallpaperType = 0;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      let res = await wallpaperModel.setWallpaper(wallpaperType)
      expect(res !== null).assertTrue()
    })

    it('test_setWallpaper_03', 0, async () => {
      const wallpaperModel = new WallpaperModel();
      let wallpaperType: WallpaperType = 0;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      let res = await wallpaperModel.setWallpaper(wallpaperType)
      expect(res !== null).assertTrue()
    })

    it('test_setWallpaper_04', 0, async () => {
      const wallpaperModel = new WallpaperModel();
      let wallpaperType: WallpaperType = 1;
      let res = await wallpaperModel.setWallpaper(wallpaperType)
      expect(res !== null).assertTrue()
    })

    it('test_handleContentColorChange_02', 0, async () => {
      const wallpaperModel = new WallpaperModel();
      (wallpaperModel as object)['contentColorListeners'] = new Map()
      let imageParam = await resourceManagerCreateImage()
      let res = await wallpaperModel.handleContentColorChange(imageParam)
      expect(res !== null).assertTrue()
    })

    it('test_handleScreenLockWallpaperChange_01', 0, async () => {
      const wallpaperModel = new WallpaperModel();
      let res: Promise<void> = await (wallpaperModel as object)['handleScreenLockWallpaperChange'](null)
      expect(res !== null).assertTrue()
    })

    it('test_handleScreenLockWallpaperChange_02', 0, async () => {
      const wallpaperModel = new WallpaperModel();
      let res: Promise<void> = await (wallpaperModel as object)['handleScreenLockWallpaperChange'](undefined)
      expect(res !== null).assertTrue()
    })

    it('test_handleScreenLockWallpaperChange_03', 0, async () => {
      const wallpaperModel = new WallpaperModel();
      let imageParam = await resourceManagerCreateImage()
      let res: Promise<void> = await (wallpaperModel as object)['handleScreenLockWallpaperChange'](imageParam)
      expect(res !== null).assertTrue()
    })

    it('test_unRegisterContentColorListener_01', 0, () => {
      const wallpaperModel = new WallpaperModel();
      let res = wallpaperModel.unRegisterContentColorListener('')
      expect(res !== null).assertTrue()
    })

    it('test_unRegisterContentColorListener_02', 0, () => {
      const wallpaperModel = new WallpaperModel();
      let res = wallpaperModel.unRegisterContentColorListener('key')
      expect(res !== null).assertTrue()
    })

  })
}

async function resourceManagerCreateImage(): Promise<image.PixelMap> {
  let width: number = 10;
  let height: number = 10;
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}