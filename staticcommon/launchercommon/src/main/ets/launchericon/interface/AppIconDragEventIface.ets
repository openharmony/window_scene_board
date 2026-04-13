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

export interface AppIconDragEventIface {
  /**
   * 拖拽开始
   * @param event DragEvent
   * @returns CustomBuilder | DragItemInfo
   */
  onDragStart: (event: DragEvent) => CustomBuilder | DragItemInfo;

  /**
   * 拖拽结束
   * @param event DragEvent
   */
  onDragEnd: (event: DragEvent) => void;

  /**
   * 拖拽前回调
   * @param preDragStatus PreDragStatus
   */
  onPreDrag: (preDragStatus: PreDragStatus) => void;

  /**
   * 拖拽预览
   * @returns CustomBuilder | DragItemInfo | string
   */
  getDragPreviewBuilder: () => CustomBuilder | DragItemInfo | string;
}