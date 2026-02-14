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
import { CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import { HiSysDataShowHide } from './HiSysData';
import { HiSysReportEvent, ReportDomain } from './HiSysReportEvent';
import type {
  ApplicationParams,
  ButtonEventParams,
  ClickParams,
  CommParams,
  DefaultParams,
  DelayReportParams,
  DeleteNtfOverLimitParams,
  DeleteParams,
  ExpandVolPanelParams,
  InManageAllParams,
  ItemClickParams,
  KeyboardStateParams,
  ManageAllParams,
  NotificationParams,
  NtfSetPinTopParams,
  PluginFailedParams,
  GetSnapshotFailed,
  QuickToggleRingModeParams,
  RotationEndParams,
  ScreenOnAnimationReportParams,
  SwipeSwitchParams,
  SwitchToPasswordParams,
  SystemMenuClickParams,
  ToggleParams,
  UnlockToDesktopParams,
  WakeScreenParams,
  AppCategoryParams,
  UnlockFailedParams,
  AccountAbnormalParams,
  FolderNaviNoTrigParams,
  RDBAbnormalParams,
  CacheAbnormalParams,
  RefreshAbnormalParams,
  IconStatusAbnormalParams,
  DockRegionTypeItemsCountParams,
  IconLostAbnormalParams,
  FolderNumsParams,
  ItemNumsParams,
  ChangeThemeParams,
  LoadedDesktopParams,
  ChangeThemeSlideOrStartParams,
  ReportCardFaultInformationEvent,
  ReportCardFaultInformationParams,
} from './ReportParams';
import {
  ReportParams
} from './ReportParams';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'HiDfxEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const GRIDLAYOUT_INFO = 'gridlayout_info';

/**
 * 大数据维测相关打点工具类
 */
export class HiDfxEventUtil {
  public static STATE_OPEN: number = 1;
  public static STATE_CLOSE: number = 0;
  public static ENTER_PAGE: number = 1;
  public static LEAVE_PAGE: number = 2;
  public static NTF_MANAGE_PAGE: string = 'NTF_MANAGE_PAGE';
  public static SHOT_FULL_SCREEN: number = 0;
  public static TOGGLE_TYPE_CLICK: number = 0;
  public static TOGGLE_TYPE_LONG_CLICK: number = 1;
  public static TOGGLE_TYPE_INTENT: number = 2;
  // 桌面元素加载完成打点
  public static UNLOCK_TO_GRID_ANIMATION_BEGIN = 'UNLOCK_TO_GRID_ANIMATION_BEGIN';
  public static UNLOCK_TO_GRID_ANIMATION_END = 'UNLOCK_TO_GRID_ANIMATION_END';
  public static UNLOCK_TO_DOCK_ANIMATION_BEGIN = 'UNLOCK_TO_DOCK_ANIMATION_BEGIN';
  public static UNLOCK_TO_DOCK_ANIMATION_END = 'UNLOCK_TO_DOCK_ANIMATION_END';
  public static UNLOCK_TO_STATUSBAR_END = 'UNLOCK_TO_STATUSBAR_END';
  // 显示 通知中心/控制中心 异常打点
  private static readonly SHOW_NTF_CONTROL_PANEL_ABNORMAL: string = 'SHOW_NTF_CONTROL_PANEL_ABNORMAL';
  // 隐藏 通知中心/控制中心 异常打点
  private static readonly HIDE_NTF_CONTROL_PANEL_ABNORMAL: string = 'HIDE_NTF_CONTROL_PANEL_ABNORMAL';
  // 横幅通知显示 异常打点
  private static readonly HEADS_UP_SHOW_ABNORMAL: string = 'HEADS_UP_SHOW_ABNORMAL';
  // 桌面元素位置异常
  private static readonly ELEMENT_POSITION_ABNORMAL: string = 'ELEMENT_POSITION_ABNORMAL';
  // 桌面数据库异常
  private static readonly LAUNCHER_DB_ABNORMAL: string = 'LAUNCHER_DB_ABNORMAL';
  // 故障打点
  private static readonly PLUGIN_FAILD: string = 'PLUGIN_FAILD';
  // 设备开机时图标丢失打点
  private static readonly ICON_MISS_ERROR = 'ICON_MISS_ERROR';
  //2x4大文件夹使用引导弹窗未触发引导故障上报
  private static readonly FOLDER_NAVI_NO_TRIG = 'FOLDER_NAVI_NO_TRIG';
  // 一屏一世界获取桌面截图失败打点
  private static readonly GET_SNAPSHOT_FAILED = 'GET_SNAPSHOT_FAILED';
  // 应用的分类信息异常打点
  private static readonly APP_CATEGORY_INFO_MISS = 'APP_CATEGORY_INFO_MISS';

  // SCBScenePanel rotation end
  private static readonly SCENE_PANEL_ROTATION_END: string = 'SCENE_PANEL_ROTATION_END';
  private static readonly BRIGHTNESS_DRAG: string = 'BRIGHTNESS_DRAG';
  private static readonly INPUT_CLICK: string = 'INPUT_CLICK';
  private static readonly WLAN_CLICK: string = 'WLAN_CLICK';
  private static readonly CLOCK_CLICK: string = 'CLOCK_CLICK';
  private static readonly NOTIFICATION_CLICK: string = 'NOTIFICATION_CLICK';
  private static readonly CONTROL_CLICK: string = 'CONTROL_CLICK';
  private static readonly SEARCH_CLICK: string = 'SEARCH_CLICK';
  private static readonly BLUETOOTH_CLICK: string = 'BLUETOOTH_CLICK';
  /**
   * 控制中心点位
   */
  private static readonly TOGGLE_CLICK: string = 'TOGGLE_CLICK';
  private static readonly TOGGLE_DATA_CHANGED: string = 'TOGGLE_DATA_CHANGED';
  private static readonly TOGGLE_EDIT_STATE: string = 'TOGGLE_EDIT_STATE';
  // 拖动快捷编辑
  private static readonly TOGGLE_EDIT_DRAG: string = 'TOGGLE_EDIT_DRAG';
  // 横滑切换通知中心/控制中心
  private static readonly SWIPE_SWITCH_CONTROL_NTF: string = 'SWIPE_SWITCH_CONTROL_NTF';
  // 控制中心显示隐藏
  private static readonly CONTROL_CENTER_SHOW_HIDE: string = 'CONTROL_CENTER_SHOW_HIDE';
  // 通知中心显示隐藏
  private static readonly NOTIFICATION_PANEL_SHOW_HIDE: string = 'NOTIFICATION_PANEL_SHOW_HIDE';
  // 点击通知 打点
  private static readonly CLICK_NOTIFICATION: string = 'CLICK_NOTIFICATION';
  // 控制中心 多用户点击 打点
  private static readonly CONTROL_CENTER_USER_CLICK: string = 'CONTROL_CENTER_USER_CLICK';
  // 通知内注册了事件的按钮点击 打点
  private static readonly NOTIFICATION_BUTTON_CLICK: string = 'NOTIFICATION_BUTTON_CLICK';
  // 快捷开关页_编辑后完成重置 打点
  private static readonly QUICK_TOGGLE_PAGE_RESET: string = 'QUICK_TOGGLE_PAGE_RESET';
  // 快捷开关页_编辑后点击完成 打点
  private static readonly QUICK_TOGGLE_PAGE_FINISH: string = 'QUICK_TOGGLE_PAGE_FINISH';
  // 快捷开关页_编辑后重置弹框里点取消 打点
  private static readonly QUICK_TOGGLE_EDIT_RESET_CANCEL: string = 'QUICK_TOGGLE_EDIT_RESET_CANCEL';
  // 快捷开关页_编辑后重置弹框里点重置 打点
  private static readonly QUICK_TOGGLE_EDIT_RESET_RESET: string = 'QUICK_TOGGLE_EDIT_RESET_RESET';
  // 切换用户 打点
  private static readonly SWITCH_ACCOUNT: string = 'SWITCH_ACCOUNT';
  // 控制中心_点击多用户_更多设置 打点
  private static readonly ACCOUNT_MORE_SETTING: string = 'ACCOUNT_MORE_SETTING';
  // 点击多用户后退出 打点
  private static readonly ACCOUNT_MENU_CANCEL: string = 'ACCOUNT_MENU_CANCEL';
  // 添加用户 打点
  private static readonly QUICK_TOGGLE_RING_MODE: string = 'QUICK_TOGGLE_RING_MODE';
  // 通知页_点击展开长通知 打点
  private static readonly NOTIFICATION_EXPAND_CLICK: string = 'NOTIFICATION_EXPAND_CLICK';
  // 通知页_点击展开收起组合通知 打点
  private static readonly NTF_GROUP_EXPAND_CLICK: string = 'NTF_GROUP_EXPAND_CLICK';
  // 通知栏_点击时间 打点
  private static readonly NOTIFICATION_PANEL_CLICK_TIME: string = 'NOTIFICATION_PANEL_CLICK_TIME';
  // 通知栏_点击日期 打点
  private static readonly NOTIFICATION_PANEL_CLICK_DATE: string = 'NOTIFICATION_PANEL_CLICK_DATE';
  // 通知栏_点击设置 打点
  private static readonly NTF_PANEL_CLICK_SETTING: string = 'NTF_PANEL_CLICK_SETTING';
  // 左滑通知点击设置按钮--点击更多设置 打点
  private static readonly NTF_MENU_CLICK_MORE_SETTING: string = 'NTF_MENU_CLICK_MORE_SETTING';
  // 左滑通知点击设置按钮 打点
  private static readonly NTF_MENU_CLICK_SETTING: string = 'NTF_MENU_CLICK_SETTING';
  // 通知置顶的操作类型 打点
  private static readonly NOTIFICATION_SET_PIN_TOP: string = 'NOTIFICATION_SET_PIN_TOP';
  // 展示音量面板 打点
  private static readonly SHOW_SINGLE_VOL_BAR: string = 'SHOW_SINGLE_VOL_BAR';
  // 隐藏音量面板 打点
  private static readonly HIDE_SINGLE_VOL_BAR: string = 'HIDE_SINGLE_VOL_BAR';
  // 展开收起音量面板 打点
  private static readonly EXPAND_VOL_PANEL: string = 'EXPAND_VOL_PANEL';
  // 点击音量面板上的设置 打点
  private static readonly VOL_PANEL_CLICK_SETTING: string = 'VOL_PANEL_CLICK_SETTING';
  // 音量面板点击取消静音-通话、媒体、铃声音量 打点
  private static readonly VOL_PANEL_CLICK_CANCEL_MUTE: string = 'VOL_PANEL_CLICK_CANCEL_MUTE';
  // 音量面板点击静音-通话、媒体、铃声音量 打点
  private static readonly VOL_PANEL_CLICK_MUTE: string = 'VOL_PANEL_CLICK_MUTE';
  // 设置或取消通知的静默状态 打点
  private static readonly SET_PKG_NTF_SILENCE_MODE: string = 'SET_PKG_NTF_SILENCE_MODE';
  // 左滑通知_点击删除项 打点
  private static readonly CLICK_DELETE_IN_NTF_MENU: string = 'CLICK_DELETE_IN_NTF_MENU';
  // 左滑通知_调出设置项 打点
  private static readonly LEFT_SWIPE_NTF_SHOW_MENU: string = 'LEFT_SWIPE_NTF_SHOW_MENU';
  // 左滑通知_点击设置_弹出框中点击取消 打点
  private static readonly NTF_SETTING_DLG_CLICK_CANCEL: string = 'NTF_SETTING_DLG_CLICK_CANCEL';
  // 左滑通知_点击设置_点击’关闭通知’按钮 打点
  private static readonly NTF_MENU_CLICK_DISABLE_NTF: string = 'NTF_MENU_CLICK_DISABLE_NTF';
  // 左滑通知_点击设置_点击’关闭通知’按钮_弹框点击取消 打点
  private static readonly NTF_MENU_DISABLE_CLICK_CANCEL: string = 'NTF_MENU_DISABLE_CLICK_CANCEL';
  // 左滑通知_点击设置_点击’关闭通知’按钮_弹框点击关闭 打点
  private static readonly NTF_MENU_DISABLE_CLICK_DISABLE: string = 'NTF_MENU_DISABLE_CLICK_DISABLE';
  // 快捷开关二级选项点击 打点
  private static readonly QUICK_TOGGLE_SUB_MENU_CLICK: string = 'QUICK_TOGGLE_SUB_MENU_CLICK';
  // 通知中心跳转通知设置界面 打点
  private static readonly NTF_PANEL_JUMP_NTF_MANAGEMENT: string = 'NTF_PANEL_JUMP_NTF_MANAGEMENT';
  // 物理键调节音量面板 打点
  private static readonly ADJUST_VOL_BY_PRESS_BUTTON: string = 'ADJUST_VOL_BY_PRESS_BUTTON';
  // 上手划音量条选中的面板 打点
  private static readonly SLIDE_SELECTED_VOL_BAR: string = 'SLIDE_SELECTED_VOL_BAR';
  // 控制中心跳转系统设置界面 打点
  private static readonly CONTROL_CENTER_JUMP_SETTING: string = 'CONTROL_CENTER_JUMP_SETTING';
  // 带回复的通知，点击回复 打点
  private static readonly NTF_REPLY_CLICK: string = 'NTF_REPLY_CLICK';
  // 带回复的通知，输入文字 打点
  private static readonly NTF_REPLY_INPUT_CONTENT: string = 'NTF_REPLY_INPUT_CONTENT';
  // 带回复的通知，点击发送 打点
  private static readonly NTF_REPLY_SEND: string = 'NTF_REPLY_SEND';
  // PC右上角关闭通知按钮点击 打点
  private static readonly DELETE_NTF_BY_CLOSE: string = 'DELETE_NTF_BY_CLOSE';
  // PC右上角设置-更多设置 打点
  private static readonly NTF_RIGHT_TOP_MENU_MORE_SETTING: string = 'NTF_RIGHT_TOP_MENU_MORE_SETTING';
  // PC右上角设置-关闭此通知 打点
  private static readonly NTF_RIGHT_TOP_MENU_DISABLE_NTF: string = 'NTF_RIGHT_TOP_MENU_DISABLE_NTF';

  /**
   * 通知管理点位
   */
  // 通知管理状态栏入口
  private static readonly NTF_MANAGEMENT_STATUS_BAR: string = 'NTF_MANAGEMENT_STATUS_BAR';
  // 通知管理状态栏中纯净显示开关打点
  private static readonly SIMPLE_DISPLAY: string = 'SIMPLE_DISPLAY';
  // 通知管理状态栏中显示通知图标开关打点
  private static readonly SHOW_APP_NOTIFICATION_ICONS: string = 'SHOW_APP_NOTIFICATION_ICONS';
  // 通知管理状态栏中显示实时网速开关打点
  private static readonly SHOW_NETWORK_SPEED: string = 'SHOW_NETWORK_SPEED';
  // 隐藏通知内容开关
  private static readonly HIDE_NOTIFICATION_CONTENT: string = 'HIDE_NOTIFICATION_CONTENT';
  // 通知亮屏提示
  private static readonly WAKE_SCREEN: string = 'WAKE_SCREEN';
  // 进入批量管理
  private static readonly MANAGE_ALL: string = 'MANAGE_ALL';
  // 批量管理中操作开关
  private static readonly SWITCH_IN_MANAGE_ALL: string = 'SWITCH_IN_MANAGE_ALL';
  // 应用通知管理页面
  private static readonly APPLICATION_NOTIFICATION_MANAGEMENT: string = 'APPLICATION_NTF_MANAGEMENT';
  // 应用通知管理页面，总开关
  private static readonly NOTIFICATION_MANAGEMENT_ALLOW_NOTIFICATION: string = 'NOTIFICATION_MANAGEMENT_ALLOW';
  // 应用通知管理页面，提醒方式中锁屏通知设置
  private static readonly NOTIFICATION_STYLE_LOCK_SCREEN: string = 'NOTIFICATION_STYLE_LOCK_SCREEN';
  // 应用通知管理页面，提醒方式中横幅通知设置
  private static readonly NOTIFICATION_STYLE_BANNERS: string = 'NOTIFICATION_STYLE_BANNERS';
  // 一键删除所有通知
  private static readonly DELETE_ALL_NOTIFICATION: string = 'DELETE_ALL_NOTIFICATION';
  // 滑动删除通知
  private static readonly DELETE_NOTIFICATION_BY_SWIPE: string = 'DELETE_NOTIFICATION_BY_SWIPE';
  // 上滑隐藏通知
  private static readonly SWIPE_IGNORE_BANNER_NTF: string = 'SWIPE_IGNORE_BANNER_NTF';
  // 控制中心点击截图 打点
  private static readonly SCREENSHOT_BY_CONTROL_CENTER: string = 'SCREENSHOT_BY_CONTROL_CENTER';
  // 媒体控制 打点
  private static readonly CONTROL_CENTER_MEDIA: string = 'CONTROL_CENTER_MEDIA';
  // 删除超出个数限制的通知 打点
  private static readonly DELETE_NTF_OVER_LIMIT: string = 'DELETE_NTF_OVER_LIMIT';
  // 进入、退出通知和状态栏管理页面 打点
  private static readonly NTF_MANAGEMENT: string = 'NTF_MANAGEMENT';

  // 输入法键盘显示隐藏
  private static readonly KEYBOARD_SHOW_HIDE: string = 'KEYBOARD_SHOW_HIDE';

  private static readonly SCREENON_EVENT: string = 'SCREENON_EVENT';
  private static readonly SCREENOFF_EVENT: string = 'SCREENOFF_EVENT';
  private static readonly USER_SWITCH_EVENT: string = 'USER_SWITCH_EVENT';
  private static readonly SCREENUNLOCK_NO_PWD_EVENT: string = 'SCREENUNLOCK_NO_PWD_EVENT';
  private static readonly SWITCH_PASSWORD_PAGE_EVENT: string = 'SWITCH_PASSWORD_PAGE_EVENT';
  private static readonly CLICK_BUTTON_EVENT: string = 'CLICK_BUTTON_EVENT';
  private static readonly SHUTDOWN_EVENT: string = 'SHUTDOWN_EVENT';
  private static readonly PASSWORD_DELETE_EVENT: string = 'PASSWORD_DELETE_EVENT';
  private static readonly PASSWORD_BACK_EVENT: string = 'PASSWORD_BACK_EVENT';
  private static readonly START_UNLOCK: string = 'START_UNLOCK';
  private static readonly BOX_ID = 'DESKTOP';
  private static readonly SWITCH_VIEW = 'SWITCH_VIEW';
  private static readonly SWITCH_SORT = 'SWITCH_SORT';
  private static readonly DESKTOP_RIGHT_MENU_CLICK = 'DESKTOP_RIGHT_MENU_CLICK';
  // screen on animation
  private static readonly SCREEN_ON_ANIMATION = 'SCREEN_ON_ANIMATION';
  // 数据库异常
  private static readonly LAUNCHER_RDB_ABNORMAL = 'LAUNCHER_RDB_ABNORMAL';
  // 桌面缓存更新异常
  private static readonly LAUNCHER_CACHE_ABNORMAL = 'LAUNCHER_CACHE_ABNORMAL';
  // 桌面布局异常,统计类型
  private static readonly LAUNCHER_LAYOUT_ABNORMAL = 'LAUNCHER_LAYOUT_ABNORMAL';
  // 图标状态异常
  private static readonly ICON_STATUS_ABNORMAL = 'ICON_STATUS_ABNORMAL';
  // 桌面文件夹数量超过16个，故障上报
  private static readonly FOLDER_NUM_MORE_16 = 'FOLDER_NUM_MORE_16';
  // 桌面图标超过200个（文件夹除外），故障上报
  private static readonly ITEM_NUM_MORE_200 = 'ITEM_NUM_MORE_200';
  // 换主题超过5s，故障上报
  private static readonly CHANGE_THEME_TIME = 'CHANGE_THEME_TIME';
  // 加载桌面超过5s，故障上报
  private static readonly LOADED_DESKTOP_TIME = 'LOADED_DESKTOP_TIME';
  // 切换主题时，有滑动或者启动app操作
  private static readonly CHANGE_TMEME_SLIDE_START = 'CHANGE_TMEME_SLIDE_START';
  // Dock区图标数量
  private static readonly DOCK_REGION_ITEMS_COUNT = 'DOCK_REGION_ITEMS_COUNT';

  /**
   * 桌面卡片点位
   */
  // 服务卡片创建异常
  public static readonly BUILD_CARD_ERROR: string = 'BUILD_CARD_ERROR';
  // 服务卡片返回id异常
  public static readonly BUILD_CARD_INVALID_FORMID: string  = 'BUILD_CARD_INVALID_FORMID';
  // 主题卡创建异常
  public static readonly BUILD_THEME_CARD_ERROR = 'BUILD_THEME_CARD_ERROR';
  // 堆叠卡片创建异常
  public static readonly BUILD_STACK_CARD_ERROR: string = 'BUILD_STACK_CARD_ERROR';
  // 堆叠卡片返回id异常
  public static readonly BUILD_STACK_CARD_INVALID_FORMID: string  = 'BUILD_STACK_CARD_INVALID_FORMID';
  // 卡片操作数据库异常
  public static readonly CARD_OPERATE_RDB_ERROR: string = 'CARD_OPERATE_RDB_ERROR';
  // 堆叠清脏退化为单卡
  public static readonly DIRTY_FORM_STACK_DEGRADATION: string = 'DIRTY_FORM_STACK_DEGRADATION';
  // 重启清除无效卡
  public static readonly CLEAR_INVALID_CARDS: string = 'CLEAR_INVALID_CARDS';
  // 卡片报错信息上报
  private static readonly REPORT_CARD_FAULT_INFORMATION: string = 'REPORT_CARD_FAULT_INFORMATION';

  private static REPORT_DELAY_TIME = 500;
  /* 延迟上报的事件容器 */
  static delayReportEventMap: Map<string, DelayReportParams> = new Map();
  private static mHiDfxEventUtil: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.SCENE_BOARD_APP);

  /**
   * 显示通知中心/控制中心异常 打点
   */
  static reportShowDropdownPanelAbnormal(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.SHOW_NTF_CONTROL_PANEL_ABNORMAL);
  }

  /**
   * 一屏一世界获取桌面截图失败打点
   */
  static reportGetSnapshotFailed(errorInfo: string, time: number): void {
    let params: GetSnapshotFailed = {
      ERROR_INFO: errorInfo,
      CURRENT_TIME: time
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.GET_SNAPSHOT_FAILED, params);
  }

  /**
   * 隐藏通知中心/控制中心异常 打点
   */
  static reportHideDropdownPanelAbnormal(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.HIDE_NTF_CONTROL_PANEL_ABNORMAL);
  }

  /**
   * 显示横幅通知异常 打点
   */
  static reportHeadsUpShowAbnormal(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.HEADS_UP_SHOW_ABNORMAL);
  }

  static reportPluginFailed(bundleName: string, failType: number, failMsg: string): void {
    let params: PluginFailedParams = {
      BUNDLENAME: bundleName,
      EVENT_TYPE: failType,
      FAULT_MSG: failMsg
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.PLUGIN_FAILD, params);
  }

  /**
   * report BMS appList different from RDB, icon miss
   */
  static reportIconMissError(): void {
    let params: DefaultParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.ICON_MISS_ERROR, params);
  }

  /**
   * 桌面获取的应用的分类信息异常 打点
   */
  public static reportAppCategoryInfoMiss(bundleName: string, secondaryCategoryId: number, errorCode: number): void {
    let params: AppCategoryParams = {
      BUNDLE_NAME: bundleName,
      SECONDARY_CATEGORY_ID: secondaryCategoryId,
      ERROR_CODE: errorCode
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.APP_CATEGORY_INFO_MISS, params);
  }

  /**
   * 桌面数据库异常 打点
   */
  static reportLauncherDbAbnormal(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.LAUNCHER_DB_ABNORMAL);
  }

  /**
   * 桌面元素位置异常 打点
   */
  static reportElementPositionAbnormal(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.ELEMENT_POSITION_ABNORMAL);
  }

  /**
   * report when SCBScenePanel rotation end
   */
  public static reportScenePanelRotationEnd(
    rotationStartTime: string, screenId: number, scenePanelName: string, rotationDuration: number): void {
    let params: RotationEndParams = {
      ROTATION_START_TIME: rotationStartTime,
      SCREEN_ID: screenId,
      SCENE_PANEL_NAME: scenePanelName,
      ROTATION_DURATION: rotationDuration
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SCENE_PANEL_ROTATION_END, params);
  }

  /**
   * 文件夹数量超过16个,故障上报
   */
  public static reportFolderNumIsMore(folderNum: number): void {
    let params: FolderNumsParams = {
      FOLDER_NUM: folderNum
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.FOLDER_NUM_MORE_16, params);
  }

  /**
   * 图标数量超过200个，故障上报
   */
  public static reportItemIsMore(itemNum: number): void {
    let params: ItemNumsParams = {
      ITEM_NUM: itemNum
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.ITEM_NUM_MORE_200, params);
  }

  /**
   * 切换主题，所用图标加载完耗时
   */
  public static reportChangeThemeTime(timeNum: number): void {
    let params: ChangeThemeParams = {
      USE_TIME: timeNum
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.CHANGE_THEME_TIME, params);
  }

  /**
   * 切换主题，有滑动桌面或者启动操作
   */
  public static reportChanThemSlideOrStart(slide: boolean, start: boolean): void {
    let params: ChangeThemeSlideOrStartParams = {
      SLIDE_ACTION: slide,
      START_ACTION: start
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.CHANGE_TMEME_SLIDE_START, params);
  }

  /**
   * 加载桌面耗时
   */
  public static reportLoadedDesktopTime(timeNum: number): void {
    let params: LoadedDesktopParams = {
      USE_TIME: timeNum
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.LOADED_DESKTOP_TIME, params);
  }

  /**
   * 2x4大文件夹弹框未使能故障 打点
   */
  public static reportFolderNaviNoTrig(checkCount: number): void {
    let params: FolderNaviNoTrigParams = {
      CHECK_COUNT: checkCount
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.FOLDER_NAVI_NO_TRIG, params);
  }

  /**
   * PC状态栏 拖动亮度条打点
   *
   */
  static reportBrightnessDrag(progress: number): void {
    let params: CommParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PROGRESS: progress
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.BRIGHTNESS_DRAG, params);
  }

  /**
   * PC状态栏 输入法图标点击打点
   *
   */
  static reportInputClick(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.INPUT_CLICK);
  }

  /**
   * PC状态栏 WLAN图标点击打点
   *
   */
  static reportWlanClick(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.WLAN_CLICK);
  }

  /**
   * PC状态栏 时钟图标点击打点
   *
   */
  static reportClockClick(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.CLOCK_CLICK);
  }

  /**
   * PC状态栏 通知中心图标点击打点
   *
   */
  static reportNotificationClick(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NOTIFICATION_CLICK);
  }

  /**
   * PC状态栏 控制中心图标点击打点
   *
   */
  static reportControlClick(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.CONTROL_CLICK);
  }

  /**
   * PC状态栏 全局搜索图标点击打点
   *
   */
  static reportSearchClick(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SEARCH_CLICK);
  }

  /**
   * PC状态栏 蓝牙图标点击打点
   *
   */
  static reportBluetoothClick(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.BLUETOOTH_CLICK);
  }

  /**
   * 进入、退出通知管理状态栏 打点
   *
   * @param state 进入状态栏：1， 退出状态栏：2
   */
  static reportNotificationManagementStatusBar(status: number): void {
    let params: NotificationParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      STATUS: status
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_MANAGEMENT_STATUS_BAR, params);
  }

  /**
   * 纯净显示开关状态 打点
   *
   * @param switchStatus 隐藏通知内容开关状态 开关打开：1 开关关闭：0
   */
  static reportSimpleDisplay(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SIMPLE_DISPLAY, params);
  }

  /**
   * 显示通知图标开关状态 打点
   *
   * @param switchStatus 显示通知图标开关状态 开关打开：1 开关关闭：0
   */
  static reportShowAppNotificationIcons(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SHOW_APP_NOTIFICATION_ICONS, params);
  }

  /**
   * 显示实时网速开关状态 打点
   *
   * @param switchStatus 显示实时网速开关状态 开关打开：1 开关关闭：0
   */
  static reportShowNetworkSpeed(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SHOW_NETWORK_SPEED, params);
  }

  /**
   * 隐藏通知开关内容 打点
   *
   * @param switchStatus 隐藏通知内容开关状态 开关打开：1 开关关闭：0
   */
  static reportHideNotificationContent(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.HIDE_NOTIFICATION_CONTENT, params);
  }

  /**
   * 通知亮屏提示 打点
   *
   * @param switchStatus 通知亮屏提示开关 开关打开：1 开关关闭：0
   */
  static reportWakeScreen(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.WAKE_SCREEN, params);
  }

  /**
   * 进入、退出批量管理 打点
   *
   * @param state 进入批量管理：1， 退出批量管理：2
   */
  static reportManageAll(state: number): void {
    let params: ManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      STATE: state
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.MANAGE_ALL, params);
  }

  /**
   * 批量管理中操作开关 打点 记录应用包名、开启后状态
   *
   * @param bundleName 应用包名
   * @param switchStatus 开关打开：1 开关关闭：0
   */
  static reportSwitchInManageAll(bundleName: string, switchStatus: number): void {
    let params: InManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      SWITCH_STATUS: switchStatus,
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SWITCH_IN_MANAGE_ALL, params);
  }

  /**
   * 进入、退出 应用通知管理页面 打点，记录包名信息
   *
   * @param bundleName 应用包名
   * @param state 进入应用通知管理：1， 退出应用通知管理：2
   */
  static reportApplicationNotificationManagement(bundleName: string, state: number): void {
    let params: ApplicationParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      STATE: state
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.APPLICATION_NOTIFICATION_MANAGEMENT, params);
  }

  /**
   * 应用通知管理页面总开关 打点，记录包名信息，操作后状态
   *
   * @param bundleName 应用包名信息
   * @param switchStatus 开关状态 开关打开：1 开关关闭：0
   */
  static reportNotificationManagementAllowNotification(bundleName: string, switchStatus: number): void {
    let params: InManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NOTIFICATION_MANAGEMENT_ALLOW_NOTIFICATION, params);
  }

  /**
   * 应用通知管理页面，提醒方式中锁屏通知设置 打点，记录包名信息，操作后状态
   *
   * @param bundleName 应用包名
   * @param switchStatus 开关状态 开关打开：1 开关关闭：0
   */
  static reportNotificationStyleLockScreen(bundleName: string, switchStatus: number): void {
    let params: InManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NOTIFICATION_STYLE_LOCK_SCREEN, params);
  }

  /**
   * 应用通知管理页面，提醒方式中横幅通知开关设置 打点，记录包名信息，操作后状态
   *
   * @param bundleName 应用包名
   * @param switchStatus 开关状态 开关打开：1 开关关闭：0
   */
  static reportNotifyStyleBanners(bundleName: string, switchStatus: number): void {
    let params: InManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NOTIFICATION_STYLE_BANNERS, params);
  }

  /**
   * 进入、退出通知和状态栏管理页面 打点
   *
   * @param name 进入页面：1， 退出页面：2
   * @param eventType 页面名字
   */
  static reportNotificationManagement(name: number, eventType: string): void {
    let params: SystemMenuClickParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      NAME: name,
      EVENT_TYPE: eventType
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_MANAGEMENT, params);
  }

  /**
   * 快捷开关点击打点
   *
   * @param slot 快捷开关唯一标识
   * @param clickType 1：长按 | 0：单击
   */
  static reportToggleClick(slot: string, clickType: number): void {
    let params: ClickParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      TOGGLE_NAME: slot,
      CLICK_TYPE: clickType,
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.TOGGLE_CLICK, params);
  }

  /**
   * 快捷开关数据改变打点
   *
   * @param toggleData 快捷开关数据
   */
  static reportToggleDataChange(toggleData: string): void {
    let params: ToggleParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      TOGGLE_DATA: toggleData
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.TOGGLE_DATA_CHANGED, params);
  }

  /**
   * 进入退出快捷开关编辑界面打点
   *
   * @param state 1：进入 | 0：退出
   */
  static reportToggleEditState(state: number): void {
    let params: ApplicationParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      STATE: state
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.TOGGLE_EDIT_STATE, params);
  }

  /**
   * 拖动调整快捷开关
   */
  static reportToggleEditDrag(slot: string): void {
    let params: ClickParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      TOGGLE_NAME: slot
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.TOGGLE_EDIT_DRAG, params);
  }

  /**
   * 通知中心显示隐藏打点
   *
   * @param type 参考 HiSysDataShowHide
   */
  static reportNotificationPanelShowHide(type: number): void {
    let params: CommParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      TYPE: type
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NOTIFICATION_PANEL_SHOW_HIDE, params);
  }

  /**
   * 控制中心显示隐藏打点
   *
   * @param type 参考 HiSysDataShowHide
   */
  static reportControlCenterShowHide(type: number): void {
    let params: CommParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      TYPE: type
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.CONTROL_CENTER_SHOW_HIDE, params);
  }

  /**
   * 横滑切换控制中心/通知中心打点
   *
   * @param TARGET：目标 1：通知中心； 2：控制中心
   * @param RESULT：结果 success:成功；fail：失败
   * @param STARTX：起始坐标x
   * @param STARTY：起始坐标y
   * @param ENDX：终点坐标x
   * @param ENDY：终点坐标y
   */
  static reportSwipeSwitchControlNtf(target: number, result: string, startX: number, startY: number,
                                     endX: number, endY: number): void {
    let params: SwipeSwitchParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      TARGET: target,
      RESULT: result,
      STARTX: startX,
      STARTY: startY,
      ENDX: endX,
      ENDY: endY
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SWIPE_SWITCH_CONTROL_NTF, params);
    if (target === 1) {
      HiDfxEventUtil.reportNotificationPanelShowHide(HiSysDataShowHide.SHOW);
    } else {
      HiDfxEventUtil.reportControlCenterShowHide(HiSysDataShowHide.SHOW);
    }
  }

  /**
   * 一键删除所有通知打点
   */
  static reportDeleteAllNotification(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.DELETE_ALL_NOTIFICATION);
  }

  /**
   * 滑动删除通知打点
   */
  static reportDeleteNotificationBySwipe(pkg: string, direction: number): void {
    let params: DeleteParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      DIRECTION: direction
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.DELETE_NOTIFICATION_BY_SWIPE, params);
  }

  /**
   * 上滑隐藏横幅通知打点
   */
  static reportSwipeIgnoreBannerNotification(pkg: string): void {
    let params: DeleteParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SWIPE_IGNORE_BANNER_NTF, params);
  }

  /**
   * 点击控制中心的截屏 打点
   */
  static reportControlCenterScreenshotClick(shotType: number): void {
    let params: ManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SHOT_TYPE: shotType
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SCREENSHOT_BY_CONTROL_CENTER, params);
  }

  /**
   * 点击控制中心的媒体卡片控制 打点
   */
  static reportMediaControllerClick(cmd: number): void {
    let params: ManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      COMMAND: cmd
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.CONTROL_CENTER_MEDIA, params);
  }

  /**
   * 删除超出个数限制的通知 打点
   */
  static reportDeleteNtfOverLimit(pkg: string, id: number, tag: string): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id,
      TAG: tag
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.DELETE_NTF_OVER_LIMIT, params);
  }

  /**
   * 通知点击 打点
   *
   * @param pkg 通知包名
   * @param state 点击通知方式,0:非锁屏点击/1锁屏双击
   */
  static reportNotifyItemClick(pkg: string, state: number): void {
    let params: ItemClickParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      STATE: state
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.CLICK_NOTIFICATION, params);
  }

  /**
   * 控制中心 多用户点击 打点
   */
  static reportControlCenterUserClick(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.CONTROL_CENTER_USER_CLICK);
  }

  /**
   * 点击通知内注册了事件的按钮 打点
   */
  static reportNotificationButtonClick(pkg: string, id: number, tag: string): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id,
      TAG: tag
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NOTIFICATION_BUTTON_CLICK, params);
  }

  /**
   * 快捷开关页_编辑后完成重置 打点
   */
  static reportQuickTogglePageReset(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.QUICK_TOGGLE_PAGE_RESET);
  }

  /**
   * 快捷开关页_编辑后点击完成 打点
   */
  static reportQuickTogglePageFinish(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.QUICK_TOGGLE_PAGE_FINISH);
  }

  /**
   * 快捷开关页_编辑后重置弹框里点取消 打点
   */
  static reportQuickToggleEditResetCancel(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.QUICK_TOGGLE_EDIT_RESET_CANCEL);
  }

  /**
   * 快捷开关页_编辑后重置弹框里点重置 打点
   */
  static reportQuickToggleEditResetReset(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.QUICK_TOGGLE_EDIT_RESET_RESET);
  }

  /**
   * 控制中心_点击多用户_切换多用户 打点
   */
  static reportSwitchAccount(accountId: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      ID: accountId
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SWITCH_ACCOUNT, params);
  }

  /**
   * 控制中心_点击多用户_更多设置 打点
   */
  static reportAccountMoreSetting(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.ACCOUNT_MORE_SETTING);
  }

  /**
   * 控制中心_点击多用户_退出 打点
   */
  static reportAccountMenuCancel(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.ACCOUNT_MENU_CANCEL);
  }

  /**
   * 快捷开关_静音/振动/响铃 打点
   *
   * @param state 0:静音/1:振动/2:响铃
   */
  static reportQuickToggleRingMode(state: number): void {
    let params: QuickToggleRingModeParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      NEWSTATE: state
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.QUICK_TOGGLE_RING_MODE, params);
  }

  /**
   * 通知页_点击展开收起组合通知 打点
   *
   * @param pkg 发通知的应用包名
   */
  static reportNtfGroupExpandClick(pkg: string, expand: boolean): void {
    let params: DeleteParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      EXPAND: expand
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_GROUP_EXPAND_CLICK, params);
  }

  /**
   * 通知栏_点击时间 打点
   *
   * @param pkg 发通知的应用包名
   */
  static reportNtfPanelClickTime(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NOTIFICATION_PANEL_CLICK_TIME);
  }

  /**
   * 通知栏_点击日期 打点
   *
   * @param pkg 发通知的应用包名
   */
  static reportNtfPanelClickDate(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NOTIFICATION_PANEL_CLICK_DATE);
  }

  /**
   * 通知栏_点击设置 打点
   *
   * @param pkg 发通知的应用包名
   */
  static reportNtfPanelClickSetting(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_PANEL_CLICK_SETTING);
  }

  /**
   * 左滑通知点击设置按钮--点击更多设置 打点
   *
   * @param pkg 发通知的应用包名
   */
  static reportNtfMenuClickMoreSetting(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_MENU_CLICK_MORE_SETTING, params);
  }

  /**
   * 左滑通知_点击设置 打点
   *
   * @param pkg 发通知的应用包名
   */
  static reportNtfMenuClickSetting(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_MENU_CLICK_SETTING, params);
  }

  /**
   * 通知置顶的操作类型 打点
   *
   * @param operationType 操作类型 insert:通知置顶；delete:取消通知置顶
   * @param pkg 发通知的应用包名
   */
  static reportNtfSetPinTop(operationType: string, pkg: string): void {
    let params: NtfSetPinTopParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      OPERATIONTYPE: operationType,
      PKG: pkg
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NOTIFICATION_SET_PIN_TOP, params);
  }

  /**
   * 展示单条的音量面板 打点
   *
   * @param type 类型 0：通话音量, 2：铃声音量, 3：媒体音量,
   * @param progress 音量
   */
  static reportShowSingleVolBar(type: number, progress: number): void {
    let params: CommParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      STREAM: type,
      PROGRESS: progress
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SHOW_SINGLE_VOL_BAR, params);
  }

  /**
   * 隐藏单条的音量面板 打点
   *
   * @param type 类型 0：通话音量, 2：铃声音量, 3：媒体音量,
   * @param progress 音量
   */
  static reportHideSingleVolBar(type: number, progress: number): void {
    let params: CommParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      STREAM: type,
      PROGRESS: progress
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.HIDE_SINGLE_VOL_BAR, params);
  }

  /**
   * 展开收起音量面板 打点
   *
   * @param type 类型 0：收起，1：展开
   */
  static reportExpandVolPanel(expand: boolean): void {
    let params: ExpandVolPanelParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      EXPAND: expand ? 1 : 0
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.EXPAND_VOL_PANEL, params);
  }

  /**
   * 设置或取消通知的静默状态 打点
   *
   * @param pkg 应用包名
   * @param silence 0：铃声，1：静音
   */
  static reportSetPkgNtfSilenceMode(pkg: string, silence: number): void {
    let params: NtfSetPinTopParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      SILENCE: silence
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SET_PKG_NTF_SILENCE_MODE, params);
  }

  /**
   * 左滑通知_点击删除项 打点
   *
   * @param pkg 应用包名
   * @param id 通知的id
   */
  static reportClickDeleteInNtfMenu(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.CLICK_DELETE_IN_NTF_MENU, params);
  }

  /**
   * 左滑通知_调出设置项 打点
   *
   * @param pkg 应用包名
   */
  static reportLeftSwipeNtfShowMenu(pkg: string): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.LEFT_SWIPE_NTF_SHOW_MENU, params);
  }

  /**
   * 左滑通知_点击设置_弹出框中点击取消 打点
   *
   * @param pkg 应用包名
   * @param id 通知的id
   */
  static reportNtfSetDialogClickCancel(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_SETTING_DLG_CLICK_CANCEL, params);
  }

  /**
   * 左滑通知_点击设置_点击’关闭通知’按钮 打点
   *
   * @param pkg 应用包名
   * @param id 通知的id
   */
  static reportNtfMenuClickDisableNtf(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_MENU_CLICK_DISABLE_NTF, params);
  }

  /**
   * 左滑通知_点击设置_点击’关闭通知’按钮_弹出框中点击取消 打点
   *
   * @param pkg 应用包名
   * @param id 通知的id
   */
  static reportNtfClickCancel(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_MENU_DISABLE_CLICK_CANCEL, params);
  }

  /**
   * 左滑通知_点击设置_点击’关闭通知’按钮_弹出框中点击关闭 打点
   *
   * @param pkg 应用包名
   * @param id 通知的id
   */
  static reportNtfClickDisable(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_MENU_DISABLE_CLICK_DISABLE, params);
  }

  /**
   * 快捷开关二级选项点击 打点
   *
   * @param buttonName 快捷开关的名称
   */
  static reportQuickToggleSubMenuClick(buttonName: string): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUTTON_NAME: buttonName
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.QUICK_TOGGLE_SUB_MENU_CLICK, params);
  }

  /**
   * 通知中心跳转通知设置界面 打点
   */
  static reportNtfPanelJumpNtfManagement(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_PANEL_JUMP_NTF_MANAGEMENT);
  }

  /**
   * 控制中心跳转系统设置界面 打点
   */
  static reportControlCenterJumpSetting(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.CONTROL_CENTER_JUMP_SETTING);
  }

  /**
   * 带回复的通知，点击回复 打点
   */
  static reportNotificationReplyClick(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_REPLY_CLICK, params);
  }

  /**
   * 带回复的通知，输入文字 打点
   */
  static reportNotificationReplyInputContent(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_REPLY_INPUT_CONTENT, params);
  }

  /**
   * 带回复的通知，点击发送 打点
   */
  static reportNotificationReplySend(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_REPLY_SEND, params);
  }

  /**
   * PC右上角关闭通知按钮点击 打点
   */
  static reportDeleteNtfByClose(pkg: string, id: number): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg,
      ID: id
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.DELETE_NTF_BY_CLOSE, params);
  }

  /**
   * PC右上角设置-更多设置 打点
   */
  static reportNtfRightTopMenuMoreSettingClick(pkg: string): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_RIGHT_TOP_MENU_MORE_SETTING, params);
  }

  /**
   * PC右上角设置-关闭此通知 打点
   */
  static reportNtfRightTopMenuDisableClick(pkg: string): void {
    let params: DeleteNtfOverLimitParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PKG: pkg
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.NTF_RIGHT_TOP_MENU_DISABLE_NTF, params);
  }

  /**
   * 确认按钮点击打点
   */
  static reportButtonEvent(name: string): void {
    let params: ButtonEventParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      NAME: name
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.CLICK_BUTTON_EVENT, params);
  }

  /**
   * 滑动/数字密码输入完离手时打点
   */
  static reportStartUnlockEvent(): void {
    let params: DefaultParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.START_UNLOCK, params);
  }

  /**
   * 输入法键盘显示隐藏打点
   *
   * @param type 0：隐藏, 1：显示, 参考 HiSysDataShowHide
   */
  static reportKeyboardShowHide(type: number): void {
    let params: KeyboardStateParams = {
      TYPE: type
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.KEYBOARD_SHOW_HIDE, params);
  }

  /**
   * 亮屏事件打点
   */
  static reportScreenOnEvent(): void {;
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SCREENON_EVENT);
  }

  /**
   * 灭屏事件打点
   */
  static reportScreenOffEvent(): void {;
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SCREENOFF_EVENT);
  }

  /**
   * 关机事件打点
   */
  static reportShutDownEvent(): void {;
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SHUTDOWN_EVENT);
  }

  /**
   * 物理键调节音量面板 打点
   *
   * @param type 类型 0：通话音量, 2：铃声音量, 3：媒体音量,
   * @param progress 音量
   */
  static reportAdjustVolByPressButton(type: number, progress: number): void {
    let params: CommParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      STREAM: type,
      PROGRESS: progress
    };
    /* 延迟500ms再上报，期间有相同的点位上报，则取消之前的上报，以最后一次为准，避免多次上报触发流控 */
    HiDfxEventUtil.delayReportEvent(HiDfxEventUtil.ADJUST_VOL_BY_PRESS_BUTTON, params, HiDfxEventUtil.REPORT_DELAY_TIME);
  }

  /**
   * 上手划音量条选中的面板 打点
   *
   * @param type 类型 0：通话音量, 2：铃声音量, 3：媒体音量
   */
  static reportSlideSelectedVolBar(type: number, progress: number): void {
    let params: CommParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      STREAM: type,
      PROGRESS: progress
    };
    /* 延迟500ms再上报，期间有相同的点位上报，则取消之前的上报，以最后一次为准，避免多次上报触发流控 */
    HiDfxEventUtil.delayReportEvent(HiDfxEventUtil.SLIDE_SELECTED_VOL_BAR, params, HiDfxEventUtil.REPORT_DELAY_TIME);
  }

  /**
   * 延迟上报事件，延迟时间内上报相同事件，会把之前的事件取消上报，以最后一次为准
   *
   * @param name 事件名字
   * @param msg 事件内容
   * @param delay 延迟时间
   * @param callback 根据域进行回调
   * */
  static delayReportEvent(name: string, msg: Object, delay: number, callback?: Function): void {
    log.error(`delayReportEvent event:${name}`);
    if (!CommonUtils.isInvalid(HiDfxEventUtil.delayReportEventMap[name])) {
      let obj: DelayReportParams = HiDfxEventUtil.delayReportEventMap[name];
      clearTimeout(obj.timer);
      HiDfxEventUtil.delayReportEventMap[name] = null;
    }
    let eventParams: DelayReportParams = {
      name: name,
      timer: setTimeout(() => {
        log.showInfo(`time out report event:${name}`);
        if (callback !== undefined) {
          callback();
        } else {
          HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(name, msg);
        }
        HiDfxEventUtil.delayReportEventMap[name] = null;
      }, delay),
      msg: msg
    };
    HiDfxEventUtil.delayReportEventMap[name] = eventParams;
  }

  /**
   * 无密码解锁打点
   */
  public static reportNoPwdUnlock(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SCREENUNLOCK_NO_PWD_EVENT);
  }

  /**
   * 多用户切换事件打点
   * @param userType 用户类型
   */
  public static reportUserSwitchEvent(userType?: number): void {
    if (userType === null || userType === undefined) {
      HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.USER_SWITCH_EVENT);
      return;
    }
    let params: SwitchToPasswordParams = {
      SWITCH_TO_USER: userType
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.USER_SWITCH_EVENT, params);
  }

  /**
   * 密码界面，点击删除键打点
   */
  public static reportPasswordDeleteEvent(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.PASSWORD_DELETE_EVENT);
  }

  /**
   * 密码界面，点击返回键打点
   */
  public static reportPasswordBackEvent(): void {
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.PASSWORD_BACK_EVENT);
  }

  /**
   * 进入密码界面
   */
  public static reportSwitchToPassword(passwordtype: string, time: number): void {
    let params: SwitchToPasswordParams = {
      COSTTIME: time,
      PASSWORDTYPE: passwordtype
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SWITCH_PASSWORD_PAGE_EVENT, params);
  }

  /**
   * 解锁进桌面
   */
  public static reportUnlockToDesktop(type: string, index?: number): void {
    let params: UnlockToDesktopParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      PAGE_INDEX: index,
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(type, params);
  }

  /**
   * report screen on animation
   */
  public static reportScreenOnAnimation(screenOnAnimationBeginTime: number, screenOnAnimationEndTime: number): void {
    let params: ScreenOnAnimationReportParams = {
      BEGIN_TIME: screenOnAnimationBeginTime.toString(),
      END_TIME: screenOnAnimationEndTime.toString(),
      E2E_LATENCY: screenOnAnimationEndTime - screenOnAnimationBeginTime,
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.SCREEN_ON_ANIMATION, params);
  }

  /**
   * 桌面数据库异常打点
   *
   * @param errorCode 错误码
   * @param errorMsg 错误信息
   * @param sceneMsg 场景
   * @param tableName 数据库表名
   * @param extra 额外数据
   */
  public static reportRDBAbnormal(errorCode: number, errorMsg: string, sceneMsg?: string, tableName?: string,
    extra?: string, bundleName?: string): void {
    if (CheckEmptyUtils.isEmpty(tableName) || !tableName.includes(GRIDLAYOUT_INFO)) {
      log.showInfo(`not need to report rdb abnormal and tableName:${tableName}, errorMsg:${errorMsg}`);
      return;
    }
    let params: RDBAbnormalParams = {
      ERROR_CODE: errorCode.toString(),
      ERROR_MSG: errorMsg,
      SCENE_MSG: sceneMsg,
      TABLE_NAME: tableName,
      EXTRA: extra,
      BUNDLE_NAME: bundleName,
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.LAUNCHER_RDB_ABNORMAL, params);
  }

  /**
   * 桌面缓存异常打点
   *
   * @param errorMsg 错误信息
   * @param sceneMsg 场景
   */
  public static reportLauncherCacheAbnormal(sceneMsg: string, errorMsg?: string): void {
    let params: CacheAbnormalParams = {
      SCENE_MSG: sceneMsg,
      ERROR_MSG: errorMsg,
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.LAUNCHER_CACHE_ABNORMAL, params);
  }

  /**
   * 桌面刷新异常打点
   *
   * @param sceneMsg
   * @param errorMsg
   */
  public static reportLauncherLayoutAbnormal(sceneMsg: string, errorMsg?: string): void {
    let params: RefreshAbnormalParams = {
      SCENE_MSG: sceneMsg,
      ERROR_MSG: errorMsg,
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportStatistic(HiDfxEventUtil.LAUNCHER_LAYOUT_ABNORMAL, params);
  }

  /**
   * 图标状态异常打点
   *
   * @param errorMsg 异常信息
   * @param bundleName 包名
   * @param extra 额外信息
   */
  public static reportIconStatusAbnormal(errorMsg: string, bundleName: string, extra?: string): void {
    let params: IconStatusAbnormalParams = {
      ERROR_MSG: errorMsg,
      BUNDLE_NAME: bundleName,
      EXTRA: extra,
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.ICON_STATUS_ABNORMAL, params);
  }

  /**
   * Dock常驻区数据异常打点
   *
   * @param dockRegionType dock分区类型
   * @param itemsCount 分区内应用数量
   * @param eventType 应用数量变更事件
   */
  public static reportDockRegionItemsCount(dockRegionType: string, itemsCount: number, eventType: string): void {
    let params: DockRegionTypeItemsCountParams = {
      DOCKREGIONTYPE: dockRegionType,
      ITEMSCOUNT: itemsCount,
      EVENTTYPE: eventType,
    };
    this.mHiDfxEventUtil.reportBehavior(HiDfxEventUtil.DOCK_REGION_ITEMS_COUNT, params);
  }

  /**
   * 桌面卡片故障维测统一上报
   */
  public static reportCardFaultInformation(event: ReportCardFaultInformationEvent): void {
    let params: ReportCardFaultInformationParams = {
      FAULTINFORMATION: event.faultInformation,
      FORMID: event.formId,
      BUNDLENAME: event.bundleName,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      SIZE: `${event.area[0]} * ${event.area[1]}`,
      POSITION: event.position,
      SOURCETYPE: event.sourceType,
      FORMTYPE: event.formType,
      FORMLOCATION: event.location,
      RESULTTYPE: event.resultType,
      ERRORMSG: event.errorMsg,
      OPERATEMSG: event.operateMsg,
      FORMLIST: event.formList,
    };
    HiDfxEventUtil.mHiDfxEventUtil.reportFault(HiDfxEventUtil.REPORT_CARD_FAULT_INFORMATION, params);
  }
}