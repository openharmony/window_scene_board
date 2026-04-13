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
import hiSysEvent from '@ohos.hiSysEvent';
import { notificationManager } from '@kit.NotificationKit';
import {
  NTFControlParams,
  ReportParams,
  FoldStateParams,
  FoldParams
} from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { ScreenSessionAdapter } from '../adapter/ScreenSessionAdapter';


export enum NtfEventName {
  /**
   * 通知中心与控制中心切换
   * 事件id: 990220235
   */
  SWITCH_DROPDOWN_PANEL = 'SWITCH_DROPDOWN_PANEL',
  /**
   * 从通知中心点击进入通知快速设置（通知管理）
   * 事件id: 990239996
   */
  NOTIFICATION_PANEL_SETTING = 'NOTIFICATION_PANEL_SETTING',
  /**
   * 从通知中心点击时间跳转至时钟
   * 事件id: 990220411
   */
  NOTIFICATION_PANEL_CLOCK = 'NOTIFICATION_PANEL_CLOCK',
  /**
   * 从通知中心点击日期跳转至日历
   * 事件id: 990220412
   */
  NOTIFICATION_PANEL_CALENDAR = 'NOTIFICATION_PANEL_CALENDAR',
  /**
   * 从通知中心点击流量跳转至流量管理页面
   * 事件id: 990220411
   */
  NOTIFICATION_PANEL_DATAPLAN = 'NOTIFICATION_PANEL_DATAPLAN',
  /**
   * 通知中心滑动
   * 事件id:
   */
  NOTIFICATION_PANEL_SLIDE = 'NOTIFICATION_PANEL_SLIDE',
  /**
   * 收到通知
   * 事件id: 990220344
   */
  NOTIFICATION_RECEIVED = 'NOTIFICATION_RECEIVED',
  /**
   * 每日通知中心通知最大数量
   * 事件id:
   */
  NOTIFICATION_MAX_NUM = 'NOTIFICATION_MAX_NUM',
  /**
   * 设置-通知和状态栏-单应用通知管理-单应用通知状态
   * 事件id:
   */
  NTF_SETTING_APP_STATE = 'NTF_SETTING_APP_STATE',
  /**
   * 设置-通知和状态栏-更多通知设置状态
   * 事件id：
   */
  NTF_MORE_SETTING_STATE = 'NTF_MORE_SETTING_STATE',
  /**
   * 曝光通知
   * 事件id: 990220033
   */
  NOTIFICATION_ON_SCREEN = 'NOTIFICATION_ON_SCREEN',
  /**
   * 点击通知进入应用
   * 事件id: 990220341
   */
  NOTIFICATION_CLICK_APP = 'NOTIFICATION_CLICK_APP',
  /**
   * 点击通知上的按钮
   * 事件id: 990220349
   */
  NOTIFICATION_CLICK_BUTTON = 'NOTIFICATION_CLICK_BUTTON',
  /**
   * 通知中心-左滑通知-点击删除按钮
   * 事件id: 990220704
   */
  NTF_PANEL_SLIP_LEFT_DELETE = 'NTF_PANEL_SLIP_LEFT_DELETE',
  /**
   * 通知中心-点击一键清空所有通知
   * 事件id: 990220345
   */
  NOTIFICATION_PANEL_CLEAR = 'NOTIFICATION_PANEL_CLEAR',
  /**
   * 横幅通知-上滑隐藏
   * 事件id: 990220350
   */
  NOTIFICATION_BANNER_SLIP_UP = 'NOTIFICATION_BANNER_SLIP_UP',
  /**
   * 横幅左滑、右滑删除通知，通知中心右滑删除通知
   * 事件id: 990220346
   */
  NOTIFICATION_SLIP_LEFT_RIGHT = 'NOTIFICATION_SLIP_LEFT_RIGHT',
  /**
   * 横幅通知-下拉
   * 事件id: 990220351
   */
  NOTIFICATION_BANNER_DROPDOWN = 'NOTIFICATION_BANNER_DROPDOWN',
  /**
   * 展开或收起组合通知
   * 事件id: 990220410
   */
  NOTIFICATION_FOLD_GROUP = 'NOTIFICATION_FOLD_GROUP',
  /**
   * 从通知中心管理通知置顶
   * 事件id: 990220416
   */
  NTF_PANEL_TOP = 'NTF_PANEL_TOP',
  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置
   * 事件id: 990220706
   */
  NTF_PANEL_SLIP_SETTING = 'NTF_PANEL_SLIP_SETTING',
  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-更多设置
   * 事件id: 990220415
   */
  NTF_PANEL_SLIP_SETTING_MORE = 'NTF_PANEL_SLIP_SETTING_MORE',
  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-取消
   * 事件id: 990220707
   */
  NTF_PANEL_SLIP_SETTING_CANCEL = 'NTF_PANEL_SLIP_SETTING_CANCEL',
  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-关闭此应用通知
   * 事件id: 990220711
   */
  NTF_PANEL_SLIP_SETTING_CLOSE = 'NTF_PANEL_SLIP_SETTING_CLOSE',
  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-关闭此应用通知-点击关闭
   * 事件id: 990220048
   */
  NTF_PANEL_SLIP_SETTING_CLOSE_OK = 'NTF_PANEL_SLIP_SETTING_CLOSE_OK',
  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-关闭此应用通知-点击取消
   * 事件id: 990220712
   */
  NTF_PANEL_SLIP_SETTING_CLOSE_CXL = 'NTF_PANEL_SLIP_SETTING_CLOSE_CXL',
  /**
   * 设置-通知和状态栏-单应用通知管理-单应用管理通知
   * 事件id: 990230043
   */
  NTF_SETTING_APP_MANAGEMENT = 'NTF_SETTING_APP_MANAGEMENT',
  /**
   * 隐藏通知内容管理
   * 事件id: 990237021
   */
  NOTIFICATION_HIDE_MANAGEMENT = 'NOTIFICATION_HIDE_MANAGEMENT',
  /**
   * 智能隐藏横幅通知内容管理
   */
  BANNER_NOTIFICATION_HIDE_MANAGEMENT = 'BANNER_NTF_HIDE_MANAGEMENT',
  /**
   * 智能隐藏横幅通知跳转人脸页面
   */
  BANNER_NOTIFICATION_HIDE_PAGE_TO_FACE_PAGE = 'BANNER_NTF_HANDLE_FACE_MGT',
  /**
   * 通知亮屏管理
   * 事件id: 990237031
   */
  NOTIFICATION_SCREEN_MANAGEMENT = 'NOTIFICATION_SCREEN_MANAGEMENT',
  /**
   * 设置-通知和状态栏-状态栏
   * 事件id：990237045
   */
  NTF_SETTING_STATUS_BAR = 'NTF_SETTING_STATUS_BAR',
  /**
   * 设置-通知和状态栏-批量管理
   * 事件id：990237040
   */
  NTF_SETTING_MANAGE_ALL = 'NTF_SETTING_MANAGE_ALL',
  /**
   * 通知-通知中心-左滑通知卡片致出现删除和设置按钮
   * 事件id：990220705
   */
  NTF_SLIP_LEFT = 'NTF_SLIP_LEFT',
  /**
   * 通知-通知中心-指纹下拉上划通知横幅
   * 事件id：未定
   */
  NTF_BANNER_DROPDOWN_BYFINGER = 'NTF_BANNER_DROPDOWN_BYFINGER',
  /**
   * 通知-实况窗-是否继续接收此应用的实况窗按钮
   */
  LIVE_WIN_ACCEPT_BUTTON = 'LIVE_WIN_ACCEPT_BUTTON',
  /**
   * 通知-通知中心-横幅通知-自定义铃声播放
   */
  NTF_PLAYBACK_RINGTONES_ITEM = 'NTF_PLAYBACK_RINGTONES_ITEM',
  /**
   * 展开或收起聚合通知
   */
  NOTIFICATION_FOLD_AGGREGATE = 'NOTIFICATION_FOLD_AGGREGATE',
  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-关闭智能聚合
   */
  NTF_PANEL_SMART_DIGEST_CLOSE = 'NTF_PANEL_SMART_DIGEST_CLOSE',
  /**
   * 横幅通知触发悬浮通知
   */
  NTF_BANNER_TO_FLOATING = 'NTF_BANNER_TO_FLOATING',
  /**
   * 通知_通知开关恢复（克隆、升级）
   */
  NOTIFICATION_SWITCH_RECOVER = 'NOTIFICATION_SWITCH_RECOVER',

