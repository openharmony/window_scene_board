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
 * 通知面板头部ViewModel
 *
 * @since 2024-11-08
 */
export interface INotificationHeaderVm {
  /**
   * 时间透明度
   */
  timeTextOpacity: number;

  /**
   * 时间缩放属性
   */
  timeTextScale: number;

  /**
   * 时间位移
   */
  timeTextTranslateY: number;

  /**
   * 日期透明度
   */
  dateTextOpacity: number;

  /**
   * 日期缩放
   */
  dateTextScale: number;

  /**
   * 日期位移
   */
  dateTextTranslateY: number;
  /**
   * 下拉跟手动效
   */
  followAnim?: AnimateParam ;

  /**
   * 是否显示时间日期组件
   */
  visibility: Visibility;

  /**
   * 时间日期容器宽度
   */
  width: string

  /**
   * 时间文本大小
   */
  timeTextFontSize: Resource
  /**
   * 时间文本字重
   */
  timeTextFontWeight: FontWeight
  /**
   * 时间文本行高
   */
  timeTextLineHeight: Resource | undefined

  /**
   * 日期文本大小
   */
  dateTextFontSize: Resource
  /**
   * 日期文本字重
   */
  dateTextFontWeight: FontWeight
  /**
   * 日期文本行高
   */
  dateTextLineHeight: Resource | undefined
  /**
   * 通知中心时间面板位移值
   */
  headerTranslateY: number;

  /**
   * 对齐规则
   */
  alignRules: LocalizedAlignRuleOptions;
  /**
   * margin
   */
  margin: Margin;
  /**
   * 前一次下拉面板距离
   */
  preDropDownMoveY: number;
  /**
   * 展示通知时间与日期
   */
  showTitleText(): void;

  /**
   * 通知时间与日志出场、消失动效
   */
  doTitleAnim(isShow: boolean): void;

  /**
   * 下拉跟手更新纵向位移
   * @param transY 位移
   */
  followUpdateTransY(transY: number): void;

  /**
   * 获取滑动手势handler
   * @returns
   */
  getPanGestureHandler(): PanGestureHandler;
  /**
   * 获取头部组件高度
   * @returns 组件高度
   */
  headerHeight: number;
  /**
   * 通知时间与日期跟手动效
   * @param firstCardTransY 第一张卡片的位移
   * @param withAnim 是否为动画中修改
   */
  doFollowHandAnim(firstCardTransY: number, withAnim?: boolean): void;
  /**
   * 模糊更新与运营商切换
   */
  showBlurAndClockWhenFollowHand(): void;

  /**
   * 通知时间与日期跟手动效状态
   */
  resetFollowHandAnim(): void;

  /**
   * 重置时钟状态
   */
  resetClockStatus(): void;
  /**
   * 通知时间与日期跟手位移
   * @param transY 卡片位移
   * @param dropDownMoveY 面板位移
   */
  doFollowUpdateTransY(transY: number, dropDownMoveY: number): void;

  /**
   * 注册事件监听
   */
  registerEventListener(): void;

  /**
   * 解注册事件
   */
  unRegisterEventListener(): void;
}