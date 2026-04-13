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
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { BaseNodeParams } from './BaseNodeParams';
import AppBubbleCommonParams from './AppBubbleCommonParams';
import { AppStatus, MenuInfo } from '../TsIndex';

export default class AppBubbleParams extends BaseNodeParams {
  // 公共参数
  public common: AppBubbleCommonParams = new AppBubbleCommonParams();

  public item: GridLayoutItemInfo = new GridLayoutItemInfo();

  public menuInfo: MenuInfo[] = [];

  public isGeometryTransiting : boolean = false;

  public pageIndex: number = 0;

  public index: number = 0;

  /**
   * 该图标在文件夹打开动效中的动效参数，非首页图标则数组长度为0
   * index0：x轴偏移量
   * index1：y轴偏移量
   * index2：缩放大小
   * index3: 图标透明度
   */
  public openFolderAniParams: number[] = [];

  /**
   * 图标名称在文件夹打开动效中的透明度
   */
  public openFolderIconNameOpt: number = 1;
  /**
   * 应用状态
   */
  public status: number | undefined = AppStatus.INSTALLED

  /**
   * 是否强制显示角标
   */
  public forceShowBadge: boolean = false;
}

