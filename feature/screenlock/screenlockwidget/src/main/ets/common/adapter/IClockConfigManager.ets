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
import { ClockGridParam, ElementConf } from '../../clock/common/ClockLayoutParam';
import { TextSizeConf } from '../../clock/constants/TextSizeForDIffFontFamily';
import { BaseClockStyleConfig } from '../../clock/model/data/BaseClockStyleConfig';
import { ClockLayout } from '../WidgetParam';

/**
 * 时钟配置接口
 */
export interface IClockConfigManager {
  /**
   * 注册时钟样式
   *
   * @param cfg 时钟样式
   */
  bindClockStyleCfg(cfg: BaseClockStyleConfig): void;

  /**
   * 获取目标样式的展开态时钟配置参数
   *
   * @param type 目标样式
   * @returns 时钟配置参数
   */
  getExpandClockStyleByType(type: ClockLayout): ElementConf[] | undefined;

  /**
   * 获取目标样式的收起态时钟配置参数
   *
   * @param type 目标样式
   * @returns 时钟配置参数
   */
  getCollapseClockStyleByType(type: ClockLayout): ElementConf[] | undefined;

  /**
   * 获取目标样式的展开态时钟网格参数
   *
   * @param type 目标样式
   * @returns 时钟网格参数
   */
  getExpandClockGridType(type: ClockLayout): ClockGridParam | undefined;

  /**
   * 获取目标样式的收起态时钟网格参数
   *
   * @param type 目标样式
   * @returns 时钟网格参数
   */
  getCollapseClockGridType(type: ClockLayout): ClockGridParam | undefined;

  /**
   * 获取一镜到底动画目标样式的收起态时钟网格参数
   *
   * @param type 目标样式
   * @returns 时钟网格修正参数
   */
  getOneShotAniCollapseClockGridType(type: ClockLayout): ClockGridParam | undefined;

  /**
   * 获取目标样式的默认字体
   *
   * @param type 目标样式
   * @returns 默认字体
   */
  getClockDefaultFontFamily(type: ClockLayout): string;

  /**
   * 获取字体对应的渲染尺寸信息
   *
   * @param fontFamily
   * @returns 字体对应的渲染尺寸信息
   */
  getTextSizeConf(fontFamily: string): TextSizeConf | undefined;
}