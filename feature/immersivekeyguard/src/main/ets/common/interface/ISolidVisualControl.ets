/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';

/**
 * 纯色模式视效管控抽象层
 */
export interface ISolidVisualControl {
  /**
   * 纯色业务初始化
   */
  solidInit(): void;

  /**
   * 纯色业务资源回收
   */
  solidDestroy(): void;

  /**
   * 纯色模式是否开启
   *
   * @returns true开启纯色模式
   */
  isSolidEnable(): boolean;

  /**
   * 是否禁用提亮
   *
   * @returns true禁用提亮
   */
  isDisableBright(): boolean;

  /**
   * 刷新纯色模式颜色值
   *
   * @param solidStyle 纯色模式样式管理器
   */
  updateSolidColor(solidStyle: WidgetStyleStateV2): void;
}