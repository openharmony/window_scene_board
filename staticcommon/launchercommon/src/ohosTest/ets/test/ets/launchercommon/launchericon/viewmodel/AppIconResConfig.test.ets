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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';

import { AppIconConfig } from '../../../../../../../main/ets/launchericon/config/AppIconConfig';
import { AppIconTouchEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconTouchEvent';
import { AppItemInfo, editModeManager } from '../../../../../../../main/ets/TsIndex';
import { AppIconData } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconData';
import { scbEventExclusiveManager } from '@ohos/windowscene';
import { DeliverUtil } from '../../../../../../../main/ets/utils/DeliverUtil';
import { AppIconMenuVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconMenuVm';
import { AppIconBadgeVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { AppIconBadgeEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBadgeEvent';
import { AppIconMenuEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconMenuEvent';
import {
  AppIconLongPressEventParam,
  AppIconLongPressGestureEvent
} from '../../../../../../../main/ets/launchericon/viewmodel/AppIconLongPressGestureEvent';
import { MultiSelectManager } from '../../../../../../../main/ets/editmode/model/MultiSelectManager';
import { MultiSelectStatus, MultiSelectItemType } from '../../../../../../../main/ets/editmode/data/MultiSelectData';
import { DeviceHelper, GlobalContext, IconResourceManager } from '@ohos/frameworkwrapper';
import { AppIconResConfig } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconResConfig';
import { image } from '@kit.ImageKit';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { AppIconModel } from '../../../../../../../main/ets/launchericon/common/AppIconModel';

export default function AppIconResConfigTest() {

  describe('AppIconResConfigTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_isValidIcon_01', 0, () => {
      try {
        let iconSrc: string = 'test';
        let appIconResConfig: AppIconResConfig = new AppIconResConfig();
        (appIconResConfig as object)['isValidIcon'](iconSrc);
        expect(appIconResConfig instanceof AppIconResConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isValidIcon_02', 0, () => {
      try {
        let iconSrc: image.PixelMap =
          GlobalContext.getContext()?.resourceManager.getDrawableDescriptor($r('app.media.default_icon').id)
            .getPixelMap();
        let appIconResConfig: AppIconResConfig = new AppIconResConfig();
        (appIconResConfig as object)['isValidIcon'](iconSrc);
        expect(appIconResConfig instanceof AppIconResConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_loadIconResourceByCache_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCombIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

        let mockFunc2: Function =
          mock.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().deleteIconResource);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());

        let mockFunc3: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyPixelMap);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.bundleName = 'com.ohos.contacts';
        let appIconResConfig: AppIconResConfig = new AppIconResConfig();
        (appIconResConfig as object)['loadIconResourceByCache'](itemInfo);
        expect(appIconResConfig instanceof AppIconResConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(IconResourceManager.getInstance());
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_loadIconResourceByCache_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCombIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

        let mockFunc2: Function =
          mock.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().deleteIconResource);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());

        let mockFunc3: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyPixelMap);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.bundleName = 'com.ohos.contacts';
        let appIconResConfig: AppIconResConfig = new AppIconResConfig();
        (appIconResConfig as object)['loadIconResourceByCache'](itemInfo);
        expect(appIconResConfig instanceof AppIconResConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(IconResourceManager.getInstance());
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_loadStaticCache_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().getCombIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.bundleName = 'com.ohos.clock';
        let appIconResConfig: AppIconResConfig = new AppIconResConfig();
        (appIconResConfig as object)['loadStaticCache'](itemInfo);
        expect(appIconResConfig instanceof AppIconResConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(IconResourceManager.getInstance());
      mock.clearAll();
    })

    it('test_initIconImage_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isDynamicIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let itemInfo: AppItemInfo = {} as AppItemInfo;

        let iconData: AppIconData = new AppIconData();

        let appIconResConfig: AppIconResConfig = new AppIconResConfig();
        appIconResConfig.initIconImage(itemInfo, iconData);
        expect(appIconResConfig instanceof AppIconResConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clearAll();
    })

    it('test_initIconImage_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isDynamicIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.bundleName = 'com.ohos.clock';

        let iconData: AppIconData = new AppIconData();

        let appIconResConfig: AppIconResConfig = new AppIconResConfig();
        appIconResConfig.initIconImage(itemInfo, iconData);
        expect(appIconResConfig instanceof AppIconResConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clearAll();
    })

    it('test_initIconImage_04', 0, () => {
      let mock = new MockKit();
      let appIconResConfig: AppIconResConfig = new AppIconResConfig();
      try {
        let mockFunc: Function =
          mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isDynamicIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function =
          mock.mockFunc(appIconResConfig, (appIconResConfig as object)['loadStaticCache']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn('test');

        let mockFunc3: Function =
          mock.mockFunc(appIconResConfig, (appIconResConfig as object)['isValidIcon']);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc4: Function =
          mock.mockFunc(appIconResConfig, (appIconResConfig as object)['getNonDynamicImage']);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(Promise.resolve('test'));

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.bundleName = 'com.ohos.clock';

        let iconData: AppIconData = new AppIconData();

        appIconResConfig.initIconImage(itemInfo, iconData);
        expect(appIconResConfig instanceof AppIconResConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clear(appIconResConfig);
      mock.clearAll();
    })

    it('test_initIconImage_05', 0, () => {
      let mock = new MockKit();
      let appIconResConfig: AppIconResConfig = new AppIconResConfig();
      try {
        let mockFunc: Function =
          mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isDynamicIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function =
          mock.mockFunc(appIconResConfig, (appIconResConfig as object)['loadStaticCache']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn('test');

        let mockFunc3: Function =
          mock.mockFunc(appIconResConfig, (appIconResConfig as object)['isValidIcon']);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc4: Function =
          mock.mockFunc(appIconResConfig, (appIconResConfig as object)['getNonDynamicImage']);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(Promise.resolve('test'));

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.bundleName = 'com.ohos.clock';

        let iconData: AppIconData = new AppIconData();

        appIconResConfig.initIconImage(itemInfo, iconData);
        expect(appIconResConfig instanceof AppIconResConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clear(appIconResConfig);
      mock.clearAll();
    })

    it('test_reInitIconImage_01', 0, () => {
      let mock = new MockKit();
      let appIconResConfig: AppIconResConfig = new AppIconResConfig();
      try {
        let mockFunc3: Function =
          mock.mockFunc(appIconResConfig, (appIconResConfig as object)['isValidIcon']);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function =
          mock.mockFunc(appIconResConfig, appIconResConfig.initIconImage);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());

        let itemInfo: AppItemInfo = {} as AppItemInfo;

        let iconData: AppIconData = new AppIconData();
        iconData.image = 'test';

        appIconResConfig.reInitIconImage(itemInfo, iconData);
        expect(appIconResConfig instanceof AppIconResConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(appIconResConfig);
      mock.clearAll();
    })


  });
}