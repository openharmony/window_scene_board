/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
export interface GlobalPersistInfo {
  /**
   * 主题Id
   */
  themeId: string;

  /**
   * 内部版本号，用于校验
   */
  version: number;

  /**
   * 持久化对应的数据
   */
  data: Record<string, string>;
}

