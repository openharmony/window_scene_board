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

import byTrace from '@ohos.hiTraceMeter';
import { DomainName } from './LogHelper';

/**
 * trace util class
 */
export class TraceUtil {
  static readonly CUSTOM_ANIMATOR_PREFIX = 'CUSTOM_ANIMATOR_';
  static readonly CORE_METHOD_START_SETTINGS = 'startSettings';
  static readonly CORE_METHOD_OPEN_FOLDER_DIALOG = 'openFolderDialog';
  static readonly CORE_METHOD_CLEAR_ALL_MISSIONS = 'clearAllMissions';
  static readonly CORE_METHOD_CLOSE_APP_ANIMATION = 'closeAppAnimation';
  static readonly CORE_METHOD_LOAD_DESKTOP_ITEMS = 'loadDesktopItems';

  // folder trace
  static readonly CORE_METHOD_OPEN_FOLDER = 'OpenFolder';
  static readonly CORE_METHOD_CLOSE_FOLDER = 'CloseFolder';
  static readonly CORE_METHOD_OPEN_FOLDER_ANI = 'OpenFolderAni';
  static readonly CORE_METHOD_CLOSE_FOLDER_ANI = 'CloseFolderAni';
  static readonly DELETE_MOVE_APP_CHANGE_ANI = 'MoveFolderAppChange';
  static readonly CORE_METHOD_SMALL_FOLDER_SNAPSHOT = 'SmallFolderSnapshot';
  static readonly INIT_FOLDER_SNAPSHOT = 'initFolderSnapshot';

  // systemUI trace
  static readonly CORE_METHOD_START_DROP_DOWN_PANEL = 'startDropDownPanel';
  static readonly CORE_METHOD_START_TOUCH_EVENT = 'startTouchEvent';
  static readonly CORE_METHOD_CLICK_CAPSULE = 'clickCapsuleEvent';
  static readonly CORE_METHOD_CLICK_NOTIFICATION = 'clickNotificationEvent';
  static readonly CORE_METHOD_START_VOLUMEPANEL = 'startVolumePanel';
  static readonly CORE_METHOD_UNLOCK_SCREEN = 'unlockScreen';
  static readonly CORE_METHOD_CALL_ACCOUNT_SYSTEM = 'callAccountSubsystem';
  static readonly CORE_METHOD_PASS_ACCOUNT_SYSTEM_RESULT = 'passingAccountSubsystemResult';
  static readonly CORE_METHOD_HIDE_PSD_PAGE = 'hidePsdPage';
  static readonly CORE_METHOD_SHOW_LOCK_SCREEN = 'showLockScreen';
  static readonly CORE_METHOD_SLEEP_TO_LOCK_SCREEN = 'sleepToLockScreen';
  static readonly CORE_METHOD_APP_LIST_SORT = 'appListSort';
  static readonly CORE_METHOD_PREPARE_APP_LIST = 'prepareAppList';
  static readonly CORE_METHOD_ADD_LOCAL_TAG = 'appAddLocalTag';
  static readonly CORE_METHOD_NOTIFICATION_SWIPE = 'notificationSwipe';
  static readonly CORE_METHOD_NTF_FOLLOW = 'notificationAnimation';
  static readonly CORE_METHOD_APP_SWIPE_UP_TO_CAPSULE = 'AppSwipeUpToCapsule'; // 动效，应用上滑退出变成胶囊
  static readonly CORE_METHOD_APP_BACK_TO_CAPSULE = 'AppBackToCapsule'; // 动效，应用侧滑退出变成胶囊
  static readonly CORE_METHOD_UN_LOCK_TO_CAPSULE = 'UnLockToCapsule'; // 动效，解锁卡片态联动到胶囊
  static readonly CORE_METHOD_LIVE_WIN_UPDATE = 'LiveWinUpdate'; // 实况窗信息刷新
  static readonly CORE_METHOD_CAPSULE_UPDATE = 'CapsuleUpdate'; // 胶囊进度条刷新
  static readonly CORE_METHOD_CAPSULE_TO_LIVE_WIN = 'CapsuleToLiveWin'; // 动效，点击胶囊展开卡片
  static readonly CORE_METHOD_CAPSULE_TO_APP = 'CapsuleToApp'; // 动效，点击胶囊跳转应用
  static readonly CORE_METHOD_LIVE_WIN_TO_APP = 'LiveWinToApp'; // 动效，点击卡片跳转应用
  static readonly CORE_METHOD_CLICK_LIVE_WIN_BUTTON = 'ClickLiveWinButton'; // 点击卡片操作按钮
  static readonly CORE_METHOD_LIVE_WINS_SWIPE_UP = 'LiveWinsSwipeUp'; // 动效，收起卡片态：上滑卡片列表
  static readonly CORE_METHOD_LIVE_WINS_CLICK_BLANK = 'LiveWinsClickBlank'; // 动效，收起卡片态：点击空白处
  static readonly CORE_METHOD_LIVE_WIN_SWIPE_LEFT_DEL = 'LiveWinSwipeLeftDel'; // 左滑出垃圾桶删除

