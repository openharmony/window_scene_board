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
import { AppItemInfo } from '../../../../../../../main/ets/bean/AppItemInfo';
import { AppIconModel } from '../../../../../../../main/ets/launchericon/common/AppIconModel';
import { AppIconCloneBadgeEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconCloneBadgeEvent';
import { AppIconCloneBadgeVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconCloneBadgeVm';
import { AppReserveType } from '../../../../../../../main/ets/transformdata/TransformAppInfoManager';
import { AppStatus,AppGalleryEventInfo } from '../../../../../../../main/ets/TsIndex';
import { NotHarmonyUtil } from '../../../../../../../main/ets/utils/NotHarmonyUtil';

export default function AppIconCloneBadgeEventTest() {

  describe('AppIconCloneBadgeEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_destroy_01', 0, () => {
      try {
        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.init(itemInfo);
        appIconCloneBadgeEvent.destroy();
        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_destroy_02', 0, () => {
      try {
        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.appStatus = AppStatus.INSTALLED;
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.init(itemInfo);
        appIconCloneBadgeEvent.destroy();
        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_init_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isValidCloneItem);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isWaitingDownloadApp);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
        itemInfo.bundleName = 'com.ohos.browser';
        itemInfo.appIndex = 0;
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.init(itemInfo);
        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clear(NotHarmonyUtil);
      mock.clearAll();
    })

    it('test_init_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isValidCloneItem);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isWaitingDownloadApp);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
        itemInfo.bundleName = 'com.ohos.browser';
        itemInfo.appIndex = 0;
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.init(itemInfo);
        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clear(NotHarmonyUtil);
      mock.clearAll();
    })

    it('test_init_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().isValidCloneItem);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isWaitingDownloadApp);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
        itemInfo.bundleName = 'com.ohos.browser';
        itemInfo.appIndex = 0;
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.init(itemInfo);
        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clear(NotHarmonyUtil);
      mock.clearAll();
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_01', 0, () => {
      try {
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);
        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.WAIT_FOR_HARMONY, intent: intentMap } as AppGalleryEventInfo;

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
        itemInfo.bundleName = 'com.ohos.browser';
        itemInfo.appIndex = 0;
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.init(itemInfo);
        (appIconCloneBadgeEvent as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);

        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_02', 0, () => {
      try {
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);
        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.WAIT_FOR_HARMONY, intent: intentMap } as AppGalleryEventInfo;

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
        itemInfo.bundleName = 'com.ohos.browser';
        itemInfo.appIndex = 1;
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.init(itemInfo);
        (appIconCloneBadgeEvent as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);

        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_02', 0, () => {
      try {
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 2);
        intentMap.set('appType', AppReserveType.ENTERPRISE);
        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.WAIT_FOR_HARMONY, intent: intentMap } as AppGalleryEventInfo;

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
        itemInfo.bundleName = 'com.ohos.browser';
        itemInfo.appIndex = 1;
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.init(itemInfo);
        (appIconCloneBadgeEvent as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);

        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_04', 0, () => {
      try {
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 2);
        intentMap.set('appType', AppReserveType.ENTERPRISE);
        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.WAIT_FOR_HARMONY, intent: intentMap } as AppGalleryEventInfo;

        let itemInfo: AppItemInfo = new AppItemInfo();
        itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
        itemInfo.bundleName = 'com.ohos.browser';
        itemInfo.appIndex = 0;
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.init(itemInfo);
        (appIconCloneBadgeEvent as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);

        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_showCloneBadgeAppearAnimate_01', 0, () => {
      try {
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.showCloneBadgeAppearAnimate(true, true);
        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_showCloneBadgeAppearAnimate_02', 0, () => {
      try {
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.showCloneBadgeAppearAnimate(true, false);
        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_showCloneBadgeAppearAnimate_03', 0, () => {
      try {
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.showCloneBadgeAppearAnimate(false, true);
        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_showCloneBadgeAppearAnimate_04', 0, () => {
      try {
        let iconCloneBadgeVm: AppIconCloneBadgeVm = new AppIconCloneBadgeVm();
        let appIconCloneBadgeEvent: AppIconCloneBadgeEvent = new AppIconCloneBadgeEvent(iconCloneBadgeVm);
        appIconCloneBadgeEvent.showCloneBadgeAppearAnimate(false, false);
        expect(appIconCloneBadgeEvent instanceof AppIconCloneBadgeEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

  });
}