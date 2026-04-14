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

import { wantAgent, WantAgent } from '@kit.AbilityKit';
import { NotificationWantAgentInfo } from '../../model/NotificationAppInfo';
import { NotificationBase } from '../../model/NotificationBase';
import { INotificationCardVm } from './INotificationCardVm';

export interface NotificationOperationInfo {
  /**
   * 按钮名称
   */
  actionName?: string,
  /**
   * 按钮索引
   */
  buttonIndex?: number,
}

export interface NotificationStartWantAgentParams {
  /**
   * 通知
   */
  groupNtf?: NotificationBase | undefined;
  /**
   * 卡片VM
   */
  cardVm: INotificationCardVm;
  /**
   * 组通知外层卡片VM
   */
  groupCardVm?: INotificationCardVm;
  /**
   * wantAgent
   */
  wantAgent: WantAgent;
  /**
   * 解析后的wantAgent信息
   */
  wantAgentInfo?: NotificationWantAgentInfo;
  /**
   * wantAgent需要携带的参数
   */
  triggerInfo: wantAgent.TriggerInfo;
  /**
   * 操作信息
   */
  operationInfo?: NotificationOperationInfo
}

/**
 * 负责通知启动的VM
 */
export interface INotificationStarterVm {
  /**
   * 拉起wantAgent
   * @param params
   * @returns
   */
  startWantAgent(params: NotificationStartWantAgentParams): Promise<void>;

  /**
   * 拉起应用后隐藏面板
   */
  hidePanel(isAnim: boolean): void;
}