  static readonly CORE_METHOD_SCROLL_CAL_CURR = 'calScrollToCurrIdx';
  static readonly CORE_METHOD_CHAIN_TRACKING = 'chainAnimationTracking';
  static readonly CORE_METHOD_CHAIN_ANIMATE = 'chainAnimationAll';

  // card trace
  static readonly CORE_METHOD_ADD_CARD_CLICK = 'addCardClick';
  static readonly CORE_METHOD_VIEW_CARD_DETAIL_CLICK = 'viewCardDetailClick';
  static readonly CORE_METHOD_CREATE_CARD = 'createCardToDeskTop';
  static readonly CORE_METHOD_CLEAR_NO_USR_FORM = 'clearNoUseForm';
  static readonly CORE_METHOD_EXIT_FORM_MANAGER_ANI = 'exitFormManager';
  static readonly CORE_METHOD_FORM_MANAGER_CREATE_FORM_ANI = 'formManagerCreateForm';
  static readonly CORE_METHOD_REMOVE_FORM_ANI = 'removeForm';
  static readonly CORE_METHOD_QUERY_APP_FORM = 'queryAppFormFromFMS';
  static readonly CORE_METHOD_QUERY_ALL_FORM = 'queryAllFormsFromFMS';
  static readonly CORE_METHOD_ENTER_FORM_MANAGER = 'enterFormManager';

  // formstack trace
  static readonly CORE_METHOD_FS_TOUCH_DOWN = 'fsTouchDown';
  static readonly CORE_METHOD_FS_TOUCH_UP = 'fsTouchUp';
  static readonly CORE_METHOD_FS_SLIDE_START = 'fsSlideStart';
  static readonly CORE_METHOD_FS_SLIDE_UPDATE = 'fsSlideUpdate';
  static readonly CORE_METHOD_FS_SLIDE_BACK = 'fsSlideBack';
  static readonly CORE_METHOD_FS_SLIDE_UP = 'fsSlideUp';
  static readonly CORE_METHOD_FS_SLIDE_DOWN_TOP_CARD = 'fsSlideDownTopCard';
  static readonly CORE_METHOD_FS_SLIDE_DOWN_SECOND_CARD = 'fsSlideDownSecondCard';
  static readonly CORE_METHOD_FS_OPEN_EXPAND_VIEW = 'fsOpenExpandView';
  static readonly CORE_METHOD_FS_EXPAND_ANIMATE = 'fsExpandAnimate';
  static readonly CORE_METHOD_FS_EXIT_ANIMATE = 'fsExitAnimate';
  static readonly CORE_METHOD_FS_EXPAND_BG_BLUR = 'fsExpandBgBlur';
  static readonly CORE_METHOD_FS_CLICK_CARD_TOP = 'fsClickCardTop';
  static readonly CORE_METHOD_FS_EXPAND_LIST_FOLLOW = 'fsExpandListFollow';
  static readonly CORE_METHOD_FS_EXPAND_LIST_SCROLL_END = 'fsExpandListScrollEnd';

  /**
   * 删除应用
   */
  static readonly UNINSTALL_APP = 'UninstallApp';

  /**
   * 删除卡片
   */
  static readonly UNINSTALL_CARD = 'UninstallCard';

  /**
   * 锁屏解锁trace
   */
  public static readonly CORE_METHOD_PSD_UNLOCK = 'startPsdUnlock';

  /**
   * 锁屏密码认证接口trace
   */
  public static readonly CORE_METHOD_PSD_AUTH = 'startPsdAuth';

  /**
   * 锁屏窗口隐藏trace
   */
  public static readonly CORE_METHOD_UNLOCK_HIDE = 'startUnlockHide';

  /**
   * 锁屏窗口显示trace
   */
  public static readonly CORE_METHOD_LOCK_HIDE = 'startlockHide';

