/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2024. All rights reserved.
 */
import { Qualifier, TargetType } from '../constant/TSTypes';

export interface TConfigArg {
  /**
   * 目标目录
   */
  target: TargetType;

  /**
   * 限定符
   */
  qualifier?: Qualifier;

  /**
   *文件名称（如："lock_config.json"）
   */
  fileName: string;

  /**
   * 需要写入的内容
   */
  value: string

  /**
   * 需要拷贝的原始路径，可以不传
   */
  originPath?: string
}