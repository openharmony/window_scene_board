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

/**
 * 点击区域类型
 */
export enum ClickRegion {
  NTF_MAIN = 0,
  CONTENT_BUTTON = 1,
  LIVE_BUTTON = 2,
  SUB_AREA = 3,
  EXTEND_AREA = 4,
  EXPAND_BUTTON = 5,
  COLLAPSE_BUTTON = 6,
  CLOSE_NTF_ENABLE = 7,
  OPEN_NTF_ENABLE = 8,
  CLOSE_LIVE_VIEW_ENABLE = 9,
  OPEN_LIVE_VIEW_ENABLE = 10,
  PIN_TOP_ON = 11,
  PIN_TOP_OFF = 12,
  MORE_SETTINGS = 13,
  CAPSULE = 14,
  AUTH_ACCEPT = 15,
  AUTH_REJECT = 16,
  BANNER_MAIN = 17,
  BANNER_BUTTON = 18,
  SMART_REMINDER_ON = 19,
  SMART_REMINDER_OFF = 20,
  CAPSULE_TRIGGER = 21,
  CAPSULE_BUTTON = 22,
  APP_FOREGROUND = 23,
  APP_BACKGROUND = 24,
  CLOSE_META_SERVICE_NTF_ENABLE = 26,
  UI_LITE_MODE = 27,
  CAPSULE_COLLAPSE = 28,
  SERVICE_BUTTON = 29,
  CLOSE_UNSTALL_META_SERVICE_LIVE_ENABLE = 30,
  SILENT_NTF_ON = 31,
  SILENT_NTF_OFF = 32,
}

/**
 * 通知类型
 */
export enum RemindType {
  NORMAL = 0
}

/**
 * 通知删除类别码，21 - 200
 */
export enum DeleteNotificationType {
  /* 左滑删除 */
  LEFT_SLIDE_DELETE = 101,
  /* 左滑点击删除按钮 */
  LEFT_SLIDE_CLICK_DELETE = 102,
  /* 右滑删除 */
  RIGHT_SLIDE_DELETE = 103,
  /* 实况列表左滑点击删除按钮 */
  LIVE_LEFT_SLIDE_CLICK_DELETE = 104,
  /* 一键删除 */
  CLICK_ALL_BUTTON_DELETE = 107,
  /* 删除聚合组 */
  AGGREGATE_GROUP_DELETE = 108,
  /* 消息超过通知中心数量限制删除 */
  EXCEED_MAX_NUMBER_DELETE = 109,
  /* 应用进程挂死删除 */
  PROCESS_DEAD_DELETE = 110,
  /* 实况数据到期隐藏 */
  LIVE_DATA_EXPIRE_HIDE = 111,
  /* 左滑点击关闭此应用实况窗 */
  LIVE_LEFT_SLIDE_CLICK_CLOSE = 112,
  /* 左滑点击关闭此应用通知 */
  NTF_LEFT_SLIDE_CLICK_CLOSE = 113,
  /* 点击通知 */
  NOTIFICATION_CLICK_DELETE = 114,
  /* 即时实况胶囊超时删除 */
  INSTANT_CAPSULE_TIMEOUT_DELETE = 115,
  /* 即时实况横幅超时删除 */
  INSTANT_BANNER_TIMEOUT_DELETE = 116,
  /* 即时实况横幅滑动超时删除 */
  INSTANT_BANNER_SWIPE_TIMEOUT_DELETE = 117,
  /* 即时实况横幅上滑删除 */
  INSTANT_BANNER_SWIPE_UP_DELETE = 118,
  /* 下拉通知面板删除即时实况横幅 */
  DROP_DOWN_INSTANT_DELETE = 119,
  /* 外部触发删除 */
  OTHER_DELETE = 201,
}

/**
 * ANS测试通知原因，0 - 100
 */
