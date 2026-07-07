/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

/**
 * 操作类型
 *
 * @since 2023-08-11
 */
export const enum OperateType {
  /** 请求推荐服务 */
  REQUEST_REC_SERVICE = 'requestRecServices',

  /** 点击推荐服务 */
  CLICK = 'clickService',

  /** 长按菜单-不感兴趣 */
  DISLIKE_SERVICE = 'dislikeService',

  /** 长按菜单-不感兴趣 */
  DISLIKE_PORTFOLIO = 'dislikePortfolio',

  /** 长按菜单-设为常驻 */
  PIN = 'pinService',

  /** 长按菜单-取消常驻 */
  UNPIN = 'unpinService',

  /** 长按菜单-移除卡片 */
  REMOVE = 'deleteForm',

  /** 语音助手建议屏布局变化 */
  SCREEN_CHANGE = 'screenChanged',

  /** 获取图片资源 */
  GET_RESOURCE = 'getResource',

  /** 点击场景栏 */
  CLICK_PORTFOLIO_CARD = 'clickPortfolioCard',

  /** 堆叠发生切换 */
  SWITCH_FORM_STACK = 'switchFormStack',

  /** 分身点击引导语 */
  CLICK_AGENT_GUIDE = 'clickAgentGuide',

  /** 分身点击胶囊 */
  CLICK_AGENT_CHIP = 'clickAgentChip',

  /** 快递事件 */
  EXPRESS = 'express',

  /** 点击热区 */
  CLICK_HOT_SPOT = 'clickHotSpot',

  /** 长按菜单-编辑场景和服务 */
  EDIT_MENU = 'editMenu',

  /** 长按菜单-管理卡片 */
  MANAGE_CARD = 'manageCards',

  /** 长按菜单-管理应用 */
  MANAGE_APP = 'manageApps',
}