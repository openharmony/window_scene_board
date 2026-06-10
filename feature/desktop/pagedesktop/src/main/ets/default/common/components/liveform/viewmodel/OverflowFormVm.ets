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

export class OverflowFormVm {
  @Track public overflowFormStatus: OverflowFormStatus = OverflowFormStatus.INACTIVE;
  @Track public overflowFormConnectionType: OverflowFormConnectionType = OverflowFormConnectionType.DATA_REFRESH;
  @Track public overflowFormDisconnectionType: OverflowFormDisconnectionType = OverflowFormDisconnectionType.OTHERS;
  @Track public uiExtWant: Want | undefined;
  @Track public isInLongPress: boolean = false;
  @Track public overflowFormVisibilityStatus: Visibility = Visibility.Hidden;
  @Track public overflowPauseVisibilityStatus: Visibility = Visibility.Hidden;
  @Track public overflowMaskVisibilityStatus: Visibility = Visibility.Visible;
  @Track public isControlButtonInRenderGroup: boolean = false;
  @Track public imageOpacity: number = 0;
  @Track public uecOpacity: number = 1;
  @Track public uiExtensionComponentWidth: number = 0;
  @Track public uiExtensionComponentHeight: number = 0;
  @Track public uiExtensionComponentOffsetX: number = 0;
  @Track public uiExtensionComponentOffsetY: number = 0;
  @Track public overflowFormHotAreaOffsetX: number = 0;
  @Track public overflowFormHotAreaOffsetY: number = 0;
}

export class StatusInfo {
  public formStatus: OverflowFormStatus = OverflowFormStatus.INACTIVE;
  public isSupportLauncher: boolean = false;

  public static toKey(status: StatusInfo): string {
    return `${OverflowFormStatus[status.formStatus]}_${status.isSupportLauncher ? 'TRUE' : 'FALSE'}`;
  }
};

export enum OverflowFormStatus {
  INACTIVE,
  PAUSE,
  ACTIVE
}

/**
 * 互动卡片触发方式
 */
export enum OverflowFormConnectionType {
  /**
   * 点击主动触发
   */
  USER_CLICK,

  /**
   * 数据刷新被动触发
   */
  DATA_REFRESH,

  /**
   * Swing注视主动触发
   */
  SWING,

  /**
   * 编辑卡片主动触发
   */
  EDIT_FORM_REFRESH,
}

export enum OverflowFormDisconnectionType {
  /**
   * 异常退出
   */
  ABNORMAL_EXIT,

  /**
   * 提供方主动退出
   */
  PROVIDER_QUIT,

  /**
   * 用户主动退出
   */
  CONSUMER_QUIT,

  /**
   * 暂停态激活其它游戏
   */
  ACTIVE_OTHER_GAME_IN_PAUSE_STATUS,

  /**
   * 激活态激活其它游戏
   */
  ACTIVE_OTHER_GAME_IN_ACTIVE_STATUS,

  /**
   * 移动卡片触发退出
   */
  CHANGE_CARD_POSITION_EXIT,

  /**
   * 其他卡片主动溢出触发退出
   */
  OTHER_CARD_OVERFLOW_EXIT,

  /**
   * 长时激活卡片队列已满触发退出
   */
  ACTIVATE_QUEUE_IS_FULL_EXIT,

  /**
   * 长按触发退出
   */
  LONGPRESS_EXIT,

  /**
   * 翻页触发退出
   */
  SWIPERPAGE_CHANGE_EXIT,

  /**
   * 桌面失焦触发退出
   */
  DESKTOP_LOSE_FOCUS_EXIT,

  /**
   * 设备折叠变化触发退出
   */
  FOLDER_STATUS_CHANGE_EXIT,

  /**
   * 屏幕旋转触发退出
   */
  SCREEN_ROTATION_CHANGE_EXIT,

  /**
   * 应用锁触发退出
   */
  APP_LOCK_CHANGE_EXIT,

  /**
   * 隐私空间切换触发退出
   */
  USER_SWITCH_EXIT,

  /**
   * 热管控触发退出
   */
  THERMAL_LEVEL_EXIT,

  /**
   * 省电模式触发退出
   */
  LOW_POWER_EXIT,

  /**
   * 其他
   */
  OTHERS,
}

/**
 * 触发信息
 */
export class ConnectionInfo {
  /**
   * 触发方式
   */
  public connectType: OverflowFormConnectionType = OverflowFormConnectionType.DATA_REFRESH;

  /**
   * 卡片id
   */
  public formId: string = '';

  /**
   * 是否是超长时间请求
   */
  public isLongRequest?: boolean = false;

  /**
   * 请求是否处于长时溢出请求保护时间段内
   */
  public isInProtected?: boolean = true;
}

export interface OverflowFormIconConfig {
  pauseIconSize: number;
  pauseIconPadding: number;
  iconSize: number;
  iconSpace: number;
}