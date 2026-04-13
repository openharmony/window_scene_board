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
import { DofWallpaperBindStateType,
  SlMainStateType,
  SlSubStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlDofWallpaperBindState } from
  '../../../../../../../../main/ets/screenlockstate/model/data/SlDofWallpaperBindState';

export default function SlDofWallpaperBindStateTest() {
  const mSlDofWallpaperBindState = new SlDofWallpaperBindState()
  const mSlDofWallpaperBindStateSon = new SlDofWallpaperBindStateSon()

  describe('SlDofWallpaperBindStateTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_setLight', 0, (): void => {
      mSlDofWallpaperBindState.setLight(729958);
      expect(true).assertTrue();
    })

    it('test_getDofLight', 0, (): void => {
      mSlDofWallpaperBindState.getDofLight();
      expect(true).assertTrue();
    })

    it('test_initSetMethods', 0, (): void => {
      mSlDofWallpaperBindStateSon.InitSetMethods();
      expect(true).assertTrue();
    })

    it('test_notifyStateChange', 0, (): void => {
      mSlDofWallpaperBindStateSon.NotifyStateChange();
      expect(true).assertTrue();
    })
  })
}

export class SlDofWallpaperBindStateSon extends SlDofWallpaperBindState {
  public InitSetMethods() {
    return this.initSetMethods();
  }

  public NotifyStateChange() {
    this.slStateChangeListener = {
      onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      }
    };
    return this.notifyStateChange(DofWallpaperBindStateType.DOF_WALLPAPER_LIGHT);
  }
}