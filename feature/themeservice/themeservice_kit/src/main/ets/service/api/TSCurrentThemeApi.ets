/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */
import { IconsInfo } from '../model/IconsInfo';

/**
 * 当前主题通用API，调用方为大桌面主进程
 */
export interface TSCurrentThemeApi {

  /**
   * 判断当前主题包是否有在线充电动效资源
   *
   * @return true：有充电动效资源
   */
  hasChargingResource(): Promise<boolean[]>;

  /**
   * 获取当前使能的图标信息
   *
   * @returns {IconsInfo} 图标信息，包含id和origin
   */
  getIconsInfo(): Promise<IconsInfo>;
}