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

import hiSysEvent from '@ohos.hiSysEvent';
import { LogDomain, LogHelper, TaskpoolUtil } from './BasicCommon';
import { NTFControlParams, ReportParams } from './ReportParams';
import { notificationManager } from '@kit.NotificationKit';
import { notificationSettingManager } from '../manager/NotificationSettingManager';
import { BitUtil } from './BasicCommon';
import { ReportDomain } from './HiSysReportEvent';

export class BannerNotDisturbParams extends NTFControlParams {
  /**
   * 操作方式
   * 0 - 关闭
   * 1 - 打开
   */
  public IS_ON?: 0 | 1;
}

export class BannerNotificationHideManagementParams extends NTFControlParams {
  /**
   * 操作方式
   * 0 - 打开
   * 1 - 关闭
   */
  public IS_HIDE_BANNER_CONTENT?: 0 | 1;
}

export class BannerNotificationHidePageToFacePageParams extends NTFControlParams {
}

export enum NtfEventName {
  /**
   * 设置-通知和状态栏-单应用通知管理-单应用管理通知类别开关
   */
  NTF_SETTING_APP_MANAGEMENT_TYPE = 'NTF_SETTING_CATEGORY',
  /**
   * 设置-通知和状态栏-单应用通知管理-单应用管理通知
   * 事件id: 990230043
   */
  NTF_SETTING_APP_MANAGEMENT = 'NTF_SETTING_APP_MANAGEMENT',
  /**
   * 设置-通知和状态栏-单应用通知管理-点击进入应用通知设置
   * 事件id:
   */
  NTF_SETTING_CLICK_EVENT = 'NTF_SETTING_CLICK_EVENT',
  /**
   * 隐藏通知内容管理
   * 事件id: 990237021
   */
  NOTIFICATION_HIDE_MANAGEMENT = 'NOTIFICATION_HIDE_MANAGEMENT',
  /**
   * 通知亮屏管理
   * 事件id: 990237031
   */
  NOTIFICATION_SCREEN_MANAGEMENT = 'NOTIFICATION_SCREEN_MANAGEMENT',
  /**
   * 显示桌面角标
   */
  NOTIFICATION_SHOW_DESKTOP_BADGES = 'NOTIFICATION_SHOW_DESKTOP_BADGES',
  /**
   * 允许普通通知多屏协同开关
   */
  NTF_SWITCH_DISTRIBUTE_BUTTON = 'NTF_SWITCH_DISTRIBUTE_BUTTON',
  /**
   * 允许实况窗多屏协同开关
   */
  LIVE_VIEW_DISTRIBUTE_BUTTON = 'LIVE_VIEW_DISTRIBUTE_BUTTON',
  /**
   * 设置-通知和状态栏-状态栏
   * 事件id：990237045
   */
  NTF_SETTING_STATUS_BAR = 'NTF_SETTING_STATUS_BAR',
  NTF_ENTER_MORE_SETTING = 'NTF_ENTER_MORE_SETTING',
  NTF_LOCK_SCREEN_STYLE = 'NTF_LOCK_SCREEN_STYLE',
  NTF_MORE_SETTING_DISPLAY_PREVIEW = 'NTF_MORE_SETTING_DISPLAY_PREVIEW',
  LIVE_VIEW_DISPLAY_PREVIEW = 'LIVE_VIEW_DISPLAY_PREVIEW',
  NTF_CLICK_SEARCH_ITEM = 'NTF_CLICK_SEARCH_ITEM',
  NTF_SEARCH_APP = 'NTF_SEARCH_APP',
  NTF_CLICK_SEARCH_RESULT = 'NTF_CLICK_SEARCH_RESULT',
  NTF_CLEAR_SEARCH_HISTORY = 'NTF_CLEAR_SEARCH_HISTORY',
  NTF_SMART_DIGEST = 'NTF_SMART_DIGEST',
  NTF_PULL_UP_HALF_MODE = 'NTF_PULL_UP_HALF_MODE',
  NTF_CLOSE_HALF_MODE = 'NTF_CLOSE_HALF_MODE',
  /**
   * 智能隐藏横幅通知内容管理
   */
  BANNER_NOTIFICATION_HIDE_MANAGEMENT = 'BANNER_NTF_HIDE_MANAGEMENT',
  /**
   * 横幅通知免打扰
   */
  BANNER_NTF_NOT_DISTURB = 'BANNER_NTF_NOT_DISTURB',
  /**
   * 智能隐藏横幅通知跳转人脸页面
   */
  BANNER_NOTIFICATION_HIDE_PAGE_TO_FACE_PAGE = 'BANNER_NTF_HANDLE_FACE_MGT',
  /**
   * 通知和状态栏设置页面Title点击事件打点
   */
  NTF_SETTING_MODULE_CLICK_EVENT = 'NTF_SETTING_MODULE_CLICK_EVENT',
  /**
   * 实况窗开关切换打点
   */
  CLICK_LIVE_VIEW_SWITCH = 'CLICK_LIVE_VIEW_SWITCH',
  /**
   * 智能隐藏横幅内容跳转玩机技巧
   */
  BANNER_NTF_HIDE_TO_TIPS = 'BANNER_NTF_HIDE_TO_TIPS',
  /**
   * 切换应用和元服务标签页
   */
  SWITCH_APP_OR_META_SERVICE_PAGE = 'SWITCH_APP_OR_META_SERVICE_PAGE',
  /**
   * 未登录账号获取元服务列表前点击登录
   */
  META_SERVICE_TO_LOGIN_ACCOUNT = 'META_SERVICE_TO_LOGIN_ACCOUNT',
  /**
   * 元服务详情页跳转失败
   */
  JUMP_TO_DETAILS_PAGE_FAILED = 'JUMP_TO_DETAILS_PAGE_FAILED',
  /**
   * 设置-通知和状态栏-通知管理-点击前往应用管理-应用内通知管理
   */
  NTF_SETTING_CLICK_APP_INNER_MGMT = 'NTF_SETTING_CLICK_APP_INNER_MGMT',
}

