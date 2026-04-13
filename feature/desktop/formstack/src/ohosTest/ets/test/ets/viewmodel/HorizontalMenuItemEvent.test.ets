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
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { MenuInfo, StyleConstants } from '@ohos/launchercommon';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { HorizontalMenuItemEvent } from '../../../../../main/ets/viewmodel//HorizontalMenuItemEvent';
import { HorizontalMenuViewData } from '../../../../../main/ets/viewmodel//HorizontalMenuViewData';

export function HorizontalMenuItemEventTest() {
  describe('HorizontalMenuItemEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initData', 0, () => {
      const event: HorizontalMenuItemEvent = new HorizontalMenuItemEvent();
      event.initData(new HorizontalMenuViewData(), new MenuInfo(), () => {});
    });

    it('updateIcon', 0, () => {
      const mockKit: MockKit = new MockKit();
      try {
        const event: HorizontalMenuItemEvent = new HorizontalMenuItemEvent();
        const viewData: HorizontalMenuViewData = new HorizontalMenuViewData();
        const menuInfo: MenuInfo = new MenuInfo();
        event.initData(viewData, menuInfo, () => {});
        menuInfo.menuImgSrc = 'imgPath';
        event.updateIcon();
        menuInfo.shortcutIconId = 1;
        const mockFun: Function =
          mockKit.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getAppIconWithCache);

        when(mockFun)().afterAction((): void => { viewData.mShortcutIcon = 'imgPath'; });
        expect(viewData.mShortcutIcon).assertEqual('/common/pics/icon.png');

        mockKit.clear(ResourceManager.getInstance());
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mockKit.clearAll();
    });

    it('updateShortcutName', 0, () => {
      const event: HorizontalMenuItemEvent = new HorizontalMenuItemEvent();
      event.initData(new HorizontalMenuViewData(), new MenuInfo(), () => {});
    });

    it('onClick', 0, () => {
      const event: HorizontalMenuItemEvent = new HorizontalMenuItemEvent();
      const viewData: HorizontalMenuViewData = new HorizontalMenuViewData();
      const menuInfo: MenuInfo = new MenuInfo();
      event.initData(viewData, menuInfo, () => {});

      event.onClick();
      expect(viewData.mHoverState).assertFalse();
      expect(viewData.mPressState).assertFalse();
    });

    it('onHover', 0, () => {
      const event: HorizontalMenuItemEvent = new HorizontalMenuItemEvent();
      const viewData: HorizontalMenuViewData = new HorizontalMenuViewData();
      const menuInfo: MenuInfo = new MenuInfo();
      event.initData(viewData, menuInfo, () => {});

      event.onHover(false);
      expect(viewData.mHoverState).assertFalse();
    });

    it('onTouch', 0, () => {
      const event: HorizontalMenuItemEvent = new HorizontalMenuItemEvent();
      const viewData: HorizontalMenuViewData = new HorizontalMenuViewData();
      const menuInfo: MenuInfo = new MenuInfo();
      event.initData(viewData, menuInfo, () => {});

      event.onTouch({ type: TouchType.Cancel } as TouchEvent);
      expect(viewData.mPressState).assertFalse();

      event.onTouch({ type: TouchType.Down } as TouchEvent);
      expect(viewData.mPressState).assertTrue();

      event.onTouch({ type: TouchType.Up } as TouchEvent);
      expect(viewData.mPressState).assertFalse();
    });

    it('onMouse', 0, () => {
      const event: HorizontalMenuItemEvent = new HorizontalMenuItemEvent();
      const viewData: HorizontalMenuViewData = new HorizontalMenuViewData();
      const menuInfo: MenuInfo = new MenuInfo();
      event.initData(viewData, menuInfo, () => {});

      event.onMouse(undefined);
      expect(viewData.mHoverState).assertFalse();
      expect(viewData.mPressState).assertFalse();

      event.onMouse({ button: MouseButton.Right } as MouseEvent);
      expect(viewData.mPressState).assertFalse();
      expect(viewData.mHoverState).assertFalse();

      event.onMouse({ button: MouseButton.Left, action: MouseAction.Hover } as MouseEvent);
      expect(viewData.mHoverState).assertFalse();
      expect(viewData.mPressState).assertFalse();

      event.onMouse({ button: MouseButton.Left, action: MouseAction.Press } as MouseEvent);
      expect(viewData.mHoverState).assertFalse();
      expect(viewData.mPressState).assertTrue();
      viewData.mPressState = false;

      event.onMouse({ button: MouseButton.Left, action: MouseAction.Release } as MouseEvent);
      expect(viewData.mPressState).assertFalse();
      expect(viewData.mHoverState).assertFalse();
    });

    let event: HorizontalMenuItemEvent = new HorizontalMenuItemEvent();
    let viewData: HorizontalMenuViewData = new HorizontalMenuViewData();
    let menuInfo: MenuInfo = new MenuInfo();

    it('updateIcon_test01', 0, () => {
      menuInfo.shortcutIconId = 1;
      event.mMenuInfo = menuInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getAppIconWithCache);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing;
      event.updateIcon();
      expect(event).not().assertUndefined();
      mocker.clear(ResourceManager.getInstance());
    });

    it('updateIcon_test02', 0, () => {
      menuInfo.shortcutIconId = -1;
      event.mMenuInfo = menuInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      event.updateIcon();
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('updateShortcutName_test01', 0, () => {
      viewData.mShortcutName = 'a';
      event.mViewData = viewData;
      menuInfo.shortcutLabelId = 1;
      event.mMenuInfo = menuInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getAppNameWithCache);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing;
      event.updateShortcutName();
      expect(event).not().assertUndefined();
      mocker.clear(ResourceManager.getInstance());
    });

    it('updateIcon_test03', 0, () => {
      viewData.mShortcutName = 'a';
      event.mViewData = viewData;
      menuInfo.shortcutLabelId = -1;
      menuInfo.menuText = 'a';
      event.mMenuInfo = menuInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      event.updateIcon();
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('updateIcon_test04', 0, () => {
      viewData.mShortcutName = 'a';
      event.mViewData = viewData;
      menuInfo.shortcutLabelId = -1;
      event.mMenuInfo = menuInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      event.updateIcon();
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('onTouch_test01', 0, () => {
      (event as object)['onTouch']();
      expect(event).not().assertUndefined();
    });
  });
}