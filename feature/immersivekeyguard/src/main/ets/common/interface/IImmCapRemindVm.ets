/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

// 沉浸胶囊强提醒业务抽象层
export interface IImmCapRemindVm {
  /**
   * 强提醒翻转动效启动回调
   */
  onRemindAnimStart(): void;

  /**
   * 当前沉浸状态是否为胶囊态状态切换
   *
   * @param isCapState true胶囊态
   */
  onCapStateChange(isCapState: boolean): void;

  /**
   * 当前状态是否为AOD状态切换
   *
   * @param isAodState true AOD
   */
  onAodStateChange(isAodState: boolean): void;

  /**
   * 强提醒胶囊动效状态切换
   *
   * @param isAnimating true动效中
   */
  onRemindAnimStChange(isAnimating?: boolean): void;
}