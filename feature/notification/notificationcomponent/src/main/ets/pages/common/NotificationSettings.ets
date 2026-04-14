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

import {
  LogDomain,
  LogHelper,
  CommonUtils,
  ArrayUtils
} from '@ohos/basicutils';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import {
  EvtBus,
  EventManager,
  ResourceManager,
  PluginSlot,
  WindowEvent,
  RequestWindowEvent,
  HiDfxEventUtil,
  ViewArea
} from '@ohos/frameworkwrapper';
import { NtfRightClickEvent } from '../../common/event/NotificationEvent';
import { NotificationRightMenu, RightMenuName } from './NotificationRightMenu';
import { NotificationEntry } from '../../model/NotificationEntry';
import { NotificationConstants } from '../../common/NotificationConstants';

const TAG = NotificationConstants.NTF_LOG_PREFIX + 'NotificationSettings';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 右键menu弹框
 */
const WINDOW_NAME = WindowConstants.WINDOW_NAME_PC_NTY_SETTING;

/**
 * 通知面板窗口名
 */
const NTF_PANEL_WINDOW_NAME = PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL;

/**
 * 弹框宽度
 */
const MENU_WIDTH = 156;

/**
 * 弹框高度
 */
const MENU_HEIGHT = 104;

/**
 * 弹框模糊度
 */
const MENU_BLUR = 20;

/**
 * 弹框饱和度
 */
const MENU_SATURATE = 0.9;

/**
 * 弹框阴影模糊半径
 */
const MENU_SHADOW_RADIUS = 60;

@Component
export struct NotificationSettings {
  /**
   * 弹框通知数据
   */
  @State ntfEntry: NotificationEntry | null = null;
  @State ntfSettingsX: number = 0;
  @State ntfSettingsY: number = 0;
  @Consume listArea: Area;
  @Consume isNtfSettingShow: boolean;
  @Consume ntfSettingRect: ViewArea;
  @Consume ntfComponentWidth: number;
  @Consume ntfComponentHeight: number;
  private shadowStyle: ShadowOptions = {
    radius: MENU_SHADOW_RADIUS,
    color: $r('app.color.ntf_pc_click_menu_shadow_color')
  };

  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  aboutToAppear() {
    log.showInfo('aboutToAppear init');
    // 请求窗口show/hide事件，settings弹框
    this.eventMgr.on(RequestWindowEvent, this.onRequestWindowEvent)
      // 鼠标右键弹框
      .on(NtfRightClickEvent, this.onNtfRightClickEvent)
      // 窗口show/hide事件
      .on(WindowEvent, this.onWindowEvent);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
  }

  build() {
    if (this.isShow()) {
      Row() {
        NotificationRightMenu({
          ntfEntry: this.ntfEntry as NotificationEntry,
          onItemClick: (item) => {
            if (this.ntfEntry) {
              // 点击事件处理
              if (item.menuName == RightMenuName.MenuEnableNtf) {
                HiDfxEventUtil.reportNtfRightTopMenuDisableClick(this.ntfEntry.creatorBundleName);
                // 关闭应用通知，收起弹窗即可
                this.hideSelf();
              } else if (item.menuName == RightMenuName.MenuMoreSetting) {
                HiDfxEventUtil.reportNtfRightTopMenuMoreSettingClick(this.ntfEntry.creatorBundleName);
                // 跳转通知管理页面，收起弹窗后，再收起通知面板
                this.hideSelfAndNtfPanel();
              }
            }
          }
        })
      }
      .borderRadius($r('app.float.ntf_pc_click_menu_radius'))
      .backgroundColor($r('app.color.ntf_pc_click_menu_background'))
      .width(MENU_WIDTH)
      .height(MENU_HEIGHT)
      .position({ x: this.ntfSettingsX, y: this.ntfSettingsY })
      .clip(true)
      .shadow(this.shadowStyle)
      .backdropBlur(MENU_BLUR)
      .saturate(MENU_SATURATE)
      .border({width: $r('app.float.ntf_pc_click_menu_inner_boarder_width'), color: $r('app.color.ntf_pc_click_menu_inner_boarder_color'), radius: $r('app.float.ntf_pc_click_menu_inner_boarder_radius')})
      .outline({width: $r('app.float.ntf_pc_click_menu_outer_boarder_width'), color: $r('app.color.ntf_pc_click_menu_outer_boarder_color'), radius: $r('app.float.ntf_pc_click_menu_inner_boarder_radius')})
    }
  }

