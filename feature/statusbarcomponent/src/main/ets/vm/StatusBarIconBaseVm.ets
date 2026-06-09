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
import { DeviceHelper, PluginInfo, PluginPosition } from '@ohos/frameworkwrapper';
import { StatusBarBaseVm, IStatusBarIconVm, StatusBarVmInjector, EnvVm } from '@ohos/systemuicommon/newIndex';
import { STATUS_BAR_LAYOUT_DEFAULT_ANCHOR } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusbarConstants';
import { RTLUtil } from '@ohos/componenthelper';

const TAG = 'StatusBarIconBaseVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class StatusBarIconBaseVm extends StatusBarBaseVm implements IStatusBarIconVm {
  /**
   * 图标基本信息
   */
  public pluginInfo: PluginInfo | undefined = undefined;
  public pluginName: string = '';
  public id = '';
  public envVm = EnvVm.instance;
  /**
   * 状态栏类型变化控制图标显隐
   * 下拉状态栏：显示运营商名称，不显示时间，通知，胶囊
   * 锁屏状态栏：运营商名称，时间，通知，胶囊都不显示
   */
  @Trace public position: LocalizedEdges | undefined = undefined;
  @Trace public marginEnd: number = 0;
  @Trace public marginStart: number = 0;
  @Trace public width: number = -1;
  @Trace public baseLayoutOpacity: number = 1;
  @Trace public capsuleLayoutOpacity: number = 1;
  @Trace public iconDelayShowOpacity: number = 0;
  @Trace public scaleX: number = 1;
  @Trace public scaleY: number = 1;
  @Trace public offset: number = 0;
  @Trace public offsetY: number = 0;
  @Trace public separatorOpacity: number = 1;
  @Trace public pixelRound: PixelRoundPolicy | undefined =
    {start: PixelRoundCalcPolicy.NO_FORCE_ROUND, end: PixelRoundCalcPolicy.NO_FORCE_ROUND};

  @Trace public showSize?: SizeOptions;
  /**
   * 图标是否上树
   */
  @Trace public isOnTheTree: boolean = true;

  private isLeftIcon(): boolean {
    let isLeftGroup = false;
    if (this.pluginInfo) {
      isLeftGroup = this.pluginInfo.pluginParseInfo.pluginPosition === PluginPosition.POSITION_LEFT;
    }
    return isLeftGroup;
  }

  get getIconScale(): ScaleOptions {
    if (!this.isLeftIcon()) {
      const isVisible: boolean = this.vmInjector.getStatusBarLayoutVm().layoutIsVisibleIcons.has(this.pluginName);
      const scaleValue = isVisible ? 1 : 0.25;
      return { x: scaleValue, y: scaleValue, centerX: RTLUtil.isRTL() ? '0%' : '100%'}
    }
    return { x: this.scaleX, y: this.scaleY, centerX: RTLUtil.isRTL() ? '100%' : '0%'}
  }

  get getVisible(): Visibility {
    // 可见性依赖
    if (this.vmInjector.getStatusBarLayoutVm().layoutIsVisibleIcons.has(this.pluginName)) {
      return Visibility.Visible;
    }
    if (!this.isLeftIcon() && DeviceHelper.is2In1DevicePadType()) {
      return Visibility.None;
    }
    return Visibility.Hidden;
  }

  /**
   * 获取图标描点，用于定位图标位置
   */
  get getAnchor(): AlignRuleOption {
    const iconListVm = this.vmInjector.getStatusBarIconListVm();
    let anchorInfo = STATUS_BAR_LAYOUT_DEFAULT_ANCHOR;
    let isLeftGroup = this.isLeftIcon();
    if (isLeftGroup) {
      anchorInfo = iconListVm.getLeftIconAnchorInfo(this.pluginName);
    } else {
      anchorInfo = iconListVm.getRightIconAnchorInfo(this.pluginName);
    }
    let findAnchor = anchorInfo != STATUS_BAR_LAYOUT_DEFAULT_ANCHOR;
    if (isLeftGroup) {
      if (!findAnchor) {
        return {
          top: {anchor: anchorInfo, align: VerticalAlign.Top},
          left: {anchor: anchorInfo, align: HorizontalAlign.Start}
        }
      } else {
        return {
          top: {anchor: anchorInfo, align: VerticalAlign.Top},
          left: {anchor: anchorInfo, align: HorizontalAlign.End}
        }
      }
    } else {
      if (!findAnchor) {
        return {
          top: {anchor: anchorInfo, align: VerticalAlign.Top},
          right: {anchor: anchorInfo, align: HorizontalAlign.End}
        }
      } else {
        return {
          top: {anchor: anchorInfo, align: VerticalAlign.Top},
          right: {anchor: anchorInfo, align: HorizontalAlign.Start}
        }
      }
    }
  }

  getIsOnTheTree(): boolean {
    return true;
  }

  constructor(vmInjector: StatusBarVmInjector, pluginName: string) {
    super(vmInjector);
    this.pluginName = pluginName;
    this.id = `StatusBarIconWrapper_${pluginName}`;
  }

  init(pluginInfo: PluginInfo) {
    this.pluginInfo = pluginInfo;
    this.width = this.pluginInfo.pluginParseInfo.pluginIconWidth;
    this.initIcon();
  }

  initIcon() {

  }

  unInit() {
    this.unInitIcon();
  }

  unInitIcon() {

  }

  getBuilder(): WrappedBuilder<[PluginInfo]> {
    throw new Error('Method not implemented.');
  }

  getOpacity(isLeftIcon: boolean): number {
    return isLeftIcon ? 1 : this.vmInjector.getStatusBarLayoutVm().iconTempHideInfo.has(this.pluginName) ? 0 : 1;
  }
}