  /**
   * 通知中心-左滑通知-点击前往应用管理-应用内通知管理
   */
  NTF_CENTER_CLICK_APP_INNER_MGMT = 'NTF_CENTER_CLICK_APP_INNER_MGMT',
  /**
   * 从通知中心管理通知置顶
   * 事件id:
   */
  NOTIFICATION_SILENCE_BUTTON = 'NOTIFICATION_SILENCE_BUTTON',
}

export enum GroupItemType {
  SINGLE_ITEM = 0,
  GROUP_ITEM = 1,
  IN_GROUP_ITEM = 2
}

/**
 * 消息智能提醒类型
 * 0 - 不显示横幅（横幅开关未开、或如锁屏等情形不展示横幅）
 * 1 - 应用锁开启隐藏消息
 * 2 - 智能提醒开启隐藏消息
 * 3 - 消息显示
 */
export enum SmartRemindType {
  NO_HEADS_UP = 0,
  APP_LOCK_HIDE = 1,
  SMART_HIDE = 2,
  MESSAGE_DISPLAY = 3
}

/**
 * 双中心切换方式
 * 0 - 通知中心顶部左滑切换到控制中心
 * 1 - 控制中心顶部右滑切换到通知中心
 * 2 - 通知中心面板左滑切换到控制中心
 * 3 - 控制中心面板右滑切换到通知中心
 */
export enum SwitchType {
  NOTIFICATION_TO_CONTROL_HEADER = 0,
  CONTROL_TO_NOTIFICATION_HEADER = 1,
  NOTIFICATION_TO_CONTROL_PANEL = 2,
  CONTROL_TO_NOTIFICATION_PANEL = 3
}

