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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DragManagerMode, DragParams } from '../../common/type/DragTypes';
import { DragAreaModel } from '../area/DragAreaModel';
import { DragItemModel } from '../item/DragItemModel';
import { DragModel } from '../model/DragModel';

const TAG = 'Drag-DragManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 组件-拖拽管理模块，分别为被拖ITEM和热区AREA创建该模块，将ARKUI的拖拽接口转换为拖拽逻辑
 * ITEM模式下起拖时创建，结束拖拽时释放
 * AREA模式下进入热区范围时创建，离开热区或者热区内落位时释放
 *
 * @since 2024/03/14
 */
export class DragManager {
  private params: DragParams;
  private mode: DragModel;

  constructor(params: DragParams) {
    this.params = params;
    if (this.params.mode === DragManagerMode.ITEM) {
      this.mode = new DragItemModel(this.params);
    } else {
      this.mode = new DragAreaModel(this.params);
    }
  }

  /**
   * 起拖方法，ITEM模式需要在onDragStart调用
   *
   * @param event ARKUI拖拽事件event参数
   * @param extraParams ARKUI拖拽事件extraParams参数
   */
  public start(event: DragEvent, extraParams?: string): void {
    return this.mode.start(event, extraParams);
  }

  /**
   * 松手方法，ITEM模式需要在onDragEnd调用
   *
   * @param event ARKUI拖拽事件event参数
   * @param extraParams ARKUI拖拽事件extraParams参数
   */
  public end(event: DragEvent, extraParams?: string): void {
    return this.mode.end(event, extraParams);
  }

  /**
   * 进入方法，AREA模式需要在onDragEnter调用
   *
   * @param event ARKUI拖拽事件event参数
   * @param extraParams ARKUI拖拽事件extraParams参数
   */
  public enter(event: DragEvent, extraParams?: string): void {
    return this.mode.enter(event, extraParams);
  }

  /**
   * 离开方法，AREA模式需要在onDragLeave调用
   *
   * @param event ARKUI拖拽事件event参数
   * @param extraParams ARKUI拖拽事件extraParams参数
   */
  public leave(event: DragEvent, extraParams?: string): void {
    return this.mode.leave(event, extraParams);
  }

  /**
   * 落位方法，AREA模式需要在onDragDrop调用
   *
   * @param event ARKUI拖拽事件event参数
   * @param extraParams ARKUI拖拽事件extraParams参数
   */
  public drop(event: DragEvent, extraParams?: string): void {
    return this.mode.drop(event, extraParams);
  }

  /**
   * 释放Manager资源
   */
  public release(): void {
    return;
  }

  /**
   * 创建Manager资源
   *
   * @param params Manager创建参数
   * @returns Manager实例
   */
  public static builder(params: DragParams): DragManager {
    if (!params) {
      log.showError(`please input your drag parameters ...`);
      return null;
    }

    return new DragManager(params);
  }
}