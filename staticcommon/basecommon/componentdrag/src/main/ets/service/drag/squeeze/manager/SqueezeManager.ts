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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SqueezeMachine } from '../fsm/SqueezeMachine';
import type { DragEvent } from 'DragControllerParam';
import { SqueezeParams } from '../../common/type/SqueezeTypes';
import { dragContext, DragContextContent, DragContextType } from '../../common/recover/DragContext';
import { dragRecoverManager } from '../../common/recover/DragRecoverManager';

const TAG = 'Drag-SqueezeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 组件-挤位管理模块，创建该模块，可以将ArkUI的拖拽接口转换为挤位逻辑
 */
export class SqueezeManager implements DragContextContent {
  private machine: SqueezeMachine;

  /**
   * 构造函数
   *
   * @param params 挤位管理类参数
   */
  public constructor(params: SqueezeParams) {
    this.machine = new SqueezeMachine(params);
  }

  /**
   * 初始化挤位管理类，业务在ArkUI的onDragEnter中调用此接口
   *
   * @param event ArkUI事件的event参数
   * @param extraParams ArkUI事件的extraParams参数
   */
  public init(event: DragEvent, extraParams?: string): void {
    dragContext.addContent(DragContextType.SQUEEZE, this);
    this.machine.initPosition(event, extraParams);
  }

  /**
   * 位移函数，业务在ArkUI的onDragMove中调用此接口
   *
   * @param event ArkUI事件的event参数
   * @param extraParams ArkUI事件的extraParams参数
   */
  public move(event: DragEvent, extraParams?: string): void {
    log.showDebug(`step run squeeze machine`);
    dragRecoverManager.startDragTimer();
    this.machine.moveStep(event, extraParams);
  }

  /**
   * 清空挤位状态，状态机设置为结束
   */
  public release(): void {
    log.showInfo(`release squeeze machine`);
    this.machine.toFinish();
  }

  /**
   * 构造函数，创建挤位管理模块实例
   *
   * @param params 挤位管理模块入参
   * @returns 挤位管理模块的实例
   */
  public static build(params: SqueezeParams): SqueezeManager | undefined {
    if (!params) {
      log.showError(`no squeeze parameters`);
      return undefined;
    }
    log.showInfo(`create squeeze machine`);
    return new SqueezeManager(params);
  }
}