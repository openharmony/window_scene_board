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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { AgentInfo } from './AgentInfo';

import type { CardResourceInfo } from './CardResourceInfo';
import { MultiLanguages } from './MultiLanguages';

/**
 * 场景栏区域相关的信息
 *
 * @since 2023-11-11
 */
export class PortfolioInfo {
  // 标题，如：“雨天路滑，小心驾驶”
  public title: string = '';

  // 场景提示语1描述，如："你在"
  public desc1: string = '';

  // 场景提示语2描述，如："驾驶模式中"
  public desc2: string = '';

  // 场景提示语3描述，如："语音助手发现"
  public desc: string = '';

  // 场景名，如：“语音助手建议 | 驾驶”
  public name: string = '';

  // 场景ID
  public portfolioId: string = '';

  // 背板卡风格 0浅色 1深色
  public backBoardStyle: number = 0;

  // 场景栏显示模式，0：可见3s后消失，1：常驻显示，2：不显示（与needDelayShow组合时，以displayMode为主）
  public displayMode: number = 0;

  // 默认3秒，可通过传参改变
  public delaySeconds: number = 0;

  // 深色资源信息
  public dark?: CardResourceInfo;

  // 浅色资源信息
  public light?: CardResourceInfo;

  // 分身信息
  public agentInfo?: AgentInfo;

  public expireTime?: number;

  public multiLanguages?: MultiLanguages;

  /**
   * 是否是语音助手建议场景卡
   *
   * @returns true 是
   */
  public static isPortfolioCard(portfolioId: string): boolean {
    if (CheckEmptyUtils.isEmpty(portfolioId) || portfolioId === 'default') {
      return false;
    }
    return true;
  }

  /**
   * 是否是主卡
   *
   * @returns true 是
   */
  public static isMainCard(portfolioId: string): boolean {
    return CheckEmptyUtils.isEmpty(portfolioId) || portfolioId === 'default';
  }
}