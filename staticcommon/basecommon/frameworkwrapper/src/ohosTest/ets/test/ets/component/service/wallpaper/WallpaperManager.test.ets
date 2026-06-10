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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level } from '@ohos/hypium';
import {
  WallpaperChangeListener,
  WallpaperManager,
  WallpaperType,
} from '../../../../../../../main/ets/service/wallpaper/WallpaperManager';
import { EvtBus } from '../../../../../../../main/ets/eventbus/EventBus'
import { ThemeActivationEvent } from '../../../../../../../main/ets/eventbus/events/Events'

export function WallpaperManagerTest() {
  describe('WallpaperManagerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('WallpaperManager_test_getInstance_should_not_null', Level.LEVEL0, (): void => {
      let instance1 = WallpaperManager.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = WallpaperManager.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('WallpaperManager_test_register_wallpaper_change', Level.LEVEL0, (): void => {
      let wallpaperCode: number = -1;
      let listener: WallpaperChangeListener = {
        registeredTag: '123',
        listenerType: WallpaperType.DESKTOP,
        onWallPaperChange: (event: ThemeActivationEvent) => {
          wallpaperCode = wallpaperCode + 1;
        }
      };
      WallpaperManager.getInstance().registerEventChange();
      WallpaperManager.getInstance().addWallpaperChangeListener(listener);

      const themeActivationEvent: ThemeActivationEvent = {
        target: 7,
        themeType: 1,
        themeOwnership: 1,
        activeThemePath: '123',
      }
      EvtBus.post(ThemeActivationEvent, themeActivationEvent);
      expect(wallpaperCode).assertEqual(0);

      WallpaperManager.getInstance().removeWallpaperChangeListener(listener);
      WallpaperManager.getInstance().unregisterEventChange();

      EvtBus.post(ThemeActivationEvent, themeActivationEvent);
      expect(wallpaperCode).assertEqual(0);
    })
  })
}