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
import { DragEvent } from 'DragControllerParam';
import { DragEventParams, DragGridInfo, DragPosition, DragGridPosition, DragCallbackParams } from '../../common/type/CommonTypes';

/**
 * 拖拽抽象类
 *
 * @since 2024/03/14
 */
export abstract class DragModel {
  public abstract start(event: DragEvent, extraParams?: string): void;
  public abstract end(event: DragEvent, extraParams?: string): void;
  public abstract enter(event: DragEvent, extraParams?: string): void;
  public abstract leave(event: DragEvent, extraParams?: string): void;
  public abstract drop(event: DragEvent, extraParams?: string): void;

  /**
   * 构造拖拽回调通用参数
   *
   * @param userEvent ARKUI事件的event参数
   * @param userExtraParams ARKUI事件的extraParams参数
   * @returns 拖拽、挤位通用参数
   */
  protected toDragCallbackParams(userEvent: DragEvent, userExtraParams?: string,
    dragInfo?: DragGridInfo, gridPosition?: DragGridPosition): DragCallbackParams {
    let dragEventParams: DragEventParams = {
      event: userEvent,
      extraParams: userExtraParams,
    };
    let rectangle = userEvent.getPreviewRect();
    let dragPosition: DragPosition = {
      x: Number(rectangle.x) + Number(rectangle.width) / 2,
      y: Number(rectangle.y) + Number(rectangle.height) / 2,
    };

    let dragCallbackParams: DragCallbackParams = {
      eventParams: dragEventParams,
      dragInfo: dragInfo,
      position: dragPosition,
      gridPosition: gridPosition,
    };
    return dragCallbackParams;
  }
}