/**
 * 滑动类型
 * 0 - 下滑距离在1屏以内
 * 1 - 下滑距离超过1屏，在2屏以内
 * 2 - 下滑距离超过2屏，在3屏以内
 * 3 - 下滑距离超过3屏
 * 4 - 滑动停止
 */
export enum SlideType {
  WITHIN_ONE_SCREEN = 0,
  WITHIN_TWO_SCREEN = 1,
  WITHIN_THREE_SCREEN = 2,
  BEYOND_THREE_SCREEN = 3,
  SCROLL_STOP = 4,
}

/**
 * 滑动类型
 * pullDown - 下拉
 * click - 点击
 */
export enum FloatingOperationType {
  PULL_DOWN = 'pullDown',
  CLICK = 'click',
}

export class NtfEntryParams extends FoldStateParams {
  /**
   * 通知id
   */
  NOTIFICATION_ID?: number;

  /**
   * 创建通知应用包名
   */
  CREATOR_BUNDLE_NAME?: string;

  /**
   * 通知通道类型
   * 0 - 未知类型
   * 1 - 社交类型
   * 2 - 服务类型
   * 3 - 内容类型
   * 4 - 实况类型
   */
  NOTIFICATION_SLOT_TYPE?: number | string;
}

export class SwitchDropdownPanelParams extends NTFControlParams {
  /**
   * 切换方式
   */
  SWITCH_TYPE: SwitchType;

  /**
   * 进入通知中心或控制中心时的时间戳
   */
  TIME_STAMP: string;

  /**
   * 手势滑动起始点X坐标
   */
  startX: number;

  /**
   * 手势滑动起始点Y坐标
   */
  startY: number;

  /**
   * 手势滑动终点X坐标
   */
  endX: number;

  /**
   * 手势滑动终点Y坐标
   */
  endY: number;

  /**
   * 屏幕分辨率
   */
  resolution?: string;

  /**
   * 屏幕方向
   */
  orientation: number;
}
export class NotificationPanelSettingParams extends NTFControlParams {
  /**
   * 进入通知中心或控制中心时的时间戳
   */
  TIME_STAMP: string;
}
export class NotificationPanelClockParams extends NTFControlParams {
  /**
   * 进入通知中心时的时间戳
   */
  TIME_STAMP: string;
}
export class NotificationPanelDataPlanParams extends NTFControlParams {
  /**
   * 进入通知中心时的时间戳
   */
  public TIME_STAMP?: string;
}
export class NotificationPanelCalendarParams extends NTFControlParams {
  /**
   * 进入通知中心时的时间戳
   */
  TIME_STAMP: string;
}
export class NotificationPanelSlideParams extends FoldStateParams {
  /**
   * 进入通知中心时的时间戳
   */
  TIME_STAMP: string;

  /**
   * 滑动类型
   */
  SLIDE_DISTANCE: SlideType;
}
export class NotificationReceivedParams extends NtfEntryParams {
  /**
   * 是否为push通知
   * 0 - push通知
   * 1 - 非push通知
   */
  IS_PUSH?: 0 | 1;

  /**
   * 是否为ongoing通知
   * 0 - ongoing通知
   * 1 - 非ongoing通知
   */
  IS_ONGOING?: 0 | 1;

  /**
   * 是否为实况通知
   * 0 - 实况通知
   * 1 - 非实况通知
   */
  IS_LIVE?: 0 | 1;

  /**
   * 收到通知的场景
   * 2 - 静默通知
   * 3 - 锁屏通知
   * 4 - 横幅通知
   */
  RECEIVED_SCENE?: 2 | 3 | 4;

  /**
   * 是否为熄屏状态
   * 0 - 熄屏状态
   * 1 - 非熄屏状态
   */
  IS_SCREEN_OFF?: 0 | 1;

  /**
   * 锁屏通知开关
   * 0 - 打开
   * 1 - 关闭
   */
  settingLock?: 0 | 1;

  /**
   * 横幅通知开关
   * 0 - 打开
   * 1 - 关闭
   */
  settingBanner?: 0 | 1;

  /**
   * 通知权限铃声状态
   * 0 - 响铃和振动
   * 1 - 铃声
   * 2 - 振动
   * 3 - 静音
   */
  settingSound?: number;

  /**
   * 当前系统语言
   */
  language: string;

  /**
   * 通知的样式
   * 基础类型 - basicText
   * 长文本类型 - longText
   * 多行文本类型 - multiLine
   * 大图片类型 - picture
   * 其他 - other
   */
  style: string;

  /**
   * 是否允许通知清除
   */
  isunremoveable: boolean;

  /**
   * 是否特权类型
   * 0 - 无特权
   * 1 - 更换图标
   */
  PRIVILEGE_TYPE?: number;

  /**
   * 是否常驻
   * 0 - 否
   * 1 - 是
   */
  IS_STICKY?: 0 | 1 = 0;

  /**
   * 消息智能提醒类型
   * 0 - 不显示横幅（横幅开关未开、或如锁屏等情形不展示横幅）
   * 1 - 应用锁开启隐藏消息
   * 2 - 智能提醒开启隐藏消息
   * 3 - 消息显示
   */
  SMART_REMINDER_TYPE?: SmartRemindType;

  /**
   * 消息弱提醒类型
   * 0 - 响铃&震动正常
   * 1 - 响铃&震动减弱
   */
  WEAK_REMINDER_TYPE?: 0 | 1;

