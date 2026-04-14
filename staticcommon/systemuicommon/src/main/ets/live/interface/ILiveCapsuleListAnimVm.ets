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

import { LiveNotification } from '../model/LiveNotification';
import type { CapsuleTransferParam } from './ILiveCapsuleListVm';


export interface ILiveCapsuleListAnimVm {
  /**
   * 设置胶囊显示动效初始状态
   * @param capsuleTransferParam
   */
  setCapsuleTransferState(capsuleTransferParam?: CapsuleTransferParam): void;

  /**
   * 胶囊收回屏幕挖孔中
   * @param capsuleTransferParam 动效参数
   * @param conflict 是否处于冲突时间内（上一轮的delay以内执行）
   * @returns
   */
  collapseCapsuleList(capsuleTransferParam?: CapsuleTransferParam, conflict?: boolean): Promise<void>;

  /**
   * 胶囊从屏幕挖孔中弹出
   * @param liveList 实况列表
   * @returns
   */
  expandCapsuleList(capsuleTransferParam?: CapsuleTransferParam): Promise<void>;

  /**
   * 动效设置胶囊最终状态
   */
  setCapsuleListFinalState(capsuleTransferParam?: CapsuleTransferParam): Promise<void>;

  /**
   *  更新胶囊的宽度和位移
   *
   * @param liveList 当前胶囊列表
   * @param live 更新的胶囊
   * @returns
   */
  updateCapsuleWidthAndOffset(liveList: LiveNotification[], live?: LiveNotification): Promise<void>;

  /**
   * 展开胶囊的边框流光动效
   * @param capsuleTransferParam
   * @returns
   */
  expandLightWave(capsuleTransferParam?: CapsuleTransferParam): Promise<void>;
}