export enum ExternalDeleteReason {
  /* 应用更改删除通知 */
  PACKAGE_CHANGED_REASON_DELETE = 5,
  /* 应用直接删除通知 */
  APP_CANCEL_REASON_DELETE = 8,
  /* 应用删除所有通知 */
  APP_CANCEL_ALL_DELETE = 9,
  /* 左滑关闭实况窗，相当于是关闭开关触发的删除 */
  DISABLE_SLOT_REASON_DELETE = 12,
  /* SA取消通知（可包含push删除通知） */
  APP_CANCEL_AS_BUNELE_REASON_DELETE = 14,
  /* 实况8小时兜底删除 */
  TRIGGER_EIGHT_HOUR_REASON_DELETE = 21,
  /* 实况4小时不更新删除 */
  TRIGGER_FOUR_HOUR_REASON_DELETE = 22,
  /* 长时任务10min不更新删除 */
  TRIGGER_TEN_MINUTES_REASON_DELETE = 23,
  /* 长时任务15min不更新删除 */
  TRIGGER_FIFTEEN_MINUTES_REASON_DELETE = 24,
  /* 长时任务30min兜底删除 */
  TRIGGER_THIRTY_MINUTES_REASON_DELETE = 25,
  /* 应用结束后再删除 */
  TRIGGER_START_ARCHIVE_REASON_DELETE = 26,
  /* 开发者设置删除时间，到期删除 */
  TRIGGER_AUTO_DELETE_REASON_DELETE = 27,
  /* 应用卸载删除通知 */
  PACKAGE_REMOVE_REASON_DELETE = 28,

  /* 实况胶囊隐藏（非ANS删除） */
  LIVE_CAPSULE_HIDE = 101,
}

/**
 * 通知解析错误码，1-1000
 */
export enum ParseNotificationErrorCode {
  /* 无wantAgent */
  NO_WANTAGENT = 1,
  /* 解析wantAgent信息失败 */
  NO_WANTAGENT_INFO = 2,
  /* wantAgent无包名 */
  WANTAGENT_NO_BUNDLE = 3,
  /* wantAgent无want信息 */
  WANTAGENT_NO_WANT = 4,
  /* 非SA无应用图标 */
  NO_APP_ICON = 5,
  /* SA无smallIcon且无应用图标 */
  NO_SA_ICON = 6,
  /* 无应用名称 */
  NO_APP_LABEL = 7,
  /* 无包名 */
  NO_BUNDLE = 8,
  /* 无应用uid */
  NO_UID = 9,
  /* 解析自定义铃声文件失败 */
  CUSTOM_SOUND_ERROR = 10,
  /* 解析实况数据失败 */
  LIVE_VIEW_ERROR = 11,
  /* 解析系统实况的按钮资源失败 */
  SYSTEM_LIVE_VIEW_BUTTON_ERROR = 12,
  /* 解析三方实况的胶囊图标资源失败 */
  OTHER_LIVE_VIEW_CAPSULE_ICON_ERROR = 13,
  /* 解析三方实况的扩展区图标资源失败 */
  OTHER_LIVE_VIEW_EXTEND_ICON_ERROR = 14,
  /* 非法的三方实况的扩展区类型 */
  OTHER_LIVE_VIEW_INVALID_LAYOUT = 15,
  /* 解析三方进度实况的指示器图标资源失败 */
  OTHER_LIVE_VIEW_PROGRESS_INDICATOR_ICON_ERROR = 16,
  /* 解析三方进度实况的进度节点图标资源失败 */
  OTHER_LIVE_VIEW_PROGRESS_NODE_ICON_ERROR = 17,
  /* 解析三方取餐类实况的描述图标资源失败 */
  OTHER_LIVE_VIEW_PICKUP_DESC_ICON_ERROR = 18,
  /* 解析三方航班类实况的分割图标资源失败 */
  OTHER_LIVE_VIEW_FLIGHT_SPACE_ICON_ERROR = 19,
  /* 解析三方比分类实况的主队图标资源失败 */
  OTHER_LIVE_VIEW_SCORE_HOST_ICON_ERROR = 20,
  /* 解析三方比分类实况的客队图标资源失败 */
  OTHER_LIVE_VIEW_SCORE_GUEST_ICON_ERROR = 21,
  /* 解析三方导航类实况的当前方向图标资源失败 */
  NAVIGATION_LIVE_VIEW_CURRENT_ICON_ERROR = 22,
  /* 解析三方导航类实况的所有方向图标资源失败 */
  NAVIGATION_LIVE_VIEW_DIRECTION_ICONS_ERROR = 23,

  /* ----可能的异常----  */
  /* remindFlag为0 */
  REMIND_FLAG_ZERO = 501,
  /* 自定义铃声没有亮屏或长振动 */
  CUSTOM_RING_BUT_NO_OTHER_CONTROL = 502,
  /* delivery time大于当前时间 */
  DELIVERY_TIME_INVALID = 503,

  /* 解析异常 */
  PARSE_FAILED = 999,
}