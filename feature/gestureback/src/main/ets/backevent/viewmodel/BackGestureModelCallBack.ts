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

export interface BackGestureModelCallBack {

  // back手势反悔Cancel
  onBackGestureCancelForUser(backDirection: string): void;

  // back手势系統Cancel
  onBackGestureCancel(): void;

  // back手势被互斥
  onIgnoreBackGesture(): void;

  // 发送back事件
  onSendGestureBackTo(event: GestureEvent): void;

}