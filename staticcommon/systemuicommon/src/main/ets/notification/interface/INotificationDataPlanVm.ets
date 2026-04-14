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
import { NtfDisplayDataInfo } from '../../vm/CellularDataVm';

/**
 * 通知面板流量套餐VM
 */
export interface INotificationDataPlanVm {
  /**
   * 今日使用流量
   */
  todayUseDataText: string;

  /**
   * 套餐总流量
   */
  totalDataText: string;

  /**
   * 剩余流量
   */
  remainDataText: string;

  /**
   * 水平对齐规格
   */
  flexAlign: FlexAlign;

  /**
   * 下拉跟手动效
   */
  followAnim?: AnimateParam;

  /**
   * 流量文本缩放
   */
  dataTextScale: number;

  /**
   * 流量文本透明度
   */
  dataTextOpacity: number;

  /**
   * 流量文本位移
   */
  dataTextTranslateY: number;

  /**
   * 流量文本字体大小
   */
  dataTextFontSize: Resource;

  /**
   * 流量文本字重
   */
  dataTextFontWeight: FontWeight

  /**
   * 流量文本行高
   */
  dataTextLineHeight: Resource | undefined;

  /**
   * 无障碍播报文本
   */
  accessibilityText: string;

  /**
   * 延迟加载
   */
  delayLoad: boolean;

  /**
   * 剩余流量文本宽度
   */
  remainTextWidth?: Length;

  init(): void;

  destroy(): void;

  /**
   * 获取组件id
   */
  getId(text: string): string;

  /**
   * 是否显示流量信息
   */
  isShowDataPlan: boolean;

  /**
   * 刷新流量展示信息
   */
  refreshDisplayDataInfo(dataPlan: NtfDisplayDataInfo): void;

  /**
   * 是否能显示全部内容，当无法显示时优先隐藏总流量
   *
   * @returns
   */
  canDisplayAll: boolean;

  /**
   * 流量是否超额
   */
  dataExceed(): boolean;

  /**
   * 重置
   */
  reset(): void;

  /**
   * 获取流量文本字体大小
   */
  getDataTextFontSize(): Resource;


  dataExceed(): boolean;

  reset(): void;

  getDataTextFontSize(): Resource;

  /**
   * 跳转到流量数据
   */
  jumpToDataPage(): void;

  /**
   * 跟手动效跟随
   */
  dataPlanDoFollowHandAnim(firstCardTransY: number): void;

  /**
   * 流量文本跟手位移
   * @param transY 卡片位移
   * @param dropDownMoveY 面板位移
   */
  dataPlanDoFollowUpdateTransY(transY: number, dropDownMoveY: number): void;

  /**
   * 展示流量数据
   */
  showDataText(): void;

  /**
   * 流量数据出场、消失动效
   */
  doDataAnim(isShow: boolean): void;

  /**
   * 是否接入天水计划
   */
  isTianShuiConnected: boolean;

  /**
   * 流量显示字体高度
   */
  getTextHeight(): number;
}