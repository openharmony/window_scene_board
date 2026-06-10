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
import { CutoutVm,
  DeviceInfoVm,
  EnvVm,
  IStatusBarIconVm, ResourceVm, StatusBarVmInjector } from '@ohos/systemuicommon/newIndex';
import lazy { MouseClickType, MouseHoverType, IMouseTypeStyleVm } from '@ohos/systemuicommon/newIndex';
import { LengthMetrics } from '@kit.ArkUI';
import { PluginSlot } from '@ohos/frameworkwrapper';
import { IconFilterType } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';

// instrument ignore file

const TAG = 'StatusBarIconWrapper'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct StatusBarIconWrapper {
  @BuilderParam content: () => void;
  @Param @Require iconVm: IStatusBarIconVm;
  @Consumer() statusBarVmInjector: StatusBarVmInjector = StatusBarVmInjector.HOLDER;
  @Param isEnableMouseTypeStyle: boolean = false;
  @Param isLeftIcon: boolean = false;
  iconListVm = this.statusBarVmInjector.getStatusBarIconListVm();
  layoutVm = this.statusBarVmInjector.getStatusBarLayoutVm();
  mouseTypeStyleVm?: IMouseTypeStyleVm;
  aboutToAppear(): void {
    log.showInfo(`aboutToAppear ${this.iconVm.pluginName}`);
    if (this.isEnableMouseTypeStyle) {
      this.mouseTypeStyleVm = this.statusBarVmInjector.getMouseTypeStyleVm();
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear ${this.iconVm.pluginName}`);
    if (this.isEnableMouseTypeStyle) {
      this.mouseTypeStyleVm = undefined;
    }
  }

  build() {
    if (this.iconVm.isOnTheTree) {
      Stack({ alignContent: Alignment.Start }) {
        this.content()
      }
      .id(this.iconVm.id)
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
        this.iconListVm.onIconVisibleSizeChange(oldValue, newValue, this.iconVm.pluginName);
      })
      .onDisAppear(() => {
        log.showInfo(`onDisAppear, slot: ${this.iconVm.pluginName}`)
        // 旋转场景会有胶囊显隐事件，胶囊显隐不影响基础布局
        if (this.iconVm.pluginName === PluginSlot.LIVE_VIEW_CAPSULE) {
          return;
        }
        this.layoutVm.recalculateLayout(true);
      })
      .visibility(this.iconVm.getVisible)
      .size(this.iconVm.showSize)
      .margin({
        end: new LengthMetrics(
          this.layoutVm.avoidIconName === this.iconVm.pluginName ? this.layoutVm.avoidIconMargin : 0),
        start: new LengthMetrics(this.iconVm.marginStart)
      })
      .padding( this.isLeftIcon ? { end: LengthMetrics.vp(0) } : { start: LengthMetrics.vp(this.layoutVm.iconGap)})
      .opacity(this.iconVm.getOpacity(this.isLeftIcon))
      .pixelRound(this.iconVm.pixelRound)
      .scale(this.iconVm.getIconScale)
      .offset({
        x: ResourceVm.instance.isRTL ? -this.iconVm.offset : this.iconVm.offset,
        y: this.iconVm.offsetY
      })
      .onMouse((event: MouseEvent) => {
        if (!this.isEnableMouseTypeStyle) {
          return;
        }
        if (!this.mouseTypeStyleVm?.leftShowStyleIcons.has(this.iconVm.pluginName)) {
          return;
        }
        this.mouseTypeStyleVm?.onMouseClick(event, MouseClickType.CLICK_LEFT);
      })
      .onHover((isHover?: boolean) => {
        if (!this.isEnableMouseTypeStyle) {
          return;
        }
        if (!this.mouseTypeStyleVm?.leftShowStyleIcons.has(this.iconVm.pluginName)) {
          return;
        }
        this.mouseTypeStyleVm?.onMouseHover(isHover, MouseHoverType.HOVER_LEFT);
      })
      .alignRules(this.iconVm.getAnchor)
    }
  }
}