  /**
   * 通知创建者ID
   */
  USER_ID?: number;

  /**
   * 通知唯一标示
   */
  HASHCODE?: string;

  /**
   * 是否携带sound
   */
  HAS_SOUND?: boolean;

  /**
   * channel_id
   */
  CHANNEL_ID?: string;

  /**
   * 通知发送方的应用类型
   * 0 - 应用
   * 1 - 元服务
   */
  BUNDLE_TYPE?: number;
}
export class NotificationMaxNumParams extends NtfEntryParams {
  /**
   * 通知数量
   */
  NTF_MAX_NUM_DAILY?: number;
}
export class NotificationSettingAppStateParams extends NTFControlParams {
  /**
   * 创建通知应用包名
   */
  CREATOR_BUNDLE_NAME?: string;

  /**
   * 允许通知开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  IS_ALLOW_STATE_ON?: number;

  /**
   * 置顶通知开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  IS_TOP_STATE_ON?: number;

  /**
   * 锁屏通知开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  IS_LOCK_STATE_ON?: number;

  /**
   * 横幅通知开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  IS_BANNER_STATE_ON?: number;

  /**
   * 桌面角标开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  IS_CORNER_STATE_ON?: number;

  /**
   * 静默通知开关
   * 0 - 关闭
   * 1 - 打开
   */
  IS_SILENCE_STATE_ON?: number;

  /**
   * 通知铃声状态
   * 0 - 铃声和振动
   * 1 - 仅铃声
   * 2 - 仅振动
   * 3 - 静音
   */
  NOTIFICATION_RING_STATE?: number;

  /**
   * 社交通讯
   * 0 - 关闭
   * 1 - 打开
   */
  NOTIFICATION_SOCIAL_TYPE_STATE?: number;

  /**
   * 服务提醒
   * 0 - 关闭
   * 1 - 打开
   */
  NOTIFICATION_SERVICE_TYPE_STATE?: number;

  /**
   * 内容咨询
   * 0 - 关闭
   * 1 - 打开
   */
  NOTIFICATION_CONTENT_TYPE_STATE?: number;

  /**
   * 客服消息
   * 0 - 关闭
   * 1 - 打开
   */
  NOTIFICATION_CUSTOMER_TYPE_STATE?: number;

  /**
   * 其他
   * 0 - 关闭
   * 1 - 打开
   */
  NOTIFICATION_OTHER_TYPE_STATE?: number;

  /**
   * 实况窗开关
   * 0 - 关闭
   * 1 - 打开
   */
  LIVE_VIEW_STATE?: number;
}
export class NtfMoreSettingStateParams extends NTFControlParams {
  /**
   * 锁屏通知样式
   * 0 - 胶囊式
   * 1 - 列表式
   */
  NTF_LOCK_STYLE?: number;
  /**
   * 锁定时显示预览开关
   * 0 - 关闭
   * 1 - 打开
   */
  IS_LOCK_PREVIEW_ON?: number;
  /**
   * 锁定时显示实况窗预览开关
   * 0 - 关闭
   * 1 - 打开
   */
  IS_LOCK_LIVE_PREVIEW_ON?: number;
  /**
   * 收到通知自动亮屏开关
   * 0 - 关闭
   * 1 - 打开
   */
  IS_SCREEN_LIGHT_UP_ON?: number;
  /**
   * 智能提醒
   * 0 - 关闭
   * 1 - 打开
   */
  IS_HIDDEN_BANNER_CONTENT_ON?: number;
  /**
   * 桌面角标开关
   * 0 - 关闭
   * 1 - 打开
   */
  IS_SHOW_DESKTOP_BADEGS_ON?: number;
  /**
   * 多屏协同开关
   * 0 - 关闭
   * 1 - 打开
   */
  IS_DISTRIBUTE_BUTTON_ON?: number;
}
export class NotificationOnScreenParams extends NtfEntryParams {
  /**
   * 是否为push通知
   * 0 - push通知
   * 1 - 非push通知
   */
  IS_PUSH?: 0 | 1;

  /**
   * 是否为组合通知
   * 0 - 组合通知
   * 1 - 非组合通知
   */
  IS_GROUP?: 0 | 1;

  /**
   * 展示通知的场景
   * 2 - 锁屏通知
   * 3 - 横幅通知
   * 4 - 通知中心
   * 5 - 实况列表
   */
  DISPLAY_SCENE?: 2 | 3 | 4 | 5;

  /**
   * 进入通知中心时间戳（不在通知中心收到通知时上报空）
   */
  TIME_STAMP?: string;

  /**
   * Push消息标识符
   */
  PUSH_DATA?: string;
}
export class NotificationClickAppParams extends NtfEntryParams {
  /**
   * 是否为实况通知
   * 0 - 实况通知
   * 1 - 非实况通知
   */
  IS_LIVE?: 0 | 1;

  /**
   * 通知展示场景
   * 2 - 锁屏通知
   * 3 - 横幅通知
   * 4 - 通知中心
   * 5 - 实况列表
   */
  DISPLAY_SCENE?: 2 | 3 | 4 | 5;