export class NtfEntryParams extends NTFControlParams {
  /**
   * 通知id
   */
  public NOTIFICATION_ID?: number;

  /**
   * 创建通知应用包名
   */
  public CREATOR_BUNDLE_NAME?: string;

  /**
   * 通知通道类型
   * 0 - 未知类型
   * 1 - 社交类型
   * 2 - 服务类型
   * 3 - 内容类型
   * 4 - 实况类型
   */
  public NOTIFICATION_SLOT_TYPE?: number | string;
}

export class NotificationClickSearchResultParams extends NtfEntryParams {
  /**
   * 点击搜索关键词
   */
  public KEY_WORD?: string;
  public SEARCH_RESULT?: string;
}
export class NotificationSearchAppParams extends NtfEntryParams {
  /**
   * 点击搜索关键词
   */
  public KEY_WORD?: string;
}
export class NotificationDisplayPreviewParams extends NTFControlParams {
  /**
   * 锁屏时是否显示预览
   * 0 - 打开
   * 1 - 关闭
   */
  public NTF_MORE_SETTING_DISPLAY_PREVIEW?: 0 | 1;
}
export class LiveViewDisplayPreviewParams extends NTFControlParams {
  /**
   * 锁屏时是否显示实况窗预览
   * 0 - 打开
   * 1 - 关闭
   */
  public LIVE_VIEW_DISPLAY_PREVIEW?: 0 | 1;
}
export class NotificationScreenStyleParams extends NTFControlParams {
  /**
   * 锁屏通知显示样式
   * 0 - 高位
   * 1 - 低位
   */
  public NTF_SCREEN_LOCK_STYLE?: 0 | 1;
}
export class NotificationSettingAppManagementParams extends NTFControlParams {
  /**
   * 创建通知应用包名
   */
  public CREATOR_BUNDLE_NAME?: string;

