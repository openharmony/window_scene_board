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

/**
 * back手势识别失败的原因
 */
export enum GestureFailReason {
  INVALID_ANGLE = 'invalid_angle',
  TIMEOUT = 'timeout',
  CANCEL_FROM_USER = 'cancel_from_user',
  CANCEL_FROM_SYSTEM = 'cancel_from_system'
}

/**
 * back热区视图的回调
 */
export interface BackEventViewModelCallBack {

  // back手势识别失败
  onRecognizeFail(reason: GestureFailReason): void;

  // bcak手势开始滑动
  onBackGestureStart(event: GestureEvent, isLeftGesture: boolean, startY: number): void;

  // back手势识别成功跟手滑动
  onBackGestureUpdate(isLeftGesture: boolean, event: GestureEvent, processAnim: number): void;

  // back手势识别成功松手
  onBackGestureEnd(): void;

  // back手势识别成功cancel
  onBackGestureCancel(): void;

  // back手势识别成功用户cancel
  onBackGestureCancelForUser(): void;

  // 注入click事件
  onSendClickEventTo(downEvent: TouchEvent, upEvent: TouchEvent): void;

  // 发送back事件
  onSendGestureBackTo(isLeftArea: boolean, event: GestureEvent): void;
}