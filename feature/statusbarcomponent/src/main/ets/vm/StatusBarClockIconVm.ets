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
import { ConfigurationEvent, EventManager, EvtBus, PluginInfo } from '@ohos/frameworkwrapper';
import { StatusBarVmInjector } from '@ohos/systemuicommon/newIndex'
import { ClockStatusView } from '../view/ClockStatusView';
import { StatusBarIconBaseVm } from './StatusBarIconBaseVm';
import { ArkUIAdapter, ViewName } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { ResUtils } from '@ohos/windowscene';
import { ClockWidth } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';

const TAG = 'StatusBarClockIconVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class StatusBarClockIconVm extends StatusBarIconBaseVm {
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 时间组件宽度
   */
  @Trace public statusBarClockNormalWidth: number = ClockWidth.NORMAL_WIDTH;
  @Trace public statusBarClockExtrudeWidth: number = ClockWidth.EXTRUDE_WIDTH;
  private statusBarLayoutVm = this.vmInjector.getStatusBarLayoutVm();
  private fontSize: number = ResUtils.getNumber($r('app.float.plugin_phone_clock_font_size'));

  constructor(vmInjector: StatusBarVmInjector, pluginName: string) {
    super(vmInjector, pluginName);
  }

  initIcon(): void {
    this.eventMgr.on(ConfigurationEvent, this.handleConfigurationEvent);
  }

  getBuilder(): WrappedBuilder<[PluginInfo]> {
    return wrapBuilder(clockIconBuilder);
  }

  /**
   * 属性变更回调
   */
  private handleConfigurationEvent = (event?: ConfigurationEvent) => {
    // 计算当前字体下时间组件的最大宽度
    let maxTextWidthPx: number = 0;
    for (let index = 0; index < 10; index++) {
      const text = `${index}${index}:${index}${index}`;
      const textWidthPx: number = ArkUIAdapter.measureText(ViewName.STATUS_BAR_VIEW, {
        textContent: text,
        fontSize: this.fontSize + 'vp',
        fontWeight: FontWeight.Medium,
        fontFamily: 'HarmonyHeiTi'
      });
      log.showInfo(`The WidthPx of ${text} is ${textWidthPx}`);
      maxTextWidthPx = Math.max(maxTextWidthPx, textWidthPx);
    }
    if (maxTextWidthPx === 0) {
      log.showError('maxTextWidthPx is 0');
      return;
    }
    maxTextWidthPx = Math.max(maxTextWidthPx, ArkUIAdapter.vp2px(ClockWidth.NORMAL_WIDTH));
    const maxTextWidthVp = Math.ceil(ArkUIAdapter.px2vp(maxTextWidthPx));
    log.showWarn(`onSizeChange oldWidth: ${this.statusBarClockNormalWidth}, newWidth: ${maxTextWidthVp}`);
    this.updateWidth(maxTextWidthVp);
  }

  /**
   * 更新时间组件宽度
   */
  public updateWidth(newWidth: number): void {
    this.statusBarClockNormalWidth = newWidth;
    this.statusBarClockExtrudeWidth = Math.ceil(newWidth / 2);
    this.statusBarLayoutVm.updateClockWidth(this.statusBarClockNormalWidth, this.statusBarClockExtrudeWidth);
  }
}

@Builder
function clockIconBuilder(pluginInfo: PluginInfo) {
  ClockStatusView({ pluginInfo: pluginInfo })
}
