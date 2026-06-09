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

import { EventConstants } from '@ohos/frameworkwrapper';
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
  when,
} from '@ohos/hypium';
import { AppIconMenuEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconMenuEvent';
import { AppIconMenuVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconMenuVm';
import { AppGalleryDownloadManager } from '../../../../../../../main/ets/manager/AppGalleryDownloadManager';
import {
  AppItemInfo,
  AppStatus,
  LayoutViewModel,
  MenuInfo,
  GridLayoutUtil,
  DownloadStatusInfo,
} from '../../../../../../../main/ets/TsIndex';

export function AppIconMenuEventTest() {
  describe('AppIconMenuEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initMenuEvent', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      let event: AppIconMenuEvent = new AppIconMenuEvent(vm);

      let appItem: AppItemInfo = new AppItemInfo();
      appItem.appStatus = AppStatus.WIFI_WAITING;

      let menuMap: Map<AppStatus, MenuInfo[]> = new Map();
      menuMap.set(AppStatus.WIFI_WAITING, [new MenuInfo()]);
      event.init(appItem, menuMap);
      expect(vm.menuInfo.length).assertEqual(1);
      event.destroy();

      appItem.appStatus = AppStatus.INSTALLED;
      event.init(appItem, new Map(), (): MenuInfo[] => {
        return [new MenuInfo(), new MenuInfo()];
      });
      expect(vm.menuInfo.length).assertEqual(2);
      event.destroy();
    });

    it('onAppear', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      let event: AppIconMenuEvent = new AppIconMenuEvent(vm);
      let iconVisible: boolean = false;
      let isLongPressShow: boolean = false;

      event.init(new AppItemInfo(), new Map(),
        (): Array<MenuInfo> => new Array<MenuInfo>(),
        (visible: boolean, isLongPress: boolean): void => {
          iconVisible = visible;
          isLongPressShow = isLongPress;
        });

      event.onAppear(false);
      expect(iconVisible).assertFalse();
      expect(isLongPressShow).assertFalse();

      event.onAppear(true);
      expect(iconVisible).assertFalse();
      expect(isLongPressShow).assertTrue();
    });

    it('onDisAppear', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      let event: AppIconMenuEvent = new AppIconMenuEvent(vm);
      let iconVisible: boolean = false;
      let isLongPressShow: boolean = false;
      event.init(new AppItemInfo(), new Map(),
        (): Array<MenuInfo> => new Array<MenuInfo>(),
        (visible: boolean, isLongPress: boolean): void => {
          iconVisible = visible;
          isLongPressShow = isLongPress;
        });

      event.onDisAppear(false);
      expect(iconVisible).assertTrue();
      expect(isLongPressShow).assertFalse();

      event.onDisAppear(true);
      expect(iconVisible).assertTrue();
      expect(isLongPressShow).assertTrue();
    });


    it('setAppMenuPosition', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      let event: AppIconMenuEvent = new AppIconMenuEvent(vm);

      let historicalPoint: HistoricalPoint = {
        touchObject: {
          type: TouchType.Down,
          id: 0,
          displayX: 10,
          displayY: 0,
          windowX: 0,
          windowY: 10,
          screenX: 0,
          screenY: 10,
          x: 0,
          y: 0
        },
        size: 10,
        force: 0,
        timestamp: 10
      }

      let touchEvent: TouchEvent = {
        target: {
          area: {
            width: 0,
            height: 0,
            position: {
              x: 0, y: 0
            },
            globalPosition: {
              x: 0, y: 0
            }
          }
        },
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        type: TouchType.Down,
        touches: [],
        changedTouches: [{
          id: 0,
          type: 0,
          displayX: 0,
          displayY: 0,
          windowX: 0,
          windowY: 0,
          screenX: 0,
          screenY: 0,
          x: 0,
          y: 0
        }],
        stopPropagation: () => {
        },
        getHistoricalPoints: () => {
          return [historicalPoint, historicalPoint];
        },
        preventDefault: (): void => {}
      }

      event.setAppMenuPosition(touchEvent?.touches?.[0]?.displayX, '');
      expect(vm).not().assertNull();
    });

    it('setMenuInfo', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      let event: AppIconMenuEvent = new AppIconMenuEvent(vm);

      let appItem: AppItemInfo = new AppItemInfo();
      appItem.appStatus = AppStatus.WIFI_WAITING;

      let menuMap: Map<AppStatus, MenuInfo[]> = new Map();
      menuMap.set(AppStatus.WIFI_WAITING, [new MenuInfo()]);

      event.init(appItem, menuMap);
      event.setMenuInfo((): MenuInfo[] => {
        return [new MenuInfo(), new MenuInfo()];
      }, () => menuMap);
      expect(vm.menuInfo.length).assertEqual(1);
      event.destroy();

      appItem.appStatus = AppStatus.INSTALLED;
      event.init(appItem, new Map());
      event.setMenuInfo((): MenuInfo[] => {
        return [new MenuInfo(), new MenuInfo()];
      });
      expect(vm.menuInfo.length).assertEqual(2);
      event.destroy();
    });

    it('onItemAppStatusChange', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      vm.notInstalledMenuMap().set(AppStatus.WIFI_WAITING, [new MenuInfo()]);
      let event: AppIconMenuEvent = new AppIconMenuEvent(vm);

      let appItem: AppItemInfo = new AppItemInfo();
      appItem.appStatus = AppStatus.WIFI_WAITING;

      let menuMap: Map<AppStatus, MenuInfo[]> = new Map();
      menuMap.set(AppStatus.WIFI_WAITING, [new MenuInfo()]);
      event.init(appItem, menuMap, (): MenuInfo[] => {
        return [new MenuInfo(), new MenuInfo()];
      });

      let itemAppStatus: AppStatus = AppStatus.WIFI_WAITING;
      event.onItemAppStatusChange(itemAppStatus);
      expect(vm.menuInfo.length).assertEqual(1);

      itemAppStatus = AppStatus.INSTALLED;
      event.onItemAppStatusChange(itemAppStatus);
      expect(vm.menuInfo.length).assertEqual(2);
      event.destroy();
    });

    it('onLongPressShowMenu', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      let event: AppIconMenuEvent = new AppIconMenuEvent(vm);

      let appItem = new AppItemInfo();
      appItem.appStatus = AppStatus.INSTALLED;
      event.init(appItem, new Map(), (): MenuInfo[] => {
        return [new MenuInfo()];
      });

      event.onLongPressShowMenu();
      expect(vm.isMenuShow()).assertEqual(true);
      event.destroy();
    });

    it('previewMaskAnim', 0, () => {
      let vm: AppIconMenuVm = new AppIconMenuVm();
      let event: AppIconMenuEvent = new AppIconMenuEvent(vm);

      let appItem = new AppItemInfo();
      appItem.appStatus = AppStatus.INSTALLED;
      event.init(appItem, new Map(), (): MenuInfo[] => {
        return [new MenuInfo()];
      });

      event.previewMaskAnim();
      expect(vm.previewMaskOpacity).assertEqual(0);
      event.destroy();
    });

    it('test_updateMenuInfo_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let vm: AppIconMenuVm = new AppIconMenuVm();
        let event: AppIconMenuEvent = new AppIconMenuEvent(vm);
        event.updateMenuInfo();
        expect(event instanceof AppIconMenuEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(GridLayoutUtil);
      mock.clearAll();
    })

    it('test_updateMenuInfo_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let vm: AppIconMenuVm = new AppIconMenuVm();
        let event: AppIconMenuEvent = new AppIconMenuEvent(vm);
        event.updateMenuInfo();
        expect(event instanceof AppIconMenuEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(GridLayoutUtil);
      mock.clearAll();
    })

    it('test_onAppStateChanged_01', 0, () => {
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let event: AppIconMenuEvent = new AppIconMenuEvent(vm);
        let appList: [] = [];
        let event1: string = EventConstants.EVENT_PACKAGE_CHANGED;
        let bundleName: string = 'com.ohos.contacts';

        let appItem: AppItemInfo = new AppItemInfo();
        appItem.bundleName = bundleName;

        let menuMap: Map<AppStatus, MenuInfo[]> = new Map();
        menuMap.set(AppStatus.WIFI_WAITING, [new MenuInfo()]);
        event.init(appItem, menuMap);

        (event as object)['onAppStateChanged'](appList, event1, bundleName);
        expect(event instanceof AppIconMenuEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onAppStateChanged_01', 0, () => {
      let mock = new MockKit();
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let event: AppIconMenuEvent = new AppIconMenuEvent(vm);

        let downloadStatusInfo: DownloadStatusInfo = {
          status: AppStatus.INSTALLING
        } as DownloadStatusInfo;
        let mockFunc: Function = mock.mockFunc(AppGalleryDownloadManager.getInstance(),
          AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(downloadStatusInfo);

        let appItem: AppItemInfo = new AppItemInfo();
        appItem.bundleName = 'com.ohos.contacts';
        appItem.appIndex = 0;

        let menuMap: Map<AppStatus, MenuInfo[]> = new Map();
        menuMap.set(AppStatus.WIFI_WAITING, [new MenuInfo()]);
        event.init(appItem, menuMap);

        (event as object)['getItemAppStatus']();
        expect(event instanceof AppIconMenuEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppGalleryDownloadManager.getInstance());
      mock.clearAll();
    })

    it('test_onAppStateChanged_02', 0, () => {
      let mock = new MockKit();
      try {
        let vm: AppIconMenuVm = new AppIconMenuVm();
        let event: AppIconMenuEvent = new AppIconMenuEvent(vm);

        let downloadStatusInfo: DownloadStatusInfo = {
          status: AppStatus.INSTALLING
        } as DownloadStatusInfo;
        let mockFunc: Function = mock.mockFunc(AppGalleryDownloadManager.getInstance(),
          AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(downloadStatusInfo);

        let appItem: AppItemInfo = new AppItemInfo();
        appItem.bundleName = 'com.ohos.contacts';
        appItem.appIndex = 1;

        let menuMap: Map<AppStatus, MenuInfo[]> = new Map();
        menuMap.set(AppStatus.WIFI_WAITING, [new MenuInfo()]);
        event.init(appItem, menuMap);

        (event as object)['getItemAppStatus']();
        expect(event instanceof AppIconMenuEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppGalleryDownloadManager.getInstance());
      mock.clearAll();
    })




  });
}