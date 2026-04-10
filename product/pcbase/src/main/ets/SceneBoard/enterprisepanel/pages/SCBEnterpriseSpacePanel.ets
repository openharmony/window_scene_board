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

import { LengthMetrics } from '@ohos.arkui.node';
import { LogHelper, LogDomain, } from '@ohos/basicutils';
import {
  PluginSlot,
  PluginWindowType,
  EvtBus,
  EventManager,
  ViewArea,
  ViewType,
  viewMgrPolicy,
  ViewCallback,
  WindowPositionChangeEvent,
  PluginPosition
} from '@ohos/frameworkwrapper';
import CommonEventManager from '@ohos.commonEventManager';
import { BaseViewController } from '@ohos/frameworkcommon';
import { StartAbilityUtil, windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import {
  StatusBarPanelInfo,
  StatusBarPanelManager
} from '../../../common/manager/StatusBarPanelManager';
import Constants from '../common/Constants';
import { EnterpriseSpacePanelVM } from '../viewModel/EnterpriseSpacePanelViewModel';
import { EnterpriseSpacePanel } from './EnterpriseSpacePanel';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { BusinessError } from '@ohos.base';

const TAG = 'SCBEnterpriseSpacePanel-Index';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const WINDOW_NAME = PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE;
const DEFAULT_HOVER_COLOR = $r('sys.color.ohos_id_color_hover');
const DEFAULT_PRESS_COLOR = $r('sys.color.ohos_id_color_click_effect');
const DEFAULT_FOCUSED_COLOR = $r('sys.color.ohos_id_color_focused_outline');
const DEFAULT_DARK_HOVER_COLOR = $r('sys.color.ohos_id_color_hover_dark');
const DEFAULT_DARK_PRESS_COLOR = $r('sys.color.ohos_id_color_click_effect_dark');
const DEFAULT_DARK_FOCUSED_COLOR = $r('sys.color.ohos_id_color_focused_outline_dark');

@Component
export struct SCBEnterpriseSpacePanel {
  private eventMgr: EventManager = EvtBus.createEventManager();
  private viewCallback: ViewCallback = {
    onShow: () => this.onViewShow(),
    onHide: () => this.onViewHide()
  };
  private subscriber: CommonEventManager.CommonEventSubscriber | null = null;
  @Provide persistentId: number = 0;
  @State viewController: PcStbSecondaryPanelController =
    new PcStbSecondaryPanelController(ViewType.ENTERPRISE_SPACE_PANEL);
  @State panelInfo: StatusBarPanelInfo | undefined = undefined;
  @State enterpriseSpacePanelVM: EnterpriseSpacePanelVM = new EnterpriseSpacePanelVM();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State isSelected: boolean = false;
  @State isHovered: boolean = false;

  aboutToAppear() {
    log.showInfo('aboutToAppear, start');
    viewMgrPolicy.registerViewController(ViewType.ENTERPRISE_SPACE_PANEL, this.viewController);
    this.viewController.registerCallback(this.viewCallback);
    this.viewController.updateId(this.persistentId);
    this.viewController.registerFocusCallback();
    let rect: ViewArea = {
      left: 0,
      top: 0,
      width: PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE),
      height: Constants.WINDOW_HEIGHT,
    };
    this.viewController.updateArea(rect);
    this.viewController.updateRect(rect);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId);
    this.subscribeUserSwitched();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
    viewMgrPolicy.unregisterViewController(ViewType.ENTERPRISE_SPACE_PANEL);
    this.viewController.unRegisterFocusCallback();
    this.viewController.unRegisterCallback(this.viewCallback);
    this.unsubscribeUserSwitched();
  }

  private onViewShow(): void {
    log.showInfo('[onViewShow]:window show!');
    this.enterpriseSpacePanelVM.updateUserList()
      .then(() => {
        this.updatePanelWindow();
      });
  }

  private onViewHide(): void {
    log.showInfo('[onViewHide]:window hide!');
    this.enterpriseSpacePanelVM.clear();
  }

  updatePanelWindow() {
    let defaultRect = windowMgr.getWindowPosition(WINDOW_NAME);
    let updateRect: ViewArea = {
      top: defaultRect.top,
      left: defaultRect.left,
      width: PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE),
      height: vp2px(this.enterpriseSpacePanelVM.getHeight()),
    };
    log.showInfo(`[updatePanelWindow]: updateRect: ${updateRect.top} ${updateRect.left}`);
    // 监听事件再变化尺寸，避免起始尺寸不正确
    EvtBus.post(WindowPositionChangeEvent, {
      windowName: PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE,
      position: PluginPosition.POSITION_RIGHT,
      area: updateRect,
    });
  }

  /**
   * 订阅用户更新事件
   */
  private async subscribeUserSwitched(): Promise<void> {
    const subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
      events: [
        CommonEventManager.Support.COMMON_EVENT_USER_ADDED,
        CommonEventManager.Support.COMMON_EVENT_USER_REMOVED,
      ]
    };
    try {
      log.showInfo(TAG, `subscribeUserSwitched`);
      this.subscriber = await CommonEventManager.createSubscriber(subscribeInfo);
      CommonEventManager.subscribe(this.subscriber, (err, data: CommonEventManager.CommonEventData) => {
        log.showInfo(TAG, `UserSwitched`);
        this.enterpriseSpacePanelVM.handleStatusBarState();
      });
    } catch (error) {
      log.showError(TAG, `subscribeUserSwitched error: ${error?.message}`);
    }
  }

  /**
   * 取消订阅
   */
  private async unsubscribeUserSwitched(): Promise<void> {
    try {
      await CommonEventManager.unsubscribe(this.subscriber);
      this.subscriber = null;
    } catch (err) {
      log.showWarn(TAG, `err,mes=${(err as BusinessError)?.message}`);
    }
  }

  private getBackgroundColor() {
    if (this.isSelected) {
      return this.panelInfo?.isDark ?
        DEFAULT_DARK_PRESS_COLOR : DEFAULT_PRESS_COLOR;
    }
    if (this.isHovered) {
      return this.panelInfo?.isDark ?
        DEFAULT_DARK_HOVER_COLOR : DEFAULT_HOVER_COLOR;
    }
    return $r('app.color.transparent');
  }

  private onTouchEvent(event?: TouchEvent) {
    log.showInfo(`[onTouchEvent] event: ${JSON.stringify(event)}`);
    if (event?.type == TouchType.Down) {
      this.isSelected = true;
    } else if (event?.type == TouchType.Up) {
      this.isSelected = false;
    }
  }
  @Builder
  MyDivider(marginLeft: LengthMetrics = LengthMetrics.vp(24)) {
    Divider()
      .strokeWidth('1px')
      .margin({
        start: marginLeft,
        end: LengthMetrics.vp(24),
        top: LengthMetrics.vp(4),
        bottom: LengthMetrics.vp(4),
      })
  }

  @Builder
  SpaceManagerSettingEntryBuilder() {
    Row() {
      Text($r('app.string.enterprise_space_manager'))
        .fontSize($r('sys.float.Body_L'))
        .width(312)
        .constraintSize({ minHeight: 24 })
        .margin({ start: LengthMetrics.vp(20), end: LengthMetrics.vp(20) })
        .fontColor(this.colorModeViewData.wifiOffTextColor) // 适配提亮压暗
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .fontWeight(FontWeight.Medium)
    }
    .backgroundColor(this.getBackgroundColor())
    .borderRadius(12)
    .height(40)
    .alignItems(VerticalAlign.Center)
    .margin({ start: LengthMetrics.vp(4), end: LengthMetrics.vp(4) })
    .stateStyles({
      normal: this.normalStyles,
      focused: this.focusedStyles
    })
    .onTouch((event) => this.onTouchEvent(event))
    .onHover((isHover) => {
      this.isHovered = isHover || false;
    })
    .onClick((event) => this.onClickEvent(event))
  }

  private hideWindow(): void {
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      return;
    }
    log.showInfo('hide anim start');
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
  }

  private onClickEvent(event?: ClickEvent): void {
    log.showInfo(`[onClickEvent] event: ${JSON.stringify(event)}`);
    this.hideWindow();
    StartAbilityUtil.startAbilityFromOther({
      bundleName: 'com.ohos.settings',
      abilityName: 'com.ohos.settings.MainAbility',
      moduleName: 'pc_settings',
      uri: 'space_manager'
    });
  }

  @Styles
  normalStyles() {
    .border({
      width: '2vp',
      color: '#00000000'
    })
  }

  @Styles
  focusedStyles() {
    .border({
      width: '2vp',
      color: this.panelInfo?.isDark ?
        DEFAULT_DARK_FOCUSED_COLOR : DEFAULT_FOCUSED_COLOR
    })
  }

  build() {
    Column() {
      EnterpriseSpacePanel({ vm: this.enterpriseSpacePanelVM })
      this.MyDivider()
      this.SpaceManagerSettingEntryBuilder()
    }
    .width(this.viewController.getArea().width)
    .height(this.viewController.getArea().height)
    .borderRadius(this.panelInfo?.panelRadius)
    .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
  }
}