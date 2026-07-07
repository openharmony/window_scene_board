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
 * VoiceConstant
 * @since 2025/2/28
 */
export class VoiceConstant {
  // 语音助手进程
  public static BUNDLE_NAME: string = 'com.ohos.vassistant';
  // aiBase进程
  public static AI_BASE_BUNDLE: string = 'com.ohos.aibase';
  // 当前是否处于语音助手展示状态
  public static isShowVoiceLive: string = 'isShowVoiceLive';
  public static isVerdeDevice: string = 'isVerdeDevice';
  // 语音助手的UiExtension是否保留
  public static isVoiceExtExist: string = 'isVoiceExtExist';
  public static isVoiceVisibility: string = 'isVoiceVisibility';
  public static isFullShown: string = 'isFullShown';
  public static isLongPressStartAiPanel: string = 'isLongPressStartAiPanel';
  // 展示或隐藏状态栏
  public static CONTROL_STATUS_BAR_VISIBLE: string = 'controlStatusBarShow';
  // 是否是折叠状态
  public static isFoldStatus: string = 'isFoldStatus';
  // 进入负一屏
  public static ENTER_NEGATIVE_SCREEN_EVENT: string = 'enterNegativeOneScreenEvent';
  // 退出负一屏
  public static EXIT_NEGATIVE_SCREEN_EVENT: string = 'exitNegativeOneScreenEvent';
  // 杀掉语音助手的UIExtension
  public static KILL_VOICE_EXTENSION: string = 'killVoiceExtension';
  // 拉起语音助手界面
  public static PULL_VOICE_PAGE: string = 'pullVoicePage';
  // 语音唤醒的权限
  public static VOICE_PERMISSION: Array<string> = ['ohos.permission.WAKEUP_VOICE'];
}