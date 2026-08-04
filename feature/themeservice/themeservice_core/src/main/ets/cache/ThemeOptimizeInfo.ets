/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
import { OriginType } from '@ohos/themeservice_inner_api/Index';

/**
 * ThemeOptimizeInfo 记录主题原始文件hash映射(当前仅记录预置主题包文件hash)
 */
export class ThemeOptimizeInfo {
  /**
   * 主题ID
   */
  public themeId: string = '';
  /**
   * 主题类型
   */
  public originType: OriginType = 'preset';
  /**
   * 优化资源类型
   */
  public optType: string = '';
  /**
   * 原始文件名称
   */
  public name: string = '';
  /**
   * 文件hash值
   */
  public hash: string = '';

  constructor(themeId: string, originType: OriginType, optType: string, name: string, hash: string) {
    this.themeId = themeId;
    this.originType = originType;
    this.optType = optType;
    this.name = name;
    this.hash = hash;
  }
}