  /**
   * 按钮名称
   * ALLOWED - 允许通知按钮
   * TOP - 置顶通知按钮
   * Lock - 提醒方式-锁屏通知按钮
   * BANNER - 提醒方式-横幅通知按钮
   * BADGE - 提醒方式-桌面角标按钮
   * RING - 通知铃声按钮
   * VIBRATION - 振动开关
   * SILENCE - 静默通知按钮
   */
  public SWITCH_ID?: string;

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
  public SWITCH_STATUS?: number;
}
export class NotificationSettingClickEventParams extends NTFControlParams {
  /**
   * 创建通知应用包名
   */
  public CREATOR_BUNDLE_NAME?: string;

  /**
   * 允许通知开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  public IS_ALLOW_STATE_ON?: number;

  /**
   * 置顶通知开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  public IS_TOP_STATE_ON?: number;

  /**
   * 静默通知开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  public IS_SILENCE_STATE_ON?: number;


  /**
   * 锁屏通知开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  public IS_LOCK_STATE_ON?: number;

  /**
   * 横幅通知开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  public IS_BANNER_STATE_ON?: number;

  /**
   * 桌面角标开关状态
   * 0 - 关闭
   * 1 - 打开
   */
  public IS_CORNER_STATE_ON?: number;

  /**
   * 通知铃声状态
   * 0 - 铃声和振动
   * 1 - 仅铃声
   * 2 - 仅振动
   * 3 - 静音
   */
  public NOTIFICATION_RING_STATE?: number;

  /**
   * 社交通讯
   * 0 - 关闭
   * 1 - 打开
   */
  public NOTIFICATION_SOCIAL_TYPE_STATE?: number;

  /**
   * 服务提醒
   * 0 - 关闭
   * 1 - 打开
   */
  public NOTIFICATION_SERVICE_TYPE_STATE?: number;

  /**
   * 内容咨询
   * 0 - 关闭
   * 1 - 打开
   */
  public NOTIFICATION_CONTENT_TYPE_STATE?: number;

  /**
   * 客服消息
   * 0 - 关闭
   * 1 - 打开
   */
  public NOTIFICATION_CUSTOMER_TYPE_STATE?: number;

  /**
   * 其他
   * 0 - 关闭
   * 1 - 打开
   */
  public NOTIFICATION_OTHER_TYPE_STATE?: number;

  /**
   * 点击跳转页面的应用类型
   * 0 - 应用
   * 1 - 元服务
   */
  public BUNDLE_TYPE?: number;
}
export class NotificationHideManagementParams extends NTFControlParams {
  /**
   * 操作方式
   * 0 - 打开
   * 1 - 关闭
   */
  public OPERATE_METHOD?: 0 | 1;
}
export class NotificationScreenManagementParams extends NTFControlParams {
  /**
   * 操作方式
   * 0 - 打开
   * 1 - 关闭
   */
  public OPERATE_METHOD?: 0 | 1;
}

export class NotificationShowDesktopBadgeParams extends NTFControlParams {
  /**
   * 操作方式
   * 0 - 打开
   * 1 - 关闭
   */
  public OPERATE_METHOD?: 0 | 1;
}

export class NotificationDistributionButtonParams extends NTFControlParams {
  /**
   * 操作方式
   * 0 - 打开
   * 1 - 关闭
   */
  public IS_DISTRIBUTE_BUTTON_ON?: 0 | 1;
}

export class NotificationLiveViewDistributionButtonParams extends NTFControlParams {
  /**
   * 操作方式
   * 0 - 打开
   * 1 - 关闭
   */
  public IS_LIVE_VIEW_DISTRIBUTE_ON?: 0 | 1;
}

export class PullUpHalfModeParams extends NTFControlParams {
  public FROM_APP?: string;
  public IS_SUCCESS?: number;
}

export class CloseHalfModeParams extends NTFControlParams {
  public FROM_APP?: string;
  public OPERATION_TYPE?: number;
}

