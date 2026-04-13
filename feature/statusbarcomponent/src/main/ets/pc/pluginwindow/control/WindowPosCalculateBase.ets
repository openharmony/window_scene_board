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
import { window } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { PluginInfo, PluginSlot, PluginWindowType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { windowMgr } from '@ohos/windowscene/src/main/ets/TsIndex';
import { Constants } from '../../common/Constants';

const DEFAULT_BORDER_WIDTH = 2;

const TAG = 'WindowPosCalculateBase';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export abstract class WindowPosCalculateBase {
  protected screenWidth: number = 0;

  protected screenHeight: number = 0;

  /**
   * 本地固定窗口宽度
   */
  protected localWinWidth: Map<string, number> = new Map([
    [PluginSlot.SLOT_STATUS_BATTERY_PANEL, 362],
    [PluginSlot.SLOT_STATUS_SOUND_PANEL, 360],
    [PluginSlot.SLOT_STATUS_INPUT_PANEL, 362],
    [PluginSlot.SLOT_STATUS_INPUT_METHOD, 362],
    [PluginSlot.SLOT_STATUS_MICROPHONE_PANEL, 360],
    [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE, 360],
    [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT, 360],
    [PluginSlot.SLOT_STATUS_PERSONAL, 182],
  ]);

  public calPluginWindowPos(slot: string, screenWidth: number, screenHeight: number,
    isNoNeedCalWidth?: boolean): [window.Rect, number, number] {
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;

    if (slot === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL && this.alreadyExpanded(slot)) {
      this.rollbackExpandAssemblyPanel(slot);
    }

    let rect: window.Rect = {
      left: 0,
      top: 0,
      width: 0,
      height: 0
    };
    rect.width = isNoNeedCalWidth ? windowMgr.getWindowPosition(slot).width : this.calPositionWidth(slot);
    rect.height = windowMgr.getWindowPosition(slot).height;
    let leftPos = this.calPositionLeft(rect, slot);
    rect.left = leftPos[0];
    rect.top = this.calPositionTop(rect, slot);

    this.expandAssemblyPanel(slot, rect);
    return [rect, leftPos[1], leftPos[2]];
  }

  protected abstract calPositionLeft(rect: window.Rect, slot: string): [number, number, number];

  protected abstract calPositionTop(rect: window.Rect, slot: string): number;

  protected abstract calPositionWidth(slot: string): number;

  protected getScreenHeight(): number {
    return this.screenHeight;
  }
  protected getScreenWidth(): number {
    return this.screenWidth;
  }

  protected calPositionLeftCommon(rect: window.Rect, slot: string): [number, number, number] {
    let mappingSlot = this.getMappingSlot(slot);
    let mappingIconArea = windowMgr.getStatusIconCache(mappingSlot) as Area;
    let screenWidth: number = this.getScreenWidth();
    let windowWidth: number = rect.width;
    if (RTLUtil.isRTL()) {
      return this.calRTLAreaLeft(mappingIconArea, screenWidth, windowWidth);
    }
    // 动态计算位置，优先图标位置左对齐，位置不够则右对齐
    let rightPadding = this.getPluginWindowRightPadding();
    let areaLeft = rightPadding;
    // vp
    let pluginLeft = vp2px((mappingIconArea?.globalPosition?.x ?? 0) as number);
    let isCutScreen = pluginLeft + windowWidth > (screenWidth - rightPadding);
    let fixedLeft = this.cutScreenLeft(mappingIconArea, screenWidth, windowWidth);
    // 窗口超出屏幕，则固定位置，否则跟随图标位置左对齐
    if (isCutScreen) {
      areaLeft = fixedLeft;
    } else {
      areaLeft = pluginLeft;
    }
    log.showInfo('calPositionLeftCommon, slot:' + slot + ' fixedLeft:' + fixedLeft +
      ' pluginLeft:' + pluginLeft + 'mappingSlot:' + mappingSlot + '');
    let scale = this.getScale(mappingIconArea, areaLeft, windowWidth, isCutScreen);
    return [areaLeft, scale[0], scale[1]];
  }

  private calRTLAreaLeft(mappingIconArea: Area, screenWidth: number, windowWidth: number): [number, number, number] {
    let areaLeft = vp2px(Constants.WINDOW_POSITION_LEFT_GAP);
    // vp
    let pluginLeft = vp2px((mappingIconArea?.globalPosition?.x ?? 0) as number) +
      vp2px((mappingIconArea?.width ?? 0) as number) - windowWidth;
    let isCutScreen = pluginLeft < vp2px(Constants.WINDOW_POSITION_LEFT_GAP);
    let fixedLeft = this.cutScreenLeft(mappingIconArea, screenWidth, windowWidth);
    // 窗口超出屏幕，则固定位置，否则跟随图标位置左对齐
    if (isCutScreen) {
      areaLeft = fixedLeft;
    } else {
      areaLeft = pluginLeft;
    }
    let scale = this.getScale(mappingIconArea, areaLeft, windowWidth, isCutScreen);
    return [areaLeft, scale[0], scale[1]];
  }

  protected abstract getScale(mappingIconArea: Area, areaLeft: number,
    windowWidth: number, isCutScreen: boolean): [number, number];

  /**
   * 获取本地固定窗口宽度
   *
   * @param cutout 孔区域
   */
  protected getWindowDefaultWidth(info: PluginInfo): number {
    // 本地图标不考虑多实例
    let localSlotWidth = this.localWinWidth.get(info?.getSlot())
    if (localSlotWidth) {
      return vp2px(localSlotWidth);
    } else {
      return PluginWindowType.getWindowWidth(info?.pluginParseInfo?.clickInfo?.windowType) +
        vp2px(DEFAULT_BORDER_WIDTH);
    }
  }

  private alreadyExpanded(slot: string): boolean {
    let area = windowMgr.getWindowPosition(slot);
    return area.width - PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE) > 10
  }

  /**
   * 通知中心日历组合窗口向外延伸，保证内部通知中心和日历组件的阴影不被裁剪
   * @param area
   */
  private expandAssemblyPanel(slot: string, area: window.Rect): void {
    if (slot !== PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL || this.alreadyExpanded(slot)) {
      return;
    }
    area.left -= vp2px(Constants.NTF_SHADOW_MARGIN);
    area.top -= vp2px(Constants.NTF_SHADOW_MARGIN);
    area.height += vp2px(Constants.NTF_SHADOW_MARGIN) * 2;
    area.width += vp2px(Constants.NTF_SHADOW_MARGIN) * 2;
  }

  private rollbackExpandAssemblyPanel(slot: string): void {
    if (slot !== PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) {
      return;
    }
    let area = windowMgr.getWindowPosition(slot);
    area.left += vp2px(Constants.NTF_SHADOW_MARGIN);
    area.top += vp2px(Constants.NTF_SHADOW_MARGIN);
    area.height -= vp2px(Constants.NTF_SHADOW_MARGIN) * 2;
    area.width -= vp2px(Constants.NTF_SHADOW_MARGIN) * 2;
    windowMgr.updateWindowPosition(slot, area);
  }


  protected abstract cutScreenLeft(mappingIconArea: Area, screenWidth: number, windowWidth: number): number;

  public abstract getMappingSlot(originSlot: string): string;

  protected abstract getPluginWindowRightPadding(): number;
}