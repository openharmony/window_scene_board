/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved. 2024-2025. All rights reserved.
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

import { DomainName } from './LogHelper';
import { TraceUtil } from './TraceUtil';

/**
 * Add method trace. Modify RECORD_TRACE before using.
 */
export class Trace {
  static readonly CORE_METHOD_START_SETTINGS = 'startSettings';
  static readonly CORE_METHOD_OPEN_FOLDER_DIALOG = 'openFolderDialog';
  static readonly CORE_METHOD_CLEAR_ALL_MISSIONS = 'clearAllMissions';
  static readonly CORE_METHOD_CLOSE_APP_ANIMATION = 'closeAppAnimation';
  static readonly CORE_METHOD_LOAD_DESKTOP_ITEMS = 'loadDesktopItems';

  //systemUI trace
  static readonly CORE_METHOD_START_DROP_DOWN_PANEL = 'startDropDownPanel';
  static readonly CORE_METHOD_START_TOUCH_EVENT = 'startTouchEvent';
  static readonly CORE_METHOD_START_FINGER_PRINT_EVENT = 'startFingerPrintEvent';
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
  static readonly CORE_METHOD_START_SCENE_FROM_RECENT = 'startSceneFromRecent';
  static readonly CORE_METHOD_START_SCENE_FROM_OTHER = 'startSceneFromOther';
  static readonly CORE_METHOD_START_SCENE_FROM_VIRTUAL = 'startSceneFromVirtual';
  static readonly CORE_METHOD_START_SCENE_FROM_SCREEN_LOCK = 'startSceneFromScreenLock';
  static readonly CORE_METHOD_START_SCENE_FROM_SCREEN_LOCK_ANIMATE = 'startSceneFromScreenLockAnimate';
  static readonly CORE_METHOD_CLOSE_SCENE_FROM_SCREEN_LOCK_ANIMATE = 'closeSceneFromScreenLockAnimate';

  static readonly CORE_METHOD_SCROLL_CAL_CURR = 'calScrollToCurrIdx';
  static readonly CORE_METHOD_CHAIN_TRACKING = 'chainAnimationTracking';
  static readonly CORE_METHOD_CHAIN_ANIMATE = 'chainAnimationAll';

  /**
   * 锁屏密码认证接口trace
   */
  public static readonly CORE_METHOD_PSD_AUTH = 'AuthPsd';

  /**
   * keyguard exit animation
   */
  public static readonly CORE_METHOD_EXIT_KEYGUARD = 'ExitKeyGuard';

  /**
   * 锁屏窗口隐藏trace
   */
  public static readonly CORE_METHOD_UNLOCK_HIDE = 'HideScreenLock';

  /**
   * 锁屏窗口显示trace
   */
  public static readonly CORE_METHOD_LOCK_HIDE = 'IntoKeyGuard';

  /**
   * 锁屏亮屏动画trace
   */
  public static readonly CORE_METHOD_SCREEN_ON_ANIMATION = 'ScreenOnAni';

  /**
   * fingerprint authentication
   */
  public static readonly CORE_METHOD_FINGERPRINT_AUTH = 'AuthFp';

  /**
   * face authentication
   */
  public static readonly CORE_METHOD_INVOKE_FACE_UNLOCK = 'AuthFace';

  public static readonly CORE_METHOD_CHECK_FACE_UNLOCK_SETTING = 'checkFaceUnlockSetting';

  public static readonly CORE_METHOD_SHOW_SCREEN_LOCK_FORM_PANEL = 'showScreenLockFormPanel';

  public static readonly CORE_METHOD_ADD_SCREEN_LOCK_FORM = 'addScreenLockForm';

  public static readonly CORE_METHOD_DELETE_SCREEN_LOCK_FORM = 'deleteScreenLockForm';

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
   * 一屏一世界获取桌面截图
   */
  public static readonly CORE_METHOD_FOUR_FINGER_SWIPE_GET_SNAPSHOT = 'FourFingersSwipeGetSnapshot';

  /**
   * 一屏一世界四指横滑动效
   */
  public static readonly CORE_METHOD_FOUR_FINGER_SWIPE_ANIMATION = 'FourFingerSwipeAni';