  /**
   * 锁屏亮屏动画trace
   */
  public static readonly CORE_METHOD_SCREEN_ON_ANIMATION = 'screenOnAnimation';

  /**
   * 解锁进入桌面
   */
  public static readonly UNLOCK_TO_HOME_ANI = 'UnlockToHomeAni';

  /**
   * exit scene zoom
   */
  public static readonly CORE_METHOD_EXIT_SCENE_ZOOM = 'SCBExitSceneZoom';

  /**
   * start from recent
   */
  public static readonly CORE_METHOD_START_FROM_RECENT = 'SCBEnterFromRecent';

  /**
   * three fingers swipe start
   */
  public static readonly CORE_METHOD_THREE_FINGERS_SWIPE_START = 'threeFingersSwipeStart';

  /**
   * three fingers swipe end
   */
  public static readonly CORE_METHOD_TOGGLE_HOME = 'toggleHome';

  /**
   * 进入全搜
   */
  public static readonly CORE_METHOD_INTO_SEARCH = 'IntoSearch';

  /**
   * 退出全搜
   */
  public static readonly CORE_METHOD_EXIT_SEARCH = 'ExitSearch';

  /**
   * 进入全搜冻结壁纸引擎
   */
  public static readonly Global_Search_Freeze_Theme_Engine = 'GlobalSearchFreezeThemeEngine';

  /**
   * 进入负一屏
   */
  public static readonly CORE_METHOD_INTO_AA = 'IntoAA';

  /**
   * 退出负一屏
   */
  public static readonly CORE_METHOD_EXIT_AA = 'ExitAA';

  /**
   * 自动补位
   */
  public static readonly AUTO_ALIGN_DELETE_APP = 'AutoAlign';

  /**
   * 底部上滑跟手
   */
  public static readonly CORE_SWIPER_FROM_BOTTOM = 'swiperFromBottom';

 // 读取文件开始
  public static readonly GET_FILE_SIZE = 'getFileSize';

  /**
   * 兼容模式应用最大化
   */
  public static readonly WINDOW_COMPATIBLE_MODE_MAXIMIZED = 'WindowCompatibleModeMax';

  /**
   * 兼容模式应用恢复自由窗口
   */
  public static readonly WINDOW_COMPATIBLE_MODE_RECOVER = 'WindowCompatibleModeRecover';

  /**
   * begin recent trace
   */
  // enter recent
  public static readonly CORE_METHOD_ENTER_RECENT = 'IntoRecent';
  // animation for enter recent from home
  public static readonly CORE_METHOD_ENTER_RECENT_FROM_HOME_ANIMATION = 'IntoRecentFromHomeAni';
  // animation for enter recent from app
  public static readonly CORE_METHOD_ENTER_RECENT_FROM_APP_ANIMATION = 'IntoRecentFromAppAni';
  // exit recent
  public static readonly CORE_METHOD_EXIT_RECENT = 'ExitRecent';
  // exit recent
  public static readonly CORE_METHOD_EXIT_RECENT_ANIMATION = 'ExitRecentAni';
  // animation for snap recent
  public static readonly CORE_METHOD_SNAP_RECENT_ANIMATION = 'SnapRecentAni';

  //interrupt other animation when exit start
  public static readonly CORE_METHOD_INTERRUPT_EXIT = 'InterruptOtherAnimation_ExitApp';
  /**
   * end recent trace
   */

  /**
   * begin app center trace
   */
  public static readonly CORE_METHOD_INTO_APP_CENTER = 'IntoAppCenter';
  public static readonly CORE_METHOD_EXIT_APP_CENTER = 'ExitAppCenter';
  public static readonly CORE_METHOD_EXIT_APP_ANIMATION = 'ExitAppAnimation';

  public static readonly CORE_METHOD_START_APP_CENTER_ANIMATION = 'startAppCenterAnimation';
  public static readonly CORE_METHOD_STOP_APP_CENTER_ANIMATION = 'stopAppCenterAnimation';
  /**
   * end app center trace
   */

  /**
   * 应用启动
   */
  public static readonly CORE_METHOD_START_APP = 'StartApp';

  /**
   * 【动效】应用启动
   */
  public static readonly CORE_METHOD_START_APP_ANI = 'StartAppAni';

  /**
   * into home
   */
  public static readonly CORE_METHOD_INTO_LAUNCHER = 'IntoHomeKey';