  /**
   * 进入通知中心时间戳（不在通知中心收到通知时上报空）
   */
  TIME_STAMP?: string;

  /**
   * 是否在组通知内
   * 0 - 不在组通知内
   * 1 - 在组通知内
   */
  IS_IN_GROUP?: 0 | 1;

  /**
   * 是否在聚合通知中
   * 0 - 不在聚合通知内
   * 1 - 在聚合通知内
   */
  IS_IN_AGGREGATE?: 0 | 1;

  /**
   * 是否在中景窗态
   * 0-非中景窗
   * 1-中景窗态
   */
  IS_MIDSCENE?: 0 | 1;

  /**
   * 通知创建者ID
   */
  USER_ID?: number;

  /**
   * 通知唯一标示
   */
  HASHCODE?: string;

  /**
   * 通知点击之后是否删除
   * 0 - 否
   * 1 - 是
   */
  IS_AUTODELETE?: 0 | 1;

  /**
   * 通知发送方的应用类型
   * 0 - 应用
   * 1 - 元服务
   */
  BUNDLE_TYPE?: number;
}
export class NotificationClickButtonParams extends NtfEntryParams {
  /**
   * 是否为实况通知
   * 0 - 实况通知
   * 1 - 非实况通知
   */
  IS_LIVE?: 0 | 1;

  /**
   * 通知展示场景
   * 2 - 锁屏通知
   * 3 - 横幅通知
   * 4 - 通知中心
   * 5 - 实况列表
   */
  DISPLAY_SCENE?: number;

  /**
   * 按钮索引
   */
  BUTTON_INDEX?: number;

  /**
   * 进入通知中心时间戳（不在通知中心收到通知时上报空）
   */
  TIME_STAMP?: string;

  /**
   * 是否在组合通知里
   * 0 - 不在组合通知
   * 1 - 在组合通知里
   */
  IS_IN_GROUP?: 0 | 1;

  /**
   * 是否在聚合通知中
   * 0 - 不在聚合通知内
   * 1 - 在聚合通知内
   */
  IS_IN_AGGREGATE?: 0 | 1;
}
export class NotificationPanelSlipLeftDeleteParams extends NtfEntryParams {
  /**
   * 通知展示场景
   * 2 - 锁屏通知
   * 4 - 通知中心
   */
  DISPLAY_SCENE?: 2 | 4;

  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;

  /**
   * 组合通知类型
   * 0 - 单通知
   * 1 - 组通知
   * 2 - 组通知中的子通知
   */
  IS_GROUP?: GroupItemType;

  /**
   * 是否聚合通知
   * 0 - 否
   * 1 - 是
   */
  IS_AGGREGATE?: number;
}
export class NotificationPanelClearParams extends FoldStateParams {
  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;
  /**
   * 删除的未知通知数量
   */
  UNKNOWN_DELETED_NUMBER?: number;
  /**
   * 删除的社交通知数量
   */
  SOCIAL_DELETED_NUMBER?: number;
  /**
   * 删除的服务通知数量
   */
  SERVICE_DELETED_NUMBER?: number;
  /**
   * 删除的内容通知数量
   */
  CONTENT_DELETED_NUMBER?: number;
  /**
   * 删除的通知总数量
   */
  DELETED_NUMBER?: number;
}
export class NotificationBannerSlipUpParams extends NtfEntryParams {

}
export class NotificationSlipLeftRightParams extends NtfEntryParams {
  /**
   * 通知展示场景
   * 2 - 锁屏通知
   * 3 - 横幅通知
   * 4 - 通知中心
   */
  DISPLAY_SCENE?: 2 | 3 | 4;

  /**
   * 进入通知中心时间戳（不在通知中心收到通知时上报空）
   */
  TIME_STAMP?: string;

  /**
   * 组合通知类型
   * 0 - 单通知
   * 1 - 组通知
   * 2 - 组通知中的子通知
   */
  IS_GROUP?: GroupItemType;

  /**
   * 是否聚合通知
   * 0 - 否
   * 1 - 是
   */
  IS_AGGREGATE?: number;

  /**
   * 通知发送方的应用类型
   * 0 - 应用
   * 1 - 元服务
   */
  BUNDLE_TYPE?: number;
}
export class NotificationBannerDropdownParams extends NtfEntryParams {

}
export class NotificationBannerToFloatingParams extends NtfEntryParams {
  /**
   * 操作方式
   */
  OPERATION?: FloatingOperationType | string;
}
/**
 * 指纹下拉和上划
 */
export class NotificationBannerDropdownByFingerParams extends NtfEntryParams {
  /**
   * 操作方式
   * pullUp - 上滑
   * pullDown - 下拉
   */
  OPERATION?: string;

  /**
   * 面板类型
   * 通知中心- notification
   * 横幅通知-banner
   */
  PANEL_TYPE?: string;
}
export class NotificationFoldGroupParams extends NtfEntryParams {
  /**
   * 操作方式
   * 0 - 展开
   * 1 - 收起
   */
  OPERATE_METHOD?: 0 | 1;

  /**
   * 通知展示场景
   * 2 - 锁屏通知
   * 3 - 横幅通知
   * 4 - 通知中心
   */
  DISPLAY_SCENE?: 2 | 3 | 4;

