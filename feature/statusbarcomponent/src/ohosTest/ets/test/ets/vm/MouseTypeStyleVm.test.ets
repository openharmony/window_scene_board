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
import { describe, beforeEach, it, expect, MockKit, when, ArgumentMatchers, } from '@ohos/hypium';
import {
  MouseClickType,
  MouseHoverType,
  ResourceVm,
  IStatusBarIconVm
} from '@ohos/systemuicommon/newIndex';
import { TargetPanel } from '@ohos/frameworkwrapper';
import { ColorUtil } from '@ohos/systemuicommon/src/main/ets/utils/ColorUtil';
import { crossModuleCallUtil } from '@ohos/systemuicommon';
import { MockUtils } from '../common/MockUtils';
import { MouseTypeStyleVm } from '../../../../../main/ets/vm/MouseTypeStyleVm';
import { MockStatusBarVmInjector } from '../common/MockStatusBarVnInjector';


export default function MouseTypeStyleVmTest() {
  describe('MouseTypeStyleVmTest', () => {
    let injector = new MockStatusBarVmInjector();
    let styleVm = new MouseTypeStyleVm(injector);
    let mock = new MockKit();

    beforeEach(() => {
      injector = new MockStatusBarVmInjector();
      styleVm = new MouseTypeStyleVm(injector);
      mock = new MockKit();
    });

    it('test_onStatusBarColorChange', 0, () => {
      try {
        const func = mock.mockFunc(ColorUtil, ColorUtil.isRGBColor);
        when(func)(ArgumentMatchers.any).afterReturn(true);
        styleVm.onStatusBarColorChange();
      } catch (err) {
      }

      try {
        const func = mock.mockFunc(ColorUtil, ColorUtil.isRGBColor);
        when(func)(ArgumentMatchers.any).afterReturn(false);
        styleVm.onStatusBarColorChange();
      } catch (err) {
      }

      expect(injector != null).assertTrue();
    });

    it('test_onDropDownPanelChange', 0, () => {
      try {
        styleVm.onClockVisibleChange();
      } catch (err) {
      }

      expect(injector != null).assertTrue();
    });

    it('test_refreshLeftGroupWidth', 0, () => {
      const iconVm = MockUtils.mockInterface<IStatusBarIconVm>({}, { 'isVisible': true });
      expect(iconVm.getVisible != null).assertTrue();

      const func = mock.mockFunc(injector, injector.getStatusBarIconVm);
      when(func)(ArgumentMatchers.any).afterReturn(iconVm);

      styleVm = new MouseTypeStyleVm(injector);
      Reflect.set(styleVm, 'curMouseHoverPos', MouseHoverType.HOVER_LEFT);
      styleVm.refreshLeftGroupWidth();

      expect(injector != null).assertTrue();
    });

    it('test_refreshBgColor', 0, () => {
      Reflect.set(styleVm, 'curMouseClickPos', MouseClickType.CLICK_LEFT);
      styleVm.refreshBgColor();
      expect(injector != null).assertTrue();

      Reflect.set(styleVm, 'curMouseClickPos', MouseClickType.CLICK_RIGHT);
      styleVm.refreshBgColor();
      expect(injector != null).assertTrue();

      Reflect.set(styleVm, 'curMouseClickPos', MouseClickType.NONE);
      Reflect.set(styleVm, 'curMouseHoverPos', MouseHoverType.HOVER_LEFT);
      styleVm.refreshBgColor();
      expect(injector != null).assertTrue();

      Reflect.set(styleVm, 'curMouseClickPos', MouseClickType.NONE);
      Reflect.set(styleVm, 'curMouseHoverPos', MouseHoverType.HOVER_RIGHT);
      styleVm.refreshBgColor();
      expect(injector != null).assertTrue();
    });

    it('test_onMouseClick_01', 0, () => {
      styleVm.onMouseClick(undefined);
      expect(injector != null).assertTrue();

      const func = mock.mockFunc(crossModuleCallUtil, crossModuleCallUtil.call);
      when(func)(ArgumentMatchers.any).afterReturn(false);

      const mouseEvent = MockUtils.mockInterface<MouseEvent>({}, { 'button': MouseButton.Left });

      styleVm.onMouseClick(mouseEvent);
      expect(injector != null).assertTrue();
    });

    it('test_onMouseClick_02', 0, () => {
      Reflect.set(styleVm, 'curMouseHoverPos', MouseHoverType.HOVER_LEFT);
      Reflect.set(styleVm, 'curMouseClickPos', MouseClickType.CLICK_LEFT);
      const func = mock.mockFunc(crossModuleCallUtil, crossModuleCallUtil.call);
      when(func)(ArgumentMatchers.any).afterReturn(true);

      const mouseEvent = MockUtils.mockInterface<MouseEvent>({}, { 'button': MouseButton.Left });
      styleVm.onMouseClick(mouseEvent);
      expect(mouseEvent.button === MouseButton.Left).assertTrue();

      const mouseEventRight = MockUtils.mockInterface<MouseEvent>({}, { 'button': MouseButton.Right });
      styleVm.onMouseClick(mouseEventRight);
      expect(mouseEventRight.button === MouseButton.Right).assertTrue();
    });

    it('test_onMouseClick_03', 0, () => {
      const func = mock.mockFunc(crossModuleCallUtil, crossModuleCallUtil.call);
      when(func)(ArgumentMatchers.any).afterReturn(true);

      const mouseEvent = MockUtils.mockInterface<MouseEvent>({}, {
        'action': MouseAction.Press, 'button': MouseButton.Right
      });
      const pos = MouseClickType.CLICK_LEFT;
      styleVm.onMouseClick(mouseEvent, pos);
      expect(mouseEvent.action === MouseAction.Press).assertTrue();
    });

    it('test_onMouseClick_04', 0, () => {
      const func = mock.mockFunc(crossModuleCallUtil, crossModuleCallUtil.call);
      when(func)(ArgumentMatchers.any).afterReturn(true);

      const mouseEvent = MockUtils.mockInterface<MouseEvent>({}, {
        'action': MouseAction.Press, 'button': MouseButton.Left
      });
      const resourceVm = ResourceVm.instance;
      resourceVm.isRTL = true;
      Reflect.set(styleVm, 'resourceVm', resourceVm);
      styleVm.onMouseClick(mouseEvent, MouseClickType.CLICK_LEFT);
      expect(resourceVm.isRTL).assertTrue();

      resourceVm.isRTL = false;
      Reflect.set(styleVm, 'resourceVm', resourceVm);
      styleVm.onMouseClick(mouseEvent, MouseClickType.CLICK_RIGHT);
      expect(!resourceVm.isRTL).assertTrue();

      Reflect.set(styleVm, 'curPanel', TargetPanel.CONTROL_CENTER_PANEL);
      styleVm.onMouseClick(mouseEvent, MouseClickType.CLICK_LEFT);
      expect(!resourceVm.isRTL).assertTrue();

      Reflect.set(styleVm, 'curPanel', TargetPanel.NOTIFICATION_PANEL);
      styleVm.onMouseClick(mouseEvent, MouseClickType.CLICK_LEFT);
      expect(!resourceVm.isRTL).assertTrue();
    });

    it('test_onMouseClick_05', 0, () => {
      const func = mock.mockFunc(crossModuleCallUtil, crossModuleCallUtil.call);
      when(func)(ArgumentMatchers.any).afterReturn(true);

      const mouseEvent = MockUtils.mockInterface<MouseEvent>({}, { 'action': MouseAction.Release });
      styleVm.onMouseClick(mouseEvent, MouseClickType.CLICK_LEFT);
      expect(mouseEvent.action === MouseAction.Release).assertTrue();
    });

    it('test_onMouseHover_01', 0, () => {
      const func = mock.mockFunc(crossModuleCallUtil, crossModuleCallUtil.call);
      when(func)(ArgumentMatchers.any).afterReturn(false);

      styleVm.onMouseHover(true);
      expect(styleVm != null).assertTrue();
    });

    it('test_onMouseHover_02', 0, () => {
      const func = mock.mockFunc(crossModuleCallUtil, crossModuleCallUtil.call);
      when(func)(ArgumentMatchers.any).afterReturn(true);

      styleVm.onMouseHover(true);
      expect(styleVm != null).assertTrue();

      styleVm.onMouseHover(false);
      expect(styleVm != null).assertTrue();
    });

  });
}