  /**
   * animation for into home
   */
  public static readonly CORE_METHOD_LAUNCHER_ANIMATION = 'IntoHomeAni';

  /**
   * animation for icon press
   */
  public static readonly CORE_METHOD_ICON_PRESS_ANIMATION = 'IconPressAni';

  /**
   * process of launch home cold
   */
  public static readonly CORE_METHOD_LAUNCH_HOME_COLD = 'LaunchHomeCold';

  /**
   * 显示DropDown窗口
   */
  public static readonly SHOW_DROPDOWN_PANEL = 'showDropDownPanel';

  /**
   * Dropdown显示回调
   */
  public static readonly DROPDOWN_VIEW_SHOW_CALLBACK = 'dropDownViewShowCallback';

  /**
   * swiper预加载调用
   */
  public static readonly PRELOAD_SWIPER_PAGE_CALLBACK = 'preloadNextPage';

  /**
   * Whether enables trace globally
   */
  private static readonly GLOBAL_TRACE_ENABLE = true;

  // dock栏显示动效
  public static readonly CORE_METHOD_SMART_DOCK_VIEW_SHOW_ANIMATION: string = 'SmartdockViewShowAnimation';

  // dock栏隐藏动效
  public static readonly CORE_METHOD_SMART_DOCK_VIEW_HIDE_ANIMATION: string = 'SmartdockViewHideAnimation';

  /**
   * process of lock screen vote boot
   */
  public static readonly CORE_LOCK_SCREEN_VOTE_BOOT = 'LockScreenVoteBoot';

  /**
   * 应用锁白板切换模糊效果打点
   */
  public static readonly APP_LOCK_WHITE_BOARD = 'appLockWhiteBoard';

  /**
   * 单手兼容模式窗口截图打点
   */
  public static readonly ONE_HAND_COMPATIBILITY_MODE_SESSION_SNAPSHOT = 'OneHandCompatibilityModeSessionSnapshot';

  /**
   * 窗口动效打点，通话，应用跳转
   */
  public static readonly ANIMATE_ON_PHONE_CALL = 'animateOnPhoneCall';
  public static readonly START_PHONE_CALL_FROM_ANIM = 'startPhoneCallFromAnim';
  public static readonly START_PHONE_CALL_TO_ANIM = 'startPhoneCallToAnim';
  public static readonly SCENE_CONTAINER_TRANSITION_FOR_PHONE_CALL = 'sceneContainerTransitionForPhoneCall';
  public static readonly SCENE_CONTAINER_APP_TRANSITION_CHANGE = 'sceneContainerAppTransitionChange';
  public static readonly SPECIAL_START_PHONE_CALL_FROM_ANIM = 'specialStartPhoneCallFromAnim';
  public static readonly SPECIAL_START_PHONE_CALL_TO_ANIM = 'specialStartPhoneCallToAnim';
  public static readonly SPECIAL_SCENE_CONTAINER_APP_TRANSITION_CHANGE = 'specialSceneContainerAppTransitionChange';
  public static readonly EXECUTE_FADE_IN_ANIMATION = 'executeFadeInAnimation';

  /**
   * 闪控球相关打点
   */
  public static readonly FLOATING_BALL_PAN_MOVE = 'floatingBallPanMove';
  public static readonly MENU_SHOW_AND_HIDE = 'floatingBallMenu';

  /**
   * Whether enables trace of each domain, used for debugging
   */
  private static readonly TRACE_ENABLE_MAP: Map<string, boolean> = new Map([
    [DomainName.SCB, true],
    [DomainName.HOME, true],
    [DomainName.SYS_UI, true],
    [DomainName.NC, true],
    [DomainName.CC, true],
    [DomainName.AOD, true],
    [DomainName.KG, true],
    [DomainName.AA, true],
    [DomainName.SEARCH, true],
    [DomainName.RECENT, true],
    [DomainName.GESTURE, true],
    [DomainName.WINDOW, true],
  ]);

  private static readonly TRACE_BASE_INDEX = 10000;

  private static taskIdMap: Map<string, number> = new Map<string, number>();

  private static traceIndex = TraceUtil.TRACE_BASE_INDEX;

  private static setTaskIdOfTrace(taskName: string): number {
    let taskId = TraceUtil.taskIdMap.get(taskName);
    if (taskId === undefined) {
      taskId = TraceUtil.traceIndex;
      TraceUtil.traceIndex++;
      TraceUtil.taskIdMap.set(taskName, taskId);
    }
    return taskId;
  }