  declare NOTIFICATION_SLOT_TYPE: string;

  /**
   * 进入通知中心时间戳（不在通知中心收到通知时上报空）
   */
  TIME_STAMP?: string;
}
export class NotificationPanelTopParams extends NtfEntryParams {
  /**
   * 操作方式
   * 0 - 置顶应用通知
   * 1 - 取消置顶
   */
  OPERATE_METHOD?: 0 | 1;

  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;
}
export class NotificationSilenceParams extends NtfEntryParams {
  /**
   * 创建通知应用包名
   */
  CREATOR_BUNDLE_NAME?: string;

  /**
   * 操作方式
   * 0 - 取消静默
   * 1 - 开启静默
   */
  IS_SILENCE_STATE_ON?: 0 | 1;

  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;
}
export class NotificationPanelSlipSettingParams extends NtfEntryParams {
  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;

  /**
   * 通知id
   */
  NOTIFICATION_ID?: number;

  /**
   * 通知发送方的应用类型
   * 0 - 应用
   * 1 - 元服务
   */
  BUNDLE_TYPE?: number;
}
export class NotificationPanelSlipSettingMoreParams extends NtfEntryParams {
  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;

  /**
   * 通知id
   */
  NOTIFICATION_ID?: number;

  /**
   * 聚合场景
   */
  AGGREGATION_SCENE?: string;

  /**
   * 通知发送方的应用类型
   * 0 - 应用
   * 1 - 元服务
   */
  BUNDLE_TYPE?: number;
}
export class NotificationPanelSlipSettingCancelParams extends NtfEntryParams {
  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP: string;

  /**
   * 通知id
   */
  NOTIFICATION_ID?: number;
}
export class NotificationPanelSlipSettingCloseParams extends NtfEntryParams {
  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;

  /**
   * 通知id
   */
  NOTIFICATION_ID?: number;

  /**
   * 通知发送方的应用类型
   * 0 - 应用
   * 1 - 元服务
   */
  BUNDLE_TYPE?: number;
}
export class NotificationPanelSlipSettingCloseConfirmParams extends NtfEntryParams {
  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;

  /**
   * 通知id
   */
  NOTIFICATION_ID?: number;
}
export class NotificationPanelSlipSettingCloseCancelParams extends NtfEntryParams {
  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;

  /**
   * 通知id
   */
  NOTIFICATION_ID?: number;
}
export class NotificationSettingAppManagementParams extends NTFControlParams {
  /**
   * 创建通知应用包名
   */
  CREATOR_BUNDLE_NAME?: string;

  /**
   * 按钮名称
   * ALLOWED - 允许通知按钮
   * TOP - 置顶通知按钮
   * Lock - 提醒方式-锁屏通知按钮
   * BANNER - 提醒方式-横幅通知按钮
   * RING - 通知铃声按钮
   */
  SWITCH_ID?: string;

  /**
   * 按钮操作状态
   *
   * 当按钮非通知铃声
   * 0 - 打开
   * 1 - 关闭
   *
   * 当按钮为通知铃声
   * 0 - 响铃和振动
   * 1 - 铃声
   * 2 - 振动
   * 3 - 静音
   */
  SWITCH_STATUS?: number;
}
export class NotificationHideManagementParams extends NTFControlParams {
  /**
   * 操作方式
   * 0 - 打开
   * 1 - 关闭
   */
  OPERATE_METHOD?: 0 | 1;
}
export class NotificationScreenManagementParams extends NTFControlParams {
  /**
   * 操作方式
   * 0 - 打开
   * 1 - 关闭
   */
  OPERATE_METHOD?: 0 | 1;

  /**
   * 是否额外开关豁免亮屏
   * 0 - 否
   * 1 - 是
   */
  IS_EXTRA_ON?: 0 | 1;
}
export class NotificationSlipLeftParams extends NtfEntryParams {
  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;

  /**
   * 通知id
   */
  NOTIFICATION_ID?: number;

  /**
   * 通知发送方的应用类型
   * 0 - 应用
   * 1 - 元服务
   */
  BUNDLE_TYPE?: number;
}

export class LiveViewAcceptButtonParams extends NtfEntryParams {
  /**
   * 是否允许继续接收
   * 0 - 拒绝
   * 1 - 继续接收
   */
  ACCEPT?: number;

  /**
   * 通知展示场景
   * 2 - 锁屏通知
   * 4 - 通知中心
   */
  DISPLAY_SCENE?: number;
}

export class NtfPlaybackRingtonesItemParams extends NTFControlParams {
  // 自定义铃声播放开始时间
  STARTTIME?: number;

  // 自定义铃声播放结束时间
  ENDTIME?: number;

  // 自定义铃声播放状态  {0:正常播放完成,1:30s播完截断，2:资源有问题无法播放,3:异常情况,4:消息更新停止}
  STATUS?: number;

  // 第三方应用包名
  BUNDLE_NAME?: string;

  // 第三方应用通知类型
  NTF_SLOT_TYPE?: notificationManager.SlotType;

  // 通知id
  NTF_ID?: number;

  /**
   * 震动模式
   * 0:无震动
   * 1:普通震动
   * 2:自定义震动
   */
  VIBRATION_MODE?: number;
}

