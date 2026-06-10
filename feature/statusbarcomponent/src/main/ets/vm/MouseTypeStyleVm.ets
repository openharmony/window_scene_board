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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DropDownPanelManager,
  DropdownVm,
  EnvVm,
  ExtraPadding,
  IMouseTypeStyleVm,
  MouseClickType,
  MouseHoverType,
  StatusBarBaseVm,
  ResourceVm,
  AccessibilityVm} from '@ohos/systemuicommon/newIndex';
import { EvtBus, PluginSlot, TargetPanel } from '@ohos/frameworkwrapper';
import { ColorUtil } from '@ohos/systemuicommon/src/main/ets/utils/ColorUtil';
import { statusBarMaskManager, crossModuleCallUtil, MouseClickDropDownEvent } from '@ohos/systemuicommon';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'MouseTypeStyleVm');

@ObservedV2
export class MouseTypeStyleVm extends StatusBarBaseVm implements IMouseTypeStyleVm {
  @Trace public leftBackgroundColor?: Resource = undefined;
  @Trace public rightBackgroundColor?: Resource = undefined;
  @Trace public leftGroupWidth: number = 0;
  public leftShowStyleIcons: Set<string> = new Set([PluginSlot.SLOT_STATUS_CLOCK]);
  private envVm = EnvVm.instance;
  private isDarkMode: boolean = true;
  private curMouseClickPos: MouseClickType = MouseClickType.NONE;
  private curMouseHoverPos: MouseHoverType = MouseHoverType.NONE;
  private isMouseClickEnable: boolean = false;
  private dropdownVm = DropdownVm.instance;
  private clockVm = this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK);
  private resourceVm = ResourceVm.instance;
  private hoverLightBgColor = $r('app.color.hover_light_bg_color');
  private hoverDarkBgColor = $r('app.color.hover_dark_bg_color');
  private clickLightBgColor = $r('app.color.click_light_bg_color');
  private clickDarkBgColor = $r('app.color.click_dark_bg_color');
  private acc = AccessibilityVm.instance;
  private isMouseClick: boolean = true;

  @Monitor('envVm.statusBarColor')
  onStatusBarColorChange(): void {
    this.checkStatusBarDarkMode();
  }

  @Monitor('clockVm.isVisible')
  onClockVisibleChange() {
    this.refreshLeftGroupWidth();
  }

  refreshLeftGroupWidth(): void {
    if (this.clockVm.getVisible === Visibility.Visible && this.isMouseOnLeftGroup() && !this.dropdownVm.isDropDown) {
      this.leftGroupWidth = this.clockVm.width + 2 * ExtraPadding.LEFT;
      return;
    }
    this.leftGroupWidth = 0;
  }

  public refreshBgColor(): void {
    if (this.curMouseClickPos === MouseClickType.NONE && this.curMouseHoverPos === MouseHoverType.NONE) {
      this.leftBackgroundColor = undefined;
      this.rightBackgroundColor = undefined;
      return;
    }
    if (this.curMouseClickPos === MouseClickType.CLICK_LEFT) {
      this.leftBackgroundColor = this.isDarkMode ? this.clickDarkBgColor : this.clickLightBgColor;
      this.rightBackgroundColor = undefined;
      return;
    }
    if (this.curMouseClickPos === MouseClickType.CLICK_RIGHT) {
      this.rightBackgroundColor = this.isDarkMode ? this.clickDarkBgColor : this.clickLightBgColor;
      this.leftBackgroundColor = undefined;
      return;
    }
    if (this.curMouseHoverPos === MouseHoverType.HOVER_LEFT) {
      this.leftBackgroundColor = this.isDarkMode ? this.hoverDarkBgColor : this.hoverLightBgColor;
      this.rightBackgroundColor = undefined;
      return;
    }
    if (this.curMouseHoverPos === MouseHoverType.HOVER_RIGHT) {
      this.rightBackgroundColor = this.isDarkMode ? this.hoverDarkBgColor : this.hoverLightBgColor;
      this.leftBackgroundColor = undefined;
    }
  }

  onMouseClick(event?: MouseEvent, pos: MouseClickType = MouseClickType.NONE): void {
    if (!event) {
      return;
    }
    log.showInfo(`onMouseClick: ${event.action}-${pos}`);
    if (!this.checkStatusBarMouseEnable()) {
      this.curMouseClickPos = MouseClickType.NONE;
      return;
    }
    // 仅鼠标左键有反应
    switch (event.button) {
      case MouseButton.Left:
        this.isMouseClickEnable = true;
        break;
      default:
        this.isMouseClickEnable = false;
        break;
    }

    switch (event.action) {
      case MouseAction.Press:
        if (!this.isMouseClickEnable) {
          return;
        }
        this.curMouseClickPos = pos;
        this.refreshBgColor();
        this.refreshLeftGroupWidth();
        this.isMouseClick = true;
        break;
      case MouseAction.Release:
        if (this.isMouseClick) {
          this.doDropDown(pos);
        }
      case MouseAction.Move:
        this.isMouseClick = false;
      default:
        this.curMouseClickPos = MouseClickType.NONE;
        this.refreshBgColor();
        this.refreshLeftGroupWidth();
        break;
    }
  }

  public onMouseHover(isHover?: boolean, pos: MouseHoverType = MouseHoverType.NONE): void {
    log.showInfo(`onMouseHover: ${isHover}-${pos}`);
    if (!this.checkStatusBarMouseEnable()) {
      this.curMouseHoverPos = MouseHoverType.NONE;
      return;
    }
    if (isHover) {
      this.curMouseHoverPos = pos;
    } else {
      this.curMouseHoverPos = MouseHoverType.NONE;
    }
    this.refreshBgColor();
    this.refreshLeftGroupWidth();
  }

  private checkStatusBarDarkMode(): void {
    const colorStr = this.envVm.statusBarColor;
    if (ColorUtil.isRGBColor(colorStr)) {
      this.isDarkMode = !ColorUtil.checkUseLightColorRGB(colorStr);
    } else {
      this.isDarkMode = !ColorUtil.checkUseLightColor(colorStr);
    }
    log.showInfo(`checkStatusBarDarkMode: ${this.isDarkMode}`);
    this.refreshBgColor();
  }

  private isMouseOnLeftGroup(): boolean {
    return this.curMouseHoverPos === MouseHoverType.HOVER_LEFT || this.curMouseClickPos === MouseClickType.CLICK_LEFT;
  }

  private isMouseOnRightGroup(): boolean {
    return this.curMouseHoverPos === MouseHoverType.HOVER_RIGHT || this.curMouseClickPos === MouseClickType.CLICK_RIGHT;
  }

  private checkStatusBarMouseEnable(): boolean {
    const enable =
      crossModuleCallUtil?.call('onMouseStyleEvent', this.isMouseOnLeftGroup(), this.isMouseOnRightGroup());
    log.showInfo(`checkStatusBarMouseEnable: ${enable}- accessibility: ${this.acc.isEnabled}`);
    return enable && !this.acc.isEnabled;
  }

  private doDropDown(pos: MouseClickType = MouseClickType.NONE): void {
    let target = TargetPanel.NONE;
    if (this.resourceVm.isRTL) {
      target = pos === MouseClickType.CLICK_LEFT ?
      TargetPanel.CONTROL_CENTER_PANEL : TargetPanel.NOTIFICATION_PANEL;
    } else {
      target = pos === MouseClickType.CLICK_LEFT ?
      TargetPanel.NOTIFICATION_PANEL : TargetPanel.CONTROL_CENTER_PANEL;
    }
    if (!DropDownPanelManager.checkKioskPanelEnable(target)) {
      return;
    }
    if (this.dropdownVm.dropdownEvent.target === TargetPanel.NONE) {
      this.mouseClickDropdownDisableTouchCheckEvent();
      DropDownPanelManager.mouseDropDownFromDesktop(target);
      statusBarMaskManager.setStatusBarMaskState(false);
    } else if (target !== this.dropdownVm.dropdownEvent.target) {
      DropDownPanelManager.mouseSwitchDropDown(target);
    } else if (this.isMouseOnRightGroup()) {
      // 在双中心只有点击右组可以收起面板，时间防抖
      DropDownPanelManager.animToDismiss();
    }
  }

  private mouseClickDropdownDisableTouchCheckEvent(): void {
    const event = new MouseClickDropDownEvent();
    EvtBus.post(MouseClickDropDownEvent, event);
  }
}