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

import type { InputCardRecInfo } from './InputCardRecInfo';

/**
 * 语音助手建议推荐的item内容
 *
 * @since 2023-10-08
 */
export class InputRecItem {
  // 服务ID
  public serviceId: string = '';

  // 推荐服务类型：0，应用；1：代表卡片；2：切换键（deprecated）；3，代表应用组
  public itemType: number = 0;

  // 0：不支持PIN，1：未PIN；2：已PIN；
  public pinStatus: number = 0;

  // 子卡片的路径名
  public abilityName: string = '';

  // 子卡片包名
  public bundleName: string = '';

  // 子卡片模块名
  public moduleName: string = '';

  // 子卡片名称
  public formName: string = '';

  // 子卡片的规格（1*2卡片=1；2*2卡片=2；2*4卡片=3）
  public dimension: number = 0;

  // 装填位置起始行
  public rowStart: number = 0;

  // 装填位置起始列
  public columnStart: number = 0;

  // 子卡片占据的行数（高度）
  public rowSpan: number = 0;

  // 子卡片占据的列数（宽度）
  public columnSpan: number = 0;

  // 透传给卡片提供方的应用数据
  public formWantInfo: string = '';

  // 卡片推荐的数据
  public recInfo?: InputCardRecInfo;

  // 应用推荐卡片支持跳转对应的快捷方式
  public deepLink: string = '';

  // 是否是分身
  public uid: number = 0;

  // 支持获取对应的应用展示图标
  public iconUrl: string = '';

  // 0表示不需要延迟展示，1表示需要延迟展示
  public needDelayShow: number = 0;

  // 子元素行数
  public subRow: number = 0;

  // 子元素列数
  public subColumn: number = 0;

  // 子元素
  public subRecItems: InputRecItem[] = [];

  // 应用名称
  public appName: string = '';

  // faLink跳转参数
  public parameters?: Record<string, Object>;
}