/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { NormalNotification } from '../../model/NormalNotification';

export interface INotificationImmersiveVm {
  /**
   * 标题
   */
  title: ResourceStr;
  /**
   * 标题组件ID
   */
  titleComponentId: string;
  /**
   * 内容
   */
  content: ResourceStr;
  /**
   * 标题宽度
   */
  titleWidth?: number;
  /**
   * 应用图标缩放比例
   */
  iconScale: number;
  /**
   * 内容透明度
   */
  contentOpacity: number;
  /**
   * 获取标题对齐方式，沉浸态展开时采用顶部对齐的方式是为了做展开动效效果更好实现
   */
  titleAlignSelf: ItemAlign;
  /**
   * 获取标题位移
   */
  titleTranslate?: TranslateOptions;
  /**
   * 沉浸卡片高度
   */
  cardHeight?: number | string;
  /**
   * 是否显示展开图标
   */
  isShowExpandIcon: boolean;
  /**
   * 初始化
   * @param ntf
   */
  init(ntf: NormalNotification): void;
  /**
   * 卡片点击
   */
  onClick: () => void;
  /**
   * 尺寸变化事件
   * @param _
   * @param size
   */
  onSizeChange: (_: SizeOptions, size: SizeOptions) => void;
  /**
   * 展开成卡片
   */
  expandToCard: () => void;
  /**
   * 通知删除后重置基础信息
   */
  reset(): void;
}