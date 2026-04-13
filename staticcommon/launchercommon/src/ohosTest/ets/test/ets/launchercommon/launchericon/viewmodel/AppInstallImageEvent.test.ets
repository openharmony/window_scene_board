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
import type abilityCommon from '@ohos.app.ability.common';
import { DownloadingProgressChangeEvent,
  DownloadStatusChangeEvent,
  GlobalContext, InstallStatusChangeEvent } from '@ohos/frameworkwrapper';
import { ScenePanelState } from '@ohos/windowscene';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { AppInstallImageEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppInstallImageEvent';
import { AppInstallImageVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppInstallImageVm';
import {
  AppGalleryEventInfo,
  AppItemInfo,
  AppStatus,
  CommonConstants,
  DownloadStatusInfo,
  AppDownloadInfo,
} from '../../../../../../../main/ets/TsIndex';
import { NotHarmonyUtil } from '../../../../../../../main/ets/utils/NotHarmonyUtil';
import { AppGalleryDownloadManager } from '../../../../../../../main/ets/manager/AppGalleryDownloadManager';
import { AppReserveType } from '../../../../../../../main/ets/transformdata/TransformAppInfoManager';

class MyEventInfo implements AppGalleryEventInfo {
  bundleName: string;
  appName?: string | undefined;
  iconUrl?: string | undefined;
  status: number;
  totalSize?: number | undefined;
  downloadedSize?: number | undefined;
  errorCode?: number | undefined;
  errorDesc?: string | undefined;
  eventType: string;

  constructor(eventType: string, status: number, bundleName: string) {
    this.eventType = eventType;
    this.status = status;
    this.bundleName = bundleName;
  }
}

export function AppInstallImageEventTest() {
  describe('AppInstallImageEventTest', () => {
    beforeAll(() => {
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initEvent', 0, () => {
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      let item: AppItemInfo = new AppItemInfo();
      item.appStatus = AppStatus.INSTALLED;
      event.init(item, () => {});
      event.destroy();

      item.appStatus = AppStatus.DOWNLOADING;
      event.init(item, () => {});
      event.destroy();

      item.appStatus = AppStatus.DOWNLOADING;
      event.init(item, () => {});
      event.destroy();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('onItemAppStatusChange', 0, () => {
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      let item: AppItemInfo = new AppItemInfo();
      let status: AppStatus = AppStatus.INSTALLED;

      item.appStatus = AppStatus.DOWNLOADING;
      item.bundleName = 'anyBundleName';
      event.init(item, (value: AppStatus) => {
        status = value;
      });
      expect(status).assertEqual(AppStatus.DOWNLOADING);

      let eventInfo: MyEventInfo = new MyEventInfo(
        InstallStatusChangeEvent.INSTALL_STATUS_CHANGE,
        AppStatus.PENDING,
        item.bundleName
      );
      GlobalContext.getContext()?.eventHub?.emit(`appGalleryStatusChange${item.bundleName}icon`, eventInfo);
      expect(status).assertEqual(AppStatus.DOWNLOADING);

      eventInfo.status = AppStatus.INSTALLING;
      GlobalContext.getContext()?.eventHub?.emit(`appGalleryStatusChange${item.bundleName}icon`, eventInfo);
      expect(status).assertEqual(AppStatus.DOWNLOADING);

      eventInfo.status = AppStatus.INSTALLED;
      GlobalContext.getContext()?.eventHub?.emit(`appGalleryStatusChange${item.bundleName}icon`, eventInfo);
      expect(status).assertEqual(AppStatus.DOWNLOADING);

      event.destroy();
    });


    it('onDownloadProgressChanged', 0, () => {
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      let item: AppItemInfo = new AppItemInfo();
      let status: AppStatus = AppStatus.INSTALLED;


      item.appStatus = AppStatus.DOWNLOADING;
      item.bundleName = 'anyBundleName';
      event.init(item, (value: AppStatus) => {
        status = value;
      });

      let eventInfo: MyEventInfo = new MyEventInfo(
        DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE,
        AppStatus.DOWNLOADING,
        item.bundleName,
      );

      eventInfo.totalSize = 100;
      eventInfo.downloadedSize = 0;
      GlobalContext.getContext()?.eventHub?.emit(`appGalleryStatusChange${item.bundleName}icon`, eventInfo);
      expect(installImageVm.downloadProgress).assertEqual(0);
      expect(status).assertEqual(AppStatus.DOWNLOADING);

      eventInfo.totalSize = 100;
      eventInfo.downloadedSize = 50;
      AppStorage.setOrCreate<ScenePanelState>('scenePanelState', ScenePanelState.HOME);
      GlobalContext.getContext()?.eventHub?.emit(`appGalleryStatusChange${item.bundleName}icon`, eventInfo);

      let ret = Math.floor((50 / 100) * CommonConstants.MAX_DOWNLOAD_VALUE);
      expect(installImageVm.downloadProgress).assertEqual(0);

      event.destroy();
    });

    it('test_isDesktopForeground_01', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        (event as object)['isDesktopForeground']();
        (event as object)['isAppCenterForeground']();
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_playInstallingAni_01', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.notInstallState = AppStatus.INSTALLING;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let mockFunc: Function = mock.mockFunc(event,  (event as object)['isDesktopForeground']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(event,  (event as object)['isDesktopForeground']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let status: AppStatus = AppStatus.INSTALLED;
        let item: AppItemInfo = new AppItemInfo();
        item.appStatus = AppStatus.DOWNLOADING;
        item.bundleName = 'anyBundleName';
        event.init(item, (value: AppStatus) => {
          status = value;
        });
        let opacity: number = 0;
        let retryCount: number = 0;
        (event as object)['playInstallingAni'](opacity,retryCount);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

    it('test_playInstallingAni_02', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.notInstallState = AppStatus.INSTALLING;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let mockFunc: Function = mock.mockFunc(event,  (event as object)['isDesktopForeground']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(event,  (event as object)['isDesktopForeground']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let status: AppStatus = AppStatus.INSTALLED;
        let item: AppItemInfo = new AppItemInfo();
        item.appStatus = AppStatus.DOWNLOADING;
        item.bundleName = 'anyBundleName';
        event.init(item, (value: AppStatus) => {
          status = value;
        });
        let opacity: number = 0;
        let retryCount: number = 0;
        (event as object)['playInstallingAni'](opacity,retryCount);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

    it('test_playInstallingAni_03', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.notInstallState = AppStatus.INSTALLING;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let mockFunc: Function = mock.mockFunc(event,  (event as object)['isDesktopForeground']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(event,  (event as object)['isDesktopForeground']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let status: AppStatus = AppStatus.INSTALLED;
        let item: AppItemInfo = new AppItemInfo();
        item.appStatus = AppStatus.DOWNLOADING;
        item.bundleName = 'anyBundleName';
        event.init(item, (value: AppStatus) => {
          status = value;
        });
        let opacity: number = 0;
        let retryCount: number = 0;
        (event as object)['playInstallingAni'](opacity,retryCount);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

    it('test_onInstallAniFinish_01', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        (event as object)['onInstallAniFinish']();
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_finishDownloadAni_01', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        (event as object)['finishDownloadAni']();
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_finishDownloadAni_02', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        installImageVm.progress = new ProgressMask(0, CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        (event as object)['finishDownloadAni']();
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initProgress_01', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.notInstallState = AppStatus.INSTALLING;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let mockFunc: Function = mock.mockFunc(NotHarmonyUtil,  NotHarmonyUtil.checkNotHarmonyItemLightingStatus);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let status: AppStatus = AppStatus.INSTALLED;
        let item: AppItemInfo = new AppItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
        item.bundleName = 'anyBundleName';
        event.init(item, (value: AppStatus) => {
          status = value;
        });

        (event as object)['initProgress']();
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(NotHarmonyUtil);
      mock.clearAll();
    })

    it('test_initProgress_02', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.notInstallState = AppStatus.INSTALLING;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let mockFunc: Function = mock.mockFunc(NotHarmonyUtil,  NotHarmonyUtil.checkItemLightingStatus);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let status: AppStatus = AppStatus.PENDING;
        let item: AppItemInfo = new AppItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
        item.bundleName = 'anyBundleName';
        event.init(item, (value: AppStatus) => {
          status = value;
        });

        (event as object)['initProgress']();
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(NotHarmonyUtil);
      mock.clearAll();
    })

    it('test_initProgress_03', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.notInstallState = AppStatus.INSTALLING;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let mockFunc: Function = mock.mockFunc(NotHarmonyUtil,  NotHarmonyUtil.checkItemLightingStatus);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(NotHarmonyUtil,  NotHarmonyUtil.checkItemLightingStatus);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(AppGalleryDownloadManager.getInstance(),  AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(null);

        let status: AppStatus = AppStatus.PENDING;
        let item: AppItemInfo = new AppItemInfo();
        item.appStatus = AppStatus.INSTALLING;
        item.bundleName = 'anyBundleName';
        event.init(item, (value: AppStatus) => {
          status = value;
        });

        (event as object)['initProgress']();
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(NotHarmonyUtil);
      mock.clear(AppGalleryDownloadManager.getInstance());
      mock.clearAll();
    })

    it('test_initProgress_04', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.notInstallState = AppStatus.INSTALLING;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let mockFunc: Function = mock.mockFunc(NotHarmonyUtil,  NotHarmonyUtil.checkItemLightingStatus);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(NotHarmonyUtil,  NotHarmonyUtil.checkItemLightingStatus);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let downloadStatusInfo: DownloadStatusInfo = { status: AppStatus.INSTALLING } as DownloadStatusInfo;
        let mockFunc3: Function = mock.mockFunc(AppGalleryDownloadManager.getInstance(),  AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(downloadStatusInfo);

        let status: AppStatus = AppStatus.PENDING;
        let item: AppItemInfo = new AppItemInfo();
        item.appStatus = AppStatus.INSTALLING;
        item.bundleName = 'anyBundleName';
        event.init(item, (value: AppStatus) => {
          status = value;
        });

        (event as object)['initProgress']();
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(NotHarmonyUtil);
      mock.clear(AppGalleryDownloadManager.getInstance());
      mock.clearAll();
    })

    it('test_initProgress_05', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.notInstallState = AppStatus.INSTALLING;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let mockFunc: Function = mock.mockFunc(NotHarmonyUtil, NotHarmonyUtil.checkItemLightingStatus);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(NotHarmonyUtil, NotHarmonyUtil.checkItemLightingStatus);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let downloadStatusInfo: DownloadStatusInfo = { status: AppStatus.INSTALLING } as DownloadStatusInfo;
        let mockFunc3: Function = mock.mockFunc(AppGalleryDownloadManager.getInstance(),
          AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(downloadStatusInfo);

        let appDownloadInfo: AppDownloadInfo = { downloadedSize: 1, totalSize: 1 } as AppDownloadInfo;
        let mockFunc4: Function = mock.mockFunc(AppGalleryDownloadManager.getInstance(),
          AppGalleryDownloadManager.getInstance().getDownloadProgressInfo);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(appDownloadInfo);

        let status: AppStatus = AppStatus.PENDING;
        let item: AppItemInfo = new AppItemInfo();
        item.appStatus = AppStatus.INSTALLING;
        item.bundleName = 'anyBundleName';
        event.init(item, (value: AppStatus) => {
          status = value;
        });

        (event as object)['initProgress']();
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(NotHarmonyUtil);
      mock.clear(AppGalleryDownloadManager.getInstance());
      mock.clearAll();
    })

    it('test_getGalleryStatusChangeEventId_01', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        (event as object)['getGalleryStatusChangeEventId']();
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_01', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.WAIT_FOR_HARMONY } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_02', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.WAIT_FOR_HARMONY, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_03', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.WAIT_FOR_HARMONY, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_04', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.PENDING, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_05', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.WAITING, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_06', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.DOWNLOADING, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_07', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.UPDATING, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_08', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.INSTALL_WAITING, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_09', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.WIFI_WAITING, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_10', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.PAUSING, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_11', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.INSTALLING, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_12', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        installImageVm.progress = new ProgressMask(0, CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.INSTALLING, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadStatusChangedEvent_13', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let intentMap: Map<string, Object> = new Map();
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
        intentMap.set('appType', AppReserveType.ENTERPRISE);

        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.INSTALLED, intent: intentMap } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadStatusChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateDownloadProgress_01', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        (event as object)['updateDownloadProgress'](1);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateDownloadProgress_02', 0, () => {
      try {
        let process: number = CommonConstants.MAX_DOWNLOAD_VALUE - 1;
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        installImageVm.progress = new ProgressMask(0, CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        (event as object)['updateDownloadProgress'](process);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateDownloadProgress_03', 0, () => {
      try {
        let process: number = CommonConstants.MAX_DOWNLOAD_VALUE - 2;
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        installImageVm.progress = new ProgressMask(0, CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        (event as object)['updateDownloadProgress'](process);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_setDownloadProgress_01', 0, () => {
      try {
        let process: number = CommonConstants.MAX_DOWNLOAD_VALUE;
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        installImageVm.progress = new ProgressMask(0, CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
        installImageVm.downloadProgress = process;
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        (event as object)['setDownloadProgress'](process);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_setDownloadProgress_02', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.progress = new ProgressMask(0, CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
      installImageVm.downloadProgress = CommonConstants.MAX_DOWNLOAD_VALUE;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let mockFunc: Function = mock.mockFunc(event, (event as object)['isDesktopForeground']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(event, (event as object)['isAppCenterForeground']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let process: number = CommonConstants.MAX_DOWNLOAD_VALUE + 1;
        (event as object)['setDownloadProgress'](process);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

    it('test_setDownloadProgress_03', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.progress = new ProgressMask(0, CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
      installImageVm.downloadProgress = CommonConstants.MAX_DOWNLOAD_VALUE;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);

      let status: AppStatus = AppStatus.PENDING;
      let item: AppItemInfo = new AppItemInfo();
      item.appIndex = 1;
      item.appStatus = AppStatus.INSTALLING;
      item.bundleName = 'anyBundleName';
      event.init(item, (value: AppStatus) => {
        status = value;
      });

      try {
        let mockFunc: Function = mock.mockFunc(event, (event as object)['isDesktopForeground']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(event, (event as object)['isAppCenterForeground']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let process: number = CommonConstants.MAX_DOWNLOAD_VALUE + 1;
        (event as object)['setDownloadProgress'](process);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

    it('test_setDownloadProgress_04', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.progress = new ProgressMask(0, CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
      installImageVm.downloadProgress = CommonConstants.MAX_DOWNLOAD_VALUE;
      installImageVm.notInstallState = AppStatus.DOWNLOADING;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);

      let status: AppStatus = AppStatus.PENDING;
      let item: AppItemInfo = new AppItemInfo();
      item.appIndex = 0;
      item.appStatus = AppStatus.INSTALLING;
      item.bundleName = 'anyBundleName';
      event.init(item, (value: AppStatus) => {
        status = value;
      });

      try {
        let mockFunc: Function = mock.mockFunc(event, (event as object)['isDesktopForeground']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(event, (event as object)['isAppCenterForeground']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let process: number = CommonConstants.MAX_DOWNLOAD_VALUE + 1;
        (event as object)['setDownloadProgress'](process);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

    it('test_setDownloadProgress_05', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      installImageVm.progress = new ProgressMask(0, CommonConstants.MAX_DOWNLOAD_VALUE, '#B3000000');
      installImageVm.downloadProgress = CommonConstants.MAX_DOWNLOAD_VALUE;
      installImageVm.notInstallState = AppStatus.UPDATING;
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);

      let status: AppStatus = AppStatus.PENDING;
      let item: AppItemInfo = new AppItemInfo();
      item.appIndex = 0;
      item.appStatus = AppStatus.INSTALLING;
      item.bundleName = 'anyBundleName';
      event.init(item, (value: AppStatus) => {
        status = value;
      });

      try {
        let mockFunc: Function = mock.mockFunc(event, (event as object)['isDesktopForeground']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(event, (event as object)['isAppCenterForeground']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let process: number = CommonConstants.MAX_DOWNLOAD_VALUE + 1;
        (event as object)['setDownloadProgress'](process);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

    it('test_onEventhubAppDownloadProgressChangedEvent_01', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let eventInfo: AppGalleryEventInfo =
          { downloadedSize: 1, totalSize: 1, status: AppStatus.UPDATING } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadProgressChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onEventhubAppDownloadProgressChangedEvent_01', 0, () => {
      try {
        let installImageVm: AppInstallImageVm = new AppInstallImageVm();
        let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
        let eventInfo: AppGalleryEventInfo =
          { downloadedSize: 1, totalSize: 1, status: AppStatus.DOWNLOADING } as AppGalleryEventInfo;
        (event as object)['onEventhubAppDownloadProgressChangedEvent'](eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initEventhubEvent_01', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let eventId: string = 'test_eventId1';
        let mockFunc: Function = mock.mockFunc(event, (event as object)['getGalleryStatusChangeEventId']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(eventId);

        (event as object)['initEventhubEvent']();
        let eventInfo: MyEventInfo = new MyEventInfo(
          DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE,
          AppStatus.PENDING,
          'item.bundleName'
        );
        GlobalContext.getContext()?.eventHub?.emit(eventId, eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

    it('test_initEventhubEvent_02', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let eventId: string = 'test_eventId2';
        let mockFunc: Function = mock.mockFunc(event, (event as object)['getGalleryStatusChangeEventId']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(eventId);

        (event as object)['initEventhubEvent']();
        let eventInfo: MyEventInfo = new MyEventInfo(
          InstallStatusChangeEvent.INSTALL_STATUS_CHANGE,
          AppStatus.PENDING,
          'item.bundleName'
        );
        GlobalContext.getContext()?.eventHub?.emit(eventId, eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

    it('test_initEventhubEvent_03', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let eventId: string = 'test_eventId3';
        let mockFunc: Function = mock.mockFunc(event, (event as object)['getGalleryStatusChangeEventId']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(eventId);

        (event as object)['initEventhubEvent']();
        let eventInfo: MyEventInfo = new MyEventInfo(
          DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE,
          AppStatus.PENDING,
          'item.bundleName'
        );
        GlobalContext.getContext()?.eventHub?.emit(eventId, eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

    it('test_initEventhubEvent_04', 0, () => {
      let mock = new MockKit();
      let installImageVm: AppInstallImageVm = new AppInstallImageVm();
      let event: AppInstallImageEvent = new AppInstallImageEvent(installImageVm);
      try {
        let eventId: string = 'test_eventId3';
        let mockFunc: Function = mock.mockFunc(event, (event as object)['getGalleryStatusChangeEventId']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(eventId);

        (event as object)['initEventhubEvent']();
        let eventInfo: MyEventInfo = new MyEventInfo(
          'com.ohos.appgallery.commonevent.EVENT_DOWNLOAD_STATUS_CHANGE_TEST',
          AppStatus.PENDING,
          'item.bundleName'
        );
        GlobalContext.getContext()?.eventHub?.emit(eventId, eventInfo);
        expect(event instanceof AppInstallImageEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(event);
      mock.clearAll();
    })

  });
}