  /**
   * Mark a single slice
   *
   * @param {string} name - name for tracing
   * @param {string} domain - domain of trace
   */
  public static traceOnce(domain: string, name: string): void {
    if (!TraceUtil.TRACE_ENABLE_MAP.get(domain) || !TraceUtil.GLOBAL_TRACE_ENABLE) {
      return;
    }
    let taskName: string = `[${domain}]${name}`;
    let taskId: number = TraceUtil.traceIndex++;
    TraceUtil.taskIdMap.set(taskName, taskId);
    byTrace.startTrace(taskName, taskId);
    byTrace.finishTrace(taskName, taskId);
  }

  /**
   * Used to track the start of sequential tasks
   *
   * @param {string} name - name for tracing
   * @param {string} domain - domain of trace
   */
  public static startTrace(domain: string, name: string, prefix?: string): void {
    if (!TraceUtil.TRACE_ENABLE_MAP.get(domain) || !TraceUtil.GLOBAL_TRACE_ENABLE) {
      return;
    }
    let taskName: string = `[${domain}]${name}`;
    if (prefix) {
      taskName = prefix + taskName;
    }
    let curTaskId: number = TraceUtil.setTaskIdOfTrace(taskName);
    byTrace.startTrace(taskName, curTaskId);
  }

  /**
   * Used to track the end of sequential tasks. The name must be the same as that at start
   *
   * @param {string} name - name for tracing
   * @param {string} domain - domain of trace
   */
  public static endTrace(domain: string, name: string, prefix?: string): void {
    let taskName: string = `[${domain}]${name}`;
    if (prefix) {
      taskName = prefix + taskName;
    }
    let taskId: number | undefined = TraceUtil.getTaskIdOfTrace(taskName);
    if (taskId === undefined) {
      return;
    }
    byTrace.finishTrace(taskName, taskId);
  }

  private static getTaskIdOfTrace(taskName: string): number | undefined {
    let taskId: number | undefined = TraceUtil.taskIdMap.get(taskName);
    if (taskId === undefined) {
      return undefined;
    }
    TraceUtil.taskIdMap.delete(taskName);
    return taskId;
  }

  /**
   * Used to track the start of cross tasks
   * (scenarios where the next task starts before the previous task is finished)
   *
   * @param {string} name - name for tracing
   * @param {string} domain - domain of trace
   */
  public static startTraceWithTaskId(domain: string, name: string, taskId: number): void {
    if (!TraceUtil.TRACE_ENABLE_MAP.get(domain) || !TraceUtil.GLOBAL_TRACE_ENABLE) {
      return;
    }
    let taskName: string = `[${domain}]${name}`;
    byTrace.startTrace(taskName, taskId);
  }

  /**
   * Used to track the end of cross tasks. The name and taskId must be the same as at start
   *
   * @param {string} name - name for tracing
   * @param {string} domain - domain of trace
   */
  public static endTraceWithTaskId(domain: string, name: string, taskId: number): void {
    if (!TraceUtil.TRACE_ENABLE_MAP.get(domain) || !TraceUtil.GLOBAL_TRACE_ENABLE) {
      return;
    }
    let taskName: string = `[${domain}]${name}`;
    byTrace.finishTrace(taskName, taskId);
  }

  /**
   * start trace for animation
   *
   * @param {string} name - name for tracing
   * @param {string} domain - domain of trace
   */
  public static startAnimTrace(domain: string, name: string, prefix?: string): void {
    if (!TraceUtil.TRACE_ENABLE_MAP.get(domain) || !TraceUtil.GLOBAL_TRACE_ENABLE) {
      return;
    }
    let taskName: string = `[${domain}]${name}`;
    if (prefix) {
      taskName = prefix + taskName;
    }
    let curTaskId: number = TraceUtil.setTaskIdOfTrace(taskName);
    byTrace.startTrace(taskName, curTaskId);
  }

  /**
   * end trace for animation
   *
   * @param {string} name - name for tracing
   * @param {string} domain - domain of trace
   */
  public static endAnimTrace(domain: string, name: string, prefix?: string): void {
    let taskName: string = `[${domain}]${name}`;
    if (prefix) {
      taskName = prefix + taskName;
    }
    let taskId: number | undefined = TraceUtil.getTaskIdOfTrace(taskName);
    if (taskId === undefined) {
      return;
    }
    byTrace.finishTrace(taskName, taskId);
  }
}