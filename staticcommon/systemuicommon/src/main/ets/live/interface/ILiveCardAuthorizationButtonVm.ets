/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 */

/**
 * 卡片授权提示按钮VM
 */
export interface ILiveCardAuthorizationButtonVm {
  /**
   * 按钮字体颜色
   */
  buttonTextFontColor: number;
  /**
   * text字体透明度
   */
  buttonTextOpacity: number;
  /**
   * text字体大小
   */
  buttonTextFontSize: number;
  /**
   * text行高度
   */
  buttonTextLineHeight: number;
  /**
   * action是否按压状态
   */
  isActionPressed: boolean;
  /**
   * 触摸事件
   */
  onTouchEvent(event: TouchEvent): void;
}
