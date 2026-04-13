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

import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { FileUtil } from '@ohos/themeservicebase';
import { FoldState, RotateState, WallpaperInfo } from '../../../../../main/ets/service/impl/activate/WallpaperCaller';
import { WallpaperBlurHandler } from '../../../../../main/ets/service/impl/optimize/WallpaperBlurHandler';
import PixelMapUtil from '../../../../../main/ets/util/PixelMapUtil';

export default function WallpaperBlurHandlerTest() {

  describe('WallpaperBlurHandlerTest', () => {
    it('should_return_wallpaperInfo_when_imagePath_is_undefined', 0, async (done: Function) => {
      let wallpaperInfo: WallpaperInfo = {
        source: '',
        foldState: FoldState.NORMAL,
        rotateState: RotateState.PORTRAIT,
      };
      const result = await WallpaperBlurHandler.handleWallpaper(wallpaperInfo, 'wallpaperType', 'rootPath');
      expect(result).assertEqual(wallpaperInfo);
      done();
    });

    it('should_return_wallpaperInfo_when_wallpaperTypeStr_is_undefined', 0, async (done: Function) => {
      let wallpaperInfo: WallpaperInfo = {
        source: 'path/to/image',
        foldState: FoldState.NORMAL,
        rotateState: RotateState.PORTRAIT,
      };
      const result = await WallpaperBlurHandler.handleWallpaper(wallpaperInfo, '', 'rootPath');
      expect(result).assertEqual(wallpaperInfo);
      done();
    });

    it('should_handle_wallpaper_when_all_parameters_are_defined', 0, async (done: Function) => {
      let wallpaperInfo: WallpaperInfo = {
        source: 'path/to/image',
        foldState: FoldState.NORMAL,
        rotateState: RotateState.PORTRAIT,
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtil, FileUtil.isFileExists);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(PixelMapUtil, PixelMapUtil.creatDefaultPixelMap);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(PixelMapUtil, PixelMapUtil.getBlurPixelMap);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(undefined);
      const result = await WallpaperBlurHandler.handleWallpaper(wallpaperInfo, 'wallpaperType', 'rootPath');
      expect(result?.source).assertEqual('path/to/image');
      mocker.ignoreMock(FileUtil, FileUtil.isFileExists);
      mocker.ignoreMock(PixelMapUtil, PixelMapUtil.creatDefaultPixelMap);
      mocker.ignoreMock(PixelMapUtil, PixelMapUtil.getBlurPixelMap);
      mocker.ignoreMock(PixelMapUtil, PixelMapUtil.writePixelMapToPath);
      mocker.ignoreMock(PixelMapUtil, PixelMapUtil.releasePixelMap);
      done();
    });
  })
}