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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG: string = 'DragContext';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 拖拽上下文内容的类型
 */
export enum DragContextType {
  /**
   * 拖拽元素
   */
  DRAG_ITEM = 0,

  /**
   * 拖拽的热区
   */
  DRAG_AREA = 1,

  /**
   * 拖拽挤位管理
   */
  SQUEEZE = 2,
}

/**
 * 拖拽上下文内容的接口
 */
export interface DragContextContent {
  /**
   * 释放拖拽内容
   */
  release(): void;
}

/**
 * 拖拽上下文，包含当前生效的拖拽管理和挤位管理实例等
 */
class DragContext {
  private context: Map<DragContextType, DragContextContent> = new Map();
  private _event?: DragEvent;
  private _extraParams?: string;

  /**
   * 添加拖拽内容到上下文中
   *
   * @param type 拖拽内容的类型
   * @param content 拖拽内容
   */
  public addContent(type: DragContextType, content: DragContextContent): void {
    this.context.set(type, content);
  }

  /**
   * 将拖拽内容从上下文中移除
   *
   * @param type 拖拽内容的类型
   * @param content 拖拽内容
   * @returns 是否移除成功
   */
  public removeContent(type: DragContextType, content: DragContextContent): boolean {
    if (this.context.get(type) === content) {
      return this.context.delete(type);
    }
    return false;
  }

  /**
   * 获取拖拽内容
   *
   * @param type 拖拽内容的类型
   * @returns 拖拽内容
   */
  public getContent(type: DragContextType): DragContextContent | undefined {
    return this.context.get(type);
  }

  /**
   * 设置拖拽参数
   *
   * @param event 拖拽事件
   * @param extraParams 额外拖拽参数
   */
  public setDragParam(event: DragEvent, extraParams?: string): void {
    this._event = event;
    this._extraParams = extraParams;
  }

  /**
   * 返回当前的拖拽事件
   *
   * @returns 拖拽事件
   */
  public get event(): DragEvent | undefined {
    return this._event;
  }

  /**
   * 返回当前的额外拖拽参数
   *
   * @returns 额外拖拽参数
   */
  public get extraParams(): string | undefined {
    return this._extraParams;
  }

  /**
   * 清空拖拽上下文
   */
  public release(): void {
    log.showInfo('release all drag context');
    this.context.forEach((value: DragContextContent) => value.release());
    this.context.clear();
    this._event = undefined;
    this._extraParams = undefined;
  }
}

export const dragContext: DragContext = SingletonHelper.getInstance(DragContext, TAG) as DragContext;