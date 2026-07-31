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
import { PluginSlot } from '../plugin/PluginConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  ReportParams,
  FoldParams,
  DefaultParams,
  HibernateDialogParams,
  ExitGlobalSearchParams,
  IntoNegativeScreenParams,
  ExitNegativeScreenParams,
  IntoGlobalSearchParams,
  DragChangeFolderSizeParams,
  DragChangeFolderSizeFailParams,
  NaviBarSettingSwitchParams,
  OnClickNAVIBarParams,
  ScreenLockQuickToolParams,
  TurboChargingParams,
  SwitchFreeMultiWindowModeParams,
  RotationChangeParams,
  SwitchEnterpriseMultiSpaceParams,
  OperatorAppCenterTypeParams,
  PullHosKeyTypeParams,
  DeleteAppParams,
  OpenDeleteAppDialogParams,
  LongPressMisTouchParams,
  SkipOOBEParams,
  FoldStateParams,
  ReportProductionAppParams,
  EditAodParams,
  ApplyAodParams,
  MidSceneState,
  SearchAppPositionParams,
  ClickShortcutParams,
  AppCenterItemsCountParams,
  IconItemsClickParams,
  IconItemsNumberChangeParams,
  ShowDesktopGestureParams,
  RestoreDesktopGestureParams,
  RenameNotHarmonyFolderParams,
  DragIconIntoNotHarmonyFolderParams,
  DragIconFromNotHarmonyFolderParams,
  DragIconFromNotHarmonyFolderBean,
  LightIconInNotHarmonyFolderParams,
  LightIconInNotHarmonyFolderBean,
  ClickDeleteAppDialogParams,
  RecentSwiperParams,
  deliverDialogOpenParams,
  deliverDialogOperationParams,
  DeleteShortcutParams,
  ToRecentGestureParams,
  AddBlankPageParams,
  DeleteBlankPageParams,
  DragPageParams,
  SlGreetModeParams,
  StateChangeParams,
  RotationLockParams,
  CloseWindowParams,
  BorCWindowsNumbersParams,
  FullScreenWaterFallModeParams,
  CCQuickToggleEyeComport,
  AddOuterAppParams,
  DeleteOuterShortcutParams,
  FolderNaviParams,
  AddOuterShortcutParams,
  UpdateAodParams,
  WritePreloadLayoutParams,
  DefaultAodParams,
  AntiPeepingStatusParams,
  SlResetPinParams,
  SwitchDesktopFourFingerSwipeParams,
  PinchGestureEventParams,
  ReportFolderCreationOpenRecommendParams,
  ReportFolderCreationRecommendOkParams,
  ReportFolderCreationRecommendCancelParams,
  ReportFolderAddAppRecommendOkParams,
  ReportFolderAddAppRecommendCancelParams,
  SceneBoardFileSizeParams,
  SwitchComputerModeParams,
  ForceMultiWindowSwitchParams,
  ForceMultiWindowSwitchWeeklyParams,
  VmUsingTimeParams,
  SuperFoldSwipeChangeParams,
  SystemSceneStateParams,
  BaseParams,
  EnterDrawerModeParams,
  ExitDrawerModeParams,
  DockAutoHideParams,
} from './ReportParams';
import type { MoveIconInFolderBean, FolderSizeModifyBean, DragIconIntoFolderBean,
  BackEventParams, PauseAppDownload, ContinueAppDownload, AnimationDurationAppDownload, CancelAppUninstall,
  ReloadDesktop, DesktopInformation, OuterDesktopInformation } from './ReportParams';
import type { ClickAppInDockRecentParams, AdjustDockSplitLineParams, DeleteRecentAppParams, DockRecentMenuParams, GetFlashLightStatusParams,
  InputParams, SoundParams, ReturnToHomeKeyParams, SwitchingType,
  SystemMenuClickParams, LogoLParams, IconClickParams, ButtonEventParams,
  ReturnToHomeParams, GoIntoRecentParams, IntoOrExitAppCenterParams, SlideLockAppInRecentParams, ClearSingleAppInRecentParams, ClearAllAppInRecentParams,
  ClearAllAppInSCBRecentParams, GoIntoAppInRecentParams, SnapToPageParams, CloseFolderParams, DragFolderParams,
  DissolveFolderParams, GoIntoAppShortcutMenuParams, CreateBigFolderParams, SnapToPageInFolderParams,
  ReverseAddInFolderParams, DragIconIntoFolderParams, ClickAppInDockParams, ClickAppIconParams, OpenFolderParams,
  OpenUninstallAppDialogParams, UninstallAppParams, RemoveAppParams, CancelRemoveAppParams, SysEventInfoParams,
  WinDragToHotareaParams, CurrentWindowNumParams, AodParams, StopAodParams,
  NotificationPanelShow, NotificationPanelHide, ControlCenterShow, ControlCenterHide, CCQuickToggleClick,
  CCQuickToggleLongClick, CCQuickToggleClickSound, CCQuickToggleLongClickSound, CCQuickToggleClickEBook, CCQuickToggleLongClickEBook,
  CCSettingIconClick, CCBrightnessSlide, CreateSmallFolderParams,
  LongPressFolderParams, RenameFolderParams, ScreenLockBaseFormDataReportParams,
  AddScreenLockFormDataReportParams, MoveIconInFolderParams, FolderSizeModifyParams,
  ClickAppInShortcutParams, ScreenLockSaveFormDataReportParams, ScreenLockFormDataReportParamsState, CompletelyDeleteParams, FullContinueAddingParams,
  PullRightMenuParams, DesktopRightMenuParams, PullAppCenterTypeParams, DesktopItemsCountParams, GestureQuickSwitchParams, ClickSleepMenuFormDataReportParams,
  DoubleClickTitleParams, LongPressAppClickShare, IntoOneHandModeParams, InAppAddShortcutToDesktop
} from './ReportParams';
import { TaskpoolUtil } from '@ohos/basicutils';
import dataPreferences from '@ohos.data.preferences';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { GlobalContext } from '../utils/GlobalContext';
import { HiSysReportEvent, ReportDomain } from './HiSysReportEvent';
import { DeviceHelper } from '../base/DeviceHelper';
import bundleManager from '@ohos.bundle.bundleManager';
import { HiDfxEventUtil } from './HiDfxEventUtil';
import { HiSysLongPressMisTouchType } from './HiSysData';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'HiSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const BI_KEY_LENGTH_MAX: number = 32;
const SUSPEND_DEVICE_REASON_FORCE_SUSPEND: number = 8;
const FORCE_SUSPEND: number = 1;
const HI_SYS_PREFERENCE: string = 'HiSysPreference';

/**
 * 大数据用户行为相关打点工具类
 */
export class HiSysEventUtil {
  public static TOUCH_EVENT = 'touch';
  public static MOUSE_EVENT = 'mouse';
  public static SHORTCUT_EVENT = 'shortcut';
  public static CLICK_MORE: number = -1;
  public static CHANGE_VOLUME: number = -2;
  private static instance: HiSysEventUtil;
  // User behavior events use this domain
  private static SCENE_BOARD_UE_DOMAIN: string = 'SCENE_BOARD_UE';
  private static OUTER_HOME_UE: string = 'OUTER_HOME_UE';
  private static SCREENLOCK_UE: string = 'SCREENLOCK_UE';
  private static SEREEN_LOCK_FLASH_LIGHT: string = 'SEREEN_LOCK_FLASH_LIGHT';
  private static SYSTEM_NAV_UE: string = 'SYSTEM_NAV_UE';
  private static USER_DATA_SIZE_UE: string = 'USER_DATA_SIZE';
  private static readonly FORM_UE_DOMAIN: string = 'FORM_UE';
  private static POWER_DOMAIN: string = 'POWER';
  // domain  notification and controlcenter
  private static NOTIFICATION_UE: string = 'NOTIFICATION_UE';
  private static CONTROLCENTER_UE: string = 'CONTROLCENTER_UE';
  private static SOUND_CLICK: string = 'SOUND_CLICK';
  private static TRAY_CLICK: string = 'TRAY_CLICK';
  private static SYSTEM_CLICK: string = 'SYSTEM_CLICK';
  private static BATTERY_CLICK: string = 'BATTERY_CLICK';
  private static SHUTDOWN_NOTIFICATION: string = 'SHUTDOWN_NOTIFICATION';
  private static HIBERNATE_DIALOG: string = 'HIBERNATE_DIALOG';
  private static POWER_MANAGER_EVENT: string = 'POWER_MANAGER_EVENT';
  private static SOUND_MENU: string = 'SOUND_MENU';
  private static SYSTEM_MENU: string = 'SYSTEM_MENU';
  private static INPUT_METHOD_CLICK: string = 'INPUT_METHOD_CLICK';
  private static ASSISTANT_TRANSLATE_CLICK: string = 'ASSISTANT_TRANSLATE_CLICK';
  private static QUICK_NOTE_CLICK: string = 'QUICK_NOTE_CLICK';
  private static SLOT_CLICK: string = 'SLOT_CLICK';
  private static SLOT_COUNT_CHANGE: string = 'SLOT_COUNT_CHANGE';
  // OOBE打点
  // domain名称
  private static OOBE_DOMAIN_UE: string = 'STARTUPGUIDE_UE';
  // 绕过OOBE的事件名
  private static OOBE_EVENT_NAME_SKIP_OOBE: string = 'SKIP_OOBE';
  // 添加生产应用的白名单事件名
  private static SCB_EVENT_NAME_RELOAD_PRO_APP: string = 'RELOAD_PRO_APP';
  // 控制中心补齐打点
  // 点击快捷开关
  private static CC_QUICK_TOGGLE_CLICK: string = 'CC_QUICK_TOGGLE_CLICK';
  // 长按快捷开关
  private static CC_QUICK_TOGGLE_LONG_CLICK: string = 'CC_QUICK_TOGGLE_LONG_CLICK';
  // 点击响铃图标
  private static CC_QUICK_TOGGLE_CLICK_SOUND: string = 'CC_QUICK_TOGGLE_CLICK_SOUND';
  // 点击电子书图标
  private static CC_QUICK_TOGGLE_CLICK_EBOOK: string = 'CC_QUICK_TOGGLE_CLICK_EBOOK';
  // 点击切换护眼模式
  public static CC_SUBPAGE_CLICK_EYE_COMPORT: string = 'CC_SUBPAGE_CLICK_EYE_COMPORT';
  // 长按响铃图标
  private static CC_QUICK_TOGGLE_LONG_CLICK_SOUND: string = 'CC_QT_LONG_CLICK_SOUND';
  // 长按电子书图标
  private static CC_QUICK_TOGGLE_LONG_CLICK_EBOOK: string = 'CC_QT_LONG_CLICK_EBOOK';
  // 点击设置图标
  private static CC_SETTING_ICON_CLICK: string = 'CC_SETTING_ICON_CLICK';
  // 拖动亮度条
  private static CC_BRIGHTNESS_SLIDE: string = 'CC_BRIGHTNESS_SLIDE';
  // 控制中心显示
  private static CONTROL_CENTER_SHOW: string = 'CONTROL_CENTER_SHOW';
  // 控制中心隐藏
  private static CONTROL_CENTER_HIDE: string = 'CONTROL_CENTER_HIDE';
  // 通知中心显示
  private static NOTIFICATION_PANEL_SHOW: string = 'NOTIFICATION_PANEL_SHOW';
  // 通知中心隐藏
  private static NOTIFICATION_PANEL_HIDE: string = 'NOTIFICATION_PANEL_HIDE';
  //2x4大文件夹使用引导弹窗
  public static readonly FOLDER_NAVI = 'FOLDER_NAVI';
  // 实况窗信息刷新
  public static readonly LIVE_WIN_UPDATE: string = 'LIVE_WIN_UPDATE';
  // 胶囊进度条刷新
  public static readonly CAPSULE_UPDATE: string = 'CAPSULE_UPDATE';
  // 点击卡片操作按钮
  public static readonly CLICK_LIVE_WIN_BUTTON: string = 'CLICK_LIVE_WIN_BUTTON';
  // 左滑出垃圾桶删除
  public static readonly LIVE_WIN_SWIPE_LEFT_DEL: string = 'LIVE_WIN_SWIPE_LEFT_DEL';
  // 点击胶囊展开卡片
  public static readonly CAPSULE_TO_LIVE_WIN: string = 'CAPSULE_TO_LIVE_WIN';
  // 点击卡片跳转应用
  public static readonly LIVE_WIN_TO_APP: string = 'LIVE_WIN_TO_APP';
  // Drag window to hotarea and change window mode to split or fullscreen
  private static WIN_DRAG_TO_HOTAREA: string = 'WIN_DRAG_TO_HOTAREA';
  // record the amount of windows every certain period
  private static CURRENT_WINDOW_NUM: string = 'CURRENT_WINDOW_NUM';
  // 自由多窗模式切换
  public static SWITCH_FREE_MULTI_WINDOWS_MODE: string = 'SWITCH_FREE_MULTI_WINDOWS_MODE';
  // 电脑模式模式切换
  public static SWITCH_COMPUTER_MODE: string = 'SWITCH_COMPUTER_MODE';
  private static REBOOT_MENU: string = '6';
  private static SHUTDOWN_MENU: string = '5';
  static systemUIName: string = 'STACK';
  private static LAUNCHER_DOMAIN: string = 'LAUNCHER';
  private static TOGGLE: string = 'TOGGLE';
  private static DOCK_MENU: string = 'DOCK_MENU';
  private static DOCK_MENU_OPEN: string = 'DOCK_MENU_OPEN';
  private static DOCK_MENU_APP_CLICK: string = 'DOCK_MENU_APP_CLICK';
  private static SYSTEM_SHORTCUT: string = 'SYSTEM_SHORTCUT';
  private static FILEMANAGEMENT: string = 'FILEMANAGEMENT';
  public static OPERATE_TYPE_DEFAULT = 1;
  public static OPERATE_TYPE_CLICK = 2;

  // 应用中心启动类型

  public static APPCENTER_TYPE_INPUT = 1;
  public static APPCENTER_TYPE_CLICK = 2;
  public static APPCENTER_TYPE_PINCH = 3;
  public static APPCENTER_TYPE_HOSKEY = 4; // 从系统键启动


  // 应用中心操作动作
  public static APPCENTER_TYPE_OPERATE_SEARCH: string = 'SEARCH';

  // 旋转类型
  public static ROTATION_TYPE_SENSOR: string = 'SENSOR';
  public static ROTATION_TYPE_APP_START: string = 'APP_START';
  public static ROTATION_TYPE_APP_OUT: string = 'APP_OUT';
  public static ROTATION_TYPE_SET_REQUESTED_ORIENTATION: string = 'SET_REQUESTED_ORIENTATION';
  public static ROTATION_TYPE_SCREEN: string = 'SCREEN';

  // 快捷键打点
  private static LOGO_L: string = 'SHORT_KEY_LOGO_AND_L';
  private static SHORT_KEY_BRIGHTNESS: string = 'SHORT_KEY_BRIGHTNESS';

  // super fold 切换桌面
  public static readonly SUPER_FOLD_SWIPE_PAGE: string = 'SUPER_FOLD_SWIPE_PAGE';
  //三指上滑清屏打点
  public static readonly PC_SHOW_DESKTOP_GESTURE: string = 'PC_SHOW_DESKTOP_GESTURE';
  // 单指上滑清屏打点
  public static readonly PC_ONE_FIN_SHOW_DESKTOP_GESTURE: string = 'PC_ONE_FIN_SHOW_DESKTOP_GESTURE';
  //三指下滑还原打点
  public static readonly PC_RESTORE_DESKTOP_GESTURE: string = 'PC_RESTORE_DESKTOP_GESTURE';
  //三指上滑停顿进多任务打点
  public static readonly PC_TO_RECENT_GESTURE: string = 'PC_TO_RECENT_GESTURE';
  // 单指上滑停顿进多任务打点
  public static readonly PC_ONE_FINGER_TO_RECENT_GESTURE: string = 'PC_ONE_FINGER_TO_RECENT_GESTURE';
  // 启动一屏一世界打点
  public static readonly SWITCHING_DESKTOP: string = 'SWITCHING_DESKTOP';
  // 一屏一世界四指滑动距离及时间打点
  public static readonly SWITCH_DESKTOP_FOUR_FINGER_SWIPE: string = 'SWITCH_DESKTOP_FOUR_FINGER_SWIPE';
  // 一屏一世界虚拟机使用时间打点
  public static readonly VM_USING_TIME: string = 'VM_USING_TIME';
  // 企业数字空间切换打点
  public static readonly SWITCH_ENTERPRISE_MULTISPACE: string = 'SWITCH_ENTERPRISE_MULTISPACE';
  // 胶囊点击打点
  private static ICON_CLICK: string = 'ICON_CLICK';

  // 进入桌面打点
  public static INTO_HOME_KEY = 'INTO_HOME_KEY';
  // 桌面动效打点
  public static INTO_HOME_ANI = 'INTO_HOME_ANI';
  // 图标按压动效打点
  public static ICON_PRESS_ANI = 'ICON_PRESS_ANI';

