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
import { WindowPosCalculateBase } from './WindowPosCalculateBase';
import { Constants } from '../../common/Constants';
import { PluginListAdapter } from '../../pluginData/PluginListAdapter';
import { PluginGroupType } from '../../common/PluginConstants';
import { PluginInfo, PluginSlot,
  PluginWindowType,
  viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { windowMgr } from '@ohos/windowscene/src/main/ets/TsIndex';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { window } from '@kit.ArkUI';

export class WinWindowPosCalculate extends WindowPosCalculateBase {
  private slotMapping: Map<string, string> | undefined = new Map([
    [PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL, PluginSlot.SLOT_STATUS_CONTROL_CENTER],
    [PluginSlot.SLOT_STATUS_BATTERY_PANEL, PluginSlot.SLOT_STATUS_CONTROL_CENTER],
    [PluginSlot.SLOT_STATUS_SOUND_PANEL, PluginSlot.SLOT_STATUS_CONTROL_CENTER],
    [PluginSlot.SLOT_STATUS_WIFI_PANEL, PluginSlot.SLOT_STATUS_CONTROL_CENTER],
  ]);

  public getMappingSlot(originSlot: string): string {
    let plugin = PluginListAdapter.getInstance().getPluginPropertyBySlot(originSlot);
    if (plugin?.isFromControlCenter) {
      return PluginSlot.SLOT_STATUS_CONTROL_CENTER;
    }

    // 托盘区里面的图标对齐托盘图标
    if (plugin?.getPluginInGroup() == PluginGroupType.TRAY) {
      return PluginSlot.SLOT_STATUS_TRAY_PANEL;
    }

    return this.slotMapping?.get(originSlot) ?? originSlot;
  }

  protected calPositionLeft(rect: window.Rect, slot: string): [number, number, number] {
    return this.calPositionLeftCommon(rect, slot);
  }

  protected calPositionTop(rect: window.Rect, slot: string): number {
    let windowHeight: number = rect.height;
    return this.getScreenHeight() - vp2px(viewMgrPolicy.getArea(ViewType.SMART_DOCK)?.height ?? 0) -
      windowHeight - vp2px(Constants.DEFAULT_DOCK_GAP);
  }

  protected calPositionWidth(slot: string): number {
    let windowWidth: number = windowMgr.getWindowPosition(slot).width;
    if (slot !== PluginSlot.SLOT_STATUS_TRAY_PANEL) {
      let property = PluginListAdapter.getInstance().getPluginPropertyBySlot(slot);
      if (property) {
        windowWidth = this.getWindowDefaultWidth(property.pluginInfo as PluginInfo);
      }
      if (!property && slot === PluginSlot.SLOT_STATUS_MICROPHONE_PANEL) {
        windowWidth = vp2px(this.localWinWidth.get(slot) ?? PluginWindowType
          .getWindowWidth(PluginWindowType.TYPE_LARGE));
      }
      if (!property && (slot === PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT ||
        slot === PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE)) {
        windowWidth = vp2px(this.localWinWidth.get(slot) ?? PluginWindowType
          .getWindowWidth(PluginWindowType.TYPE_LARGE));
      }
    }
    return windowWidth > 0 ? windowWidth : this.getScreenWidth();
  }

  protected getScale(mappingIconArea: Area, areaLeft: number,
    windowWidth: number, isCutScreen: boolean): [number, number] {
    let scaleX = (vp2px((mappingIconArea?.globalPosition?.x ?? 0) as number) - areaLeft +
      vp2px((mappingIconArea?.width ?? 0) as number) / 2) / windowWidth;
    return [scaleX, 1.0];
  }

  protected cutScreenLeft(mappingIconArea: Area, screenWidth: number, windowWidth: number): number {
    if (RTLUtil.isRTL()) {
      return vp2px(Constants.WINDOW_POSITION_LEFT_GAP);
    }
    return screenWidth - vp2px(Constants.WINDOW_POSITION_LEFT_GAP) - windowWidth;
  }

  protected getPluginWindowRightPadding(): number {
    return vp2px(Constants.WINDOW_POSITION_LEFT_GAP);
  }
}