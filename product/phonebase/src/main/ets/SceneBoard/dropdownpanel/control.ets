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
import { TargetPanel, DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import NewControlCenterComponent
  from '@ohos/controlcentercomponent/src/main/ets/com/ohos/pages/newStyle/ControlCenterComponent';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import SwitchDropdownPanel from './switchdropdownpanel';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import sControlCenterController
  from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterController';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import {
  sIOTSubPageLayoutController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/IOTSubPageLayoutController';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import {
  sMediaCenterController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/MediaCenterController';
import { display } from '@kit.ArkUI';
import {
  CC_LAYOUT_CONFIGS,
  ControlCenterLayoutController,
  ControlCenterLayoutIndex
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterLayoutController';
import { ScreenSessionAdapter } from '@ohos/systemuicommon';

const TAG = 'DropdownPanel-Control';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 从通知中心横滑回到控制中心时，控制中心面板横向偏移初始值增大一段距离
 */
const DROPPANEL_POSITION_PADDING = 7;

class GridConfig {
  public left: GridColColumnOption = {};
  public middle: GridColColumnOption = {};
  public right: GridColColumnOption = {};
}

@Component
export default struct Control {
  /**
   * 控制中心主面板右间距
   */
  private readonly mainPanelRightMargin: number = 36;
  /**
   * 控制中心面板中心横坐标
   */
  private mainPanelCenterX: number = 0;
  /**
   * 列表内容透明度
   */
  @State contentOpacity: number = 1;
  /**
   * 列表内容透明度
   */
  @State contentScale: number = 1;
  @State contentTransX: number = 0;
  @State contentTransY: number = 0;
  @Link contentZIndex: number;
  @Consume microphoneDialogIsOpen: boolean;
  @StorageLink('isNewStyle') isNewStyle: boolean = false;
  @StorageLink('isPortrait') @Watch('onPortraitChanged') isPortrait: boolean = true;
  @StorageLink('foldStatusForOuterScreen')@Watch('onFoldStatusChange') foldStatus: number =
    AppStorage.get<number>('foldStatusForOuterScreen') as number;

  /**
   * 控制中心面板横向偏移量
   */
  @State horizontalDropPanelPosition: number = 380;
  /**
   * 滑动事件Y轴起始点
   */
  startY: number | undefined = undefined;
  isPad: Boolean = DeviceHelper.isPad();

  aboutToAppear() {
    log.showInfo(`aboutToAppear Start`);
    this.onFoldStatusChange();
    ControlCenterLayoutController.getInstance().setLayoutChangeCallback('control', this.controlLayoutChangeCallback);
    if (this.isPad) {
      this.isNewStyle = true;
    }
    let initToggleDataBridger = GlobalContext.getInstance().getObject('initToggleDataBridger');
    if (initToggleDataBridger) {
      (initToggleDataBridger as Function)();
    }
  }

/**
 * 监听控制中心布局变化，更新面板横向偏移量
 * 1、直板机横竖屏，面板横向偏移量=(屏幕宽度+面板宽度)/2
 * 2、折叠屏或者pad，面板横向偏移量=控制中心主页面宽度+主页面面板右边距
 * @param newIndex 新布局id
 * @param screenProp 窗口属性
 */
  private controlLayoutChangeCallback = (newIndex: ControlCenterLayoutIndex, screenProp?: SCBScreenProperty): void => {
    log.showInfo('ccLayoutIndex:' + newIndex);
    if (screenProp === undefined) {
      log.showWarn('screenProp is undefined, return');
      return;
    }
    let extraMargin: number = 0;
    if (newIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE ||
      newIndex === ControlCenterLayoutIndex.NORMAL_PORTRAIT) {
      let displayWidth = px2vp(display.getDefaultDisplaySync().width);
      let mainPanelWidth = CC_LAYOUT_CONFIGS[newIndex].mainPanelWidth as number;
      this.horizontalDropPanelPosition = (displayWidth + mainPanelWidth) / 2;
      this.setScaleCenterX(mainPanelWidth, screenProp.width);
      log.showInfo(`horizontalDropPanelPosition: ${this.horizontalDropPanelPosition}`);
      return;
    } else if (newIndex === ControlCenterLayoutIndex.FOLD_EXPANDED) {
      // 折叠屏的横屏状态下，右边距会额外增加
      if (screenProp.width > screenProp.height) {
        extraMargin = px2vp(screenProp.width - screenProp.height) / 2;
      }
      // 折叠屏展开态，增加横向偏移量
      extraMargin = extraMargin + DROPPANEL_POSITION_PADDING;
    }
    let mainPanelWidth = CC_LAYOUT_CONFIGS[newIndex].mainPanelWidth as number;
    this.horizontalDropPanelPosition = mainPanelWidth + this.mainPanelRightMargin + extraMargin;
    log.showInfo(`horizontalDropPanelPosition: ${this.horizontalDropPanelPosition}`);
    this.setScaleCenterX(mainPanelWidth, screenProp.width);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
    ControlCenterLayoutController.getInstance().setLayoutChangeCallback('control', undefined);
  }

  build() {
    Column() {
      SwitchDropdownPanel({
        contentOpacity: $contentOpacity,
        contentScale: $contentScale,
        contentTransX: $contentTransX,
        contentTransY: $contentTransY,
        contentZIndex: $contentZIndex,
        currentPanel: TargetPanel.CONTROL_CENTER_PANEL,
        horizontalDropPanelPosition: this.horizontalDropPanelPosition,
      })
      if (this.isNewStyle) {
        NewControlCenterComponent()
          .width('100%')
          .height('100%')
          .opacity(this.contentOpacity)
          .scale({ x: this.contentScale, y: this.contentScale, centerX: this.mainPanelCenterX })
          .translate({ x: this.contentTransX })
          .zIndex(this.contentZIndex)
          .layoutWeight(1)
      } else {
      }
    }
    .width('100%')
    .height('100%')
  }

  onSideClick(): void {
    let currentState: ControlCenterState = sControlCenterController.getData()?.state ?? ControlCenterState.MAIN_LAYOUT;
    log.showInfo('on side click, currentState:%{public}d', currentState);
    if (currentState === ControlCenterState.IOT_SUB_PAGE) {
      sIOTSubPageLayoutController.onBackPress();
    } else if (currentState === ControlCenterState.SUB_PANEL) {
      sToggleSubWindowController.onBackPress();
    } else if (currentState === ControlCenterState.MEDIA_CENTER) {
      sMediaCenterController.onBackPress();
    } else {
      DropDownPanelManager.animToDismiss();
    }
  }

  private onPanelSlideUp(event: GestureEvent): void {
    log.showInfo('onPanelSlideUp');
    this.onSideClick();
  }

  private onPortraitChanged() {
    if (DeviceHelper.isPad()) {
      let screenProp: SCBScreenProperty =
        SCBScreenSessionManager.getInstance().getMainScreenSession()?.scbScreenProperty;
      let mainPanelWidth = CC_LAYOUT_CONFIGS[ControlCenterLayoutIndex.PAD].mainPanelWidth as number;
      this.setScaleCenterX(mainPanelWidth, screenProp.width);
    }
  }

  private setScaleCenterX(mainPanelWidth: number, screenPropertyWidth: number): void {
    this.mainPanelCenterX = px2vp(screenPropertyWidth) - (mainPanelWidth / 2) - this.mainPanelRightMargin;
    log.showInfo(`mainPanelCenterX: ${this.mainPanelCenterX}`);
  }

  private onFoldStatusChange(): void {
    log.showInfo(`onFoldStatusChange: ${this.foldStatus}`);
    return;
  }
}
