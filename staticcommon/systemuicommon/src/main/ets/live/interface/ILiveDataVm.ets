/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 */
import { LiveNotification } from '../model/LiveNotification';

export interface ILiveDataVm {
  /**
   * 所有实况数据全集
   */
  liveMap: Map<string, LiveNotification>;

  /**
   * 是否执行多任务一键清除任务
   */
  isClearAllApp: boolean;

  /**
   * 初始化
   */
  init(): void;

  /**
   * 处理多任务一键清除任务
   */
  onClearAllApp(): void;
}