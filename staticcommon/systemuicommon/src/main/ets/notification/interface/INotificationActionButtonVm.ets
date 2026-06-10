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
import { NotificationAction } from '../../model/NotificationContent';

export interface INotificationActionButtonVm {
  /**
   * 被触摸的按钮索引
   */
  touchedIndex: number;

  /**
   * 是否显示输入按钮
   */
  replyAction?: NotificationAction;

  /**
   * 是否正在回复
   */
  isReplying: boolean;

  /**
   * 输入文本
   */
  replyContent: string;

  /**
   * 按钮背景色
   */
  bgColor: ResourceColor;

  /**
   * 按钮底部间距
   */
  paddingBottom?: number;

  /**
   * 点击卡片按钮
   * @param action 按钮信息
   * @param buttonIndex 按钮索引
   * @param isInGroup 是否为子通知
   */
  onClickActionButton: (action: NotificationAction, buttonIndex?: number, isInGroup?: boolean) => Promise<void>;

  /**
   * 输入回复内容变化
   */
  onInputChange: (value: string) => void;

  /**
   * 点击回复按钮
   */
  onClickReply: () => void;

  /**
   * 处理触摸事件
   * @param event
   */
  onTouchEvent: (event: TouchEvent, index: number) => void;

  /**
   * 按钮字体颜色
   */
  fontColor: ResourceColor | undefined;

  /**
   * 按钮字体背景提亮参数
   */
  fontFgBrightness: BrightnessOptions | undefined;

  /**
   * 按钮字体透明度
   */
  fontOpacity: number | undefined;

  /**
   * 获取下挂按钮id
   *
   * @param index 按钮索引
   * @returns id 按钮id
   */
  getActionButtonId(index: number): string;
}