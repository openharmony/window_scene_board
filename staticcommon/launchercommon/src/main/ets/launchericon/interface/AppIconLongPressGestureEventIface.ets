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
 * 长按手势回调接口
 */
export interface AppIconLongPressGestureEventIface {
  /**
   * 长按触发预加载 300ms 开始
   * @param event GestureEvent
   */
  onLongPressPreGatherAction: (event: GestureEvent) => void;

  /**
   * 长按触发预加载 300ms 结束
   * @param event GestureEvent
   */
  onLongPressPreGatherActionEnd: (event: GestureEvent) => void;

  /**
   * 长按开始截图 350ms
   * @param event GestureEvent
   */
  onLongPressSnapshotAction: (event: GestureEvent) => void;

  /**
   * 长按开始截图结束 350ms
   * @param event GestureEvent
   */
  onLongPressSnapshotActionEnd: (event: GestureEvent) => void;

  /**
   * 长按开始截图取消 350ms
   * @param event GestureEvent
   */
  onLongPressSnapshotActionCancel: () => void;

  /**
   * 长按触发多选时长 400ms
   * @param event GestureEvent
   */
  onLongPressGatherAction: (event: GestureEvent) => void;

  /**
   * 长按触发多选结束 400ms
   * @param event GestureEvent
   */
  onLongPressGatherActionEnd: (event: GestureEvent) => void;

  /**
   * 长按触发振动 500ms
   * @param event GestureEvent
   */
  onLongPressVibrateAction: (event: GestureEvent) => void;

  /**
   * 长按触发振动结束 500ms
   * @param event GestureEvent
   */
  onLongPressVibrateActionEnd: (event: GestureEvent) => void;

  /**
   * 长按触发振动取消 500ms
   */
  onLongPressVibrateActionCancel: () => void;
  
  /**
   * 长按放大动效 550ms
   * @param event GestureEvent
   */
  onLongPressZoomInAction: (event: GestureEvent) => void;

  /**
   * 图标长按动效
   * @param isZoomOut 是否缩小
   * @param bundleName 应用信息
   */
  onIconLongPressZoomAnimation: (isZoomOut: boolean, bundleName: string) => void;
}