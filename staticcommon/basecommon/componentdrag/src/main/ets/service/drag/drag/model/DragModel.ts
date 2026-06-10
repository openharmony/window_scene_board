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

/**
 * 拖拽抽象类
 */
export abstract class DragModel {
  /**
   * 起拖接口
   *
   * @param event 拖拽事件
   * @param extraParams 拖拽额外参数
   */
  public abstract start(event: DragEvent, extraParams?: string): void;

  /**
   * 拖拽结束接口
   *
   * @param event 拖拽事件
   * @param extraParams 拖拽额外参数
   */
  public abstract end(event: DragEvent, extraParams?: string): void;

  /**
   * 拖入接口
   *
   * @param event 拖拽事件
   * @param extraParams 拖拽额外参数
   */
  public abstract enter(event: DragEvent, extraParams?: string): void;

  /**
   * 拖出接口
   *
   * @param event 拖拽事件
   * @param extraParams 拖拽额外参数
   */
  public abstract leave(event: DragEvent, extraParams?: string): void;

  /**
   * 拖拽落位接口
   *
   * @param event 拖拽事件
   * @param extraParams 拖拽额外参数
   */
  public abstract drop(event: DragEvent, extraParams?: string): void;

  /**
   * 清空当前拖拽状态
   */
  public abstract release(): void;
}