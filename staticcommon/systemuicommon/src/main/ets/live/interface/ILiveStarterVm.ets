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
import { NotificationWantAgentInfo } from '../../model/NotificationAppInfo';
import { WantAgent } from '@kit.AbilityKit';
import { LiveNotification } from '../model/LiveNotification';
import { LiveButtonModel } from '../model/LiveCommonModel';
import { ILiveCardListItemVm } from './ILiveCardListItemVm';

export interface LiveNotificationOperationInfo {
  /**
   * 按钮名称
   */
  actionName?: string,
  /**
   * 按钮索引
   */
  buttonIndex?: number,
  /**
   * 跳转类型
   */
  operationType?: number;
}

export interface LiveStartWantAgentParams {
  /**
   * wantAgent
   */
  wantAgent?: WantAgent;
  /**
   * 实况卡片项VM
   */
  cardVm: ILiveCardListItemVm;
  /**
   * 解析后的wantAgent信息
   */
  wantAgentInfo?: NotificationWantAgentInfo;
  /**
   * 播控卡片进应用需要提前关闭面板
   */
  onStartApp?: () => void;
  /**
   * 操作信息
   */
  operationInfo?: LiveNotificationOperationInfo;
}

export interface StartResult {
  /**
   * 是否一镜到底拉起
   */
  start?: boolean;

  /**
   * wantagent拉起类型
   */
  operationType?: number;
}

/**
 * 负责通知实况的VM
 */
export interface ILiveStarterVm {
  /**
   * 拉起wantAgent
   * @param params
   * @returns 返回值true表示为拉起应用
   */
  startCardWantAgent(params: LiveStartWantAgentParams): Promise<StartResult>;

  /**
   * 拉起胶囊的wantAgent
   * @param live
   * @param needAnim
   */
  startCapsuleWantAgent(live: LiveNotification, needAnim?: boolean): Promise<void>;

  /**
   * 触发系统实况按钮的动作
   * @param button
   * @returns
   */
  triggerButton(live: LiveNotification, button: LiveButtonModel): Promise<void>;
}