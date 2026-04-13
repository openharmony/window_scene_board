/*
 *
 *  Copyright (c) 2025 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

/**
 * 智能体服务助手功能元素的功能类型。
 */
export const enum FunctionType {
  // 拉起智能体模态框。
  CALL_AGENT = 0,
  // 桌面通用跳转。
  JUMP_TO_PAGE = 1,
}

/**
 * 智能体服务助手数据。
 */
export interface AgentServiceAssistantData {
  agentId: string;
  asaCard: ASACard;
}

/**
 * 智能体服务助手常驻卡数据。
 */
@Observed
export class ASACard {
  public display: ASACardDisplay = new ASACardDisplay();
  public chips: ASACardChip[] = [];
  public guides: ASACardGuide[] = [];
}

/**
 * 智能体服务助手常驻卡展示数据。
 */
@Observed
export class ASACardDisplay {
  public mainTitle: string = '';
  public subTitle: string = '';
  public extras: Record<string, Object> = {};
}

/**
 * 智能体功能元素接口。
 */
export interface IAgentCardFunctionElement {
  name: string;
  type: FunctionType;
  param?: string;
  extras: Record<string, Object>;
}

/**
 * 智能体功能元素 --- 条状标签。
 */
@Observed
export class ASACardChip implements IAgentCardFunctionElement {
  public chipId: string = '';
  public name: string = '';
  public type: FunctionType = FunctionType.CALL_AGENT;
  public param?: string = '';
  public extras: Record<string, Object> = {};
}

/**
 * 智能体功能元素 --- 引导语。
 */
@Observed
export class ASACardGuide implements IAgentCardFunctionElement {
  public name: string = '';
  public type: FunctionType = FunctionType.CALL_AGENT;
  public param?: string = '';
  public extras: Record<string, Object> = {};
}
