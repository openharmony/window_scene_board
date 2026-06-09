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

import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  DropDownEvent,
  EventManager,
  EvtBus,
  StatusBarBackgroundEvent,
  TargetPanel
} from '@ohos/frameworkwrapper';
import Window from '@ohos.window';
import statusBarBackgroundVM from '../viewmodel/StatusBarBackgroundVM';
import { BackgroundLinearGradient } from '../viewmodel/BackgroundLinearGradient';
import { BackgroundAnimConstants, backgroundAnimManager } from '../viewmodel/BackgroundAnimManager';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { StatusBarHeightVm } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarHeightVm';

const TAG = 'StatusBarBackground';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const OPACITY: string = '00';

/**
 * 状态栏背景
 */
@Component
export struct StatusBarBackground {
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 下拉事件进度
   */
  progress: number = 0;

  @State backgroundLinearGradient: BackgroundLinearGradient = statusBarBackgroundVM.getBackgroundLinearGradient();

  /**
   * 沉浸式背景颜色集
   */
  @State tintBgColors: Array<string> = [];
  /**
   * 沉浸式背景区域集
   */
  @State tintBgRegions: Array<Window.Rect> = [];

  @State bgOpacity: number = 1;

  /**
   * 下拉事件
   */
  @StorageLink('dropDownEvent')
  @Watch('onDropdownChanged')
  dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();

  /**
   * 是否为折叠屏折叠态
   */
  @Consume isFolded: boolean;

  @State statusBarHeightVm: StatusBarHeightVm = StatusBarHeightVm.getInstance();

  /**
   * 是否需要刷新背景颜色
   */
  private needRefreshBgColorOpacity: boolean = false;

  /**
   * 下拉事件参数改变回调
   */
  private onDropdownChanged() {
    if (!this.needRefreshBgColorOpacity) {
      return;
    }

    if (this.dropDownEvent.target === TargetPanel.NONE) {
        return;
    }

    if (this.dropDownEvent.progress === this.progress) {
      return;
    }

    this.bgOpacity = BackgroundAnimConstants.BACKGROUND_TRANSITION_CURVE.interpolate(1 - this.dropDownEvent.progress);

    log.showDebug(`onDropdownChanged, this.bgOpacity: ${this.bgOpacity} progress: ${this.dropDownEvent.progress}`);
    this.progress = this.dropDownEvent.progress;

  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear StatusBarBackground');
    this.eventMgr.on(StatusBarBackgroundEvent, this.onStatusBarBackgroundEvent);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear StatusBarBackground');
    this.eventMgr.offAll();
  }


  build() {
    if (!ArrayUtils.isEmpty(this.tintBgColors)) {
      Row()
        .opacity(this.bgOpacity)
        .width(this.getTintBgWidth(this.tintBgRegions[0]))
        .height(this.statusBarHeightVm.getAvoidHeight())
        .backgroundColor(this.tintBgColors[0])
        .id(`${TAG}_Row_0`)
        .transition(backgroundAnimManager.getTransitionEffect())
    }
  }

  /**
   * 状态栏沉浸式背景颜色变更事件
   *
   * @param event 事件
   */
  private onStatusBarBackgroundEvent = (event: StatusBarBackgroundEvent): void => {
    log.showDebug('onStatusBarBackgroundEvent');
    this.tintBgColors = event.bgColors;
    this.tintBgRegions = event.regions;
    if (ArrayUtils.isEmpty(this.tintBgColors) || !this.tintBgColors[0].startsWith('#')) {
      // 无效颜色不刷新透透明度
      this.needRefreshBgColorOpacity = false;
    } else {
      // 非透明色需要刷新背景颜色
      this.needRefreshBgColorOpacity = this.tintBgColors[0].slice(1, 3).toUpperCase() !== OPACITY;
    }
    // 不更新透明度的时候，重置透明度的值
    if (!this.needRefreshBgColorOpacity) {
      this.bgOpacity = 1;
    }

    statusBarBackgroundVM.onBackgroundColorChange(this.tintBgColors);
  }

  /**
   * 获取某一tint的区域范围
   *
   * @param region 沉浸式背景区域
   */
  private getTintBgWidth(region: Window.Rect): string {
    // 没有区域范围时，直接屏幕宽度
    if (CommonUtils.isInvalid(region)) {
      return '100%';
    }
    // 直接取区域宽度
    return region.width + 'px';
  }
}