export class NotificationFoldAggregateParams extends NTFControlParams {
  /**
   * 聚合通知中子通知的包名和对应包名的通知个数
   * 格式为：包名1_通知个数;包名2_通知个数
   */
  BUNDLE_AND_NTF_NUM?: string;

  /**
   * 聚合场景
   */
  AGGREGATION_SCENE?: string;

  /**
   * 通知展示场景
   * 2 - 锁屏通知
   * 4 - 通知中心
   */
  DISPLAY_SCENE?: 2 | 4;

  /**
   * 操作方式
   * 0 - 展开
   * 1 - 收起
   */
  OPERATE_METHOD?: 0 | 1;

  /**
   * 进入通知中心时间戳（不在通知中心收到通知时上报空）
   */
  TIME_STAMP?: string;
}

// 克隆升级开关恢复打点
export class NotificationSwitchRecoverParams extends NTFControlParams {
  /**
   * 恢复应用包名
   */
  BUNDLE_NAME?: string;

  /**
   * 应用UID
   */
  UID?: number;

  /**
   * 通知提醒方式
   */
  SLOT_FLAGS?: number;

  /**
   * 角标开关
   */
  BADGE?: number;

  /**
   * 置顶开关
   */
  PINTOP?: number;

  /**
   * 通知提醒方式恢复结果 0：成功 1：失败
   */
  SLOT_FLAGS_RES?:number;

  /**
   * 角标开关恢复结果 0：成功 1：失败
   */
  BADGE_RES?:number;

  /**
   * 置顶开关恢复结果 0：成功 1：失败
   */
  PINTOP_RES?:number;

  /**
   * 通知开关
   */
  ENABLE?:number;

  /**
   * 通知开关恢复结果 0：成功 1：失败
   */
  ENABLE_RES?:number;
}
export class NotificationOpenAppMgmtParams extends NtfEntryParams {
  /**
   * 进入通知中心时间戳
   */
  TIME_STAMP?: string;

  /**
   * 通知id
   */
  NOTIFICATION_ID?: number;

  /**
   * 通知面板类型
   */
  NOTIFICATION_TYPE?: number;
}
/**
 * 打点函数类
 */
export class NotificationSysEventReporter {
  /**
   * 上报域
   */
  public static NOTIFICATION_UE = 'NOTIFICATION_UE';

  /**
   *设置折叠屏打点
   */
  private static async setFoldParams(params: FoldStateParams): Promise<void> {
    params.FOLDDEVICETYPE = FoldParams.FOLD_DEVICE_TYPE;
    params.ISFOLDEXPAND = await ScreenSessionAdapter.isFoldablePhoneExpandStatus();
  }

