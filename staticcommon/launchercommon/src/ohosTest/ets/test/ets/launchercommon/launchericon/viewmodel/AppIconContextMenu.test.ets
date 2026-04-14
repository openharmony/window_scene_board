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

import { LogDomain, LogHelper } from '@ohos/basicutils';
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
import { AppIconConfig } from '../../../../../../../main/ets/launchericon/config/AppIconConfig';
import {
  AppIconContextMenu,
  AppIconContextMenuParam,
} from '../../../../../../../main/ets/launchericon/viewmodel/AppIconContextMenu';
import { AppIconMenuVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconMenuVm';
import { AppIconBadgeVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { AppItemInfo, GridLayoutUtil, MenuInfo } from '../../../../../../../main/ets/TsIndex';
import { BadgeAnimationType } from '../../../../../../../main/ets/uicomponents/CustomBadge';

export function AppIconContextMenuTest() {
  describe('AppIconContextMenuTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initContextMenuParam', 0, () => {
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };

      const TAG: string = 'AppIconContextMenu';
      const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

      let mocker: MockKit = new MockKit();
      let mockShowError = mocker.mockFunc(log, log.showError);
      when(mockShowError)(ArgumentMatchers.any).afterAction(action);

      let inValidParam: AppIconContextMenuParam = AppStorage.get('AppIconContextMenuTestInvalidKey') as
        AppIconContextMenuParam;
      new AppIconContextMenu().initContextMenuParam(inValidParam);
      expect(called).assertTrue();

      let inValidAppItemInfo: AppItemInfo = AppStorage.get('AppIconContextMenuTestInvalidKey') as AppItemInfo;
      called = false;
      new AppIconContextMenu().initContextMenuParam({
        itemInfo: inValidAppItemInfo,
        appIconConfig: new AppIconConfig,
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      expect(called).assertTrue();

      let inValidAppIconConfig: AppIconConfig = AppStorage.get('AppIconContextMenuTestInvalidKey') as AppIconConfig;
      called = false;
      new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: inValidAppIconConfig,
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      expect(called).assertTrue();

      let inValidAppIconMenuVm: AppIconMenuVm = AppStorage.get('AppIconContextMenuTestInvalidKey') as AppIconMenuVm;
      called = false;
      new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig,
        iconMenuVm: inValidAppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      expect(called).assertTrue();

      called = false;
      new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig,
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: undefined,
        longPressImageBuilder: () => {}
      });
      expect(called).assertTrue();

      called = false;
      new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig,
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: undefined
      });
      expect(called).assertTrue();

      called = false;
      new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig,
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      expect(called).assertFalse();

      mocker.clear(log);
      mocker.clearAll();
    });

    it('test_showContextMenu_7', 0, () => {
      let inValidAppIconConfig: AppIconConfig = AppStorage.get('AppIconContextMenuTestInvalidKey') as AppIconConfig;
      let appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: inValidAppIconConfig,
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      expect(appIconContextMenu.showContextMenu()).assertInstanceOf('Boolean');

      appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig().setEnableMenu(false),
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      expect(appIconContextMenu.showContextMenu()).assertFalse();

      let mocker: MockKit = new MockKit();
      let mockIsAppInstalled = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
      when(mockIsAppInstalled)(ArgumentMatchers.any).afterReturn(false);
      appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig().setEnableMenu(true),
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      expect(appIconContextMenu.showContextMenu()).assertTrue();

      let inValidAppIconMenuVm: AppIconMenuVm = AppStorage.get('AppIconContextMenuTestInvalidKey') as AppIconMenuVm;
      appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig().setEnableMenu(true),
        iconMenuVm: inValidAppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      when(mockIsAppInstalled)(ArgumentMatchers.any).afterReturn(true);
      expect(appIconContextMenu.showContextMenu()).assertFalse();

      appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig().setEnableMenu(true),
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      expect(appIconContextMenu.showContextMenu()).assertFalse();

      let menuInfo: MenuInfo[] = AppStorage.get('AppIconContextMenuTestInvalidValue') as MenuInfo[];
      let menuVm: AppIconMenuVm = new AppIconMenuVm;
      menuVm.menuInfo = menuInfo;
      appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig().setEnableMenu(true),
        iconMenuVm: menuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      expect(appIconContextMenu.showContextMenu()).assertFalse();

      menuInfo = [new MenuInfo(), new MenuInfo()];
      menuVm.menuInfo = menuInfo;
      appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig().setEnableMenu(true),
        iconMenuVm: menuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      expect(appIconContextMenu.showContextMenu()).assertTrue();
    });

    it('getContentBuilder', 0, () => {
      let appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig(),
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: undefined,
        longPressImageBuilder: () => {}
      });
      expect(!appIconContextMenu.getContentBuilder()).assertTrue();
    });

    it('getContextMenuOptions', 0, () => {
      let appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig(),
        iconMenuVm: new AppIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      let options: ContextMenuOptions = appIconContextMenu.getContextMenuOptions();
      expect(options.layoutRegionMargin).assertUndefined();
    });

    it('onMenuDisappear', 0, () => {
      let appIconMenuVm: AppIconMenuVm = AppStorage.get('AppIconContextMenuTestInvalidValue') as AppIconMenuVm;
      let appIconBadgeVm: AppIconBadgeVm = AppStorage.get('AppIconContextMenuTestInvalidValue') as AppIconBadgeVm;
      let appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig().setEnableMenu(true),
        iconMenuVm: appIconMenuVm,
        iconBadgeVm: appIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      appIconContextMenu.onMenuDisappear();
      expect(appIconMenuVm).assertUndefined();

      appIconBadgeVm = new AppIconBadgeVm();
      appIconMenuVm = new AppIconMenuVm();
      appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig().setEnableMenu(true),
        iconMenuVm: appIconMenuVm,
        iconBadgeVm: appIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      appIconContextMenu.onMenuDisappear();
      expect(appIconBadgeVm.animate).assertEqual(BadgeAnimationType.TOUCH_UP);
    });

    it('onMenuAppear', 0, () => {
      let appIconMenuVm: AppIconMenuVm = AppStorage.get('AppIconContextMenuTestInvalidValue') as AppIconMenuVm;
      let appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig().setEnableMenu(true),
        iconMenuVm: appIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      appIconContextMenu.onMenuAppear();
      expect(appIconMenuVm).assertUndefined();

      appIconMenuVm = new AppIconMenuVm();
      appIconMenuVm.menuInfo = [new MenuInfo(), new MenuInfo()];
      appIconContextMenu = new AppIconContextMenu().initContextMenuParam({
        itemInfo: new AppItemInfo,
        appIconConfig: new AppIconConfig().setEnableMenu(true),
        iconMenuVm: appIconMenuVm,
        iconBadgeVm: new AppIconBadgeVm,
        contentBuilder: () => {},
        longPressImageBuilder: () => {}
      });
      appIconContextMenu.onMenuAppear();
      expect(appIconMenuVm.isMenuShow()).assertTrue();
    });
  });
}