  /**
   * 一屏一世界一次性动效左滑切换
   */
  public static readonly CORE_METHOD_DESKTOP_SWITCH_LEFT = 'DesktopSwitchLeft';

  /**
   * 一屏一世界一次性动效右滑切换
   */
  public static readonly CORE_METHOD_DESKTOP_SWITCH_RIGHT = 'DesktopSwitchRight';

  /**
   * 进入全搜
   */
  public static readonly CORE_METHOD_INTO_SEARCH = 'IntoSearch';

  /**
   * 退出全搜
   */
  public static readonly CORE_METHOD_EXIT_SEARCH = 'ExitSearch';

  /**
   * AOD获取image
   */
  public static readonly CORE_METHOD_AOD_GET_IMAGE = 'AODGetImage';

  /**
   * AOD prepare
   */
  public static readonly CORE_METHOD_AOD_PREPARE = 'AODPrepare';

  /**
   * 进入AOD
   */
  public static readonly CORE_METHOD_INTO_AOD = 'IntoAOD';

  /**
   * 退出AOD
   */
  public static readonly CORE_METHOD_EXIT_AOD = 'ExitAOD';

  /**
   * 退出重进AOD
   */
  public static readonly CORE_METHOD_RESTART_AOD = 'RestartAOD';

  /**
   * 人脸变为锁
   */
  public static readonly CORE_METHOD_FACE_LOTTIE_LOCK = 'FaceLottieLock';

  /**
   * 解锁前人脸循环
   */
  public static readonly CORE_METHOD_FACE_LOTTIE_ROTATE_LOOP = 'FaceLottieRotateLoop';

  /**
   * 人脸识别中
   */
  public static readonly CORE_METHOD_FACE_LOTTIE_LOOP = 'FaceLottieLoop';

  /**
   * 人脸解锁成功
   */
  public static readonly CORE_METHOD_FACE_LOTTIE_UNLOCK_SUCCESS = 'FaceLottieUnlockSuccess';

  /**
   * 人脸解锁失败
   */
  public static readonly CORE_METHOD_FACE_LOTTIE_UNLOCK_FAIL = 'FaceLottieUnlockFail';

  /**
   * 密码界面解锁前人脸循环
   */
  public static readonly CORE_METHOD_PSD_FACE_LOTTIE_DETECTED = 'FaceLottieDetected';

  /**
   * 锁屏指纹出现
   */
  public static readonly CORE_METHOD_FINGER_ICON_OPEN: string = 'fingerIconOpen';

  /**
   * 锁屏指纹消失
   */
  public static readonly CORE_METHOD_FINGER_ICON_CLOSE: string = 'fingerIconClose';

  // 控制中心显示
  public static CORE_METHOD_CONTROL_CENTER_SHOW: string = 'IntoCC';

  // 控制中心隐藏
  public static CORE_METHOD_CONTROL_CENTER_HIDE: string = 'ExitCC';

  // 控制中心亮度条滑动
  public static CORE_METHOD_SLIDING_BRIGHTNESS: string = 'SlidingBrightness';

  // 控制中心亮度条点击
  public static CORE_METHOD_TAP_BRIGHTNESS: string = 'TapBrightness';

  // 控制中心音量条滑动
  public static CORE_METHOD_SLIDING_VOLUME: string = 'SlidingVolume';

  // 控制中心音量条点击
  public static CORE_METHOD_TAP_VOLUME: string = 'TapVolume';

  // 通知中心显示
  public static CORE_METHOD_NOTIFICATION_PANEL_SHOW: string = 'IntoNC';

  // 通知中心隐藏
  public static CORE_METHOD_NOTIFICATION_PANEL_HIDE: string = 'ExitNC';

  // 删除通知
  public static CORE_METHOD_DELETE_NOTIFICATION: string = 'ClearNtAni';

  // 组通知展开
  public static CORE_METHOD_UNFOLD_NOTIFICATION: string = 'UnfoldNtAni';

  // 组通知收起
  public static CORE_METHOD_FOLD_NOTIFICATION: string = 'FoldNtAni';

  /**
   * 拖拽落位
   */
  public static readonly CORE_METHOD_DRAG_DROP = 'DragDrop';