  private isShow(): boolean {
    if (!this.isNtfSettingShow || CommonUtils.isInvalid(this.ntfEntry)) {
      return false;
    }
    if (this.ntfEntry && ArrayUtils.contains(
      NotificationConstants.DISABLE_CLOSE_NOTIFICATION_PACKAGE_NAME,
      this.ntfEntry.creatorBundleName)) {
      return false;
    }
    return true;
  }

  /**
   * 隐藏弹窗
   */
  private hideSelf(): void {
    windowMgr.hideWindowImmediately(WINDOW_NAME);
    this.isNtfSettingShow = false;
  }

  /**
   * 隐藏弹窗后，接着隐藏通知面板
   */
  private hideSelfAndNtfPanel(): void {
    windowMgr.hideWindowCallback(WINDOW_NAME).then(() => {
      let requestEvent = RequestWindowEvent.create(NTF_PANEL_WINDOW_NAME, RequestWindowEvent.REQUEST_HIDE);
      EvtBus.post(RequestWindowEvent, requestEvent);
    });
  }

  /**
   * 鼠标右键弹框
   *
   * @param event 事件
   */
  private onNtfRightClickEvent = (event: NtfRightClickEvent): void => {
    if (CommonUtils.isInvalid(event.ntfEntry) || CommonUtils.isInvalid(this.listArea)) {
      return;
    }

    // 计算弹框相对通知列表的位置
    let offsetX = event.screenX - Number(this.listArea.globalPosition.x);
    let offsetY = event.screenY - Number(this.listArea.globalPosition.y);

    // 优先在点击点的右边、下边，不够则在左边、上边
    let isAtRight = offsetX + MENU_WIDTH <= this.ntfComponentWidth;
    let titleHeight: number = ResourceManager.getInstance().getNumberByResource($r('app.float.ntf_center_header_pc_height'));
    let isAtBottom = offsetY + MENU_HEIGHT <= (this.ntfComponentHeight - titleHeight);

    // 更新位置、通知数据
    this.ntfSettingsX = isAtRight ? offsetX : (offsetX - MENU_WIDTH);
    this.ntfSettingsY = isAtBottom ? offsetY : (offsetY - MENU_HEIGHT);
    this.ntfEntry = event.ntfEntry;
    this.isNtfSettingShow = true;

    // 计算弹框全局位置，用于通知面板判断是否点击了弹框之外的区域
    let globalX = isAtRight ? event.screenX : event.screenX - MENU_WIDTH;
    let globalY = isAtBottom ? event.screenY : event.screenY - MENU_HEIGHT;
    this.ntfSettingRect = { left: globalX, top: globalY, width: MENU_WIDTH, height: MENU_HEIGHT };
  }

  /**
   * 窗口显示/隐藏事件
   *
   * @param event 事件
   */
  private onWindowEvent = (event: WindowEvent): void => {
    // 通知面板隐藏，则setting窗口同步隐藏
    if (event.isWindowStartHide() && event.isMatchName(NTF_PANEL_WINDOW_NAME)) {
      this.hideSelf();
      return;
    }
    // 弹窗隐藏，则清空数据
    if (event.isMatchName(WINDOW_NAME) && event.isWindowEndHide()) {
      this.ntfEntry = null;
    }
  }

  /**
   * 处理setting弹窗事件
   *
   * @param event 事件
   */
  private onRequestWindowEvent = (event: RequestWindowEvent): void => {
    // 只处理弹框隐藏事件
    if (event.windowName != WINDOW_NAME || !event.isRequestHide()) {
      return;
    }
    this.hideSelf();
  }
}