  /**
   * 通知中心与控制中心切换
   */
  public static async switchDropdownPanel(params: SwitchDropdownPanelParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.SWITCH_DROPDOWN_PANEL,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 从通知中心点击进入通知快速设置（通知管理）
   */
  public static async notificationPanelSetting(params: NotificationPanelSettingParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_PANEL_SETTING,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 从通知中心点击时间跳转至时钟
   */
  public static async notificationPanelClock(params: NotificationPanelClockParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_PANEL_CLOCK,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }
  /**
   * 从通知中心点击流量跳转至流量管理
   */
  public static async notificationPanelDataPlan(params: NotificationPanelDataPlanParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_PANEL_DATAPLAN,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }
  /**
   * 从通知中心点击日期跳转至日历
   */
  public static async notificationPanelCalendar(params: NotificationPanelCalendarParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_PANEL_CALENDAR,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心滑动
   */
  public static async notificationPanelSlide(params: NotificationPanelSlideParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_PANEL_SLIDE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 收到通知
   */
  public static async notificationReceived(params: NotificationReceivedParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_RECEIVED,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 每日通知中心通知最大数量
   */
  public static async notificationMaxNum(params: NotificationMaxNumParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_MAX_NUM,
      hiSysEvent.EventType.STATISTIC,
      params
    );
  }

  /**
   * 设置-通知和状态栏-单应用通知管理-单应用通知状态
   */
  public static async notificationSettingAppState(params: NotificationSettingAppStateParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SETTING_APP_STATE,
      hiSysEvent.EventType.STATISTIC,
      params
    );
  }

  /**
   * 通知-通知和状态栏-更多通知状态
   */
  public static async ntfMoreSettingState(params: NtfMoreSettingStateParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_MORE_SETTING_STATE,
      hiSysEvent.EventType.STATISTIC,
      params
    );
  }


  /**
   * 曝光通知
   */
  public static async notificationOnScreen(params: NotificationOnScreenParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_ON_SCREEN,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 点击通知进入应用
   */
  public static async notificationClickApp(params: NotificationClickAppParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    if (params.DISPLAY_SCENE === 2) {params.TIME_STAMP = undefined};
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_CLICK_APP,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 点击通知上的按钮
   */
  public static async notificationClickButton(params: NotificationClickButtonParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_CLICK_BUTTON,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-左滑通知-点击删除按钮
   */
  public static async notificationPanelSlipLeftDelete(params: NotificationPanelSlipLeftDeleteParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    if (params.DISPLAY_SCENE === 2) {params.TIME_STAMP = undefined};
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PANEL_SLIP_LEFT_DELETE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-点击一键清空所有通知
   */
  public static async notificationPanelClear(params: NotificationPanelClearParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_PANEL_CLEAR,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 横幅通知-上滑隐藏
   */
  public static async notificationBannerSlipUp(params: NotificationBannerSlipUpParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_BANNER_SLIP_UP,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 横幅左滑、右滑删除通知，通知中心右滑删除通知
   */
  public static async notificationSlipLeftRight(params: NotificationSlipLeftRightParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_SLIP_LEFT_RIGHT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 横幅通知触发悬浮窗
   */
  public static async notificationBannerToFloating(params: NotificationBannerToFloatingParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_BANNER_TO_FLOATING,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 横幅通知-下拉
   */
  public static async notificationBannerDropdown(params: NotificationBannerDropdownParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_BANNER_DROPDOWN,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 横幅通知-指纹下拉
   */
  public static async notificationBannerDropdownByFinger(params: NotificationBannerDropdownByFingerParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_BANNER_DROPDOWN_BYFINGER,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 状态栏下拉-指纹下拉
   */
  public static async statusBarDropdownByFinger(params: NotificationBannerDropdownByFingerParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_BANNER_DROPDOWN_BYFINGER,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 展开或收起组合通知
   */
  public static async notificationFoldGroup(params: NotificationFoldGroupParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_FOLD_GROUP,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 从通知中心管理通知置顶
   */
  public static async notificationPanelTop(params: NotificationPanelTopParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PANEL_TOP,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 从通知中心管理通知静默
   */
  public static async notificationSilence(params: NotificationSilenceParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_SILENCE_BUTTON,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置
   */
  public static async notificationPanelSlipSetting(params: NotificationPanelSlipSettingParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PANEL_SLIP_SETTING,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-更多设置
   */
  public static async notificationPanelSlipSettingMore(params: NotificationPanelSlipSettingMoreParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PANEL_SLIP_SETTING_MORE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-取消
   */
  public static async notificationPanelSlipSettingCancel(params: NotificationPanelSlipSettingCancelParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PANEL_SLIP_SETTING_CANCEL,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-关闭此应用通知
   */
  public static async notificationPanelSlipSettingClose(params: NotificationPanelSlipSettingCloseParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PANEL_SLIP_SETTING_CLOSE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-关闭此应用通知-点击关闭
   */
  public static async notificationPanelSlipSettingCloseConfirm(params: NotificationPanelSlipSettingCloseConfirmParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PANEL_SLIP_SETTING_CLOSE_OK,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-关闭此应用通知-点击取消
   */
  public static async notificationPanelSlipSettingCloseCancel(params: NotificationPanelSlipSettingCloseCancelParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PANEL_SLIP_SETTING_CLOSE_CXL,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 设置-通知和状态栏-单应用通知管理-单应用管理通知
   */
  public static async notificationSettingAppManagement(params: NotificationSettingAppManagementParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SETTING_APP_MANAGEMENT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 隐藏通知内容管理
   */
  public static async notificationHideManagement(params: NotificationHideManagementParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_HIDE_MANAGEMENT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知亮屏管理
   */
  public static async notificationScreenManagement(params: NotificationScreenManagementParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_SCREEN_MANAGEMENT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 设置-通知和状态栏-状态栏
   */
  public static async notificationSettingStatusBar(): Promise<void> {
    let params: NTFControlParams = {};
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SETTING_STATUS_BAR,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-通知中心-左滑通知卡片致出现删除和设置按钮
   */
  public static async notificationSlipLeft(params: NotificationSlipLeftParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SLIP_LEFT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-实况窗-是否继续接收此应用的实况窗按钮
   */
  public static async liveViewAcceptButton(params: LiveViewAcceptButtonParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    await this.setFoldParams(params);

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.LIVE_WIN_ACCEPT_BUTTON,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 展开或收起组合通知
   */
  public static async notificationFoldAggregate(params: NotificationFoldAggregateParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_FOLD_AGGREGATE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-通知中心-横幅通知-自定义铃声播放打点
   */
  public static async ntfPlaybackRingtonesItem(params: NtfPlaybackRingtonesItemParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PLAYBACK_RINGTONES_ITEM,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-左滑通知-点击设置按钮进入通知设置-关闭智能摘要
   */
  public static async ntfSmartDigestClose(params: NotificationPanelSlipSettingMoreParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PANEL_SMART_DIGEST_CLOSE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-克隆、升级开关同步
   */
  public static async ntfSwitchRecover(params: NotificationSwitchRecoverParams, useTaskPool: boolean): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_SWITCH_RECOVER,
      hiSysEvent.EventType.BEHAVIOR,
      params,
      useTaskPool,
    );
  }

  /**
   * 通知中心-左滑通知-点击前往应用管理-应用内通知管理
   */
  public static async notificationOpenAppInnerMgmt(params: NotificationOpenAppMgmtParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    HiSysEventUtil.report(
      NotificationSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_CENTER_CLICK_APP_INNER_MGMT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }
}