export class NtfSettingModuleClickEventParams extends NTFControlParams {
  /**
   * 通知和状态栏管理入口类型：1-实况窗 2-状态栏 3-更多通知设置
   */
  public MODULE?: number;
}

export class ClickLiveViewSwitchParams extends NTFControlParams {
  /** 实况窗应用包名 */
  public PACKAGE?: string;
  /** 实况窗开关状态 */
  public STATUS?: string;
  /** 操作入口 */
  public SOURCRE?: string;
}

export class SwitchAppOrMetaServiceSegmentButton extends NTFControlParams {
  /**
   * 切换标签页所选中的页面
   * 0 - 应用
   * 1 - 元服务
   */
  public BUNDLE_TYPE?: number;
}

export class MetaServiceToLoginHuaweiAccount extends NTFControlParams {
  /**
   * 登录状态
   * 0 - 登录失败
   * 1 - 登录成功
   */
  public LOGIN_STATE?: 0 | 1;
  /**
   * 登录失败返回的错误码
   */
  public ERROR_CODE?: number;
}

export class JumpToDetailsPageFailedParams extends NTFControlParams {
  /**
   * 创建通知应用包名
   */
  public CREATOR_BUNDLE_NAME?: string;
  /**
   * 点击跳转页面的应用类型
   * 0 - 应用
   * 1 - 元服务
   */
  public BUNDLE_TYPE?: number;
  /**
   * 跳转失败的错误码
   */
  public ERROR_CODE?: number;
}

/**
 * 打点函数类
 */
export class NtfSettingSysEventReporter {
  /**
   * 上报域
   */
  public static NOTIFICATION_UE = 'NOTIFICATION_UE';