  // 控制中心根据取色结果改变文字颜色
  public static CORE_METHOD_CONTROL_CENTER_CHANGE_LABEL_COLOR: string = 'ChangeLabelColor';

  // 调用截图接口
  public static CORE_METHOD_SCREEN_SHOT: string = 'SceneBoardScreenShot';

  // 调用取色接口-part1
  public static CORE_METHOD_CREATE_PICKER: string = 'SceneBoardCreatePicker';

  // 调用取色接口-part2
  public static CORE_METHOD_GET_DEGREE: string = 'SceneBoardGetDegree';

  /**
   * 拖拽起拖
   */
  public static readonly CORE_METHOD_DRAG_START = 'DragStart';

  public static readonly CORE_METHOD_SCREEN_PROPERTY_CHANGE_DESKTOP = 'DesktopSceneChange';

  public static readonly CORE_METHOD_SCREEN_PROPERTY_CHANGE_KEYGUARD = 'KeyguardSceneChange';

  // 锁屏应用服务初始化
  public static readonly CORE_METHOD_LOCK_SERVICE_INIT: string = 'LockServiceInit';

  // 锁屏应用界面初始化
  public static readonly CORE_METHOD_SCREEN_LOCK_INIT: string = 'ScreenLockInit';

  // 锁屏字体长度计算
  public static readonly CORE_METHOD_MEASURE_TEXT: string = 'MeasureText';

  // 锁屏初始化时钟布局参数
  public static readonly CORE_METHOD_INIT_CLOCK_LAYOUT: string = 'InitClockLayout';

  // AppStorage.setOrCreate
  public static readonly CORE_METHOD_APP_STORAGE_SET: string = 'SetOrCreate';

  /**
   * 进入编辑模式
   */
  public static readonly CORE_METHOD_INTO_EDIT_MODE: string = 'IntoEditMode';

  /**
   * 退出编辑模式
   */
  public static readonly CORE_METHOD_EXIT_EDIT_MODE: string = 'ExitEditMode';

  /**
   * 多选选择事件
   */
  public static readonly CORE_METHOD_MULTISELECT_SELECT: string = 'MultiSelectSelected';

  /**
   * 多选汇聚事件
   */
  public static readonly CORE_METHOD_MULTISELECT_GATHER: string = 'MultiSelectGather';

  /**
   * 多选拖动
   */
  public static readonly CORE_METHOD_MULTISELECT_DRAG: string = 'MultiSelectDrag';

  /**
   * 多选落位
   */
  public static readonly CORE_METHOD_MULTISELECT_DROP: string = 'MultiSelectDrop';

  /**
   *  负一屏接收push端消息
   */
  public static readonly INTELLIGENT_PUSH_RECEIVE_MESSAGE: string = 'IntelligentPushReceiveMessage';

  /**
   * 桌面数据刷新
   */
  public static readonly CORE_METHOD_LOAD_GRID_LIST: string = 'LoadGridList';

  /**
   * 桌面分页刷新
   */
  public static readonly CORE_METHOD_PAGING_FILTERING: string = 'PagingFiltering';

  /**
   * 桌面轻量分页刷新
   */
  public static readonly CORE_METHOD_LIGHT_PAGING_FILTERING: string = 'LightPagingFiltering';

  /**
   * 拖拽页面
   */
  public static readonly CORE_METHOD_PAGE_DRAG: string = 'PageDrag';

  /**
   * 桌面断点变化
   */
  public static readonly CORE_METHOD_BREAKPOINT_CHANGE_DESKTOP = 'BreakpointChangeDesktop';

  /**
   * start trace method
   *
   * @param {string} methodName - methodName for tracing
   */
  public static start(methodName: string, prefix?: string): void {
    if (prefix) {
      TraceUtil.startTrace(DomainName.SCB, methodName, prefix);
    } else {
      TraceUtil.startTrace(DomainName.SCB, methodName);
    }
  }

  /**
   * stop trace method
   *
   * @param {string} methodName - methodName for tracing
   */
  public static end(methodName: string, prefix?: string): void {
    if (prefix) {
      TraceUtil.endTrace(DomainName.SCB, methodName, prefix);
    } else {
      TraceUtil.endTrace(DomainName.SCB, methodName);
    }
  }
}