  private static readonly EXIT_KEYGUARD = 'EXITKEYGUARD';
  private static readonly HIDE_KEYGUARD = 'HIDESCREENLOCK';
  private static readonly SHOW_KEYGUARD = 'INTOKEYGUARD';

  // 进入退出锁屏问候
  public static readonly EXIT_SL_GREET_MODE = 'EXIT_SL_GREET_MODE';
  public static readonly INTO_SL_GREET_MODE = 'INTO_SL_GREET_MODE';

  // 取消或重置密码
  public static readonly SL_RESET_PIN = 'SL_RESET_PIN';

  // 桌面左右滑动事件打点
  public static DESKTOP_LEFT_RIGHT_SWIPE_EVENT = 'DESKTOP_SWIPE_EVENT_UE';

  private static WRITE_PRELOAD_LAYOUT_EVENT = 'WRITE_PRELOAD_LAYOUT';

  // 点击桌面应用
  public static CLICK_APP_ICON = 'CLICK_APP_ICON_UE';

  // 点击、文件夹中应用-出现弹窗
  public static DELIVER_DIALOG_OPEN = 'DELIVER_DIALOG_OPEN_UE';

  // 点击、文件夹中应用-弹窗操作
  public static DELIVER_DIALOG_OPERATION = 'DELIVER_DIALOG_OPERATION_UE';

  // 点击未鸿蒙化应用下载打点
  public static CLICK_NH_APP_ICON_INSTALL = 'CLICK_NH_APP_ICON_INSTALL_UE';

  // 点击未鸿蒙化应用弹窗打点
  public static CLICK_APP_ICON_OPEN_DIALOG = 'CLICK_APP_ICON_OPEN_DIALOG_UE';

  // 点击桌面快捷方式
  public static CLICK_SHORTCUT_ICON = 'CLICK_SHORTCUT_ICON_UE';

  // 桌面-正在下载的应用点击暂停
  public static readonly PAUSE_DOWNLOAD_APP = 'PAUSE_DOWNLOAD_APP';

  // 桌面-正在下载的应用暂停后点击继续下载
  public static readonly CONTINUE_DOWNLOAD_APP = 'CONTINUE_DOWNLOAD_APP';

  // 桌面下载图标动画时长
  public static readonly ANIMATION_DURATION_DOWNLOAD_APP = 'ANIMATION_DURATION_DOWNLOAD_APP';

  // 取消卸载单应用-快捷菜单栏点击卸载
  public static readonly CANCEL_UNSTALL_APP = 'CANCEL_UNSTALL_APP';

  // 桌面_重新加载桌面
  public static readonly RELOAD_DESKTOP = 'RELOAD_DESKTOP';

  public static readonly TITLE = 'ENTRY_PRIVICE_SPACE';

  // 桌面概要信息
  public static readonly DESKTOP_INFORMATION = 'DESKTOP_INFORMATION';

  // 新形态小外屏桌面概要信息
  public static readonly OUTER_DESKTOP_INFORMATION = 'LAUNCHER_OUTER_DESKTOP_INFO';

  //桌面空白处右键菜单
  public static DESKTOP_RIGHT_MENU = 'DESKTOP_RIGHT_MENU';

  //桌面上的各元素数量统计
  public static DESKTOP_ITEMS_COUNT_DATA = 'DESKTOP_ITEMS_COUNT_DATA';

  public static DRAG_AND_DROP_FOLDER_CREATION = 'DRAG_AND_DROP_FOLDER_CREATION';

  //应用中心的各元素数量统计
  public static APPCENTER_ITEMS_COUNT_DATA = 'PC_APPCENTER_ITEMS_COUNT_DATA';

  // 打开文件夹
  public static OPEN_FOLDER = 'OPEN_FOLDER_UE';

  // 关闭文件夹打点
  public static CLOSE_FOLDER = 'CLOSE_FOLDER_UE';

  // 关闭文件夹动效打点
  public static CLOSE_FOLDER_ANI = 'CLOSE_FOLDER_ANI';

  // 文件夹拖动
  public static DRAG_FOLDER = 'DRAG_FOLDER_UE';

  // 文件夹解散
  public static DISSOLVE_FOLDER = 'DISSOLVE_FOLDER_UE';

  // 大文件夹信息
  public static readonly FOLDER_INFORMATION = 'FOLDER_INFORMATION';

  // 长按应用出现菜单/长按快捷方式出现菜单
  public static GO_INTO_APP_SHORTCUT_MENU = 'GO_INTO_APP_SHORTCUT_MENU_UE';

  // 长按快捷方式-移除
  public static DELETE_SHORTCUT = 'DELETE_SHORTCUT_UE';

  // 生成大文件夹
  public static CREATE_BIG_FOLDER = 'CREATE_BIG_FOLDER_UE';

  // 创建小文件夹
  public static CREATE_SMALL_FOLDER = 'CREATE_SMALL_FOLDER_UE';

  // 图标在单屏内调整顺序
  public static DRAG_ICON_ADJUSTMENT_SEQUENCE = 'DRAG_ICON_ADJUSTMENT_SEQUENCE_UE';

  // 长按图标_卸载应用
  public static UNINSTALL_APP = 'UNINSTALL_APP_UE';

  // 长按图标_移除应用（新形态小外屏）
  public static DELETE_APP = 'LAUNCHER_DELETE_APP';

  // 长按图标_移除shortcut（新形态小外屏）
  public static OUTER_DELETE_SHORTCUT = 'LAUNCHER_DELETE_SHORTCUT_OUTER';

  // 添加shortcut（新形态小外屏）
  public static OUTER_ADD_SHORTCUT = 'LAUNCHER_ADD_SHORTCUT_OUTER';

  // 添加APP（新形态小外屏）
  public static OUTER_ADD_APP = 'LAUNCHER_ADD_APP_OUTER';

  // 长按文件夹内图标点击移除
  public static DELETE_APP_IN_FOLDER = 'DELETE_APP_IN_FOLDER_UE';

  // 进入全搜
  public static INTO_SEARCH = 'INTO_SEARCH';

  // 退出全搜
  public static EXIT_SEARCH = 'EXIT_SEARCH';

  // 进入负一屏
  public static INTO_AA = 'INTO_AA';

  // 退出负一屏
  public static EXIT_AA = 'EXIT_AA';

  // 长按应用/快捷方式图标_拖动调位
  public static MOVE_ICON_IN_FOLDER = 'MOVE_ICON_IN_FOLDER_UE';

  // 拖动应用图标/应用快捷方式至文件夹外
  public static DRAG_ICON_FROM_FOLDER = 'DRAG_ICON_FROM_FOLDER_UE';

  // 拖动应用图标/应用快捷方式至未鸿蒙化文件夹外
  public static DRAG_ICON_FROM_NH_FOLDER = 'DRAG_ICON_FROM_NH_FOLDER_UE';

  // 菜单方式修改大文件夹尺寸
  public static CONVERT_FOLDER_TYPE_BY_MENUS = 'CONVERT_FOLDER_TYPE_BY_MENUS_UE';

  // 卸载应用_快捷菜单栏点击卸载_确定
  public static DETERMINED_UNINSTALL_APP = 'DETERMINED_UNINSTALL_APP_UE';

  // 卸载应用_快捷菜单栏点击卸载_取消
  public static CANCEL_UNINSTALL_APP = 'CANCEL_UNINSTALL_APP_UE';

  // 移除应用_快捷菜单栏点击移除_确定（新形态小外屏）
  public static DETERMINED_DELETE_APP = 'LAUNCHER_DETERMINED_DELETE_APP';

  // 桌面_应用图标_长按移除_从桌面移除单应用
  public static DELETE_APP_IN_DESKTOP = 'DELETE_APP_IN_DESKTOP_UE';

  // 桌面_应用图标_长按移除_取消移除单应用
  public static CANCEL_DELETE_APP = 'CANCEL_DELETE_APP';

  //文件管理_彻底删除
  public static Completely_Delete = 'COMPLETELY_DELETE';

  //桌面满时继续添加
  public static Full_Continue_Adding = 'FULL_CONTINUE_ADDING';

  //拉起文价右键菜单
  public static Pull_Right_Menu = 'PULL_RIGHT_MENU';

  //桌面右键菜单进入个性化
  public static DESKTOP_RIGHT_MENU_INDIVIDUATION = 'DESKTOP_RIGHT_MENU_INDIVIDUATION';

  //桌面右键菜单进入卡片中心
  public static DESKTOP_RIGHT_MENU_FORM_CENTER = 'DESKTOP_RIGHT_MENU_FORM_CENTER';

  //启动应用中心
  public static Pull_APPCENTER_TYPE = 'PC_PULL_APP_CENTER';

  // 应用中心操作
  public static PC_OPERATE_TYPE_APP_CENTER = 'PC_OPERATE_TYPE_APP_CENTER';

  // 桌面_打开大文件夹_翻页
  public static LEFT_RIGHT_SWIPE_IN_FOLDER = 'LEFT_RIGHT_SWIPE_IN_FOLDER_UE';

  // 点击文件夹内加号进行反向添加/移除应用
  public static ADD_OR_REMOVE_APP_IN_FOLDER = 'ADD_OR_REMOVE_APP_IN_FOLDER_UE';

  // 拖动图标向文件夹中添加应用
  public static DRAG_ICON_INTO_FOLDER = 'DRAG_ICON_INTO_FOLDER_UE';

  // 拖动图标向未鸿蒙化文件夹中添加应用
  public static DRAG_ICON_INTO_NH_FOLDER = 'DRAG_ICON_INTO_NH_FOLDER_UE';

  // 未鸿蒙化文件夹中图标点亮
  public static LIGHT_ICON_IN_NH_FOLDER = 'LIGHT_ICON_IN_NH_FOLDER_UE';

  private static DRAG_CHANGE_BIG_FOLDER_SIZE = 'DRAG_CHANGE_BIG_FOLDER_SIZE';

  private static DRAG_CHANGE_BIG_FOLDER_SIZE_FAIL = 'DRAG_CHANGE_BIG_FOLDER_SIZE_FAIL';

  // 长按文件夹
  public static readonly LONG_PRESS_FOLDER = 'LONG_PRESS_FOLDER_UE';

  // 长按应用点击分享
  public static readonly LONG_PRESS_APP_CLICK_SHARE = 'LONG_PRESS_APP_CLICK_SHARE';

  // 应用内加桌快捷方式
  public static readonly IN_APP_ADD_SHORTCUT_TO_DESKTOP = 'IN_APP_ADD_SHORTCUT_TO_DESKTOP';

  // 重命名文件夹
  public static readonly RENAME_FOLDER = 'RENAME_FOLDER_UE';

  // 重命名未鸿蒙化文件夹
  public static readonly RENAME_NOT_HARMONY_FOLDER = 'RENAME_NOT_HARMONY_FOLDER_UE';

  // 点击X号清空文件夹名称
  public static readonly CLEAR_FOLDER_NAME = 'CLEAR_FOLDER_NAME_UE';

  // 点击DOCK栏应用
  public static CLICK_APP_IN_DOCK = 'CLICK_APP_IN_DOCK_UE';

  // 点击锁屏小组件应用
  public static readonly CLICK_APP_IN_SCREEN_LOCK_SHORTCUT = 'CLICK_APP_IN_SCREEN_LOCK_SHORTCUT_UE';

  // 点击dock栏最近使用区
  public static CLICK_APP_IN_DOCK_RECENT: string = 'CLICK_APP_IN_DOCK_RECENT_UE';

  // 删除dock最近使用区应用
  public static DELETE_APP_IN_DOCK_RECENT: string = 'DELETE_APP_IN_DOCK_RECENT_UE';

  // 操作dock最近使用区的长按菜单
  public static OPERATE_MENU_IN_DOCK_RECENT: string = 'OPERATE_MENU_IN_DOCK_RECENT_UE';

  // 调整dock分割线
  public static ADJUST_SPLIT_LINE_IN_DOCK: string = 'ADJUST_SPLIT_LINE_IN_DOCK_UE';

  // 应用底部上滑返回桌面
  public static readonly SWIPE_RETURN_DESKTOP = 'SWIPE_RETURN_DESKTOP';

  // 应用底部上滑停顿进入多任务
  public static SWIPE_PAUSE_INTO_RECENT = 'INTO_RECENT';

  // 手势导航返回
  public static readonly GESTURE_NAVIGATION_BACK_UE = 'GESTURE_NAVIGATION_BACK';

  // 上滑清除单个应用
  public static SWIPE_CLEAR_SINGLE_APP = 'SWIPE_CLEAR_SINGLE_APP_UE';

  // 下滑锁定单个应用
  public static RECENT_SLIDE_LOCK = 'RECENT_SLIDE_LOCK';

  // 禁止删除应用（包含上滑清除，一键清除）
  public static UN_CLEAR_ABLE_APP = 'UN_CLEAR_ABLE_APP_UE';

  // 一件清除所有应用卡片
  public static CLEAR_ALL_APP = 'CLEAR_ALL_APP_UE';

  // 点击应用卡片进入应用
  public static GO_INTO_APP = 'GO_INTO_APP_UE';

  // 点击应用卡片进入应用
  public static GO_INTO_APP_BY_TITLE = 'GO_INTO_APP_BY_TITLE_UE';

  // 启动应用
  public static readonly START_APP = 'START_APP';

  // AOD domain
  public static readonly AOD_UE = 'AOD_UE';

  // 设置AOD
  public static readonly SET_AOD = 'SET_AOD';

  // 进入AOD
  public static readonly INTO_AOD = 'INTO_AOD';

  // 退出AOD
  public static readonly EXIT_AOD = 'EXIT_AOD';

  // 进入熄屏显示界面
  public static readonly EDIT_AOD = 'EDIT_AOD';

  // 应用AOD样式
  public static readonly APPLY_AOD = 'APPLY_AOD';

  // 灭屏AOD更新
  public static readonly UPDATE_AOD = 'UPDATE_AOD';

  // 跳转更多在线样式
  public static readonly ENTER_VIEW_AOD = 'ENTER_VIEW_AOD';

  // 进入应用中心
  public static readonly INTO_APP_CENTER: string = 'INTO_APP_CENTER';

  // 退出应用中心
  public static readonly EXIT_APP_CENTER: string = 'EXIT_APP_CENTER';

  // 滑入负一屏
  public static readonly SCROLL_2_AA = 'SCROLL_2_AA';

  // 拖拽跟手动效
  public static readonly DRAG_ITEM_ANI = 'DRAG_ITEM_ANI';

  // 通知中心横滑切换控制中心
  public static readonly INTO_CC_FROM_NC = 'INTO_CC_FROM_NC';

  // 多任务列表滑动
  public static readonly SNAP_RECENT_ANI = 'SNAP_RECENT_ANI';
  public static readonly RECENT_SWIPER = 'RECENT_SWIPER_UE';

  //桌面快切
  public static readonly GESTURE_ENTER_TO_SWITCH = 'GESTURE_ENTER_TO_SWITCH';

  // 上滑删除一个多任务
  public static readonly CLEAR_1_RECENT_ANI = 'CLEAR_1_RECENT_ANI';

  // 卡片补位
  public static readonly RECENT_REALIGN_ANI = 'RECENT_REALIGN_ANI';

  // 一键删除
  public static readonly CLEAR_All_RECENT_ANI = 'CLEAR_All_RECENT_ANI';

  // 退出多任务
  public static readonly EXIT_RECENT_2_HOME_ANI = 'EXIT_RECENT_2_HOME_ANI';

  // pc退出多任务
  public static readonly PC_EXIT_RECENT = 'PC_EXIT_RECENT';

  // pc进入多任务
  public static readonly PC_INTO_RECENT = 'PC_INTO_RECENT';

  //pc快捷键进多任务
  public static readonly PC_SHORTCUT_TO_RECENT = 'PC_SHORTCUT_TO_RECENT';

  //pc手势进多任务
  public static readonly PC_GESTURE_TO_RECENT = 'PC_GESTURE_TO_RECENT';

  //pc手势进应用中心
  public static readonly PC_GESTURE_TO_APP_CENTER = 'PC_GESTURE_TO_APP_CENTER';

  //pc手势退出应用中心
  public static readonly PC_GESTURE_EXIT_APP_CENTER = 'PC_GESTURE_EXIT_APP_CENTER';

  //pc快捷键进应用中心
  public static readonly PC_SHORTCUT_TO_APP_CENTER = 'PC_SHORTCUT_TO_APP_CENTER';

  //pc 任务中心打开时 快捷键进应用中心
  public static readonly PC_SHORTCUT_TO_APP_CENTER_ON_RECENT = 'PC_SHORTCUT_TO_APP_CENTER_ON_RECENT';

  //pc 快捷键退出应用中心
  public static readonly PC_SHORTCUT_EXIT_APP_CENTER = 'PC_SHORTCUT_EXIT_APP_CENTER';

  //pc dock退出app center
  public static readonly PC_DOCK_EXIT_APP_CENTER = 'PC_DOCK_EXIT_APP_CENTER';