  public static async notificationSettingAppManagementTypeChange(params: NotificationSettingAppManagementParams):
    Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SETTING_APP_MANAGEMENT_TYPE,
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

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SETTING_APP_MANAGEMENT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 设置-通知和状态栏-单应用通知管理-点击进入应用通知设置
   */
  public static async notificationSettingClickEvent(bundleName: string, uid: number,
    bundleType: number = 0): Promise<void> {
    let bundleOption: notificationManager.BundleOption = { bundle: bundleName, uid: uid };
    let num = await notificationManager.getSlotFlagsByBundle(bundleOption);
    let slots = await notificationManager.getSlotsByBundle(bundleOption);
    let socialType = Number(slots.find((slot) => slot.notificationType ===
    notificationManager.SlotType.SOCIAL_COMMUNICATION)?.enabled);
    let serviceType =
      Number(slots.find((slot) => slot.notificationType === notificationManager.SlotType.SERVICE_INFORMATION)?.enabled);
    let contentType =
      Number(slots.find((slot) => slot.notificationType === notificationManager.SlotType.CONTENT_INFORMATION)?.enabled);
    let customerType =
      Number(slots.find((slot) => slot.notificationType === notificationManager.SlotType.CUSTOMER_SERVICE)?.enabled);
    let otherType =
      Number(slots.find((slot) => slot.notificationType === notificationManager.SlotType.OTHER_TYPES)?.enabled);

    let params: NotificationSettingClickEventParams = {
      CREATOR_BUNDLE_NAME: bundleName,
      IS_ALLOW_STATE_ON: Number(await notificationManager.isNotificationEnabled(bundleOption)),
      IS_TOP_STATE_ON: Number(await notificationSettingManager.getPinTopState(uid)),
      IS_SILENCE_STATE_ON: Number(await notificationSettingManager.getSilenceState(bundleName, uid)),
      IS_LOCK_STATE_ON: Number(BitUtil.getStateByIdx(num, 1)),
      IS_BANNER_STATE_ON: Number(BitUtil.getStateByIdx(num, 2)),
      IS_CORNER_STATE_ON: Number(await notificationManager.isBadgeDisplayed(bundleOption)),
      NOTIFICATION_RING_STATE: BitUtil.getStateByIdx(num, 0) ?
        (BitUtil.getStateByIdx(num, 4) ? 0 : 1) : (BitUtil.getStateByIdx(num, 4) ? 2 : 3),

      NOTIFICATION_SOCIAL_TYPE_STATE: isNaN(socialType) ? 1 : socialType,
      NOTIFICATION_SERVICE_TYPE_STATE: isNaN(serviceType) ? 1 : serviceType,
      NOTIFICATION_CONTENT_TYPE_STATE: isNaN(contentType) ? 1 : contentType,
      NOTIFICATION_CUSTOMER_TYPE_STATE: isNaN(customerType) ? 1 : customerType,
      NOTIFICATION_OTHER_TYPE_STATE: isNaN(otherType) ? 1 : otherType,
      BUNDLE_TYPE: bundleType,
    };

    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SETTING_CLICK_EVENT,
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

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
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

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_SCREEN_MANAGEMENT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 显示桌面角标
   */
  public static async notificationShowDesktopBadge(params: NotificationShowDesktopBadgeParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NOTIFICATION_SHOW_DESKTOP_BADGES,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 允许普通通知多屏协同开关
   */
  public static async NotificationDistributionButton(params: NotificationDistributionButtonParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SWITCH_DISTRIBUTE_BUTTON,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 允许实况窗多屏协同开关
   */
  public static async NotificationLiveViewDistributionButtonParams(
    params: NotificationLiveViewDistributionButtonParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.LIVE_VIEW_DISTRIBUTE_BUTTON,
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

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SETTING_STATUS_BAR,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-通知和状态栏-点击更多通知设置
   */
  public static async notificationMoreSetting(): Promise<void> {
    let params: NTFControlParams = {};
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_ENTER_MORE_SETTING,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知和状态栏设置页面Title点击事件打点
   *
   * @param module 通知和状态栏管理入口类型：1-实况窗 2-状态栏 3-更多通知设置
   */
  public static async reportNtfSettingModuleClickEvent(module: number): Promise<void> {
    let params: NtfSettingModuleClickEventParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: await ReportParams.getVersionCode(),
      MODULE: module,
    };
    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SETTING_MODULE_CLICK_EVENT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 实况开关点击切换打点
   *
   * @param packageName 实况窗应用包名
   * @param status 实况窗开关状态
   * @param source 操作入口
   */
  public static async reportClickLiveViewSwitch(packageName: string, status: boolean, source: string): Promise<void> {
    let params: ClickLiveViewSwitchParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: await ReportParams.getVersionCode(),
      PACKAGE: packageName,
      STATUS: status ? 'on' : 'off',
      SOURCRE: source,
    };
    NtfSettingSysEventReporter.report(
      ReportDomain.SETTINGS_APP_UE,
      NtfEventName.CLICK_LIVE_VIEW_SWITCH,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-通知和状态栏-更多通知设置-切换锁屏通知样式
   */
  public static async notificationLockScreenStyle(params: NotificationScreenStyleParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_LOCK_SCREEN_STYLE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-通知和状态栏-更多通知设置-切换通知预览
   */
  public static async notificationDisplayPreview(params: NotificationDisplayPreviewParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_MORE_SETTING_DISPLAY_PREVIEW,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-通知和状态栏-更多设置-切换实况窗预览
   */
  public static async liveViewDisplayPreview(params: LiveViewDisplayPreviewParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.LIVE_VIEW_DISPLAY_PREVIEW,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-通知和状态栏-搜索-点击搜索框
   */
  public static async notificationClickSearch(): Promise<void> {
    let params: NTFControlParams = {};
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_CLICK_SEARCH_ITEM,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-通知和状态栏-搜索-点击搜索结果
   */
  public static async notificationClickSearchResult(params: NotificationClickSearchResultParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_CLICK_SEARCH_RESULT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-通知和状态栏-搜索-清空搜索记录
   */
  public static async notificationClearSearchHistory(): Promise<void> {
    let params: NTFControlParams = {};
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_CLEAR_SEARCH_HISTORY,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知-通知和状态栏-搜索应用
   */
  public static async notificationSearchApp(params: NotificationSearchAppParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SEARCH_APP,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 设置-通知和状态栏-更多通知设置-智能摘要
   */
  public static async notificationSmartDigest(params: NotificationScreenManagementParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SMART_DIGEST,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 应用_通知管理_拉起通知管理半模态
   */
  public static async notificationPullUpHalfMode(params: PullUpHalfModeParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_PULL_UP_HALF_MODE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 应用_通知管理_关闭通知管理半模态
   */
  public static async notificationCloseHalfMode(params: CloseHalfModeParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_CLOSE_HALF_MODE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 智能隐藏横幅通知内容管理
   */
  public static async bannerNotificationHideManagement(params: BannerNotificationHideManagementParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.BANNER_NOTIFICATION_HIDE_MANAGEMENT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 横幅通知免打扰
   */
  public static async bannerNotDisturb(params: BannerNotDisturbParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.BANNER_NTF_NOT_DISTURB,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 智能隐藏横幅通知点击跳转到人脸设置页打点
   */
  public static async bannerNotificationHidePageToFacePage(params: BannerNotificationHidePageToFacePageParams):
    Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.BANNER_NOTIFICATION_HIDE_PAGE_TO_FACE_PAGE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 智能隐藏横幅内容跳转玩机技巧
   */
  public static async bannerNotificationHidePageToTipsPage(params: NTFControlParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.BANNER_NTF_HIDE_TO_TIPS,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 切换应用和元服务标签页
   */
  public static async switchAppOrMetaServicePage(params: SwitchAppOrMetaServiceSegmentButton): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.SWITCH_APP_OR_META_SERVICE_PAGE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 未登录账号获取元服务列表前点击登录
   */
  public static async metaServiceToLoginAccount(params: MetaServiceToLoginHuaweiAccount): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.META_SERVICE_TO_LOGIN_ACCOUNT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 元服务详情页跳转失败
   */
  public static async jumpToDetailsPageFailed(params: JumpToDetailsPageFailedParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.JUMP_TO_DETAILS_PAGE_FAILED,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 通知中心-左滑通知-点击前往应用管理-应用内通知管理
   */
  public static async ntfSettingOpenAppInnerMgmt(params: NtfEntryParams): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();

    NtfSettingSysEventReporter.report(
      NtfSettingSysEventReporter.NOTIFICATION_UE,
      NtfEventName.NTF_SETTING_CLICK_APP_INNER_MGMT,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 打点基础接口
   *
   * @deprecated
   * @useinstead HiSysReportEvent#reportFault/reportStatistic/reportSecurity/reportBehavior
   * @param domain 事件领域
   * @param name 事件名称
   * @param eventType 事件类型
   * @param params 事件参数
   */
  private static report(domain: string, name: string, eventType: hiSysEvent.EventType, params: Object): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: domain,
      name: name,
      eventType: eventType,
      params: params
    };
    TaskpoolUtil.doTask(reportHiSysEvent, sysEventInfo);
  }
}

async function reportHiSysEvent(sysEventInfo: hiSysEvent.SysEventInfo): Promise<void> {
  'use concurrent';
  const TAG = 'NtfSettingSysEventReporter';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
  try {
    hiSysEvent.write(sysEventInfo)
      .catch(
        (err: ErrorCode) => {
          log.error('reportHiSysEvent error:' + err?.code + ', message:' + err?.message);
        }
      )
      .then(
        val => {
          log.showInfo(`reportHiSysEvent ${sysEventInfo.name} success.`);
        });
  } catch (err) {
    log.error('reportHiSysEvent error:' + err?.code + ', message:' + err?.message);
  }
}

interface ErrorCode {
  code?: string;
  message?: string;
}