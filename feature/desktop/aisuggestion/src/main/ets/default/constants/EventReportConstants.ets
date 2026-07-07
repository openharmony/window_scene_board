/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * 语音助手建议打点相关参数
 */
export class EventReportConstants {
  // 卡片打点domain
  public static FORM_REPORT_DOMAIN: string = 'FORM_UE';

  // 语音助手建议点位 语音助手建议_语音助手卡片刷新
  public static AISUGGESTION_CARD_UPDATE: string = 'AISUGGESTION_CARD_UPDATE';

  // 语音助手建议点位 语音助手卡片状态周报（周日0点上报）
  public static AISUGGESTION_CARD_WEEKLY_REPORT: string = 'AISUGGESTION_CARD_WEEKLY_REPORT';

  // 语音助手建议点位 点击语音助手建议卡片内应用图标
  public static AISUGGESTION_INNER_ICON_CLICK: string = 'AISUGGESTION_INNER_ICON_CLICK';

  // 语音助手建议点位 长按语音助手建议桌面卡片内部应用图标
  public static AISUGGESTION_ICON_LONG_PRESS: string = 'AISUGGESTION_ICON_LONG_PRESS';

  // 服务卡片点位 语音助手建议_删除卡片
  public static REMOVE_CARD_UE: string = 'REMOVE_CARD_UE';

  // 服务卡片点位 语音助手建议_点击卡片
  public static CLICK_CARD_UE: string = 'CLICK_CARD_UE';

  // 服务卡片点位 语音助手建议_长按菜单
  public static GO_INTO_CARD_SHORTCUT_MENU_UE: string = 'GO_INTO_CARD_SHORTCUT_MENU_UE';

  // 设备类型 0-手机 1-平板 2-折叠屏
  // 手机
  public static DEVICE_PHONE: number = 0;

  // 平板
  public static DEVICE_PAD: number = 1;

  // 折叠屏
  public static DEVICE_FOLD: number = 2;

  // 屏幕旋转类型 0-竖屏 1-横屏
  // 竖屏
  public static ROTATIONMODE_PORTRAIT: number = 0;

  // 横屏
  public static ROTATIONMODE_LANDSCAPE: number = 1;

  // 卡片类型 0-普通卡片 1-语音助手母卡 2-语音助手子卡
  // 普通卡片
  public static INFOTYPE_COMMON: number = 0;

  // 语音助手母卡
  public static INFOTYPE_MASTER: number = 1;

  // 语音助手子卡
  public static INFOTYPE_SUB: number = 2;

  // 删除操作 0-移除 1-取消
  // 移除
  public static RESULTTYPE_DELETE: number = 0;

  // 取消
  public static RESULTTYPE_CANCEL: number = 1;

  // 语音助手建议点位中的菜单类型
  // 缺省值
  public static SUGGEST_MENU_TYPE_DEFAULT: number = -1;

  // 没有点击
  public static SUGGEST_MENU_TYPE_NO_CLICK: number = 0;

  // 更多服务卡片
  public static SUGGEST_MENU_TYPE_MORE_CARD: number = 1;

  // 不感兴趣
  public static SUGGEST_MENU_TYPE_UNINTEREST: number = 2;

  // 常驻
  public static SUGGEST_MENU_TYPE_PIN: number = 3;

  // 取消常驻
  public static SUGGEST_MENU_TYPE_UNPIN: number = 4;

  // 移除
  public static SUGGEST_MENU_TYPE_REMOVE: number = 5;

  // 不感兴趣此场景
  public static SUGGEST_MENU_TYPE_UNINTEREST_SCENE: number = 6;

  // 服务卡片点位中的菜单类型
  // 没有点击
  public static SERVICE_MENU_TYPE_NO_CLICK: number = 0;

  // 更多服务卡片
  public static SERVICE_MENU_TYPE_MORE_CARD: number = 1;

  // 移除
  public static SERVICE_MENU_TYPE_REMOVE: number = 2;

  // 不感兴趣
  public static SERVICE_MENU_TYPE_UNINTEREST: number = 4;

  // 常驻
  public static SERVICE_MENU_TYPE_PIN: number = 5;

  // 取消常驻
  public static SERVICE_MENU_TYPE_UNPIN: number = 6;

  // 不感兴趣此场景
  public static SERVICE_MENU_TYPE_UNINTEREST_SCENE: number = 7;
}