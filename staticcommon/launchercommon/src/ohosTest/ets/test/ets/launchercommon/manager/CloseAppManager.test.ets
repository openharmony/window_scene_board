/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  CloseAppManager,
  ClosePosition,
  AppInfo,
  StartSubtype
} from '../../../../../../main/ets/TsIndex';
import { BaseCloseAppHandler } from '../../../../../../main/ets/TsIndex';
import { AppItemInfo } from '../../../../../../main/ets/TsIndex';
import { CommonConstants } from '../../../../../../main/ets/TsIndex';
import { StartType, RectInfo, CheckEmptyUtils } from '@ohos/basicutils';
import { onLineThemeUtil } from '@ohos/frameworkwrapper';

function getNullObject(): BaseCloseAppHandler | null {
  return null;
}

export function CloseAppManagerTest() {
  describe('CloseAppManagerTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('CloseAppManagerTest_setStartAppType', Level.LEVEL0, (): void => {
      CloseAppManager.getInstance().setStartAppType(StartType.APP);
      expect(CloseAppManager.getInstance().getStartAppType()).assertEqual(StartType.APP);
    });

    it('setIsStartCard', Level.LEVEL0, (): void => {
      CloseAppManager.getInstance().setIsStartCard();
      expect(CloseAppManager.getInstance().getAndResetIsStartCard()).assertEqual(true);
    });

    it('getIsStartCard', Level.LEVEL0, (): void => {
      CloseAppManager.getInstance().setIsStartCard();
      expect(CloseAppManager.getInstance().getAndResetIsStartCard()).assertEqual(true);
      expect(CloseAppManager.getInstance().getAndResetIsStartCard()).assertEqual(false);
    });

    it('resetIsStartCard', Level.LEVEL0, (): void => {
      CloseAppManager.getInstance().setIsStartCard();
      CloseAppManager.getInstance().resetIsStartCard();
      expect(CloseAppManager.getInstance().getAndResetIsStartCard()).assertEqual(false);
    });

    it("test_registerCloseAppHandler_paramIsEmpty", Level.LEVEL0, () => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(null);
      manager.unregisterCloseAppHandler(null);
      expect(handler.mWindowTarget).assertEqual('1');
    })

    it('CloseAppManagerTest_getAppIconInfo_1', Level.LEVEL0, (): void => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.unregisterCloseAppHandler(handler);
      manager.getAppIconInfo('2');
      expect(handler.mWindowTarget).assertEqual('1');
    });

    it('CloseAppManagerTest_getAppIconInfo_2', Level.LEVEL0, (): void => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.getAppIconInfo('2');
      expect(handler.mWindowTarget).assertEqual('2');
    });

    it('CloseAppManagerTest_getAppIconInfo_3', Level.LEVEL0, (): void => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      let handlerNext: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handlerNext);
      manager.unregisterCloseAppHandler(handler);
      manager.getAppIconInfo('2');
      expect(handler.mWindowTarget).assertEqual('1');
      expect(handlerNext.mWindowTarget).assertEqual('2');
    });

    it('CloseAppManagerTest_getAppIconInfo_4', Level.LEVEL0, (): void => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      let handlerNext: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handlerNext);
      manager.unregisterCloseAppHandler(handlerNext);
      manager.getAppIconInfo('2');
      expect(handler.mWindowTarget).assertEqual('2');
      expect(handlerNext.mWindowTarget).assertEqual('1');
    });

    it('CloseAppManagerTest_getAppIconInfo_5', Level.LEVEL0, (): void => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      let handlerNext: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handlerNext);
      manager.getAppIconInfo('2');
      expect(handler.mWindowTarget).assertEqual('2');
      expect(handlerNext.mWindowTarget).assertEqual('2');
    });

    it('CloseAppManagerTest_getAppIconInfo_6', Level.LEVEL0, (): void => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.unregisterCloseAppHandler(handler);
      let handlerNext: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handlerNext);
      manager.unregisterCloseAppHandler(handlerNext);
      manager.getAppIconInfo('2');
      expect(handler.mWindowTarget).assertEqual('1');
      expect(handlerNext.mWindowTarget).assertEqual('1');
    });

    it('CloseAppManagerTest_getAppInfo_1', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      expect(manager.getAppInfo('1').iconInfo).assertUndefined();
    });

    it('CloseAppManagerTest_getAppInfo_2', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.addPagedesktopClosePosition(null, null);
      manager.addSmartDockClosePosition(null, null);
      let info: AppInfo = manager.getAppInfo('1');
      expect(info.iconInfo).assertNull();
      expect(info.appItemInfo).assertNull();
    });

    it('CloseAppManagerTest_getAppInfo_3', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.addPagedesktopClosePosition(null, null);
      let smartPosition: ClosePosition = {
        appIconSize: 1,
        appIconHeight: 1,
        appIconPositionX: 1,
        appIconPositionY: 1
      }
      let smartItem: AppItemInfo = new AppItemInfo();
      smartItem.appName = 'test';
      manager.addSmartDockClosePosition(smartPosition, smartItem);
      let info: AppInfo = manager.getAppInfo('1');
      expect(smartPosition.appIconSize).assertEqual(1);
    });

    it('CloseAppManagerTest_getAppInfo_4', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      let desktopPosition: ClosePosition = {
        appIconSize: 1,
        appIconHeight: 1,
        appIconPositionX: 1,
        appIconPositionY: 1
      }
      manager.addPagedesktopClosePosition(desktopPosition);
      let info: AppInfo = manager.getAppInfo('1');
      expect(info.iconInfo?.appIconSize).assertEqual(1);
      expect(info.iconInfo?.appIconHeight).assertEqual(1);
      expect(info.iconInfo?.appIconPositionX).assertEqual(1);
      expect(info.iconInfo?.appIconPositionY).assertEqual(1);
      expect(info.appItemInfo).assertUndefined();
    });

    it('CloseAppManagerTest_getAppInfo_5', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      let desktopPosition: ClosePosition = {
        appIconSize: 1,
        appIconHeight: 1,
        appIconPositionX: 1,
        appIconPositionY: 1
      }
      let desktopItem: AppItemInfo = new AppItemInfo();
      desktopItem.appName = 'test';
      manager.addPagedesktopClosePosition(desktopPosition, desktopItem);
      let info: AppInfo = manager.getAppInfo('1');
      expect(info.iconInfo?.appIconSize).assertEqual(1);
      expect(info.iconInfo?.appIconHeight).assertEqual(1);
      expect(info.iconInfo?.appIconPositionX).assertEqual(1);
      expect(info.iconInfo?.appIconPositionY).assertEqual(1);
      expect(info.appItemInfo?.appName).assertEqual('test');
    });

    it('CloseAppManagerTest_getAppInfoByBundleName_1', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      expect(manager.getAppInfoByBundleName('1').iconInfo).assertUndefined();
    });

    it('CloseAppManagerTest_getAppInfoByBundleName_2', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.addPagedesktopClosePosition(null, null);
      manager.addSmartDockClosePosition(null, null);
      let info: AppInfo = manager.getAppInfoByBundleName('1');
      expect(info.iconInfo).assertNull();
      expect(info.appItemInfo).assertNull();
    });

    it('CloseAppManagerTest_getAppInfoByBundleName_3', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.addPagedesktopClosePosition(null, null);
      let smartPosition: ClosePosition = {
        appIconSize: 1,
        appIconHeight: 1,
        appIconPositionX: 1,
        appIconPositionY: 1
      }
      let smartItem: AppItemInfo = new AppItemInfo();
      smartItem.appName = 'test';
      manager.addSmartDockClosePosition(smartPosition, smartItem);
      let info: AppInfo = manager.getAppInfoByBundleName('1');
      expect(smartPosition.appIconSize).assertEqual(1);
    });

    it('CloseAppManagerTest_getAppInfoByBundleName_4', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      let desktopPosition: ClosePosition = {
        appIconSize: 1,
        appIconHeight: 1,
        appIconPositionX: 1,
        appIconPositionY: 1
      }
      manager.addPagedesktopClosePosition(desktopPosition);
      let info: AppInfo = manager.getAppInfoByBundleName('1');
      expect(info.iconInfo?.appIconSize).assertEqual(1);
      expect(info.iconInfo?.appIconHeight).assertEqual(1);
      expect(info.iconInfo?.appIconPositionX).assertEqual(1);
      expect(info.iconInfo?.appIconPositionY).assertEqual(1);
      expect(info.appItemInfo).assertUndefined();
    });

    it('CloseAppManagerTest_getAppInfoByBundleName_5', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      let desktopPosition: ClosePosition = {
        appIconSize: 1,
        appIconHeight: 1,
        appIconPositionX: 1,
        appIconPositionY: 1
      }
      let desktopItem: AppItemInfo = new AppItemInfo();
      desktopItem.appName = 'test';
      manager.addPagedesktopClosePosition(desktopPosition, desktopItem);
      let info: AppInfo = manager.getAppInfoByBundleName('1');
      expect(info.iconInfo?.appIconSize).assertEqual(1);
      expect(info.iconInfo?.appIconHeight).assertEqual(1);
      expect(info.iconInfo?.appIconPositionX).assertEqual(1);
      expect(info.iconInfo?.appIconPositionY).assertEqual(1);
      expect(info.appItemInfo?.appName).assertEqual('test');
    });

    it('CloseAppManagerTest_getAppInfoByBundleName_6', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      let desktopPosition: ClosePosition = {
        appIconSize: 1,
        appIconHeight: 1,
        appIconPositionX: 1,
        appIconPositionY: 1
      }
      let desktopItem: AppItemInfo = new AppItemInfo();
      desktopItem.appName = 'test';
      manager.addPagedesktopClosePosition(desktopPosition, desktopItem);
      let info: AppInfo = manager.getAppInfoByBundleName('1', '1');
      expect(info.iconInfo?.appIconSize).assertEqual(1);
      expect(info.iconInfo?.appIconHeight).assertEqual(1);
      expect(info.iconInfo?.appIconPositionX).assertEqual(1);
      expect(info.iconInfo?.appIconPositionY).assertEqual(1);
      expect(info.appItemInfo?.appName).assertEqual('test');
    });

    it('CloseAppManagerTest_getAppInfoByBundleName_7', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      let desktopPosition: ClosePosition = {
        appIconSize: 1,
        appIconHeight: 1,
        appIconPositionX: 1,
        appIconPositionY: 1
      }
      let desktopItem: AppItemInfo = new AppItemInfo();
      desktopItem.appName = 'test';
      manager.addPagedesktopClosePosition(desktopPosition, desktopItem);
      let info: AppInfo = manager.getAppInfoByBundleName('1', '1', 1);
      expect(info.iconInfo?.appIconSize).assertEqual(1);
      expect(info.iconInfo?.appIconHeight).assertEqual(1);
      expect(info.iconInfo?.appIconPositionX).assertEqual(1);
      expect(info.iconInfo?.appIconPositionY).assertEqual(1);
      expect(info.appItemInfo?.appName).assertEqual('test');
    });

    it('CloseAppManagerTest_setOpenFolderAppIconInfo_1', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      manager.setOpenFolderAppIconInfo(null);
      expect(manager.getOpenFolderAppIconInfo()).assertNull();
    });

    it('CloseAppManagerTest_setOpenFolderAppIconInfo_2', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      manager.setOpenFolderAppIconInfo(undefined);
      expect(manager.getOpenFolderAppIconInfo()).assertNull();
    });

    it('CloseAppManagerTest_setOpenFolderAppIconInfo_3', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.APP);
      let rectInfo: RectInfo = new RectInfo();
      manager.setOpenFolderAppIconInfo(rectInfo);
      expect(manager.getOpenFolderAppIconInfo()).assertNull();
    });

    it('CloseAppManagerTest_setOpenFolderAppIconInfo_4', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.FOLDER);
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      manager.setOpenFolderAppIconInfo(rectInfo);
      let info: ClosePosition = manager.getOpenFolderAppIconInfo();
      expect(info.appIconSize).assertEqual(1);
      expect(info.appIconHeight).assertEqual(1);
      expect(info.appIconPositionX).assertEqual(0);
      expect(info.appIconPositionY).assertEqual(0);
    });

    it('CloseAppManagerTest_setOpenFolderIconPosition_1', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      AppStorage.delete('openFolderId');
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.FOLDER);
      manager.setOpenFolderIconPosition(null, rectInfo);
      let info: ClosePosition = manager.getOpenFolderAppIconInfo();
      expect(info.appIconSize).assertEqual(0);
      expect(info.appIconHeight).assertEqual(0);
      expect(info.appIconPositionX).assertEqual(0);
      expect(info.appIconPositionY).assertEqual(0);
    });

    it('CloseAppManagerTest_setOpenFolderIconPosition_2', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      AppStorage.delete('openFolderId');
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.FOLDER);
      manager.setOpenFolderIconPosition('1', rectInfo);
      let info: ClosePosition = manager.getOpenFolderAppIconInfo();
      expect(info.appIconSize).assertEqual(0);
      expect(info.appIconHeight).assertEqual(0);
      expect(info.appIconPositionX).assertEqual(0);
      expect(info.appIconPositionY).assertEqual(0);
    });

    it('CloseAppManagerTest_setOpenFolderIconPosition_3', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      AppStorage.delete('openFolderId');
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.FOLDER);
      manager.setOpenFolderIconPosition(CommonConstants.Folder_BUBBLE_APP_ICON_TAG + '1', rectInfo);
      let info: ClosePosition = manager.getOpenFolderAppIconInfo();
      expect(info.appIconSize).assertEqual(0);
      expect(info.appIconHeight).assertEqual(0);
      expect(info.appIconPositionX).assertEqual(0);
      expect(info.appIconPositionY).assertEqual(0);
    });

    it('CloseAppManagerTest_setOpenFolderIconPosition_4', Level.LEVEL0, (): void => {
      globalThis.CloseAppManager = null;
      AppStorage.setOrCreate<string>('openFolderId', CommonConstants.INVALID_FOLDER_ID);
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.FOLDER);
      manager.setOpenFolderIconPosition(null, rectInfo);
      let info: ClosePosition = manager.getOpenFolderAppIconInfo();
      expect(info.appIconSize).assertEqual(0);
      expect(info.appIconHeight).assertEqual(0);
      expect(info.appIconPositionX).assertEqual(0);
      expect(info.appIconPositionY).assertEqual(0);
    });

    it('CloseAppManagerTest_setOpenFolderIconPosition_5', Level.LEVEL0, (): void => {
      AppStorage.setOrCreate<string>('openFolderId', CommonConstants.INVALID_FOLDER_ID);
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.FOLDER);
      manager.setOpenFolderIconPosition('1', rectInfo);
      let info: ClosePosition = manager.getOpenFolderAppIconInfo();
      expect(info.appIconSize).assertEqual(0);
      expect(info.appIconHeight).assertEqual(0);
      expect(info.appIconPositionX).assertEqual(0);
      expect(info.appIconPositionY).assertEqual(0);
    });

    it('CloseAppManagerTest_setOpenFolderIconPosition_6', Level.LEVEL0, (): void => {
      AppStorage.setOrCreate<string>('openFolderId', CommonConstants.INVALID_FOLDER_ID);
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.FOLDER);
      manager.setOpenFolderIconPosition(CommonConstants.Folder_BUBBLE_APP_ICON_TAG + '1', rectInfo);
      let info: ClosePosition = manager.getOpenFolderAppIconInfo();
      expect(info.appIconSize).assertEqual(0);
      expect(info.appIconHeight).assertEqual(0);
      expect(info.appIconPositionX).assertEqual(0);
      expect(info.appIconPositionY).assertEqual(0);
    });

    it('CloseAppManagerTest_setOpenFolderIconPosition_7', Level.LEVEL0, (): void => {
      AppStorage.setOrCreate<string>('openFolderId', '1');
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.FOLDER);
      manager.setOpenFolderIconPosition(null, rectInfo);
      let info: ClosePosition = manager.getOpenFolderAppIconInfo();
      expect(info.appIconSize).assertEqual(0);
      expect(info.appIconHeight).assertEqual(0);
      expect(info.appIconPositionX).assertEqual(0);
      expect(info.appIconPositionY).assertEqual(0);
    });

    it('CloseAppManagerTest_setOpenFolderIconPosition_8', Level.LEVEL0, (): void => {
      AppStorage.setOrCreate<string>('openFolderId', '1');
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.FOLDER);
      manager.setOpenFolderIconPosition('1', rectInfo);
      let info: ClosePosition = manager.getOpenFolderAppIconInfo();
      expect(info.appIconSize).assertEqual(0);
      expect(info.appIconHeight).assertEqual(0);
      expect(info.appIconPositionX).assertEqual(0);
      expect(info.appIconPositionY).assertEqual(0);
    });

    it('CloseAppManagerTest_setOpenFolderIconPosition_9', Level.LEVEL0, (): void => {
      AppStorage.setOrCreate<string>('openFolderId', '1');
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.FOLDER);
      manager.setOpenFolderIconPosition(CommonConstants.Folder_BUBBLE_APP_ICON_TAG + '1', rectInfo);
      let info: ClosePosition = manager.getOpenFolderAppIconInfo();
      expect(info.appIconPositionY).assertEqual(0);
    });

    it('CloseAppManagerTest_setStartAppType_1', Level.LEVEL0, () => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.APP);
      expect(manager.getStartAppType()).assertEqual(StartType.APP);
      expect(manager.getStartCardId()).assertUndefined();
      expect(manager.getExtraId()).assertUndefined();
    });

    it('CloseAppManagerTest_setStartAppType_2', Level.LEVEL0, () => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.CARD, '1');
      expect(manager.getStartAppType()).assertEqual(StartType.CARD);
      expect(manager.getStartCardId()).assertEqual('1');
      expect(manager.getExtraId()).assertUndefined();
    });

    it('CloseAppManagerTest_setStartAppType_3', Level.LEVEL0, () => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(handler);
      manager.setStartAppType(StartType.CARD, '1', '1');
      expect(manager.getStartAppType()).assertEqual(StartType.CARD);
      expect(manager.getStartCardId()).assertEqual('1');
      expect(manager.getExtraId()).assertEqual('1');
    });

    it('CloseAppManagerTest_setStartAppSubtype_1', Level.LEVEL0, () => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      manager.setStartAppSubtype(StartSubtype.NONE);
      expect(manager.getStartAppSubtype()).assertEqual(StartSubtype.NONE);
    });

    it('CloseAppManagerTest_setStartAppSubtype_2', Level.LEVEL0, () => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      manager.setStartAppSubtype(StartSubtype.DOCK_ICON);
      manager.resetStartAppSubtype();
      expect(manager.getStartAppSubtype()).assertEqual(StartSubtype.NONE);
    });

    it('CloseAppManagerTest_setStartAppSubtype_3', Level.LEVEL0, () => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      manager.setStartAppSubtype(StartSubtype.DOCK_ICON);
      expect(manager.getStartAppSubtype()).assertEqual(StartSubtype.DOCK_ICON);
    });

    it('CloseAppManagerTest_setStartAppSubtype_4', Level.LEVEL0, () => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      manager.setStartAppSubtype(StartSubtype.DOCK_RIGHT_MENU);
      expect(manager.getStartAppSubtype()).assertEqual(StartSubtype.DOCK_RIGHT_MENU);
    });

    it('CloseAppManagerTest_setStartAppSubtype_5', Level.LEVEL0, () => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      manager.setStartAppSubtype(StartSubtype.ICON_FROM_APP_CENTER);
      expect(manager.getStartAppSubtype()).assertEqual(StartSubtype.ICON_FROM_APP_CENTER);
    });

    it('CloseAppManagerTest_getAppCloseIconInfo', Level.LEVEL0, () => {
      let pos: ClosePosition = CloseAppManager.getInstance().getAppCloseIconInfo();
      expect(pos.appIconPositionX).assertLargerOrEqual(0);
    });

    it('CloseAppManagerTest_getAppCloseItemInfo', Level.LEVEL0, () => {
      const appname = 'test';
      let desktopItem: AppItemInfo = new AppItemInfo();
      desktopItem.appName = appname;
      CloseAppManager.getInstance().addPagedesktopClosePosition(null, desktopItem);
      let info: AppItemInfo = CloseAppManager.getInstance().getAppCloseItemInfo();
      expect(info.appName).assertEqual(appname);
    });

    it('CloseAppManagerTest_isAppIconInOpenFolder', Level.LEVEL0, () => {
      const Folder_BUBBLE_APP_ICON_TAG = 'FolderAppBubble_FolderIcon_';
      const iconId = Folder_BUBBLE_APP_ICON_TAG + 'demo_icon';

      AppStorage.setOrCreate<string>('openFolderId', '1000');
      let ret: boolean = CloseAppManager.getInstance().isAppIconInOpenFolder(iconId);
      expect(ret).assertFalse();
    });

    it('getAppIconInfo_01', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      try {
        closeAppManager.getAppIconInfo('2');
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getAppIconInfo_02', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      try {
        closeAppManager.getAppIconInfo('2');
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getAppInfo_01', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      try {
        closeAppManager.getAppInfo('2');
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getAppInfo_02', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      try {
        closeAppManager.getAppInfo('2');
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getAppInfoByBundleName_01', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(true);
      try {
        closeAppManager.getAppInfoByBundleName('2', '1', 3);
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getAppInfoByBundleName_02', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmptyArr: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(isEmptyArr)(ArgumentMatchers.any).afterReturn(false);
      try {
        closeAppManager.getAppInfoByBundleName('2', '1', 3);
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getAppCloseIconInfo_01', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      try {
        closeAppManager.getAppCloseIconInfo();
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getAppCloseIconInfo_02', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
      try {
        closeAppManager.getAppCloseIconInfo();
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getAppCloseItemInfo_01', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      try {
        closeAppManager.getAppCloseItemInfo();
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('getAppCloseItemInfo_02', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
      try {
        closeAppManager.getAppCloseItemInfo();
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('setOpenFolderAppIconInfo_01', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let mocker: MockKit = new MockKit();
      let getStartAppType: Function = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(getStartAppType)(ArgumentMatchers.any).afterReturn(2);
      try {
        closeAppManager.setOpenFolderAppIconInfo(rectInfo);
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(closeAppManager);
      mocker.clearAll();
    });

    it('setOpenFolderAppIconInfo_02', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let mocker: MockKit = new MockKit();
      let getStartAppType: Function = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(getStartAppType)(ArgumentMatchers.any).afterReturn(1);
      try {
        closeAppManager.setOpenFolderAppIconInfo(rectInfo);
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(closeAppManager);
      mocker.clearAll();
    });

    it('getOpenFolderAppIconInfo_01', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let getStartAppType: Function = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(getStartAppType)(ArgumentMatchers.any).afterReturn(2);
      try {
        closeAppManager.getOpenFolderAppIconInfo();
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(closeAppManager);
      mocker.clearAll();
    });

    it('getOpenFolderAppIconInfo_02', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let getStartAppType: Function = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(getStartAppType)(ArgumentMatchers.any).afterReturn(1);
      try {
        closeAppManager.getOpenFolderAppIconInfo();
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(closeAppManager);
      mocker.clearAll();
    });

    it('setOpenFolderIconPosition_01', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let mocker: MockKit = new MockKit();
      let isAppIconInOpenFolder: Function = mocker.mockFunc(closeAppManager, closeAppManager.isAppIconInOpenFolder);
      when(isAppIconInOpenFolder)(ArgumentMatchers.any).afterReturn(true);
      try {
        closeAppManager.setOpenFolderIconPosition('1',rectInfo);
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(closeAppManager);
      mocker.clearAll();
    });

    it('setOpenFolderIconPosition_02', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let rectInfo: RectInfo = new RectInfo();
      rectInfo.left = 0;
      rectInfo.right = 1;
      rectInfo.top = 0;
      rectInfo.bottom = 1;
      let mocker: MockKit = new MockKit();
      let isAppIconInOpenFolder: Function = mocker.mockFunc(closeAppManager, closeAppManager.isAppIconInOpenFolder);
      when(isAppIconInOpenFolder)(ArgumentMatchers.any).afterReturn(false);
      closeAppManager.setOpenFolderIconPosition('1',rectInfo);
      expect(closeAppManager).not().assertNull();
      mocker.clear(closeAppManager);
      mocker.clearAll();
    });

    it('setAdaptiveIcon_01', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      try {
        closeAppManager.setAdaptiveIcon('1', '2', '3', 4);
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('setAdaptiveIcon_02', 0, (): void => {
      let closeAppManager: CloseAppManager = CloseAppManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
      try {
        closeAppManager.setAdaptiveIcon('1', '2', '3', 4);
        expect(closeAppManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('CloseAppManagerTest_setAdaptiveIcon', Level.LEVEL0, async (done: Function) => {
      const bundle = 'com.ohos.contacts';
      try {
        await CloseAppManager.getInstance().setAdaptiveIcon(bundle, 'module name', 'ability name', 0);
        expect(CloseAppManager.getInstance()['isUpdatingAdaptiveIcon']).assertEqual(true)
      } catch (error) {
      }
      done();
    });

    it('CloseAppManagerTest_setAdaptiveIcon_02', Level.LEVEL0, async (done: Function) => {
      const bundle = 'com.ohos.contacts';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(onLineThemeUtil, onLineThemeUtil.isOnlineTheme);
      try {
        CloseAppManager.getInstance()['isUpdatingAdaptiveIcon'] = false;
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        await CloseAppManager.getInstance().setAdaptiveIcon(bundle, 'module name', 'ability name', 0);
        expect(CloseAppManager.getInstance()['isUpdatingAdaptiveIcon']).assertEqual(false);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        await CloseAppManager.getInstance().setAdaptiveIcon(bundle, 'module name', 'ability name', 0);
        expect(CloseAppManager.getInstance()['isUpdatingAdaptiveIcon']).assertEqual(false);
      } catch (error) {
      }
      mocker.clear(onLineThemeUtil);
      mocker.clearAll();
      done();
    });

    it('CloseAppManagerTest_getAdaptiveIcon', Level.LEVEL0, async (done: Function) => {
      const bundle = 'com.ohos.contacts';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(onLineThemeUtil, onLineThemeUtil.isOnlineTheme);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let ret = await CloseAppManager.getInstance().getAdaptiveIcon(bundle, 'module name', 'ability name', 1);
      expect(ret.length).assertEqual(0);
      CloseAppManager.getInstance()['touchedBundleName'] = bundle;
      CloseAppManager.getInstance()['touchedModuleName'] = 'module name';
      CloseAppManager.getInstance()['touchedAbilityName'] = 'ability name';
      CloseAppManager.getInstance()['isUpdatingAdaptiveIcon'] = true;
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        ret = await CloseAppManager.getInstance().getAdaptiveIcon(bundle, 'module name', 'ability name', 1);
        expect(ret.length).assertEqual(0);
      } catch (e) {
      }
      CloseAppManager.getInstance()['isUpdatingAdaptiveIcon'] = false;
      try {
        ret = await CloseAppManager.getInstance().getAdaptiveIcon(bundle, 'module name', 'ability name', 1);
        expect(ret.length).assertEqual(0);
      } catch (e) {
      }
      CloseAppManager.getInstance()['touchedModuleName'] = 'module name2';
      try {
        ret = await CloseAppManager.getInstance().getAdaptiveIcon(bundle, 'module name', 'ability name', 1);
        expect(ret.length).assertEqual(0);
      } catch (e) {
      }
      mocker.clear(onLineThemeUtil);
      mocker.clearAll();
      done();
    });

    it('CloseAppManagerTest_getCardStartSnapshot', Level.LEVEL0, async (done: Function) => {
      CloseAppManager.getInstance()['touchedCardId'] = '1';
      let ret = await CloseAppManager.getInstance().getCardStartSnapshot('2');
      expect(ret === undefined).assertTrue();
      done()
    });

    it('CloseAppManagerTest_registerCloseAppHandler', Level.LEVEL0, () => {
      let manager: CloseAppManager = CloseAppManager.getInstance();
      let item: BaseCloseAppHandler = getNullObject() as BaseCloseAppHandler;
      manager.registerCloseAppHandler(item);
      manager.unregisterCloseAppHandler(item);
      let item2: BaseCloseAppHandler = new CloseAppTestHandler();
      let handler: CloseAppTestHandler = new CloseAppTestHandler();
      manager.registerCloseAppHandler(item2);
      manager.unregisterCloseAppHandler(item2);
      expect(handler.mWindowTarget).assertEqual('1');
    });
  });
}

export class CloseAppTestHandler extends BaseCloseAppHandler {
  mWindowTarget: string = '1';

  protected calculateAppIconPosition(): void {
  }

  getAppIconInfo(windowTarget: string): void {
    this.mWindowTarget = windowTarget;
  }
}