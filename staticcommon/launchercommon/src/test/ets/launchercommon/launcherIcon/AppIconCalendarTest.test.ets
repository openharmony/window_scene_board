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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, } from '@ohos/hypium';
import { CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants';
import { AppIconCalendarCache } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconCalendarCache';

export function AppIconCalendarCacheTest() {

  describe('AppIconCalendarCacheTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('registerImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      calendarCache.registerImageChangeCb(() => {});
      expect(true).assertTrue();
    });

    it('unRegisterImageChangeCbTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.unRegisterImageChangeCb(callback);
      calendarCache.registerImageChangeCb(callback);
      calendarCache.unRegisterImageChangeCb(callback);
      expect(true).assertTrue();
    });

    it('getCalendarImageTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let result = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
      expect(result === undefined).assertTrue();

      result = await calendarCache.getCalendarImage(CommonConstants.CALENDAR_BUNDLE);
      expect(result === undefined).assertTrue();
    });

    it('updateImageCacheTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let callback = () => {}
      calendarCache.registerImageChangeCb(callback);
      calendarCache.initBuilder(undefined);
      await calendarCache.updateImageCache();
      expect(true).assertTrue();
    });

    it('checkIsDynamicCalendarIconTest', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });
  });
}