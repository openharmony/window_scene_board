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

import { Event } from '@ohos/frameworkwrapper';
import InputMethodSubtype from '@ohos.InputMethodSubtype';


/**
 * 自定义图标事件Handler
 */
export interface InternalEventPoster {
  postClickEvent(event: ClickEvent, slot: string, actsOn: string): void;

  postHoverEvent(event: HoverEvent, slot: string, actsOn: string, isHovered: boolean): void;

  postTouchEvent(event: TouchEvent, slot: string, actsOn: string): void;

  postGestureEvent(event: GestureEvent, slot: string, actsOn: string): void;

  postDoubleClickEvent(event: GestureEvent, slot: string, actsOn: string): void;

  postLongClickEvent(event: GestureEvent, slot: string, actsOn: string): void;

  postRightClickEvent(event: MouseEvent, slot: string, actsOn: string): void;

  postMouseEvent(event: MouseEvent, slot: string, actsOn: string): void;

  postAreaEvent(slot: string, area?: Area): void;

  postCapsuleSortEvent(position: string): void;
}

export interface ExternalEventPoster {
  postExternalEvent<T>(event: Event<T>, data: T): void;
}

export interface InputMethodSubtypeInfo {
  /**
   * 用于联合类型区分具体类型
   */
  vType: 'InputMethodSubtypeInfo';
  subtype: InputMethodSubtype;
}