  //pc 任务中心打开时进应用中心
  public static readonly PC_INTO_APP_CENTER_ON_RECENT = 'PC_INTO_APP_CENTER_ON_RECENT';

  //pc dock进入应用中心
  public static readonly PC_DOCK_INTO_APP_CENTER = 'PC_DOCK_INTO_APP_CENTER';

  //pc 应用中心手势操作
  public static readonly PC_APP_CENTER_GESTURE_OPERATION = 'PC_APP_CENTER_GESTURE_OPERATION';

  //pc alt+tab进任务中心
  public static readonly PC_ALT_TAB_TO_RECENT = 'PC_ALT_TAB_TO_RECENT';

  // 任务中心窗口关闭动效
  public static readonly APP_EXIT_FROM_RECENT = 'APP_EXIT_FROM_RECENT';

  // 桌面搜索结果，点击图标右侧定位
  public static readonly DESKTOP_SEARCH_APPICON_POSITION = 'DESKTOP_SEARCH_APPICON_POSITION';

  /**
   * 导航条点击时打点
   */
  private static aiNavigationBarOnclick: string = 'CLICK_BOTTOM_NAVIGATION_BAR';

  // 上报锁屏卡片数据（关联主题id）
  public static SCREEN_LOCK_FORM_DATA: string = 'SCREEN_LOCK_FORM_DATA';

  // 上报临时填加锁屏卡片数据（关联主题id)
  public static SCREEN_LOCK_FORM_DATA_ADD: string = 'SCREEN_LOCK_FORM_DATA_ADD';

  // 上报锁屏卡片状态点（关联主题id)
  public static SCREEN_LOCK_FORM_DATA_STATE: string = 'SCREEN_LOCK_FORM_DATA_STATE';

  // 上报系统迁移app不匹配事件
  public static BACKUP_MISMATCH_APP = 'BACKUP_MISMATCH_APP';

  // 上报系统迁移卡片不匹配事件
  public static BACKUP_MISMATCH_CARD = 'BACKUP_MISMATCH_CARD';

  // 上报系统迁移 快捷方式不匹配事件
  public static BACKUP_MISMATCH_SHORTCUT = 'BACKUP_MISMATCH_SHORTCUT';

  // 上报系统迁移 备份恢复结果
  public static BACKUP_RESULT = 'BACKUP_RESULT';

  // 上报临时移除锁屏卡片数据（关联主题id)
  public static SCREEN_LOCK_FORM_DATA_REMOVE: string = 'SCREEN_LOCK_FORM_DATA_REMOVE';

  // 底部手势快切
  public static GESTURE_QUICK_SWITCH: string = 'GESTURE_QUICK_SWITCH';

  // 手势导航_底部横滑进入单手模式
  public static INTO_ONE_HAND_MODE: string = 'INTO_ONE_HAND_MODE';

  // 误触长按
  public static LONG_PRESS_MISTOUCH: string = 'LONG_PRESS_MISTOUCH';

  // AI横条设置
  public static NAVI_BAR_SWITCH: string = 'NAVI_BAR_SWITCH';

  // 锁屏密码有效期
  public static USER_PIN_TIMEOUT_AUTH: string = 'USER_PIN_TIMEOUT_AUTH';

  // 窗口旋转
  public static readonly ROTATION_CHANGE: string = 'ROTATION_CHANGE';

  // 上报用户点击睡眠按键
  public static CLICK_SLEEP_MENU: string = 'SLEEP_START';

  // 锁屏小工具使用
  public static readonly SEREEN_LOCK_GADGETS_OPEN_STATUS: string = 'SEREEN_LOCK_GADGETS_OPEN_STATUS';

  // 充电动画
  public static readonly SEREEN_LOCK_TURBO_CHARGING: string = 'SEREEN_LOCK_TURBO_CHARGING';

  // 桌面_排序
  public static readonly SORT_DESKTOP_ITEM = 'SORT_DESKTOP_ITEM';

  // 快游戏引擎包名
  public static readonly GAME_ENGINE_BUNDLE_NAME: string = 'com.ohos.litegamelauncher';

  // 屏幕类型， 1为其他屏（默认值）， 2为新形态小外折
  public static screenType: number = 1;

  // 当前系统开启的情景模式id， 0为未开启模式，其他为当前开启的模式Id
  public static intelligentSceneModeId: string = '0';

