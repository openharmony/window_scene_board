/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 */

export interface IFloatingBallMenuVm {
  /**
   * 菜单是否显示
   */
  isShow: boolean;

  /**
   * 透明度
   */
  opacity: number;

  /**
   * 缩放
   */
  scale: number;

  /**
   * 菜单宽度，与原面板相同
   */
  width: number;

  /**
   * 菜单高度，与原面板相同
   */
  height: number;

  /**
   * 初始化
   * @param width
   * @param height
   */
  init(width: number, height: number): void;
}