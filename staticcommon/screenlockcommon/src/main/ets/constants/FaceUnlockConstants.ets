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
 * Face authentication constant class
 */
export class FaceUnlockConstants {
  /**
   * whether the face unlock is open
   */
  public static readonly IS_FACE_UNLOCK_SWITCH_OPEN: string = 'isFaceUnlockSwitchOpen';

  /**
   * face unlock state.
   */
  public static readonly FACE_UNLOCK_VERIFY_STATE: string = 'faceUnlockVerifyState';

  /**
   * face unlock need slide.
   */
  public static readonly FACE_UNLOCK_NEED_SLIDE: string = 'isFaceUnlockNeedSlide';

  /**
   * The key to get whether faceUnlock is enable.
   */
  public static readonly KEY_FACE_KEYGUARD_ENABLE: string = 'face_bind_with_lock';

  /**
   * If pass face authentication, the user need to slide unlock.
   */
  public static readonly FACE_RECOGNIZE_SLIDE_UNLOCK: string = 'face_recognize_slide_unlock';

  /**
   * Default value of Setting config
   */
  public static readonly FACE_CONFIG_DEFAULT_VALUE: string = '1';

  /**
   * Default value of face unlock slide type config
   */
  public static readonly FACE_UNLOCK_CONFIG_SLIDE_VALUE: string = '1';

  /**
   * Default value of PC face unlock direct type config
   */
  public static readonly FACE_UNLOCK_CONFIG_DIRECT_VALUE: string = '0';

  /**
   * is enabled
   */
  public static readonly FACE_SWITCH_ENABLE: string = '1';

  /**
   *  unload face alg delay: 10s
   */
  public static readonly FACE_ALG_UNLOAD_DELAY = 10000;

  /**
   * 密码解锁页面，人脸解锁动画的时长
   */
  public static readonly FACE_UNLOCK_ANIMATOR_DURATION: number = 600;

  /**
   * 人脸识别成功的TIP
   */
  public static readonly FACE_AUTH_TIP_AUTH_SUCCESS = 10018;
}

export class FaceUnlockVerifyState {
  public static readonly READY: number = 0;

  public static readonly VERIFYING: number = 1;

  // 未识别：例如人脸认证超时、人脸认证异常
  public static readonly NOT_RECOGNIZED: number = 2;

  public static readonly SUCCESS: number = 3;

  // 人脸认证失败，结果不匹配
  public static readonly FAILED: number = 4;

  public static readonly LOCKED: number = 5;
  // 凭证过期
  public static readonly EXPIRED: number = 6;
}

/**
 * 触发人脸解锁原因
 */
export class FaceUnlockReason {
  /**
   * 未知原因触发人脸解锁
   */
  public static readonly UNKNOWN: string = 'Unknown';

  /**
   * 亮屏触发人脸解锁
   */
  public static readonly SCREEN_ON: string = 'ScreenOn';

  /**
   * 隐藏相机界面触发人脸解锁
   */
  public static readonly CAMERA_HIDE: string = 'CameraHide';

  /**
   * 收起下拉面板触发人脸解锁
   */
  public static readonly DROPDOWN_HIDE: string = 'DropdownHide';

  /**
   * 覆盖模式改变触发人脸解锁
   */
  public static readonly OCCLUDED_CHANGED: string = 'OccludedChanged';

  /**
   * 解除相机禁用触发人脸解锁
   */
  public static readonly CAMERA_MUTE_OFF: string = 'CameraMuteOff';

  /**
   * 进入密码界面触发人脸解锁
   */
  public static readonly BOUNCER_SHOW: string = 'BouncerShow';

  /**
   * 密码界面单击人脸图标触发人脸解锁
   */
  public static readonly BOUNCER_CLICK: string = 'BouncerClick';

  /**
   * 密码界面手势导航触发人脸解锁
   */
  public static readonly BOUNCER_GESTURE: string = 'BouncerGesture';

  /**
   * 退回主页
   */
  public static readonly BACK_MAIN_PAGE: string  = 'BackMainPage';

  /**
   * 黑屏错误指纹触发人脸解锁
   */
  public static readonly WRONG_FINGER: string = 'WrongFinger';

  /**
   * IPC调用触发人脸解锁
   */
  public static readonly IPC: string = 'IPC';

  /**
   * 切换用户触发人脸解锁
   */
  public static readonly USER_SWITCHED: string = 'UserSwitched';

  /**
   * 线程重启触发人脸解锁
   */
  public static readonly THREAD_START: string = 'ThreadStart';

  /**
   * 锁屏主界面双击触发人脸解锁
   */
  public static readonly DOUBLE_TAP: string = 'DoubleTap';

  /**
   * 折叠状态改变触发人脸解锁
   */
  public static readonly FOLD_CHANGED: string = 'FoldChanged';
  /**
   * 皮套移除触发人脸解锁
   */
  public static readonly COVER_REMOVED: string = 'CoverRemoved';
}
