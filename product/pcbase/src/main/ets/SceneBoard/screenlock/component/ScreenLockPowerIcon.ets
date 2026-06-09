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
import { AbsResourceManager as ResourceManager, DeviceHelper } from '@ohos/frameworkwrapper';
import { InputMethodManager } from '@ohos/launchercommon';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import Constants from '../common/Constants';
import { LengthMetrics } from '@kit.ArkUI';
import { StaticVariables } from '@ohos/statusbarcomponent';

const TAG = 'ScreenLock-PowerIcon';
const COMPONENT_ID_POWER = TAG + '_Image_power';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const HOVER_SCALE: number = 1.10;

@Component
export default struct ScreenLockPowerIcon {
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightOrDark: boolean = true;
  @StorageLink('isEnterpriseAuthing') isEnterpriseAuthing: boolean = false;
  @Link isPowerMenuPanelShowed: boolean;
  @State isHovered: boolean = false;
  @State scaleX: number = 1;
  @State scaleY: number = 1;
  private images: Map<string, Resource> = new Map();
  private resourceMgr: ResourceManager | null = null;

  /**
   * @description: 获取图片资源
   * @returns: 图片资源
   */
  private getImage(): Resource | undefined {
    log.showInfo(`this.isBrightOrDark is ${this.isBrightOrDark}`);
    return !this.isBrightOrDark ? this.images.get(StaticVariables.IC_BRIGHT_MENU_POWER_OFF) :
    this.images.get(StaticVariables.IC_DARK_MENU_POWER_OFF);
  }

  private requestFocus(value: string, reason?: string): void {
    let isSuccess = focusControl.requestFocus(value);
    log.showInfo(`Pwd textbox requestFocus, reson:${reason}, isSuccess = ${isSuccess}`);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    if (this.resourceMgr) {
      this.images = this.resourceMgr?.getPcSystemMenuOffIcon();
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  /**
   * hover态 和 二级菜单显示后的背景色
   * @returns 电源背景色
   */
  private getCurrentBgColor(): ResourceColor {
    if (this.isPowerMenuPanelShowed) {
      return $r('app.color.plugin_icon_color_bg_selected');
    }
    if (this.isHovered) {
      return this.isBrightOrDark ? $r('app.color.plugin_icon_color_bg_hovered') : $r('app.color.screen_lock_hover_dark_bg_color');
    }
    return $r('app.color.plugin_icon_color_bg_none');
  }

  /**
   * hover时图标正常动效
   * @param isHovered
   */
  private onHoveredChange(isHovered: boolean): void {
    this.isHovered = isHovered;
  }

  build() {
    Stack() {
      Image(this.getImage())
        .id(COMPONENT_ID_POWER)
        .draggable(false)
        .height('30vp')
        .width('30vp')
        .focusable(this.isEnterpriseAuthing ? false : !this.isPowerMenuPanelShowed)
        .objectFit(ImageFit.Contain)
        .scale({ x: this.scaleX, y: this.scaleY })
        .animation({ curve: Curve.Linear, duration: 100 })
        .borderRadius('8vp')
        .interpolation(ImageInterpolation.Low)
        .borderRadius('8vp')
        .focusBox({
          margin: LengthMetrics.px(0),
        })
    }
    .height('34vp')
    .width('34vp')
    .key(Constants.KEY_POWER_KEY)
    .hoverEffect(HoverEffect.None)
    .backgroundColor(this.getCurrentBgColor())
    .focusable(!this.isPowerMenuPanelShowed)
    .onHover((isHover: boolean) => {
      this.onHoveredChange(isHover);
    })
    .onClick(() => {
      if (this.isEnterpriseAuthing) {
        log.showInfo('enterprise account is authing');
        return;
      }
      this.isPowerMenuPanelShowed = !this.isPowerMenuPanelShowed;
      log.showInfo(`isPowerMenuPanelShowed power clicked == ${this.isPowerMenuPanelShowed}`);
      if (this.isPowerMenuPanelShowed === false) {
        this.requestFocus(Constants.PC_COMPONENT_SLIDE_SCREEN_LOCK);
      }
      InputMethodManager.getInstance().stopInputSession();
    })
    .focusBox({
      margin: LengthMetrics.px(0),
    })
    .onTouch((event: TouchEvent) => {
      event.stopPropagation();
    })
    .borderRadius($r('sys.float.corner_radius_level4'))
    .margin({
      left: '16vp',
      right: '16vp',
      top: '3vp'
    })
  }
}