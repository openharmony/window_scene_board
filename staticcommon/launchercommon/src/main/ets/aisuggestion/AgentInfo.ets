/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * 场景栏区域分身相关的信息
 *
 * @since 2024-06-29
 */
export class AgentInfo {
  // 分身服务ID
  public agentId: string = '';

  // 引导语ID
  public guideId: string = '';

  // 分身意图ID
  public intentId: string = '';

  // 分身服务意图UUID
  public intentUuId: string = '';

  // 分身胶囊chips
  public chips: AgentChip[] = [];
}

/**
 * 分身chips信息
 *
 * @since 2024-06-29
 */
export class AgentChip {
  // 胶囊ID
  public chipId: string = '';

  // 胶囊文本
  public chipText: string = '';
}