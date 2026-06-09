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
import { NotificationConfigBaseManager } from '../../manager/NotificationConfigBaseManager';
import { PinTopAppItem } from '../../vm/NotificationPinTopLimitDialogVm';

export interface INotificationPinTopLimitDialogVm {
  /**
   * 置顶弹框是否显示
   */
  isShow: boolean;
  /**
   * 当前置顶的应用列表
   */
  pinTopConfigList: Array<PinTopAppItem>;
  /**
   * 弹框副标题文本
   */
  dialogContentText: string;
  /**
   * 是否横屏布局
   */
  isLandLayout: boolean;
  /**
   * 横屏时适老化布局
   */
  isLandSuitableForOld: boolean;
  /**
   * 所以组件加入滑动区
   */
  isAllScroll:boolean;
  /**
   * 滚动区域的高度
   */
  scrollerHeight: number;
  /**
   * 每行显示的图标个数
   */
  colCount: number;
  /**
   * 初始化
   * @param manager
   * @param controller
   */
  init(manager: NotificationConfigBaseManager, controller: CustomDialogController): void;
  /**
   * 设置置顶
   * @param uid
   * @param enabled
   */
  setPinTop(uid: number, enabled: boolean): Promise<boolean>;
  /**
   * 返回、ESC键和点击遮障层弹窗退出时的回调。
   */
  cancel: () => void;
  /**
   * 取消按钮回调。
   */
  onCancel(): void;
  /**
   * 确认按钮回调
   * @param selected 选中需要取消置顶的应用集合
   */
  onSubmit(selected: Set<PinTopAppItem>): void;

  /**
   * 设置对话框是否显示
   */
  isDialogOpen(): boolean;

  /**
   * 刷新是否所有组件都需要加入滑动区
   * @param dialogHeight
   * @param contentTextID
   */
  refreshIsAllScroll(dialogHeight:  Length | undefined, contentTextID: string): void;
}