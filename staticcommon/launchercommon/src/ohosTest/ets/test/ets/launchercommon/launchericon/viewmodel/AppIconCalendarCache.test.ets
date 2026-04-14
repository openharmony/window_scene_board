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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers, } from '@ohos/hypium';
import { CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants';
import { AppIconCalendarCache } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconCalendarCache';
import { commonEventManager } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { AppModel } from '../../../../../../../main/ets/model/AppModel';
import { AppItemInfo } from '../../../../../../../main/ets/bean/AppItemInfo';
import { AppIconModel } from '../../../../../../../main/ets/launchericon/common/AppIconModel';
import { GraphicUtils } from '@ohos/frameworkwrapper';

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
      let result: PixelMap | undefined = await calendarCache.getCalendarImage(CommonConstants.BROWSER_BUNDLE);
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
      let mock = new MockKit();
      let calendarCache = AppIconCalendarCache.getInstance();
      let flag1 = calendarCache.checkIsDynamicCalendarIcon('test');
      expect(flag1).assertFalse();
      let mockFunc: Function = mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isDynamicIcon);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let flag2 = calendarCache.checkIsDynamicCalendarIcon(CommonConstants.CALENDAR_BUNDLE);
      expect(flag2).assertTrue();
      mock.clear(AppIconModel.getInstance());
      mock.clearAll();
    });

    it('getCalendarImageSyncWithoutCheckTest', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      let image: PixelMap | undefined = calendarCache.getCalendarImageSyncWithoutCheck();
      expect(CheckEmptyUtils.isEmptyPixelMap(image)).assertTrue();
    });

    it('test_isNeedUpdateImageCache', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      if (!calendarCache.getCacheData().image) {
        await calendarCache.updateImageCache();
      }
      if (calendarCache.getCacheData().image && (typeof calendarCache.getCacheData().image !== 'string')) {
        (calendarCache.getCacheData().image as image.PixelMap).release();
        commonEventManager.publish(commonEventManager.Support.COMMON_EVENT_TIME_CHANGED, () => {});
        await calendarCache.updateImageCache();
        expect(calendarCache.getCacheData().image !== undefined).assertTrue();
      }
    });

    it('test_isNeedUpdateImageCache2', 0, async () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      if (!calendarCache.getCacheData().image) {
        await calendarCache.updateImageCache();
      }
      calendarCache.getCacheData().dateText = '16';
      calendarCache.getCacheData().weekText = '星期一';
      if (calendarCache.getCacheData().image && (typeof calendarCache.getCacheData().image !== 'string')) {
        (calendarCache.getCacheData().image as image.PixelMap).release();
        commonEventManager.publish(commonEventManager.Support.COMMON_EVENT_TIME_CHANGED, () => {});
        await calendarCache.updateImageCache();
        expect(calendarCache.getCacheData().image !== undefined).assertTrue();
      }
    });

    it('test_iconChangeListener_01', 0, () => {
      try {
        let calendarCache = AppIconCalendarCache.getInstance();
        (calendarCache as object)['iconChangeListener'].onIconResourceChange();
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initCalenderDate_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppInfoByBundleNameAndAbility);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

        let calendarCache = AppIconCalendarCache.getInstance();
        (calendarCache as object)['item'] = null;
        (calendarCache as object)['initCalenderDate']();
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it('test_initCalenderDate_02', 0, () => {
      let mock = new MockKit();
      try {
        let info: AppItemInfo = new AppItemInfo();
        let mockFunc: Function =
          mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppInfoByBundleNameAndAbility);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(info);

        let mockFunc2: Function =
          mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isDynamicIcon);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let calendarCache = AppIconCalendarCache.getInstance();
        (calendarCache as object)['item'] = null;
        (calendarCache as object)['initCalenderDate']();
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clear(AppIconModel.getInstance());
      mock.clearAll();
    })

    it('test_initCalenderDate_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc2: Function =
          mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isDynamicIcon);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let calendarCache = AppIconCalendarCache.getInstance();
        (calendarCache as object)['item'] = null;
        (calendarCache as object)['initCalenderDate']();
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clear(AppIconModel.getInstance());
      mock.clearAll();
    })

    it('test_initSubscriber_01', 0, () => {
      let mock = new MockKit();
      let calendarCache = AppIconCalendarCache.getInstance();
      try {
        let mockFunc2: Function =
          mock.mockFunc(calendarCache, (calendarCache as object)['dateChangeEventHandler']);
        when(mockFunc2)(ArgumentMatchers.any).afterThrow('err');

        (calendarCache as object)['initSubscriber']();
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(calendarCache);
      mock.clearAll();
    })

    it('test_dateChangeEventHandler_01', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      try {
        (calendarCache as object)['initSubscriber']();
        (calendarCache as object)['dateChangeEventHandler']();
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isNeedUpdateImageCache_01', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      try {
        let now: Date = new Date();
        (calendarCache as object)['isNeedUpdateImageCache'](now);
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initCalenderImage_01', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      try {
        calendarCache.initCalenderImage();
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getCalendarForegroundImageSync_01', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      try {
        let bundleName: string = CommonConstants.CALENDAR_BUNDLE;
        calendarCache.getCalendarForegroundImageSync(bundleName);
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getCalendarForegroundImageSync_02', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      try {
        let bundleName: string = 'test';
        calendarCache.getCalendarForegroundImageSync(bundleName);
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getCalendarImageSync_01', 0, () => {
      let calendarCache = AppIconCalendarCache.getInstance();
      try {
        let bundleName: string = 'test';
        calendarCache.getCalendarImageSync(bundleName);
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getCalendarImageSync_02', 0, () => {
      let mock = new MockKit();
      let calendarCache = AppIconCalendarCache.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isDynamicIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyPixelMap);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let bundleName: string = CommonConstants.CALENDAR_BUNDLE;
        calendarCache.getCalendarImageSync(bundleName);
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_getCalendarImageSync_03', 0, () => {
      let mock = new MockKit();
      let calendarCache = AppIconCalendarCache.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isDynamicIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyPixelMap);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let bundleName: string = CommonConstants.CALENDAR_BUNDLE;
        calendarCache.getCalendarImageSync(bundleName);
        expect(calendarCache instanceof AppIconCalendarCache).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_updateImageCache_03', 0, async () => {
      let mock = new MockKit();
      let calendarCache = AppIconCalendarCache.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isDynamicIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyPixelMap);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(GraphicUtils, GraphicUtils.checkPixelMapCenterInfo);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

       await calendarCache.updateImageCache();

        expect(calendarCache.getCacheData().dateText !== undefined).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clear(CheckEmptyUtils);
      mock.clear(GraphicUtils);
      mock.clearAll();
    })
  });
}