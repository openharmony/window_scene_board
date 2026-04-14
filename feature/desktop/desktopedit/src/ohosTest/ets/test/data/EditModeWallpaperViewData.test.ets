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
import { EditModeWallpaperViewData } from '../../../../main/ets/default/data/EditModeWallpaperViewData';

export function EditModeWallpaperViewDataTest() {
  describe('EditModeWallpaperViewDataTest', (): void => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getWallpaperBackgroundBlurScale', 0, () => {
      const editModeWallpaperViewData = new EditModeWallpaperViewData();
      expect(editModeWallpaperViewData.getWallpaperBackgroundBlurScale()).assertEqual(0);
    })

    it('test_setWallpaperBackgroundBlurScale', 0, () => {
      const editModeWallpaperViewData = new EditModeWallpaperViewData();
      expect(editModeWallpaperViewData.setWallpaperBackgroundBlurScale(1) === undefined).assertTrue();
    })

    it('test_getWallpaperBackgroundColor', 0, () => {
      const editModeWallpaperViewData = new EditModeWallpaperViewData();
      expect(editModeWallpaperViewData.getWallpaperBackgroundColor()).assertEqual('');
    })

    it('test_setWallpaperBackgroundColor', 0, () => {
      const editModeWallpaperViewData = new EditModeWallpaperViewData();
      expect(editModeWallpaperViewData.setWallpaperBackgroundColor('#FFFFFF') === undefined).assertTrue();
    })
  })
}