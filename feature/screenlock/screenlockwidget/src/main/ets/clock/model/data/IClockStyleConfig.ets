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
import { ClockLayout, ClockWidgetId } from '../../../common/WidgetParam';
import { ClockGridParam, ElementConf } from '../../common/ClockLayoutParam';

/**
 * 时钟配置数据类型
 */
export interface IClockStyleConfig {
  /**
   * 取值时钟样式类型
   *
   * @returns 样式类型
   */
  getClockLayout(): ClockLayout;

  /**
   * 取值展开样式元素配置集
   *
   * @returns 元素集
   */
  getExpandElementArr(): ElementConf[];

  /**
   * 取值收起样式元素配置集
   *
   * @returns 元素集
   */
  getCollapseElementArr(): ElementConf[];

  /**
   * 取值时钟收起样式元素配置
   *
   * @param id 元素标识
   * @returns 元素配置
   */
  getCollapseElement(id: ClockWidgetId): ElementConf | undefined;

  /**
   * 取值时钟展开样式栅格配置
   *
   * @returns 栅格配置
   */
  getExpandGrid(): ClockGridParam | undefined;

  /**
   * 取值时钟收起样式栅格配置
   *
   * @returns 栅格配置
   */
  getCollapseGrid(): ClockGridParam | undefined;

  /**
   * 取值时钟一镜到底收起样式栅格配置
   *
   * @returns 栅格配置
   */
  getOneShotGrid(): ClockGridParam | undefined;

  /**
   * 取值时钟样式默认字体配置
   *
   * @returns 字体配置
   */
  getFontFamily(): string;
}