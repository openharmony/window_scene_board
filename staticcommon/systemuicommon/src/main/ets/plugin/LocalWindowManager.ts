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
import { EvtBus, WindowCreatedEvent } from '@ohos/frameworkwrapper';
import { windowMgr, WindowAnimMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import Context from '@ohos.app.ability.common';
import Window from '@ohos.window';

const TAG = 'LocalWindowManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
/**
 * 本地弹窗管理
 *
 * @since 2022-11-12
 */
export class LocalWindowManager {
  /**
   * 横幅通知弹窗背景模糊颜色
   */
  static readonly NTF_BANNER_BLUR_BG_COLOR = '#8CFAFAFA';

  /**
   * 托盘面板宽度220vp
   */
  static readonly PC_TRAY_PANEL_WIDTH = 360;

  /**
   * 托盘面板高度108vp
   */
  static readonly PC_TRAY_PANEL_HEIGHT = 214;

  /**
   * 电池面板宽度220vp
   */
  static readonly PC_BATTERY_PANEL_WIDTH = 220;

  /**
   * 电池面板高度108vp
   */
  static readonly PC_BATTERY_PANEL_HEIGHT = 108;

  /**
   * 日历面板展开窗口高度
   */
  static readonly PC_CALENDAR_PANEL_EXPAND_HEIGHT = 407;

  /**
   * hopper日历面板展开窗口高度
   */
  static readonly PC_HOPPER_CALENDAR_PANEL_EXPAND_HEIGHT = 416;

  /**
   * 日历面板折叠窗口高度
   */
  static readonly PC_CALENDAR_PANEL_COLLAPSE_HEIGHT = 156;

  /**
   * hopper融合模式二级面板展开窗口最大高度
   */
  static readonly PC_HOPPER_WINDOWS_MAX_HEIGHT_WINDOW = 804;

  /**
   * hopper分离模式二级面板展开窗口最大高度
   */
  static readonly PC_HOPPER_WINDOWS_MAX_HEIGHT_MAC = 768;

  /**
   * 控制中心面板窗口高度532vp
   */
  static readonly PC_CONTROL_PANEL_HEIGHT = 532;

  /**
   * 通知面板窗口高度529vp
   */
  static readonly PC_NTF_PANEL_HEIGHT = 529;

  /**
   * 声音面板窗口高度246vp
   */
  static readonly PC_SOUND_PANEL_HEIGHT = 246;

  /**
   * 超级隐私面板窗口高度208vp
   */
  static readonly PC_SUPER_PRIVACY_PANEL_HEIGHT = 208;

  /**
   * 系统面板窗口高度223vp
   */
  static readonly PC_SYSTEM_PANEL_HEIGHT = 223;

  /**
   * 输入法面板窗口高度223vp
   */
  static readonly PC_INPUT_PANEL_HEIGHT = 223;

  /**
   * The height of camera panel: 112vp
   */
  static readonly PC_CAMERA_PANEL_HEIGHT = 112;

  /**
   * 亮度面板宽度 单位vp
   */
  static readonly PC_BRIGHTNESS_PANEL_WIDTH = 312;

  /**
   * 亮度面板高度 单位vp
   */
  static readonly PC_BRIGHTNESS_PANEL_HEIGHT = 32;
  /**
   * 亮度面板底部距顶部占比
   */
  static readonly PC_BRIGHTNESS_RATIO = 0.88;

  /**
   * 亮度面板圆角 单位px
   */
  static readonly PC_BRIGHTNESS_PANEL_RADIUS = 32;

  /**
   * 亮度面板圆角 单位px
   */
  static readonly PC_BRIGHTNESS_PANEL_RADIUS_160 = 36;

  /**
   * 创建本地plugin弹窗
   *
   * @param windowName 窗口名
   * @param context 环境
   * @param position 位置
   * @param content 内容页
   */
  static createPcPanelWindow(windowName: string, context: Context.BaseContext, position: Window.Rect, content: string): void {
    windowMgr.createWindow(windowName, context, position, content).then((window: Window.Window) => {
      log.showInfo('createWindow local name: ' + windowName);
      // 窗口动画
      windowMgr.setWindowAnim(windowName, WindowAnimMgr.createPcPanelWinAnim(window));
      // 默认圆角
      windowMgr.updateWindowRadius(windowName, WindowConstants.getPcSecondaryWindowRadius());
      // 窗口背景模糊
      windowMgr.setWindowBackBlur(windowName, WindowConstants.BLUR_BG_COLOR, WindowConstants.BLUR_RADIUS);
      // 窗口阴影
      windowMgr.setWindowShadow(windowName, WindowConstants.PC_SECONDARY_WINDOW_SHADOW_RADIUS,
        WindowConstants.PC_SECONDARY_WINDOW_SHADOW_COLOR, WindowConstants.SHADOW_OFFSET_X,
        WindowConstants.PC_SECONDARY_WINDOW_SHADOW_OFFSET_Y);
      EvtBus.post(WindowCreatedEvent, WindowCreatedEvent.create(windowName));
    });
  }

  /**
   * 创建横幅通知窗口
   *
   * @param context 环境
   * @param position 位置
   * @param content 内容页面
   */
  static createBannerWindow(context: Context.BaseContext, position: Window.Rect, content: string): void {
    let windowName = WindowConstants.WINDOW_NAME_BANNER;
    windowMgr.createWindow(windowName, context, position, content).then((window) => {
      log.showInfo('createBannerWindow local name: ' + windowName);
      // 窗口动画
      windowMgr.setWindowAnim(windowName, WindowAnimMgr.createBannerWinAnim(window));
      // 默认圆角
      windowMgr.updateWindowRadius(windowName, WindowConstants.getDefaultRadius());
      // 窗口透明
      windowMgr.setWindowBgColor(windowName, WindowConstants.DEFAULT_BG_COLOR);
    });
  }
}