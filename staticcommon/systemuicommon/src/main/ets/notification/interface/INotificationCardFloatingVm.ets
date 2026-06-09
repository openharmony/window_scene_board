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
import { NotificationBase } from '../../model/NotificationBase';
import { WantAgent } from '@kit.AbilityKit';
import { NotificationWantAgentInfo } from '../../model/NotificationAppInfo';

export interface NotificationCardFloatingWantAgentParams {
  /**
   * wantAgent
   */
  wantAgent?: WantAgent;
  /**
   * 解析后的wantAgent信息
   */
  wantAgentInfo?: NotificationWantAgentInfo;
  /**
   * card id
   * 一镜到底动效使用
   */
  cardId?: string;
}

export interface INotificationCardFloatingVm {
  ntf: NotificationBase;
  /**
   * 是否可以打开悬浮窗
   * @returns
   */
  canOpenFloating(params: NotificationCardFloatingWantAgentParams): Promise<boolean>;
  /**
   * 点击拉起悬浮窗
   */
  startFloatingForClick(params: NotificationCardFloatingWantAgentParams): Promise<void>;
  /*
   * 执行拉起悬浮窗后卡片卡片隐藏动画
   */
  runCardHideAnimation(event: () => void): Promise<void>;
}