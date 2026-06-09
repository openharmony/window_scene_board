/*
 * Copyright (c) Huawei Device Co., Ltd. 2024. All rights reserved.
 */
import { NormalNotification } from '../../model/NormalNotification';

/**
 * 隐藏保护通知VM，如应用锁隐藏，智能提醒隐藏，锁屏隐藏等
 */
export interface INotificationPrivacyVm {
  /**
   * 加锁通知中的最新通知
   */
  latestNotification: NormalNotification;

  /**
   * 当前通知是否处于应用锁保护状态
   */
  isProtected: boolean;

  /**
   * 当前通知是否处于隐藏状态
   */
  isHidden: boolean;

  /**
   * 隐藏状态通知内容
   */
  content: ResourceStr;

  /**
   * 隐私保护卡片点击直接跳转，不会展开按钮
   */
  onClick: () => void;

  /**
   * 是否为底部扩展实况通知
   */
  isExpandedLive?: boolean;

  /**
   * 标题字号
   */
  titleFontSize?: Length;

  /**
   * 标题行高
   */
  titleLineHeight?: Length;
}