  private static mSystemNavReportEvent: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain
    .SYSTEM_NAV_UE);
  private static mRotationChangeReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.ROTATION_UE);

  // 系统键启动类型
  public static readonly HOSKEY_TYPE_INPUT = 1;
  private static readonly HOSKEY_UE_DOMAIN: string = 'HOSKEY_UE';
  public static readonly Pull_HOSKEY = 'AWAKE_HOSKEY';

  //双击标题栏
  private static readonly DOUBLE_CLICK_TITLE = 'DOUBLE_CLICK_TITLE';
  public static readonly DOUBLE_CLICK_TO_MAXIMIZE = 1;
  public static readonly DOUBLE_CLICK_TO_RECOVER = 2;

  //密码解锁
  public static readonly PASSWORD_UNLOCK_ANI = 'PASSWORD_UNLOCK_ANI';

  //进入控制中心
  public static readonly INTO_CC_ANI = 'INTO_CC_ANI';
  public static readonly EXIT_CC_ANI = 'EXIT_CC_ANI';
  public static readonly INTO_NC_ANI = 'INTO_NC_ANI';
  public static readonly EXIT_NC_ANI = 'EXIT_NC_ANI';

  public static readonly VOLUME_BAR_CHANGE_ON = 'VOLUME_BAR_CHANGE_ON';
  public static readonly VOLUME_BAR_SHOW = 'VOLUME_BAR_SHOW';
  public static readonly VOLUME_BAR_SLIDE = 'VOLUME_BAR_SLIDE';
  public static readonly VOLUME_BAR_EXPAND = 'VOLUME_BAR_EXPAND';
  public static readonly VOLUME_BAR_COLLAPSE = 'VOLUME_BAR_COLLAPSE';
  public static readonly VOLUME_BAR_TOUCHED = 'VOLUME_BAR_TOUCHED';

  public static readonly INTO_SEARCH_ANI = 'INTO_SEARCH_ANI';
  public static readonly EXIT_SEARCH_ANI = 'EXIT_SEARCH_ANI';
  public static readonly FORM_MANAGER_CREATE_FORM = 'FORM_MANAGER_CREATE_FORM';

  // 点击添加空白页
  public static readonly ADD_BLANK_PAGE = 'ADD_BLANK_PAGE';
  // 点击删除空白页
  public static readonly DELETE_BLANK_PAGE = 'DELETE_BLANK_PAGE';
  // 拖拽页面
  public static readonly DRAG_PAGE = 'DRAG_PAGE';

  private static readonly VALID_GAME_LAUNCHER_VERSION: number = 10400220;

  // 设置PC dock栏独立图标打点
  private static SET_DOCK_INDEPENT_ICON: string = 'SET_DOCK_INDEPENT_ICON';

  // Dock栏通信共享图标打点
  private static SHOW_COLLABORATION_ICON: string = 'SHOW_COLLABORATION_ICON';

  // 点击Dock栏箭头翻页打点
  private static CLICK_PC_DOCK_ARROW_BUTTON: string = 'CLICK_PC_DOCK_ARROW_BUTTON';

  protected constructor() {
  }

  //hopper状态切换
  public static readonly PC_STATE_CHANGE: string = 'PC_STATE_CHANGE';

  //hopper进入退出虚拟机旋转锁定
  public static readonly PC_ROTATION_LOCK: string = 'PC_ROTATION_LOCK';

  //hopper关闭窗口
  public static readonly PC_CLOSE_WINDOW: string = 'PC_CLOSE_WINDOW';

  //hopper点击分屏菜单进入瀑布屏
  public static readonly PC_FULL_SCREEN_WATERFALL_MODE: string = 'PC_FULL_SCREEN_WATERFALL_MODE';

  //hopper区分B/C面窗口数量
  public static readonly PC_B_OR_C_WINDOWS_NUMBERS: string = 'PC_B_OR_C_WINDOWS_NUMBERS';

  //张开手势
  public static readonly PC_PINCH_OPEN_GESTURE: string = 'PC_PINCH_OPEN_GESTURE';

  //捏合手势
  public static readonly PC_PINCH_CLOSE_GESTURE: string = 'PC_PINCH_CLOSE_GESTURE';

  // 检测到应用图片采样为恶意透明图片
  public static EVIL_APP_DETECTED = 'EVIL_APP_DETECTED';

  //进入抽屉模式
  public static ENTER_DRAWER_MODE = 'ENTER_DRAWER_MODE';

  //退出抽屉模式
  public static EXIT_DRAWER_MODE = 'EXIT_DRAWER_MODE';

  // 上报防窥按钮切换
  public static DOMAIN_ANTI_PEEPING_UE = 'ANTI_PEEPING_UE';
  public static ANTI_PEEPING_SWITCH_MAIN_STATUS = 'SWITCH_MAIN_STATUS';

  public static FOLDER_CREATION_OPEN_RECOMMEND = 'FOLDER_CREATION_OPEN_RECOMMEND';
  // 桌面曝光
  public static SCENE_BOARD_EXPOSURE_DAILY = 'SCENE_BOARD_EXPOSURE_DAILY';

  public static FOLDER_CREATION_RECOMMEND_OK = 'FOLDER_CREATION_RECOMMEND_OK';

  public static FOLDER_CREATION_RECOMMEND_CANCEL = 'FOLDER_CREATION_RECOMMEND_CANCEL';

  public static FOLDER_ADD_APP_RECOMMEND_OK = 'FOLDER_ADD_APP_RECOMMEND_OK';

  public static FOLDER_ADD_APP_RECOMMEND_CANCEL = 'FOLDER_ADD_APP_RECOMMEND_CANCEL';

  public static SAME_CATEGORY_ADD_BUBBLE_CLICK = 'SAME_CATEGORY_ADD_BUBBLE_CLICK';

  // 智慧多窗_兼容模式开关
  private static readonly FORCE_MULTI_WINDOW_SWITCH: string = 'FORCE_MULTI_WINDOW_SWITCH';

  // 智慧多窗_兼容模式开关_每周上报
  private static readonly FORCE_MULTI_WINDOW_SWITCH_WEEKLY = 'FORCE_MULTI_WINDOW_SWITCH_WEEKLY';

  // 0层组件状态打点，每周上报
  private static readonly SYSTEM_SCENE_STATE: string = 'SYSTEM_SCENE_STATE';

  // Dock自动隐藏打点
  public static readonly DOCK_AUTO_HIDE: string = 'DOCK_AUTO_HIDE';

  /**
   *set screenType
   */
  public static setScreenType(screenType: number): void {
  }

  /**
   *set intelligentSceneModeId
   */
  public static setIntelligentSceneModeId(intelligentSceneModeId: string): void {
    HiSysEventUtil.intelligentSceneModeId = intelligentSceneModeId;
  }

  /**
   *get intelligentSceneModeId
   */
  public static getIntelligentSceneModeId(): string {
    return HiSysEventUtil.intelligentSceneModeId;
  }

  /**
   *change FlashLight
   */
  public static getFlashLightStatus(flashStatus: string): void {
    if (flashStatus === undefined || flashStatus === null) {
      log.showError(`getFlashLightStatus start, ${flashStatus}`);
      return;
    }
    let params: GetFlashLightStatusParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      STATUS: flashStatus,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCREENLOCK_UE, HiSysEventUtil.SEREEN_LOCK_FLASH_LIGHT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 企业数字空间切换事件打点
   */
  public static reportSwitchEnterpriseMultiSpaceEvent(currentSpace: number, targetSpace: number, switchType: string,
    switchResult: number): void {
    let params: SwitchEnterpriseMultiSpaceParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CURRENT_SPACE: currentSpace,
      TARGET_SPACE: targetSpace,
      SWITCH_TYPE: switchType,
      SWITCH_RESULT: switchResult
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SWITCH_ENTERPRISE_MULTISPACE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /*
   *设置折叠屏打点
   */
  private static setFoldParams(params: FoldStateParams, expandStatus: boolean): void {
    params.FOLDDEVICETYPE = FoldParams.FOLD_DEVICE_TYPE;
    params.ISFOLDEXPAND = FoldParams.getDisplayType(expandStatus);
  }

  /**
   * Get single instance.
   */
  static getInstance(): HiSysEventUtil {
    if (HiSysEventUtil.instance == null) {
      HiSysEventUtil.instance = new HiSysEventUtil();
    }
    return HiSysEventUtil.instance;
  }

  /**
   * PC状态栏 托盘图标点击打点
   *
   */
  static reportTrayClick(): void {
    let params: BaseParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.TRAY_CLICK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC状态栏 声音图标点击打点
   *
   */
  static reportSoundClick(): void {
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SOUND_CLICK,
      hiSysEvent.EventType.BEHAVIOR, new DefaultParams());
  }

  /**
   * PC状态栏 系统菜单图标点击打点
   *
   */
  static reportSystemClick(): void {
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SYSTEM_CLICK,
      hiSysEvent.EventType.BEHAVIOR, new DefaultParams());
  }

  /**
   * PC状态栏 电池图标点击打点
   *
   */
  static reportBatteryClick(): void {
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.BATTERY_CLICK,
      hiSysEvent.EventType.BEHAVIOR, new DefaultParams());
  }

  /**
   * PC通知中心 低电关机横幅通知
   *
   */
  static reportShutDownNotification(): void {
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SHUTDOWN_NOTIFICATION,
      hiSysEvent.EventType.BEHAVIOR, new DefaultParams());
  }

  /**
   * PC电源管理 低电休眠弹窗
   *
   */
  static reportHibernateDialog(value: string): void {
    let params: HibernateDialogParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      VALUE: value
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.HIBERNATE_DIALOG,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC电源管理 shutdown,hibernate,reboot
   *
   */
  static reportPowerManagerEvent(value: string): void {
    let params: HibernateDialogParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      VALUE: value
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.POWER_MANAGER_EVENT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC状态栏 音量功能点击 打点
   *
   * @param name 点击的类型 -1：点击更多/-2：改变音量/正数是切换音源的类型
   * @param eventType touch/mouse
   * @param volume 音量
   */
  static reportSoundMenu(name: number, eventType: string, volume?: number): void {
    let params: SoundParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      NAME: name,
      EVENT_TYPE: eventType,
      VOLUME: volume
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SOUND_MENU,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC状态栏 系统菜单功能点击 打点
   *
   * @param name 系统菜单项 1，关于本机/2，系统设置/3，睡眠/4，锁定屏幕/5，关机/6，重启
   * @param eventType touch/mouse
   */
  static reportSystemMenu(name: number, eventType: string): void {
    let params: SystemMenuClickParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      NAME: name,
      EVENT_TYPE: eventType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SYSTEM_MENU,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC状态栏 输入法功能点击 打点
   *
   * @param name 0：重启输入法服务/1：切换输入法/2：切换语言
   * @param inputMethod 输入法名称
   * @param language 语言
   */
  static reportInputMethod(name: number, inputMethod: string, language: string): void {
    let params: InputParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      NAME: name,
      INPUT_METHOD: inputMethod,
      LANGUAGE: language
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.INPUT_METHOD_CLICK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC状态栏 语音助手翻译图标点击打点
   *
   */
  static reportAssistantTranslateClick(): void {
    let params: BaseParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.ASSISTANT_TRANSLATE_CLICK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC状态栏 备忘录图标点击打点
   *
   */
  static reportQuickNoteClick(): void {
    let params: BaseParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.QUICK_NOTE_CLICK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 状态栏图标点击打点封装
   *
   * @param keyId状态栏图标唯一标识
   */
  static hiSysOnIconItemClick(keyId: string): void {
    switch (keyId) {
      case PluginSlot.SLOT_STATUS_TRAY_PANEL:
        HiSysEventUtil.reportTrayClick();
        break;
      case PluginSlot.SLOT_STATUS_BATTERY_PANEL:
        HiSysEventUtil.reportBatteryClick();
        break;
      case PluginSlot.SLOT_STATUS_PERSONAL:
        HiSysEventUtil.reportSystemClick();
        break;
      case PluginSlot.SLOT_STATUS_SOUND_PANEL:
        HiSysEventUtil.reportSoundClick();
        break;
      case PluginSlot.SLOT_STATUS_INPUT_PANEL:
        HiDfxEventUtil.reportInputClick();
        break;
      case PluginSlot.SLOT_STATUS_WIFI_PANEL:
        HiDfxEventUtil.reportWlanClick();
        break;
      case PluginSlot.SLOT_STATUS_CLOCK_PANEL:
        HiDfxEventUtil.reportClockClick();
        break;
      case PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL:
        HiDfxEventUtil.reportNotificationClick();
        break;
      case PluginSlot.SLOT_STATUS_CONTROL_CENTER:
        HiDfxEventUtil.reportControlClick();
        break;
      case PluginSlot.SLOT_STATUS_SEARCH:
        HiDfxEventUtil.reportSearchClick();
        break;
      case PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL:
        HiDfxEventUtil.reportBluetoothClick();
        break;
      case PluginSlot.SLOT_STATUS_ASSISTANT_TRANSLATE:
        HiSysEventUtil.reportAssistantTranslateClick();
        break;
      case PluginSlot.SLOT_STATUS_QUICK_NOTE:
        HiSysEventUtil.reportQuickNoteClick();
        break;
      default:
        log.showInfo('keyId, unknown action type.');
        break;
    }
  }

  static hiSysOnIconItemsClick(bundleName: string, slot: string, deskStyle: number): void {
    let params: IconItemsClickParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLENAME: bundleName,
      PLUGINSLOT: slot,
      DESKSTYLE: deskStyle
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SLOT_CLICK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  static hiSysOnIconItemsNumberChange(count: number): void {
    let params: IconItemsNumberChangeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      COUNT: count
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SLOT_COUNT_CHANGE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  static reportLogoL(times: number): void {
    let params: LogoLParams = {
      TIMES: times,
      CURRENT_TIME: JSON.stringify(new Date().getTime())
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.LOGO_L,
      hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 上滑清屏用户行为事件打点
   * @isShow 是否清屏成功
   * @isOneFingerSlip 是否是单指上滑手势
   */
  public static reportShowDesktopGestureEvent(isShow: boolean, isOneFingerSlip: boolean): void {
    let params: ShowDesktopGestureParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      IS_SHOW: isShow
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN,
      isOneFingerSlip ? HiSysEventUtil.PC_ONE_FIN_SHOW_DESKTOP_GESTURE : HiSysEventUtil.PC_SHOW_DESKTOP_GESTURE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 三指下滑还原用户行为事件打点
   * @isRestore 是否还原成功
   * @isExitRecent 是退出多任务还是还原回桌面
   */
  public static reportRestoreDesktopGestureEvent(isRestore: boolean, isExitRecent: boolean): void {
    let params: RestoreDesktopGestureParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      IS_RESTORE: isRestore,
      IS_EXIT_RECENT: isExitRecent
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.PC_RESTORE_DESKTOP_GESTURE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 上滑进多任务用户行为事件打点
   * @isToRecent 是否成功进入多任务
   * @isOneFingerSlip 是否是单指上滑手势
   */
  public static reportToRecentGestureEvent(isToRecent: boolean, isOneFingerSlip: boolean): void {
    let params: ToRecentGestureParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      IS_TO_RECENT: isToRecent
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN,
      isOneFingerSlip ? HiSysEventUtil.PC_ONE_FINGER_TO_RECENT_GESTURE : HiSysEventUtil.PC_TO_RECENT_GESTURE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 一屏一世界切换事件打点
   */
  public static reportSwitchingDesktopEvent(switchingType: string, time: number): void {
    let params: SwitchingType = {
      SWITCHING_TYPE: switchingType,
      CURRENT_TIME: time
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SWITCHING_DESKTOP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 一屏一世界四指横划行为事件打点
   * @duration 横划切换手势划动时长_单位ms
   * @distance 横划切换手势划动横向距离_单位px
   */
  public static reportSwitchDesktopFourFingerSwipe(duration: number, distance: number): void {
    let params: SwitchDesktopFourFingerSwipeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DURATION: duration,
      DISTANCE: distance,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SWITCH_DESKTOP_FOUR_FINGER_SWIPE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 一屏一世界虚拟机使用时间打点
   * @vmState 虚拟机使用形态
   * @timeData 时间数据 结构为[使用时长、终点时刻、起点时刻]
   */
  public static reportVmUsingTimeEvent(vmState: string, timeData: number[]): void {
    let params: VmUsingTimeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      VM_STATE: vmState,
      TIME_DATA: timeData
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.VM_USING_TIME,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  static reportBrightnessDownOrUp(times: number, isDown: boolean): void {
    let params: LogoLParams = {
      TIMES: times,
      DOWN_OR_UP: isDown ? 0 : 1,
      CURRENT_TIME: JSON.stringify(new Date().getTime())
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SHORT_KEY_BRIGHTNESS,
      hiSysEvent.EventType.STATISTIC, params);
  }

  static reportIconClick(times: number, slot: string): void {
    let params: IconClickParams = {
      TIMES: times,
      BUNDLENAME: slot,
      CURRENT_TIME: JSON.stringify(new Date().getTime())
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.ICON_CLICK,
      hiSysEvent.EventType.STATISTIC, params);
  }

  static hiSysWriteStorage(name: number, eventType: string, event: () => void): void {
    let preferences: dataPreferences.Preferences | null = null;
    log.showInfo('hiSysWriteStorage start');
    try {
      preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: HI_SYS_PREFERENCE });
      preferences.putSync(name.toString(), eventType);
      preferences.flush(() => {
        event();
      });
    } catch (e) {
      log.showError(`hiSysWriteStorage error, code: ${e?.code}, msg: ${e?.message}`);
    }

  }

  static hiSysReadStorage(): void {
    log.showInfo('hiSysReadStorage start');
    try {
      let preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: HI_SYS_PREFERENCE });
      let rebootEventType = preferences.getSync(HiSysEventUtil.REBOOT_MENU, 'default');
      log.showInfo('get the REBOOT_MENU value：' + rebootEventType);
      if (rebootEventType !== 'default') {
        HiSysEventUtil.reportSystemMenu(Number.parseInt(HiSysEventUtil.REBOOT_MENU), rebootEventType.toString());
        let deletePromise = preferences.delete(HiSysEventUtil.REBOOT_MENU);
        deletePromise.then(() => {
          log.showInfo('delete REBOOT_MENU');
          preferences.flush();
        });
      }
      let shutdownEventType = preferences.getSync(HiSysEventUtil.SHUTDOWN_MENU, 'default');
      log.showInfo('get the SHUTDOWN_MENU value：' + shutdownEventType);
      if (shutdownEventType !== 'default') {
        HiSysEventUtil.reportSystemMenu(Number.parseInt(HiSysEventUtil.SHUTDOWN_MENU), shutdownEventType.toString());
        let deletePromise = preferences.delete(HiSysEventUtil.SHUTDOWN_MENU);
        deletePromise.then(() => {
          log.showInfo('delete SHUTDOWN_MENU');
          preferences.flush();
        });
      }
    } catch (e) {
      log.showError(`hiSysReadStorage error, code: ${e?.code}, msg: ${e?.message}`);
    }
  }

  static reportEvent(name: string, msg?: Object, type?: hiSysEvent.EventType, domain?: string): void {
    if (msg === undefined || msg === null) {
      msg = {
        PACKAGE_NAME: ReportParams.PACKAGE_NAME,
        PROCESS_NAME: ReportParams.PROCESS_NAME
      } as BaseParams;
    }
    if (!name || name.length > BI_KEY_LENGTH_MAX) {
      // 打点key长度不能超过32
      log.error(`name =  ${name} is error`);
      return;
    }
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: domain === undefined ? HiSysEventUtil.SCENE_BOARD_UE_DOMAIN : domain,
      name: name,
      eventType: type === undefined ? hiSysEvent.EventType.BEHAVIOR : type,
      params: msg
    };
    TaskpoolUtil.sequenceExecute(reportHiSysEvent, sysEventInfo);
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
   * @param useTaskPool 是否使用taskpool 调用打点可能已经处于taskpool中时，不需要再启用taskpool，避免峰值内存增长
   */
  static report(domain: string, name: string, eventType: hiSysEvent.EventType, params: Object,
    useTaskPool = true): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: domain,
      name: name,
      eventType: eventType,
      params: params
    };
    if (useTaskPool) {
      TaskpoolUtil.sequenceExecute(reportHiSysEvent, sysEventInfo);
    } else {
      reportHiSysEvent(sysEventInfo);
    }
  }

  /**
   * 批量打点基础接口
   *
   * @deprecated
   * @useinstead HiSysReportEvent#reportFault/reportStatistic/reportSecurity/reportBehavior
   * @param domain 事件领域
   * @param name 事件名称
   * @param eventType 事件类型
   * @param params 事件参数
   */
  static batchReport(domain: string, name: string, eventType: hiSysEvent.EventType, params: Object[],
    useTaskPool = true): void {
    const sysEventInfos: hiSysEvent.SysEventInfo[] = params.map(param => {
      let sysEventInfo: hiSysEvent.SysEventInfo = {
        domain: domain,
        name: name,
        eventType: eventType,
        params: param
      };
      return sysEventInfo;
    });
    if (useTaskPool) {
      TaskpoolUtil.sequenceExecute(batchReportHiSysEvent, sysEventInfos);
    } else {
      batchReportHiSysEvent(sysEventInfos);
    }
  }

  static reportToggle(eventType: string): void {
    let params: SystemMenuClickParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      EVENT_TYPE: eventType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.TOGGLE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  static reportDockMenuBundles(bundleNames: string): void {
    let params: ButtonEventParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAMES: bundleNames
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DOCK_MENU,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  static reportDockMenuOpen(): void {
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DOCK_MENU_OPEN,
      hiSysEvent.EventType.BEHAVIOR, new DefaultParams());
  }

  static reportDockMenuAppClick(): void {
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DOCK_MENU_APP_CLICK,
      hiSysEvent.EventType.BEHAVIOR, new DefaultParams());
  }

  /**
   * dock栏最近应用区应用点击打点
   *
   * @param bundleName 应用包名
   */
  static reportDockRecentAppClick(bundleName: string): void {
    let params: ClickAppInDockRecentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PACKAGE_NAME,
      BUNDLE_NAME: bundleName
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CLICK_APP_IN_DOCK_RECENT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 调整dock栏分割线
   *
   * @param recentAppNumBeforeAdjust 调整前最近应用区的应用个数
   * @param recentAppNumAfterAdjust 调整后最近应用区的应用个数
   * @param residentAppNum 固定区域应用个数
   */
  static reportDockAdjustSplitLine(recentAppNumBeforeAdjust: number, recentAppNumAfterAdjust: number): void {
    let params: AdjustDockSplitLineParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PACKAGE_NAME,
      RECENT_APP_NUM_BEFORE_ADJUST: recentAppNumBeforeAdjust,
      RECENT_APP_NUM_AFTER_ADJUST: recentAppNumAfterAdjust
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.ADJUST_SPLIT_LINE_IN_DOCK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * dock最近区删除操作打点
   *
   * @param bundleName 被删除的应用包名
   */
  static reportDockDeleteRecentApp(bundleName: string): void {
    let params: DeleteRecentAppParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PACKAGE_NAME,
      BUNDLE_NAME: bundleName
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DELETE_APP_IN_DOCK_RECENT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 用户操作一次最近使用应用长按出的菜单
   *
   * @param bundleName 操作的应用包名
   * @param operationName 操作的名称
   */
  static reportDockRecentMenu(bundleName: string, operationName: string): void {
    let params: DockRecentMenuParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PACKAGE_NAME,
      BUNDLE_NAME: bundleName,
      OPERATION_NAME: operationName
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.OPERATE_MENU_IN_DOCK_RECENT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  static reportKey(shortcutName: string): void {
    let params: ButtonEventParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SHORTCUT_NAME: shortcutName
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SYSTEM_SHORTCUT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  static reportEventById(id: string, msg: string): void {
    let infoParams: SysEventInfoParams = {
      BEHAVIOR_ID: id,
      MSG: msg,
    };

    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: HiSysEventUtil.LAUNCHER_DOMAIN,
      name: 'LAUNCHER_BEHAVIOR',
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: infoParams
    };
    TaskpoolUtil.sequenceExecute(reportHiSysEvent, sysEventInfo);
  }

  /**
   * 解锁进桌面
   */
  public static reportUnlockEnterDesktop(type: string, index: number): void {
    let msg: ReturnToHomeKeyParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      INDEX: index,
      SCREEN_TYPE: HiSysEventUtil.screenType
    };
    HiSysEventUtil.reportEvent(type, msg, hiSysEvent.EventType.BEHAVIOR, HiSysEventUtil.SCREENLOCK_UE);
  }

  /**
   *  进入退出问候模式
   */
  public static reportSlGreetModeEvent(type: string, scene: string): void {
    let msg: SlGreetModeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SCENE: scene
    };
    HiSysEventUtil.reportEvent(type, msg, hiSysEvent.EventType.BEHAVIOR, HiSysEventUtil.SCREENLOCK_UE);
  }

  /**
   *  进入退出96小时旧密码重置
   */
  public static reportResetPinEvent(type: string, scene: string): void {
    let msg: SlResetPinParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SCENE: scene
    };
    HiSysEventUtil.reportEvent(type, msg, hiSysEvent.EventType.BEHAVIOR, HiSysEventUtil.SCREENLOCK_UE);
  }

  /**
   * 手势上滑回桌面
   *
   * @param from APP:从应用上滑，DESKTOP:从桌面上滑
   * @param startPos 手势起始位置
   * @param endPos 手势抬手位置
   * @param curBundleName 当前应用包名
   */
  public static reportReturnToHome(params: ReturnToHomeParams): void {
    params.SCREEN_TYPE = HiSysEventUtil.screenType;
    HiSysEventUtil.mSystemNavReportEvent.reportBehavior(HiSysEventUtil.SWIPE_RETURN_DESKTOP, params);
  }

  /**
   * 大数据打点，上报sceneboard文件大小
   * @param fileNameList:要打点的文件名
   * @param fileSize:要打点的文件大小
   */
  public static reportFileSize(fileNameList: string[], fileSize: number[]): void {
    let params: SceneBoardFileSizeParams = {
      COMPONENT_NAME: ReportParams.PROCESS_NAME,
      PARTITION_NAME: ReportParams.PARTITION_NAME,
      // scenebord 不需要打点剩余大小，默认传0；
      REMAIN_PARTITION_SIZE: 0,
      FILE_OR_FOLDER_PATH: fileNameList,
      FILE_OR_FOLDER_SIZE: fileSize
    };
    HiSysEventUtil.report(HiSysEventUtil.FILEMANAGEMENT, HiSysEventUtil.USER_DATA_SIZE_UE,
      hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 进入多任务
   */
  public static reportGoIntoRecent(params: GoIntoRecentParams): void {
    params.SCREEN_TYPE = HiSysEventUtil.screenType;
    HiSysEventUtil.report(HiSysEventUtil.SYSTEM_NAV_UE, HiSysEventUtil.SWIPE_PAUSE_INTO_RECENT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 多任务界面滑动
   *
   * @param direction 滑动方向 left/right
   */
  public static reportRecentSwiper(direction: string): void {
    let params: RecentSwiperParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DIRECTION: direction
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.RECENT_SWIPER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 手势导航-返回
   *
   * @param result 操作结果：success/cancel
   * @param side 操作方向：left/right
   * @param isMidScene 是否在中景窗态返回操作(1：是中景窗态 0：不是中景窗态)
   * @param bundleName 应用包名
   */
  public static reportBackEvent(result: string, side?: string, isMidScene?: boolean, bundleName?: string): void {
    let params: BackEventParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      RESULT: result,
      BUNDLENAME: bundleName,
      SIDE: side,
      SCREEN_TYPE: HiSysEventUtil.screenType,
      IS_MIDSCENE: isMidScene ? MidSceneState.IS_MID_SCENE : MidSceneState.IS_NOT_MID_SCENE,
    };
    HiSysEventUtil.mSystemNavReportEvent.reportBehavior(HiSysEventUtil.GESTURE_NAVIGATION_BACK_UE, params);
  }

  /**
   * 进入应用中心
   */
  public static reportIntoAppCenter(success: string): void {
    let params: IntoOrExitAppCenterParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SUCCESS: success
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.INTO_APP_CENTER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 退出应用中心
   */
  public static reportExitAppCenter(success: string): void {
    let params: IntoOrExitAppCenterParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SUCCESS: success
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.EXIT_APP_CENTER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 多任务下滑锁定应用
   */
  public static reportSlideLockAppInRecent(params: SlideLockAppInRecentParams): void {
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.RECENT_SLIDE_LOCK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 多任务清除单个应用
   */
  public static reportClearSingleAppInRecent(packageName: string, unClearAble: boolean): void {
    let params: ClearSingleAppInRecentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      UNCLEARABLE: unClearAble,
      SCREEN_TYPE: HiSysEventUtil.screenType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SWIPE_CLEAR_SINGLE_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 多任务一键清除所有应用
   */
  public static reportClearAllAppInRecent(unClearAbleList: string[]): void {
    let params: ClearAllAppInSCBRecentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      UNCLEARABLELIST: unClearAbleList,
      SCREEN_TYPE: HiSysEventUtil.screenType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CLEAR_ALL_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 多任务图标点击进入应用
   */
  public static reportGoIntoAppByTitleInRecent(packageName: string): void {
    let params: GoIntoAppInRecentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      SCREEN_TYPE: HiSysEventUtil.screenType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.GO_INTO_APP_BY_TITLE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 多任务点击进入应用
   */
  public static reportGoIntoAppInRecent(packageName: string): void {
    let params: GoIntoAppInRecentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      SCREEN_TYPE: HiSysEventUtil.screenType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.GO_INTO_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 桌面翻页
   */
  public static reportSnapToPage(isSuccess: boolean, rotationMode: number, deviceType: number, fromPage: number, toPage: number): void {
    let params: SnapToPageParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISSUCCESS: isSuccess,
      ROTATIONMODE: rotationMode,
      DEVICETYPE: deviceType,
      FROMPAGE: fromPage,
      TOPAGE: toPage,
      SCREEN_TYPE: HiSysEventUtil.screenType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DESKTOP_LEFT_RIGHT_SWIPE_EVENT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 加载预制布局写库完成后打点
   * @param params
   */
  public static writePreloadLayout(message: string): void {
    let params: WritePreloadLayoutParams = {
      MESSAGE: message,
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.WRITE_PRELOAD_LAYOUT_EVENT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 启动应用
   */
  public static reportStartApp(packageName?: string): void {
    interface StartAppParams {
      PNAMEID: string;
      PVERSIONID: string;
      PACKAGE_NAME: string | undefined;
      SCREEN_TYPE: number;
      INTELLIGENT_SCENE_MODE_ID: string;
    }
    let params: StartAppParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGE_NAME: packageName,
      SCREEN_TYPE: HiSysEventUtil.screenType,
      INTELLIGENT_SCENE_MODE_ID: HiSysEventUtil.intelligentSceneModeId
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.START_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 设置AOD事件
   */
  public static reportSetAodEvent(params: AodParams): void {
    HiSysEventUtil.reportEvent(HiSysEventUtil.SET_AOD, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.AOD_UE);
  }

  /**
   * 进入AOD事件
   */
  public static reportStartAodEvent(params: AodParams): void {
    HiSysEventUtil.reportEvent(HiSysEventUtil.INTO_AOD, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.AOD_UE);
  }

  /**
   * 退出AOD事件
   */
  public static reportStopAodEvent(params: StopAodParams): void {
    HiSysEventUtil.reportEvent(HiSysEventUtil.EXIT_AOD, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.AOD_UE);
  }

  /**
   * 进入熄屏显示界面
   */
  public static reportEditAodEvent(params: EditAodParams): void {
    HiSysEventUtil.reportEvent(HiSysEventUtil.EDIT_AOD, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.AOD_UE);
  }

  /**
   * 应用AOD样式
   */
  public static reportApplyAodEvent(params: ApplyAodParams): void {
    HiSysEventUtil.reportEvent(HiSysEventUtil.APPLY_AOD, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.AOD_UE);
  }

  /**
   * 灭屏AOD更新
   */
  public static reportUpdateAodEvent(params: UpdateAodParams): void {
    HiSysEventUtil.reportEvent(HiSysEventUtil.UPDATE_AOD, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.AOD_UE);
  }

  /**
   * 跳转更多在线样式
   */
  public static reportEnterViewEvent(params: DefaultAodParams): void {
    HiSysEventUtil.reportEvent(HiSysEventUtil.ENTER_VIEW_AOD, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.AOD_UE);
  }

  /**
   * 关闭文件夹
   *
   * @param folderPositionInDesktop 文件夹位置
   * @param isCardFolder 是否是大文件夹，true表示是大文件夹，false表示不是大文件夹
   * @param folderContent 文件夹内容：SCREENCOUNT: 文件夹的屏幕数,ICONCOUNT:文件夹内图标数
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportCloseFolder(folderPositionInDesktop: string, isCardFolder: boolean, folderContent: string,
    folderId?: string, folderType?: number): void {
    let params: CloseFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISCARDFOLDER: isCardFolder,
      FOLDERPOSITIONINDESKTOP: folderPositionInDesktop,
      FOLDERCONTENT: folderContent,
      ISHIFOLDER: false,
      FOLDERID: folderId,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CLOSE_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 拖动文件夹
   *
   * @param dragStartPositionInDesktop 拖动起始位置
   * @param dragEndPositionInDesktop 拖动结束位置
   * @param isCardFolder 是否是大文件夹，true表示是大文件夹，false表示不是大文件夹
   * @param folderContent 文件夹内容：SCREENCOUNT: 文件夹的屏幕数,ICONCOUNT:文件夹内图标数
   * @param folderId 文件夹id
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportDragFolder(dragStartPositionInDesktop: string, dragEndPositionInDesktop: string,
    isCardFolder: boolean, folderContent: string, folderId: string, folderType: number): void {
    let params: DragFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISCARDFOLDER: isCardFolder,
      DRAGSTARTPOSITIONINDESKTOP: dragStartPositionInDesktop,
      DRAGENDPOSITIONINDESKTOP: dragEndPositionInDesktop,
      FOLDERCONTENT: folderContent,
      ISHIFOLDER: false,
      FOLDERID: folderId,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DRAG_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 文件夹解散
   */
  public static reportDissolveFolder(shortcutCount: number, isCardFolder: boolean, dismissReason: string, folderId: string): void {
    let params: DissolveFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISCARDFOLDER: isCardFolder,
      SHORTCUTCOUNT: shortcutCount,
      DISMISSREASON: dismissReason,
      ISHIFOLDER: false,
      FOLDERID: folderId
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DISSOLVE_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  public static getVersionName(bundleName: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      return '';
    }
    try {
      let bundleInfo: bundleManager.BundleInfo =
        bundleManager.getBundleInfoSync(bundleName, bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
      return bundleInfo.versionName;
    } catch (err) {
      log.error(`get bundle info of the bundleName ${bundleName} error`, err);
      return '';
    }
  }

  /**
   * 更新快游戏引擎对游戏卡片的支持状态
   *
   * @param bundleName 应用包名
   */
  public static updateGameEngineValidStatus(bundleName: string): void {
    if (bundleName !== HiSysEventUtil.GAME_ENGINE_BUNDLE_NAME) {
      log.showInfo(`updateGameEngineValidStatus, not game engine bundle: ${bundleName}`);
      return;
    }
    let result: boolean = HiSysEventUtil.isGameEngineValid();
    log.showInfo(`updateGameEngineValidStatus, bundleName is ${bundleName}, isvalid: ${result}`);
    AppStorage.setOrCreate('isGameEngineValid', result);
  }

  /**
   * 检测快游戏引擎是否可支持游戏卡片
   */
  public static isGameEngineValid(): boolean {
    return HiSysEventUtil.getVersionCode(HiSysEventUtil.GAME_ENGINE_BUNDLE_NAME) >= HiSysEventUtil.VALID_GAME_LAUNCHER_VERSION;
  }

  /**
   * 获取指定包名版本号
   */
  private static getVersionCode(bundleName: string): number {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      return -1;
    }
    try {
      let bundleInfo: bundleManager.BundleInfo =
        bundleManager.getBundleInfoSync(bundleName, bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
      return bundleInfo.versionCode;
    } catch (err) {
      log.error(`get bundle info of the bundleName ${bundleName} error, code: ${err.errcode}, msg: ${err.message}`);
      return -1;
    }
  }

  public static getRotationMode(): number {
    let rotationMode: number;
    let isPortrait: boolean | undefined = AppStorage.get<boolean>('isPortrait');
    // rotationMode: 屏幕旋转类型 0-竖屏 1-横屏
    if (isPortrait === false) {
      rotationMode = 1;
    } else {
      rotationMode = 0;
    }
    return rotationMode;
  }

  /**
   * 长按应用进入快捷菜单
   */
  public static reportGoIntoAppShortcutMenu(component: string, title: string, scene?: string): void {
    let params: GoIntoAppShortcutMenuParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      COMPONENT: component,
      TITLE: title,
      SCENE: scene
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.GO_INTO_APP_SHORTCUT_MENU,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 长按快捷方式-移除打点
   *
   * @param bundleName 应用包名
   * @param shortCutName 快捷方式名
   */
  public static reportDeleteShortcutMenu(bundleName: string, shortCutName: string): void {
    let params: DeleteShortcutParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLENAME: bundleName,
      SHORTCUTNAME: shortCutName,
      SCREEN_TYPE: HiSysEventUtil.screenType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DELETE_SHORTCUT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 生成大文件夹
   */
  public static reportCreateBigFolder(folderId: string, type: boolean, screenType: number): void {
    let params: CreateBigFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FOLDERID: folderId,
      SCREENTYPE: screenType,
      TYPE: type
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CREATE_BIG_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 生成小文件夹
   */
  public static reportCreateSmallFolder(folderId: string, screenType: number, operation: number, content: string, position: string, appCategory: string): void {
    let params: CreateSmallFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SCREENTYPE: screenType,
      OPERATION: operation,
      FOLDERCONTENT: content,
      FOLDERPOSITION: position,
      FOLDERID: folderId,
      APPCATEGORY: appCategory
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CREATE_SMALL_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 文件夹内翻页
   *
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportSnapToPageInFolder(folderId: string, appCount: number, pageCount: number, isCardFolder: boolean,
    folderType: number): void {
    let params: SnapToPageInFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FOLDERID: folderId,
      APPCOUNT: appCount,
      PAGECOUNT: pageCount,
      ISCARDFOLDER: isCardFolder,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.LEFT_RIGHT_SWIPE_IN_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 文件夹反向添加删除
   *
   * @param folderId 文件夹Id
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   * @param isBigFolder 是否是大文件夹 true-是, false-否
   */
  public static reportReverseAddInFolder(folderId: string, folderType?: number, isCardFolder?: boolean): void {
    let params: ReverseAddInFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FOLDERID: folderId,
      FOLDERTYPE: folderType,
      ISCARDFOLDER: isCardFolder
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.ADD_OR_REMOVE_APP_IN_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 拖动图标向文件夹内增加应用
   */
  public static reportDragIconIntoFolder(draggingPackageNames: string, folderPositionInDesktop: string, isCardFolder: boolean,
    folderContent: string, folderId: string): void {
    let params: DragIconIntoFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISBATCH: false,
      ISDRAGIN: true,
      DRAGGINGPACKAGENAMES: draggingPackageNames,
      ISCARDFOLDER: isCardFolder,
      FOLDERPOSITIONINDESKTOP: folderPositionInDesktop,
      FOLDERCONTENT: folderContent,
      ISHIFOLDER: false,
      FOLDERID: folderId
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DRAG_ICON_INTO_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 拖动鸿蒙化图标向未鸿蒙化文件夹内增加应用
   *
   * @param folderPositionInDesktop 被拖动应用的起始位置
   * @param isCardFolder 是否是大文件夹，true表示是大文件夹，false表示不是大文件夹
   * @param folderContent 文件夹内容：SCREENCOUNT: 文件夹的屏幕数,ICONCOUNT:文件夹内图标数
   * @param folderId 文件夹id
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportDragIconIntoNotHarmonyFolder(folderPositionInDesktop: string,
    isCardFolder: boolean, folderContent: string, folderId: string, folderType: number): void {
    let params: DragIconIntoNotHarmonyFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISCARDFOLDER: isCardFolder,
      FOLDERPOSITIONINDESKTOP: folderPositionInDesktop,
      FOLDERCONTENT: folderContent,
      FOLDERID: folderId,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DRAG_ICON_INTO_NH_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 点亮未鸿蒙化文件夹中图标
   *
   * lighticonInfo 被点亮图标的信息（含bundleName-应用包名）
   */
  public static reportLightIconInNotHarmonyFolder(lighticonInfo: LightIconInNotHarmonyFolderBean): void {
    let params: LightIconInNotHarmonyFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLENAME: lighticonInfo.bundleName,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.LIGHT_ICON_IN_NH_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 点击dock栏应用
   */
  public static reportClickAppInDock(ciId: string): void {
    let params: ClickAppInDockParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CIID: ciId
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CLICK_APP_IN_DOCK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 点击锁屏小组件应用
   */
  public static reportClickAppInShortcut(bundleName: string): void {
    let params: ClickAppInShortcutParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CLICK_APP_IN_SCREEN_LOCK_SHORTCUT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 点击桌面应用
   *
   * @param ISLIGHTING 是否点亮 'true'-是，'false'-否
   * @param 点亮时间
   */
  public static reportClickAppIcon(component: string, containerType: string, iconPositionInDesktop: string,
    folderPositionInDesktop: string, iconPositionInFolder: string, isBigIconInCardFolder: string, isHiFolder: string,
    folderId: string, clickAppTpp: number, appIndex: number, isLighting: string, lightingTime: string): void {
    let params: ClickAppIconParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      COMPONENT: component,
      CONTAINERTYPE: containerType,
      ICONPOSITIONINDESKTOP: iconPositionInDesktop,
      FOLDERPOSITIONINDESKTOP: folderPositionInDesktop,
      ICONPOSITIONINFOLDER: iconPositionInFolder,
      ISBIGICONINCARDFOLDER: isBigIconInCardFolder,
      ISHIFOLDER: isHiFolder,
      FOLDERID: folderId,
      SCREEN_TYPE: HiSysEventUtil.screenType,
      CLICKAPPTYPE: clickAppTpp,
      APP_INDEX: appIndex ?? 0,
      ISLIGHTING: isLighting,
      LIGHTINGTIME: lightingTime
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CLICK_APP_ICON,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 点击、文件夹中应用出现弹窗
   *
   * @param bundleName 应用包名
   */
  public static reportdeliverDialogOpen(bundleName: string): void {
    let params: deliverDialogOpenParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLENAME: bundleName,

    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DELIVER_DIALOG_OPEN,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 、文件夹中应用弹窗操作
   *
   * @param bundleName 应用包名
   * @param dialogType 弹窗类型 0-下载新版本，1-弹窗类型：已，卸载版本，2-下载、
   * @param operation 具体操作
   */
  public static reportdeliverDialogOperation(bundleName: string, dialogType: number, operation: string): void {
    let params: deliverDialogOperationParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLENAME: bundleName,
      DIALOGTYPE: dialogType,
      OPERATION: operation
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DELIVER_DIALOG_OPERATION,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 点击桌面快捷方式
   */
  public static reportClickShortcut(component: string, shortcutId: string, containerType: string, iconPositionInDesktop: string,
    folderPositionInDesktop: string, iconPositionInFolder: string, folderId: string): void {
    let params: ClickShortcutParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      COMPONENT: component,
      SHORTCUTID: shortcutId,
      CONTAINERTYPE: containerType,
      ICONPOSITIONINDESKTOP: iconPositionInDesktop,
      FOLDERPOSITIONINDESKTOP: folderPositionInDesktop,
      ICONPOSITIONINFOLDER: iconPositionInFolder,
      FOLDERID: folderId,
      SCREEN_TYPE: HiSysEventUtil.screenType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CLICK_SHORTCUT_ICON,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 点击暂停桌面下载应用
   * @param bundleName 应用包名
   */
  public static reportPauseAppDownload(bundleName: string): void {
    let params: PauseAppDownload = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: bundleName
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.PAUSE_DOWNLOAD_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 点击继续桌面下载应用
   * @param bundleName 应用包名
   */
  public static reportContinueAppDownload(bundleName: string): void {
    let params: ContinueAppDownload = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: bundleName
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CONTINUE_DOWNLOAD_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 桌面应用下载的动画时长
   * @param bundleName 应用包名
   * @param duration 动画持续时长
   */
  public static reportAnimationDurationAppDownload(bundleName: string, duration: number): void {
    let params: AnimationDurationAppDownload = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: bundleName,
      VISIBLETIMEMS: duration
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.ANIMATION_DURATION_DOWNLOAD_APP,
      hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 取消卸载单应用
   *
   * @param bundleName 应用包名
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportCancelUninstallSingleApp(bundleName: string, folderType: number): void {
    let params: CancelAppUninstall = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: bundleName,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CANCEL_UNSTALL_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 重新加载桌面
   * @param title 场景
   * @param time 加载时长
   * @param userid 0|主用户, 其他|非主用户
   */
  public static reportReloadDesktop(time: number, userid: number): void {
    let params: ReloadDesktop = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      TIME: time,
      USERID: userid,
      SCREEN_TYPE: HiSysEventUtil.screenType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.RELOAD_DESKTOP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }


  /**
   * 桌面概要信息
   * @param DesktopInformation
   */
  public static reportDesktopInformation(DesktopInformation: DesktopInformation): void {
    let params: DesktopInformation = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SCREEN: DesktopInformation.SCREEN,
      ICON: DesktopInformation.ICON,
      FA: DesktopInformation.FA,
      FORMSTACK: DesktopInformation.FORMSTACK,
      FAOFFORMSTACK: DesktopInformation.FAOFFORMSTACK,
      HOME_PAGE_INDEX: DesktopInformation.HOME_PAGE_INDEX,
      BIGFOLDER: DesktopInformation.BIGFOLDER,
      SMALLFOLDER: DesktopInformation.SMALLFOLDER,
      FOLDER: DesktopInformation.FOLDER,
      PRESETS_STACK_NUM: DesktopInformation.PRESETS_STACK_NUM,
      PRESETS_CARD_NUM: DesktopInformation.PRESETS_CARD_NUM,
      UPGRADE_CARD_NUM: DesktopInformation.UPGRADE_CARD_NUM,
      CLICKBACKSTATUS: DesktopInformation.CLICKBACKSTATUS,
      ICONSIZE: DesktopInformation.ICONSIZE,
      IS_NAME_SHOW: DesktopInformation.IS_NAME_SHOW,
      THREE_BTN_POSITION_STYLE_WEEK: DesktopInformation.THREE_BTN_POSITION_STYLE_WEEK,
      FLOATING_BALL_SWITCH_STATUS: DesktopInformation.FLOATING_BALL_SWITCH_STATUS,
      LOCKLAYOUTSTATUS: DesktopInformation.LOCKLAYOUTSTATUS,
      SHORTCUTICONNUMBER: DesktopInformation.SHORTCUTICONNUMBER,
      BAREICONNUMBER: DesktopInformation.BAREICONNUMBER,
      BARESHORTCUTICONNUMBER: DesktopInformation.BARESHORTCUTICONNUMBER,
      DESKTOPLAYOUT: DesktopInformation.DESKTOPLAYOUT,
      HISEARCHSTATUS: DesktopInformation.HISEARCHSTATUS,
      AUTOALIGNSTATUS: DesktopInformation.AUTOALIGNSTATUS,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DESKTOP_INFORMATION,
      hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 新形态小外屏桌面概要信息
   *
   * @param DesktopInformation
   */
  public static reportOuterDesktopInformation(OuterDesktopInformation: OuterDesktopInformation): void {
    let params: OuterDesktopInformation = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ICON: OuterDesktopInformation.ICON,
      FA: OuterDesktopInformation.FA,
      SCREEN: OuterDesktopInformation.SCREEN,
      FORMSTACK: OuterDesktopInformation.FORMSTACK,
      PRESETS_CARD_NUM: OuterDesktopInformation.PRESETS_CARD_NUM,
      PRESETS_STACK_NUM: OuterDesktopInformation.PRESETS_STACK_NUM,
      SHORTCUT_NUM: OuterDesktopInformation.SHORTCUT_NUM
    };
    HiSysEventUtil.report(HiSysEventUtil.OUTER_HOME_UE, HiSysEventUtil.OUTER_DESKTOP_INFORMATION,
      hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 打开文件夹
   *
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportOpenFolder(pageNum: number, iconNum: number, isCardFolder: boolean, folderType: number,
    folderPosition?: string, shortcutCount?: number, folderId?: string): void {
    let params: OpenFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PAGENUM: pageNum,
      ICONNUM: iconNum,
      ISCARDFOLDER: isCardFolder,
      FOLDERPOSITION: folderPosition,
      SHORTCUTCOUNT: shortcutCount,
      ISHIFOLDER: false,
      FOLDERID: folderId,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.OPEN_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 长按文件夹内的图标拖动变换位置
   *
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportMoveIconInFolder(moveIconInFolderBean: MoveIconInFolderBean, folderType?: number): void {
    if (!moveIconInFolderBean) {
      log.showError('moveIconInFolderBean error');
      return;
    }
    let params: MoveIconInFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISCARDFOLDER: moveIconInFolderBean.isCardFolder,
      ISHIFOLDER: false,
      FOLDERPOSITIONINDESKTOP: moveIconInFolderBean.folderPositionInDesktop,
      FOLDERCONTENT: moveIconInFolderBean.folderContent,
      PACKAGENAMES: moveIconInFolderBean.packageNames,
      STARTPOSITION: moveIconInFolderBean.startPosition,
      ENDPOSITION: moveIconInFolderBean.endPosition,
      FOLDERID: moveIconInFolderBean.folderId,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.MOVE_ICON_IN_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 文件夹_拖动应用图标/应用快捷方式至文件夹外 (非批量)
   */
  public static reportDragIconFromFolder(dragIconIntoFolderBean: DragIconIntoFolderBean): void {
    if (!dragIconIntoFolderBean) {
      log.showError('dragIconIntoFolderBean error');
      return;
    }
    let params: DragIconIntoFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISBATCH: false,
      ISDRAGIN: false,
      DRAGGINGPACKAGENAMES: dragIconIntoFolderBean.draggingPackageNames,
      ISCARDFOLDER: dragIconIntoFolderBean.isCardFolder,
      FOLDERPOSITIONINDESKTOP: dragIconIntoFolderBean.folderPositionInDesktop,
      FOLDERCONTENT: dragIconIntoFolderBean.folderContent,
      ISHIFOLDER: false,
      FOLDERID: dragIconIntoFolderBean.folderId
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DRAG_ICON_INTO_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 文件夹_拖动应用图标/应用快捷方式至未鸿蒙化文件夹外 (非批量)
   */
  public static reportDragIconFromNotHarmonyFolder(dragIconFromFolderBean: DragIconFromNotHarmonyFolderBean): void {
    if (!dragIconFromFolderBean) {
      log.showError('dragIconIntoFolderBean error');
      return;
    }
    let params: DragIconFromNotHarmonyFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISCARDFOLDER: dragIconFromFolderBean.isCardFolder,
      FOLDERPOSITIONINDESKTOP: dragIconFromFolderBean.folderPositionInDesktop,
      FOLDERCONTENT: dragIconFromFolderBean.folderContent,
      FOLDERID: dragIconFromFolderBean.folderId,
      FOLDERTYPE: dragIconFromFolderBean.folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DRAG_ICON_FROM_NH_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 文件夹_通过菜单方式转换文件夹类型
   *
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportMenuModifyFolderSize(folderSizeModifyBean: FolderSizeModifyBean): void {
    if (!folderSizeModifyBean) {
      log.showError('folderSizeModifyBean error');
      return;
    }
    let params: FolderSizeModifyParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      OPERATION: folderSizeModifyBean.operation,
      RESULT: folderSizeModifyBean.result,
      FOLDERICONPOSITIONINDESKTOP: folderSizeModifyBean.folderIconPositionInDesktop,
      FOLDERCONTENT: folderSizeModifyBean.folderContent,
      FOLDERID: folderSizeModifyBean.folderId,
      ISHIFOLDER: false,
      FOLDERTYPE: folderSizeModifyBean.folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CONVERT_FOLDER_TYPE_BY_MENUS,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 丢失APP事件
   */
  public static reportBackUpMismatchAppEventInfo(mismatchAppStr: string, lostAppStr: string, totalApp: number,
    misAppCount: number): void {
    interface BackUpMismatchParams {
      PNAMEID: string;
      PVERSIONID: string;
      MISMATCH_APP_LIST: string;
      LOST_APP_LIST: string;
      TOTAL_APP: number;
      MISMATCH_APP_NUM: number;
    }
    let params: BackUpMismatchParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      MISMATCH_APP_LIST: mismatchAppStr,
      LOST_APP_LIST: lostAppStr,
      TOTAL_APP: totalApp,
      MISMATCH_APP_NUM: misAppCount
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.BACKUP_MISMATCH_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 丢失Card事件
   */
  public static reportBackUpMismatchCardEventInfo(mismatchCardStr: string, totalCard: number, misCardCount: number,
    mismatchWidgetStr: string, totalWidget: number, misWidgetCount: number): void {
    interface BackUpMismatchCardParams {
      PNAMEID: string;
      PVERSIONID: string;
      MISMATCH_CARD_LIST: string;
      TOTAL_CARD: number;
      MISMATCH_CARD_NUM: number;
      MISMATCH_WIDGET_LIST: string;
      TOTAL_WIDGET: number;
      MISMATCH_WIDGET_NUM: number;
    }
    let params: BackUpMismatchCardParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      MISMATCH_CARD_LIST: mismatchCardStr,
      TOTAL_CARD: totalCard,
      MISMATCH_CARD_NUM: misCardCount,
      MISMATCH_WIDGET_LIST: mismatchWidgetStr,
      TOTAL_WIDGET: totalWidget,
      MISMATCH_WIDGET_NUM: misWidgetCount,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.BACKUP_MISMATCH_CARD,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 快捷方式丢失事件
   */
  public static reportBackUpMismatchShortCutEventInfo(mismatchShortCutStr: string, shortCutCount: number): void {
    interface BackUpMismatchShortCutParams {
      PNAMEID: string;
      PVERSIONID: string;
      MISMATCH_SHORTCUT_LIST: string;
      MISMATCH_SHORTCUT_NUM: number;
      TOTAL_SHORTCUT: number;
    }
    let params: BackUpMismatchShortCutParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      MISMATCH_SHORTCUT_LIST: mismatchShortCutStr,
      MISMATCH_SHORTCUT_NUM: shortCutCount,
      TOTAL_SHORTCUT: shortCutCount
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.BACKUP_MISMATCH_SHORTCUT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 备份恢复结果和耗时
   */
  public static reportBackUpResultEventInfo(result: number, costTime: number, stage: number, layoutScheme: number): void {
    interface BackUpResultParams {
      PNAMEID: string;
      PVERSIONID: string;
      BACKUP_RESULT: number;
      BACKUP_TIME: number;
      BACKUP_STAGE: number;
      BACKUP_LAYOUT_SCHEME: number;
    }
    let params: BackUpResultParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BACKUP_RESULT: result,
      BACKUP_TIME: costTime,
      BACKUP_STAGE: stage,
      BACKUP_LAYOUT_SCHEME: layoutScheme
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.BACKUP_RESULT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 打开卸载弹窗
   *
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   * @param isBigFolder 是否是大文件夹 true-是, false-否
   */
  public static reportOpenUninstallAppDialog(packageName: string, folderType: number, isCardFolder?: boolean): void {
    let params: OpenUninstallAppDialogParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      FOLDERTYPE: folderType,
      ISCARDFOLDER: isCardFolder
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.UNINSTALL_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 打开移除弹窗（新形态小折叠外屏）
   *
   * @param packageName 应用包名
   */
  public static reportOpenDeleteAppDialog(packageName: string): void {
    let params: OpenDeleteAppDialogParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName
    };
    HiSysEventUtil.report(HiSysEventUtil.OUTER_HOME_UE, HiSysEventUtil.DELETE_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 文件夹内应用长按点击移除按钮打点
   *
   * @param packageName 应用包名
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportClickDeleteAppDialog(packageName: string, folderType: number): void {
    let params: ClickDeleteAppDialogParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DELETE_APP_IN_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 确定卸载应用
   *
   * @param component 被移除应用名
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   * @param isBigFolder 是否是大文件夹 true-是, false-否
   */
  public static reportUninstallApp(component: string, folderType: number, isCardFolder?: boolean): void {
    let params: UninstallAppParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      COMPONENT: component,
      UNINSTALL: 'UNINSTALL',
      FOLDERTYPE: folderType,
      ISCARDFOLDER: isCardFolder
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DETERMINED_UNINSTALL_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 从桌面移除应用
   *
   * @param packageName 应用包名
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportRemoveApp(packageName: string, folderType: number): void {
    let params: RemoveAppParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DELETE_APP_IN_DESKTOP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 取消从桌面移除应用
   *
   * @param packageName 应用包名
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportCancelRemoveApp(packageName: string, folderType: number): void {
    let params: CancelRemoveAppParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CANCEL_DELETE_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 确定移除应用（新形态小折叠外屏）
   *
   * @param component 被移除应用名
   */
  public static reportDeleteApp(component: string): void {
    let params: DeleteAppParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      COMPONENT: component
    };
    HiSysEventUtil.report(HiSysEventUtil.OUTER_HOME_UE, HiSysEventUtil.DETERMINED_DELETE_APP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 进入全搜
   *
   * @param startX 全搜手势起点X坐标（距离屏幕左边缘距离）
   * @param startY 全搜手势起点Y坐标（距离屏幕上边缘距离）
   * @param endX 全搜手势终点X坐标（距离屏幕边左缘距离）
   * @param endY 全搜手势终点Y坐标（距离屏幕上边缘距离）
   */
  public static reportIntoSearch(startX?: number, startY?: number, endX?: number, endY?: number): void {
    let params: IntoGlobalSearchParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      STARTX: startX,
      STARTY: startY,
      ENDX: endX,
      ENDY: endY
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.INTO_SEARCH, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.SCENE_BOARD_UE_DOMAIN);
  }

  /**
   * 退出全搜
   */
  public static reportExitSearch(duration: number): void {
    let params: ExitGlobalSearchParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DURATION: duration
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.EXIT_SEARCH, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.SCENE_BOARD_UE_DOMAIN);
  }

  /**
   * 进入负一屏
   */
  public static reportIntoAA(): void {
    let params: IntoNegativeScreenParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.INTO_AA, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.SCENE_BOARD_UE_DOMAIN);
  }

  /**
   * 退出负一屏
   */
  public static reportExitAA(duration: number): void {
    let params: ExitNegativeScreenParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DURATION: duration
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.EXIT_AA, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.SCENE_BOARD_UE_DOMAIN);
  }

  /**
   * 长按文件夹弹出菜单
   */
  public static reportLongPressFolder(folderId?: string, isCardFolder?: boolean): void {
    let params: LongPressFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISCARDFOLDER: isCardFolder,
      ISHIFOLDER: false,
      FOLDERID: folderId
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.LONG_PRESS_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 应用内加桌快捷方式
   *
   * @param bundleName 应用bundleName
   * @param shortcutId 快捷方式id
   */
  public static reportInAppAddShortcutToDesktop(bundleName: string, shortcutId: string): void {
    let params: InAppAddShortcutToDesktop = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      SHORTCUT_ID: shortcutId
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.IN_APP_ADD_SHORTCUT_TO_DESKTOP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 文件夹改名
   */
  public static reportRenameFolder(folderId?: string, isCardFolder?: boolean, isChanged?: boolean, entrance?: string): void {
    let params: RenameFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISCARDFOLDER: isCardFolder,
      ISHIFOLDER: false,
      FOLDERID: folderId,
      ENTRANCE: entrance,
      ISCHANGED: isChanged
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.RENAME_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 未鸿蒙化文件夹改名打点
   *
   * @param folderType 文件夹类型 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-均不是
   */
  public static reportRenameNotHarmonyFolder(folderType: number): void {
    let params: RenameNotHarmonyFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.RENAME_NOT_HARMONY_FOLDER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * FOLDER_NAVI 2x4大文件夹使用引导
   */
  public static reportFolderNavi(checkCount: number): void {
    let params: FolderNaviParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CHECK_COUNT: checkCount
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.FOLDER_NAVI,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC桌面空白处右键菜单
   * @param menuType 点击的菜单项（0:拉起右键菜单,1:点击“整理”,2:“编辑壁纸”,3:“显示和亮度”,4:“终端”）
   */
  public static reportDesktopRightMenu(menuType: number): void {
    let params: DesktopRightMenuParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      MENU_TYPE: menuType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DESKTOP_RIGHT_MENU,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * super fold 切换桌面打点
   *
   * @param type 切换方式
   */
  public static reportSwipePage(type: number): void {
    let params: SuperFoldSwipeChangeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SWIPER_METHOD: type
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SUPER_FOLD_SWIPE_PAGE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 桌面上的各元素数量统计
   */
  public static reportDesktopItemsCount(DesktopItemsCount: DesktopItemsCountParams): void {
    let params: DesktopItemsCountParams = {
      PNAMEID: DesktopItemsCount.PNAMEID,
      PVERSIONID: DesktopItemsCount.PVERSIONID,
      DTYPE: DesktopItemsCount.DTYPE,
      APPCNT: DesktopItemsCount.APPCNT,
      FCNT: DesktopItemsCount.FCNT,
      FDCNT: DesktopItemsCount.FDCNT,
      FACNT: DesktopItemsCount.FACNT,
      SCCNT: DesktopItemsCount.SCCNT,
      RFCNT: DesktopItemsCount.RFCNT
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DESKTOP_ITEMS_COUNT_DATA,
      hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 应用中心的各元素数量统计
   */
  public static reportAppCenterItemsCount(appCenterItemsCount: AppCenterItemsCountParams): void {
    let params: AppCenterItemsCountParams = {
      PNAMEID: appCenterItemsCount.PNAMEID,
      PVERSIONID: appCenterItemsCount.PVERSIONID,
      DTYPE: appCenterItemsCount.DTYPE,
      PAGECNT: appCenterItemsCount.PAGECNT,
      SINGLEPAGEICONSCNT: appCenterItemsCount.SINGLEPAGEICONSCNT,
      SUMICONSCNT: appCenterItemsCount.SUMICONSCNT
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.APPCENTER_ITEMS_COUNT_DATA,
      hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 点击X号重命名
   */
  public static clearFolderName(folderId?: string, isCardFolder?: boolean, isChanged?: boolean, entrance?: string): void {
    let params: RenameFolderParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ISCARDFOLDER: isCardFolder,
      ISHIFOLDER: false,
      FOLDERID: folderId,
      ENTRANCE: entrance,
      ISCHANGED: isChanged
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CLEAR_FOLDER_NAME,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * exit keyguard
   */
  public static reportExitKeyguard(): void {
    let params: ClearAllAppInRecentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCREENLOCK_UE, HiSysEventUtil.EXIT_KEYGUARD,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * hide keyguard
   */
  public static reportHideKeyguard(): void {
    let params: ClearAllAppInRecentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCREENLOCK_UE, HiSysEventUtil.HIDE_KEYGUARD,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * into keyguard
   */
  public static reportShowKeyguard(): void {
    let params: ClearAllAppInRecentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCREENLOCK_UE, HiSysEventUtil.SHOW_KEYGUARD,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * record after dragging a window to hot area and window mode has changed successfully to split or full screen
   * @param currentpkg the package name of app
   * @param changedWindowMode the window mode that is chosen: 1 left, 2 right, 3 full screen
   * @param windowPosition -1 not hopper; 0: B screen; 1: C screen;
   */
  public static reportWinDragToHotarea(currentpkg: string, changedWindowMode: number, windowPosition: number = -1): void {
    const isChangedWindowModeValid = [1, 2, 3].includes(changedWindowMode);
    if (isChangedWindowModeValid === false) {
      return;
    }
    const params: WinDragToHotareaParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CHANGEDWINDOWMODE: changedWindowMode,
      CURRENTPKG: currentpkg,
      WINDOWPOSITION: windowPosition
    };

    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.WIN_DRAG_TO_HOTAREA,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 拖动大文件夹改变大小事件
   */
  public static reportDragChangeFolderSize(changeParams: DragChangeFolderSizeParams): void {
    let params: DragChangeFolderSizeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      OLDSPAN: changeParams.OLDSPAN,
      NEWSPAN: changeParams.NEWSPAN,
      OLDPOSITION: changeParams.OLDPOSITION,
      NEWPOSITION: changeParams.NEWPOSITION,
      PAGEINDEX: changeParams.PAGEINDEX,
      FOLDERID: changeParams.FOLDERID,
      ISHIFOLDER: changeParams.ISHIFOLDER,
      ISEDITMODE: changeParams.ISEDITMODE,
      FOLDERTYPE: changeParams.FOLDERTYPE
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DRAG_CHANGE_BIG_FOLDER_SIZE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 拖动大文件夹改变大小失败, failType取值 1/2/3
   */
  public static reportDragChangeFolderFail(failType: number): void {
    let params: DragChangeFolderSizeFailParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FAILEDTYPE: failType,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DRAG_CHANGE_BIG_FOLDER_SIZE_FAIL,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * record the amount of windows every certain period
   * @param currentwindownum: the current amount of windows
   */
  public static reportCurrentWindowNum(currentwindownum: number): void {
    const isCurrentwindownumValid = !isNaN(currentwindownum);
    if (isCurrentwindownumValid === false) {
      return;
    }
    const params: CurrentWindowNumParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CURRENTWINDOWNUM: currentwindownum,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.CURRENT_WINDOW_NUM,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 自由窗口模式 进出打点
   *
   * @param params 参考 SwitchFreeMultiWindowModeParams
   */
  public static reportSwitchFreeMultiWindowMode(params: SwitchFreeMultiWindowModeParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SWITCH_FREE_MULTI_WINDOWS_MODE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 电脑模式 切换打点
   *
   * @param params 参考 SwitchFreeMultiWindowModeParams
   */
  public static reportSwitchComputerMode(params: SwitchComputerModeParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SWITCH_COMPUTER_MODE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * Dock自动隐藏开关打点
   */
  public static reportDockAutoHide(isAutoHide: boolean): void {
    let params: DockAutoHideParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SWITCH_STATE: isAutoHide
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DOCK_AUTO_HIDE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 桌面搜索结果，点击图标右侧定位
   */
  public static reportSearchAppPosition(component: string, shortcutId: string): void {
    let params: SearchAppPositionParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      COMPONENT: component,
      SHORTCUTID: shortcutId,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DESKTOP_SEARCH_APPICON_POSITION,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 导航条点击时打点
   *
   * @param isOn 是否开启
   */
  static reportOnClickNAVIBar(isOn: boolean): void {
    let params: OnClickNAVIBarParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      IS_ON: isOn
    };
    HiSysEventUtil.report(HiSysEventUtil.SYSTEM_NAV_UE, HiSysEventUtil.aiNavigationBarOnclick,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 通知中心显示打点
   *
   * @param params 参考 NotificationPanelShow
   */
  static async reportNotificationPanelShow(params: NotificationPanelShow, expandStatus: boolean): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    HiSysEventUtil.setFoldParams(params, expandStatus);
    HiSysEventUtil.report(HiSysEventUtil.NOTIFICATION_UE, HiSysEventUtil.NOTIFICATION_PANEL_SHOW, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 通知中心隐藏打点 expandStatus: 用于替换 SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()
   *
   * @param params 参考 NotificationPanelHide
   */
  static async reportNotificationPanelHide(params: NotificationPanelHide, expandStatus: boolean): Promise<void> {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    HiSysEventUtil.setFoldParams(params, expandStatus);
    HiSysEventUtil.report(HiSysEventUtil.NOTIFICATION_UE, HiSysEventUtil.NOTIFICATION_PANEL_HIDE, hiSysEvent.EventType.BEHAVIOR, params);
  }
  /**
   * 文件管理 彻底删除
   */
  public static reportCompletelyDelete(dtype: number, ftype: number): void {
    let params: CompletelyDeleteParams = {
      DTYPE: dtype,
      FTYPE: ftype
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.Completely_Delete,
      hiSysEvent.EventType.BEHAVIOR, params);
  }
  /**
   * 文件管理 桌面满时继续添加
   */
  public static reportFullContinueAdding(dtype: number): void {
    let params: FullContinueAddingParams = {
      DTYPE: dtype,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.Full_Continue_Adding,
      hiSysEvent.EventType.BEHAVIOR, params);
  }
  /**
   * 文件管理 拉起文件右键菜单
   */
  public static reportPullRightMenu(dtype: number): void {
    let params: PullRightMenuParams = {
      DTYPE: dtype,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.Pull_Right_Menu,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 桌面 空白处右键菜单进入个性化
   */
  public static reportDesktopRightMenuIndividuation(): void {
    let params:DesktopRightMenuParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DESKTOP_RIGHT_MENU_INDIVIDUATION,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 桌面 空白处右键菜单进入卡片中心
   */
  public static reportDesktopRightMenuFormCenter(): void {
    let params:DesktopRightMenuParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DESKTOP_RIGHT_MENU_FORM_CENTER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 应用中心 拉起方式打点
   */
  public static reportPullAppCenter(otype: number): void {
    let params: PullAppCenterTypeParams = {
      OTYPE: otype,
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.Pull_APPCENTER_TYPE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 应用中心 操作类型
   */
  public static reportOperateTypeAppCenter(otype: string): void {
    let params: OperatorAppCenterTypeParams = {
      OTYPE: otype,
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.PC_OPERATE_TYPE_APP_CENTER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }


  /**
   * 控制中心显示打点
   *
   * @param params 参考ControlCenterShow
   */
  static reportControlCenterShow(params: ControlCenterShow): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CONTROL_CENTER_SHOW, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心隐藏打点
   *
   * @param params 参考ControlCenterHide
   */
  static reportControlCenterHide(params: ControlCenterHide): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CONTROL_CENTER_HIDE, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心点击快捷开关打点
   *
   * @param params 参考CCQuickToggleClick
   */
  static reportCCQuickToggleClick(params: CCQuickToggleClick): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CC_QUICK_TOGGLE_CLICK, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心长按快捷开关打点
   *
   * @param params 参考CCQuickToggleLongClick
   */
  static reportCCQuickToggleLongClick(params: CCQuickToggleLongClick): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CC_QUICK_TOGGLE_LONG_CLICK, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心点击响铃快捷开关打点
   *
   * @param params 参考CCQuickToggleClickSound
   */
  static reportCCQuickToggleClickSound(params: CCQuickToggleClickSound): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CC_QUICK_TOGGLE_CLICK_SOUND, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心点击电子书模式快捷开关打点
   *
   * @param params 参考CCQuickToggleClickEBook
   */
  static reportCCQuickToggleClickEBook(params: CCQuickToggleClickEBook): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CC_QUICK_TOGGLE_CLICK_EBOOK, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心切换护眼模式打点
   *
   * @param params CCQuickToggleEyeComport
   */
  static reportCCEyeComportChangeEvent(params: CCQuickToggleEyeComport,): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CC_SUBPAGE_CLICK_EYE_COMPORT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心长按响铃快捷开关打点
   *
   * @param params 参考CCQuickToggleClickSound
   */
  static reportCCQuickToggleLongClickSound(params: CCQuickToggleLongClickSound): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CC_QUICK_TOGGLE_LONG_CLICK_SOUND, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心长按电子书模式快捷开关打点
   *
   * @param params CCQuickToggleLongClickEBook
   */
  static reportCCQuickToggleLongClickEBook(params: CCQuickToggleLongClickEBook): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CC_QUICK_TOGGLE_LONG_CLICK_EBOOK, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心点击设置图标打点
   *
   * @param params 参考CCSettingIconClick
   */
  static reportCCSettingIconClick(params: CCSettingIconClick): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CC_SETTING_ICON_CLICK, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 控制中心拖动亮度条打点
   *
   * @param params 参考CCBrightnessSlide
   */
  static reportCCBrightnessSlide(params: CCBrightnessSlide): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.CONTROLCENTER_UE, HiSysEventUtil.CC_BRIGHTNESS_SLIDE, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 上报锁屏卡片数据（关联主题id)
   *
   * @param params 上报锁屏卡片数据
   */
  static reportScreenLockFormData(params: ScreenLockSaveFormDataReportParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.SCREENLOCK_UE, HiSysEventUtil.SCREEN_LOCK_FORM_DATA, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 上报锁屏卡片状态点（关联主题id)
   *
   * @param params 上报锁屏卡片数据
   */
  static reportScreenLockFormDataState(params: ScreenLockFormDataReportParamsState): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.SCREENLOCK_UE, HiSysEventUtil.SCREEN_LOCK_FORM_DATA_STATE, hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 上报临时填加锁屏卡片数据（关联主题id)
   *
   * @param params 上报临时填加锁屏卡片数据
   */
  static reportAddScreenLockFormData(params: AddScreenLockFormDataReportParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    HiSysEventUtil.report(HiSysEventUtil.SCREENLOCK_UE, HiSysEventUtil.SCREEN_LOCK_FORM_DATA_ADD, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 上报临时移除锁屏卡片数据（关联主题id)
   *
   * @param params 上报临时移除锁屏卡片数据
   */
  static reportRemoveScreenLockFormData(params: ScreenLockBaseFormDataReportParams): void {
    HiSysEventUtil.report(HiSysEventUtil.SCREENLOCK_UE, HiSysEventUtil.SCREEN_LOCK_FORM_DATA_REMOVE, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * AI横条设置页开关
   * @param switchType 开关名
   * @param isOn 是否开启
   */
  static reportNaviBarSettingSwitchParams(switchType: string, isOn: boolean): void {
    let params: NaviBarSettingSwitchParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SWITCH_TYPE: switchType,
      IS_ON: isOn,
    };
    HiSysEventUtil.report(HiSysEventUtil.SYSTEM_NAV_UE, HiSysEventUtil.NAVI_BAR_SWITCH,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   *用户点击睡眠打点
   *
   * @param params  用户睡眠打点数据
   */
  static reportClickSleepMenuFormData(): void {
    const params: ClickSleepMenuFormDataReportParams = {
      TRIGGER_EVENT_TYPE: SUSPEND_DEVICE_REASON_FORCE_SUSPEND,
      ACTION_EVENT_TYPE: FORCE_SUSPEND,
    };
    HiSysEventUtil.report(HiSysEventUtil.POWER_DOMAIN, HiSysEventUtil.CLICK_SLEEP_MENU, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 底部手势快切
   * @param from 手势起始位置
   * @param startPos 手势起始坐标
   * @param endPos 手势结束坐标
   * @param orientation 设备方向
   * @param fromBundleName 切换前应用包名
   * @param nextBundleName 切换后应用包名
   * @param expandStatus: 用于替换 SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()，有业务方传入
   */
  static reportGestureQuickSwitch(from: string, startPos: number[], endPos: number[], orientation: number,
    fromBundleName: string, nextBundleName: string,
    fromIsMidScene: boolean, toIsMidScene: boolean, expandStatus: boolean): void {
    let params: GestureQuickSwitchParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FROM: from,
      START_POS: startPos,
      END_POS: endPos,
      DEVICE_STATUS: DeviceHelper.isFold() ? (expandStatus ? 1 : 2) : 0,
      ORIENTATION: orientation,
      FROM_BUNDLE_NAME: fromBundleName,
      NEXT_BUNDLE_NAME: nextBundleName,
      FROM_IS_MIDSCENE: fromIsMidScene ? MidSceneState.IS_MID_SCENE : MidSceneState.IS_NOT_MID_SCENE,
      TO_IS_MIDSCENE: toIsMidScene ? MidSceneState.IS_MID_SCENE : MidSceneState.IS_NOT_MID_SCENE,
    };
    HiSysEventUtil.report(HiSysEventUtil.SYSTEM_NAV_UE, HiSysEventUtil.GESTURE_QUICK_SWITCH,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 手势导航_底部横滑进入单手模式
   */
  public static reportIntoOneHandMode(params: IntoOneHandModeParams): void {
    HiSysEventUtil.report(HiSysEventUtil.SYSTEM_NAV_UE, HiSysEventUtil.INTO_ONE_HAND_MODE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 误触长按
   */
  static reportLongPressMisTouch(type: HiSysLongPressMisTouchType): void {
    let params: LongPressMisTouchParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      TYPE: type
    };
    HiSysEventUtil.report(HiSysEventUtil.SYSTEM_NAV_UE, HiSysEventUtil.LONG_PRESS_MISTOUCH,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   *
   * @param bundleName 包名
   * @param currentRotation 当前角度
   * @param targetRotation 目标角度
   * @param rotationType 旋转类型
   */
  public static reportRotationChange(bundleName: string, currentRotation: number, targetRotation: number,
    rotationType: string): void {
    log.showInfo('reportRotationChange bundleName:' + bundleName);
    if (!bundleName) {
      bundleName = 'Desktop';
    }
    let params: RotationChangeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLENAME: bundleName,
      CURRENT_ROATION: currentRotation,
      TARGET_ROATION: targetRotation,
      ROTATION_TYPE: rotationType,
    };
    HiSysEventUtil.mRotationChangeReportEvent.reportBehavior(HiSysEventUtil.ROTATION_CHANGE, params);
  }

  /**
   * 上报密码验证PIN是否过期
   *
   * @param params 上报密码验证PIN是否过期
   */
  public static userPinTimeAuth(authResult: number): void {
    interface UserPinTimeAuthParams {
      PNAMEID: string;
      PVERSIONID: string;
      AUTH_RESULT: number;
    }
    let params: UserPinTimeAuthParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      AUTH_RESULT: authResult,
    };
    log.showInfo(`authUser UserAuthManager, USER_PIN_TIMEOUT_AUTH`);
    HiSysEventUtil.reportEvent(HiSysEventUtil.USER_PIN_TIMEOUT_AUTH, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.SCREENLOCK_UE);
  }

  /**
   * 上报锁屏小工具使用情况
   *
   * @param bundleInfo 使用的应用信息
   * @param startMode 拉起的方式eg:滑动-slide、点击-click
   * @param openStatus 开启的状态eg:开启-on，关闭-off
   */
  public static reportScreenLockQuickTool(bundleInfo: string[], startMode: string, openStatus: string): void {
    if (!bundleInfo || bundleInfo.length !== 3) {
      return;
    }
    let params: ScreenLockQuickToolParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLENAME: bundleInfo[0],
      MODULENAME: bundleInfo[1],
      ABILITYNAME: bundleInfo[2],
      STARTMODE: startMode,
      OPENSTATUS: openStatus,
      SCREEN_TYPE: HiSysEventUtil.screenType
    };
    log.showInfo(`reportScreenLockQuickTool`);
    HiSysEventUtil.reportEvent(HiSysEventUtil.SEREEN_LOCK_GADGETS_OPEN_STATUS, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.SCREENLOCK_UE);
  }

  /**
   * 充电情况
   * @param turboChargingStatus 充电状态
   * @param batterySOC 电池状态
   */
  public static reportTurboCharging(turboChargingStatus: boolean, batterySOC: number): void {
    if (!turboChargingStatus) {
      return;
    }
    let params: TurboChargingParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BATTRTYSOC: batterySOC.toString(),
    };
    log.showInfo('turboChargingUE');
    HiSysEventUtil.reportEvent(HiSysEventUtil.SEREEN_LOCK_TURBO_CHARGING, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.SCREENLOCK_UE);
  }

  /**
   * PC桌面排序打点
   * @param desktopType 屏幕类型(0,主屏;1,副屏;）
   * @param orderType 排序类型（1:名称,2:修改时间,3:创建时间,4:大小,5:类型）
   * @param isAscend 是否升序
   */
  public static reportSortDesktop(desktopType: number, orderType: number, isAscend: boolean): void {
    interface SortDesktopParams {
      PNAMEID: string;
      PVERSIONID: string;
      DESKTOP_TYPE: number;
      ORDER_TYPE: number;
      IS_ASCEND: boolean;
    }
    let params: SortDesktopParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DESKTOP_TYPE: desktopType,
      ORDER_TYPE: orderType,
      IS_ASCEND: isAscend
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SORT_DESKTOP_ITEM,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  public static reportPullHosKey(type: number): void {
    let params: PullHosKeyTypeParams = {
      TYPE: type,
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
    };
    HiSysEventUtil.report(HiSysEventUtil.HOSKEY_UE_DOMAIN, HiSysEventUtil.Pull_HOSKEY,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 双击标题栏
   *
   * @param bundleName 双击窗口的应用信息
   * @param stateChange 1：双击标题栏最大化; 2：双击标题栏还原
   */
  public static reportDoubleClickTitle(bundleName: string, stateChange: number): void {
    let params: DoubleClickTitleParams = {
      CURRENTPKG: bundleName,
      STATECHANGE: stateChange
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.DOUBLE_CLICK_TITLE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 跳过OOBE并重置数据时的打点上报
   * @param resetDataKey 重置数据key
   * @param resetDataValue 重置数据值
   */
  public static reportSkipOOBE(resetDataKey: string, resetDataValue: string): void {
    let params: SkipOOBEParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      RESET_DATA_KEY: resetDataKey,
      RESET_DATA_VALUE: resetDataValue
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.OOBE_EVENT_NAME_SKIP_OOBE, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.OOBE_DOMAIN_UE);
  }

  /**
   * scb加载生产应用白名单的打点上报
   * @param appInfo 生产应用信息
   */
  public static reportReloadProductionApp(appInfo: string): void {
    let params: ReportProductionAppParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PRODUCTION_APP_INFO: appInfo
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.SCB_EVENT_NAME_RELOAD_PRO_APP, params, hiSysEvent.EventType.BEHAVIOR,
      ReportDomain.SCENE_BOARD_UE);
  }

  /**
   * 点击加号页新增空白页
   *
   * @param pageCount 新增后屏幕数量
   */
  public static reportAddBlankPage(pageCount: number): void {
    let params: AddBlankPageParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PAGE_COUNT_AFTER_ADD: pageCount,
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.ADD_BLANK_PAGE, params, hiSysEvent.EventType.STATISTIC,
      HiSysEventUtil.SCENE_BOARD_UE_DOMAIN);
  }

  /**
   * 点击叉号页删除空白页
   *
   * @param pageCount 删除后屏幕数量
   * @param launcherType 桌面布局类型
   */
  public static reportDeleteBlankPage(pageCount: number, launcherType: number): void {
    let params: DeleteBlankPageParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PAGE_COUNT_AFTER_DELETE: pageCount,
      LAUNCHERTYPE: launcherType,
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.DELETE_BLANK_PAGE, params, hiSysEvent.EventType.STATISTIC,
      HiSysEventUtil.SCENE_BOARD_UE_DOMAIN);
  }

  /**
   * 拖拽页面
   */
  public static reportDragPage(): void {
    let params: DragPageParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.DRAG_PAGE, params, hiSysEvent.EventType.STATISTIC,
      HiSysEventUtil.SCENE_BOARD_UE_DOMAIN);
  }

  static reportDockIndependentIcon(bundleName: string): void {
    interface DockIndependentIconParams {
      PNAMEID: string;
      PVERSIONID: string;
      PACKAGENAME: string;
    }
    let params: DockIndependentIconParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: bundleName
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.SET_DOCK_INDEPENT_ICON, params, hiSysEvent.EventType.STATISTIC,
      HiSysEventUtil.SCENE_BOARD_UE_DOMAIN);
  }

  /**
   * PC状态机切换状态打点
   * @param currentState PC当前状态 0:未知状态;1:半折叠虚拟键盘态;2:半折叠物理键盘态;3:半折叠状态;4:垂直展开态;5:水平展开态
   * @param nextState PC下一个状态 0:未知状态;1:半折叠虚拟键盘态;2:半折叠物理键盘态;3:半折叠状态;4:垂直展开态;5:水平展开态
   */
  public static reportStateChangeEvent(currentState: number, nextState: number): void {
    let params: StateChangeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PC_CURRENT_STATE: currentState,
      PC_NEXT_STATE: nextState
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.PC_STATE_CHANGE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC进入退出虚拟机旋转锁定打点
   * @isLocked 是否上锁
   */
  public static reportRotationLockEvent(isLocked: boolean): void {
    let params: RotationLockParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      IS_LOCKED: isLocked
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.PC_ROTATION_LOCK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC关闭窗口打点
   * @param currentPackage 当前窗口名称
   */
  public static reportCloseWindowEvent(currentPackage: string): void {
    let params: CloseWindowParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CURRENTPKG: currentPackage
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.PC_CLOSE_WINDOW,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC点击分屏菜单进入瀑布屏
   * @param currentPackage 瀑布模式的应用名
   */
  public static reportFullScreenWaterFallModeEvent(currentPackage: string): void {
    let params: FullScreenWaterFallModeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CURRENTPKG: currentPackage
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.PC_FULL_SCREEN_WATERFALL_MODE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 张开手势
   * @param packageName 应用名称
   * @param fingersNum 手指数量
   * @param modeChangeType 模式切换类型
   */
  public static reportPinchOpenGestureEvent(packageName: string, fingersNum: number, modeChangeType: string): void {
    let params: PinchGestureEventParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CURRENTPKG: packageName,
      FINGERS_NUMBER: fingersNum,
      MODE_CHANGE_TYPE: modeChangeType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.PC_PINCH_OPEN_GESTURE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 捏合手势
   * @param packageName 应用名称
   * @param fingersNum 手指数量
   * @param modeChangeType 模式切换类型
   */
  public static reportPinchCloseGestureEvent(packageName: string, fingersNum: number, modeChangeType: string): void {
    let params: PinchGestureEventParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CURRENTPKG: packageName,
      FINGERS_NUMBER: fingersNum,
      MODE_CHANGE_TYPE: modeChangeType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.PC_PINCH_CLOSE_GESTURE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * PC区分B/C面窗口数量
   * @param bWindowsNumbers B屏幕中窗口的数量
   * @param cWindowsNumbers C屏幕中窗口的数量
   */
  public static reportBAndCWindowsNumbersEvent(bWindowsNumbers: number, cWindowsNumbers: number): void {
    let params: BorCWindowsNumbersParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      B_WINDOWS_NUMBERS: bWindowsNumbers,
      C_WINDOWS_NUMBERS: cWindowsNumbers
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.PC_B_OR_C_WINDOWS_NUMBERS,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 添加应用（新形态小折叠外屏）
   *
   * @param packageName 应用名称
   * @param reportName 点位名称
   * @param actionType 0-是长按添加，1-是拖拽添加
   */
  public static reportOuterAddAppItem(packageName: string, reportName: string, actionType: number): void {
    let params: AddOuterAppParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      TYPE: actionType
    };
    HiSysEventUtil.report(HiSysEventUtil.OUTER_HOME_UE, reportName, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 添加shortcut（新形态小折叠外屏）
   *
   * @param packageName shortcut名称
   * @param reportName 点位名称
   * @param actionType 0-是长按添加，1-是拖拽添加
   */
  public static reportOuterAddShortcut(packageName: string, shortcutId: string, reportName: string, actionType: number): void {
    let params: AddOuterShortcutParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      SHORTCUTID: shortcutId,
      TYPE: actionType
    };
    HiSysEventUtil.report(HiSysEventUtil.OUTER_HOME_UE, reportName, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * Dock栏通信共享图标打点
   *
   * @param packageName 应用名称
   * @param showType 0-是不显示，1-是显示
   */
  static reportShowCollaborationIcon(packageName: string, showType: number): void {
    interface ShowCollaborationIconParams {
      PNAMEID: string;
      PVERSIONID: string;
      PACKAGENAME: string;
      SHOW_TYPE: number;
    }
    let params: ShowCollaborationIconParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      SHOW_TYPE: showType
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.SHOW_COLLABORATION_ICON, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.SCENE_BOARD_UE_DOMAIN);
  }

  /**
   * 点击Dock栏箭头翻页打点
   *
   * @param buttonType 按钮类型
   */
  static reportClickDockArrowButton(buttonType: number): void {
    interface ClickDockArrowButtonParams {
      PNAMEID: string;
      PVERSIONID: string;
      BUTTON_TYPE: number;
    }
    let params: ClickDockArrowButtonParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUTTON_TYPE: buttonType
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.CLICK_PC_DOCK_ARROW_BUTTON, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.SCENE_BOARD_UE_DOMAIN);
  }

  /**
   * 检测到应用图片采样为恶意透明图片
   *
   * @param packageName 包名
   */
  public static reportEvilAppDetected(packageName: string): void {
    interface EvilAppDetectedParams {
      PNAMEID: string;
      PVERSIONID: string;
      PACKAGENAME: string;
      VERSIONCODE: string;
    }
    let params: EvilAppDetectedParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: packageName,
      VERSIONCODE: HiSysEventUtil.getVersionName(packageName),
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.EVIL_APP_DETECTED,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 防窥，控制中心开关打点
   * @param where 切换位置（0-控制中心，1-设置）
   * @param type 切换方式（0-开启，1-关闭）
   * @param result 切换结果（0-切换成功，1-切换失败）
   */
  public static async reportAntiPeepingSwitch(where: string, type: string, result: number): Promise<void> {
    let params: AntiPeepingStatusParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SWITCH_WHERE: where,
      SWITCH_TYPE: type,
      SWITCH_RESULT: result,
    };
    HiSysEventUtil.reportEvent(HiSysEventUtil.ANTI_PEEPING_SWITCH_MAIN_STATUS, params, hiSysEvent.EventType.BEHAVIOR,
      HiSysEventUtil.DOMAIN_ANTI_PEEPING_UE);
  }

  /**
   * Folder Creation Open Recommend
   * @param dialogAppCount count of apps in dialog
   * @param folderId folder id
   * @param folderType folder type id
   */
  public static reportFolderCreationOpenRecommend(dialogAppCount: number, folderId: string, folderType: number): void {
    let params: ReportFolderCreationOpenRecommendParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DIALOGAPPCO: dialogAppCount,
      FOLDERID: folderId,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.FOLDER_CREATION_OPEN_RECOMMEND,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * Folder Creation Recommend Ok
   * @param folderId folder id
   * @param folderType folder type id
   * @param chooseAppCount choose app count
   * @param appCategory app category
   * @param area area 1X1,1X2,2X1,2X2,4X2
   */
  public static reportFolderCreationRecommendOk(folderId: string, folderType: number, chooseAppCount: number, appCategory: string, area: string): void {
    let params: ReportFolderCreationRecommendOkParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FOLDERID: folderId,
      FOLDERTYPE: folderType,
      CHOOSECOUN: chooseAppCount,
      APPCATEGORY: appCategory,
      AREA: area
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.FOLDER_CREATION_RECOMMEND_OK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * Folder Creation Recommend Cancel
   * @param folderId folder id
   * @param folderType folder type id
   */
  public static reportFolderCreationRecommendCancel(folderId: string, folderType: number): void {
    let params: ReportFolderCreationRecommendCancelParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FOLDERID: folderId,
      FOLDERTYPE: folderType
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.FOLDER_CREATION_RECOMMEND_CANCEL,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * Folder Add App Recommend Ok
   * @param folderId folder id
   * @param folderType folder type id
   * @param chooseAppCount choose app count
   * @param appCategory app category
   * @param area area 1X1,1X2,2X1,2X2,4X2
   */
  public static reportFolderAddAppRecommendOk(folderId: string, folderType: number, chooseAppCount: number, appCategory: string, area: string): void {
    let params: ReportFolderAddAppRecommendOkParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FOLDERID: folderId,
      FOLDERTYPE: folderType,
      CHOOSECOUN: chooseAppCount,
      APPCATEGORY: appCategory,
      AREA: area
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.FOLDER_ADD_APP_RECOMMEND_OK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * Folder Add App Recommend Cancel
   * @param folderId folder id
   * @param folderType folder type id
   */
  public static reportFolderAddAppRecommendCancel(folderId: string, folderType: number): void {
    let params: ReportFolderAddAppRecommendCancelParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FOLDERID: folderId,
      FOLDERTYPE: folderType,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.FOLDER_ADD_APP_RECOMMEND_CANCEL,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /*
   * 桌面曝光打点
   * @param exposureData 曝光数据
   */
  public static async reportExposureData(reportData: Map<string, string[]>): Promise<void> {
    interface ExposureDataParams {
      PNAMEID: string;
      PVERSIONID: string;
      DESKTOP_EXPOSURE_DATA?: string[];
      FOLDER_EXPOSURE_DATA?: string[];
      STACK_EXPOSURE_DATA?: string[];
    }
    let params: ExposureDataParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DESKTOP_EXPOSURE_DATA: reportData.get('DESKTOP_EXPOSURE_DATA'),
      FOLDER_EXPOSURE_DATA: reportData.get('FOLDER_EXPOSURE_DATA'),
      STACK_EXPOSURE_DATA: reportData.get('STACK_EXPOSURE_DATA'),
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SCENE_BOARD_EXPOSURE_DAILY, hiSysEvent.EventType.STATISTIC,
      params);
  }

  /**
   * 上报设置项智慧多窗兼容模式开关状态
   *
   * @param singleSwitch: 单个开关值(-1无操作，0关闭，1开启)
   * @param allSwitch: 总开关值(-1无操作，0关闭，1开启)
   * @param appList: 应用
   */
  public static reportForceMultiWindowSwitch(singleSwitch: number, allSwitch: number,
    appList: string): void {
    let params: ForceMultiWindowSwitchParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SINGLESWITCH: singleSwitch,
      ALLSWITCH: allSwitch,
      APPLIST: appList
    };
    HiSysEventUtil.report(ReportDomain.MULTI_WINDOW_UE_DOMAIN, HiSysEventUtil.FORCE_MULTI_WINDOW_SWITCH,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 上报设置项智慧多窗兼容模式开关状态，每周上报一次
   *
   * @param appList: 应用及其开关值
   */
  public static reportForceMultiWindowSwitchWeekly(appList: string): void {
    let params: ForceMultiWindowSwitchWeeklyParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      APPLIST: appList
    };
    HiSysEventUtil.report(ReportDomain.MULTI_WINDOW_UE_DOMAIN, HiSysEventUtil.FORCE_MULTI_WINDOW_SWITCH_WEEKLY,
      hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 0层组件状态打点
   *
   * @param sceneStatus 0层组件状态
   */
  public static reportSystemSceneStateEvent(systemSceneState: string): void {
    let params: SystemSceneStateParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SYSTEM_SCENE_STATE: systemSceneState,
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.SYSTEM_SCENE_STATE,
      hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 进入抽屉模式
   * @param type
   * 1 : 点击抽屉图标打开
   * 2 ：上滑打开
   */
  public static reportOpenDrawerModeEvent(type: number): void {
    let params: EnterDrawerModeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ENTER_TYPE: type
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.ENTER_DRAWER_MODE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 退出抽屉模式
   * @param type
   * 1: 下滑退出
   * 2： back退出
   * 3： 手势上滑退出
   * 4： 其它方式退出
   * */
  public static reportExitDrawerModeEvent(type: number): void {
    let params: ExitDrawerModeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      EXIT_TYPE: type
    };
    HiSysEventUtil.report(HiSysEventUtil.SCENE_BOARD_UE_DOMAIN, HiSysEventUtil.EXIT_DRAWER_MODE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }
}

async function reportHiSysEvent(sysEventInfo: hiSysEvent.SysEventInfo): Promise<void> {
  'use concurrent';
  const TAG = 'HiSysEventUtil';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
  try {
    hiSysEvent.write(sysEventInfo)
      .catch(
        (err: BusinessError) => {
          log.error('HiSysEventUtil reportHiSysEvent error:' + err.code + ', message:' + err.message );
        }
      )
      .then(
        val => {
          log.showDebug(`HiSysEventUtil reportHiSysEvent ${sysEventInfo.name} success.`);
        });
  } catch (err) {
    log.error('reportHiSysEvent error:' + err);
  }
}

async function batchReportHiSysEvent(sysEventInfos: hiSysEvent.SysEventInfo[]): Promise<void> {
  'use concurrent';
  const TAG = 'HiSysEventUtil';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
  for (const sysEventInfo of sysEventInfos) {
    try {
      hiSysEvent.write(sysEventInfo)
        .catch(
          (err: BusinessError) => {
            log.error('HiSysEventUtil reportHiSysEvent error:' + err.code + ', message:' + err.message );
          }
        );
    } catch (err) {
      log.error('reportHiSysEvent error:' + err);
    }
  }
}

