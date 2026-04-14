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

/*
 * 展开态布局计算入参对象,通过给定的入参得到结果
 */

export class OpenFolderStyleParam {
  public iconSize: number = 0;
  public defaultIconSize: number = 0;
  public columnGap: number = 0;
  public rowGap: number = 0;
  public iconMarginTop: number = 0;
  public titleMargin: number = 0;
  // 水平方向图标之间距离和图标大小的比值
  public iconHorizontalScale: number = 0;
  // 垂直方向图标之间距离和图标大小的比值
  public iconVerticalScale: number = 0;
  public maxRows: number = 0;
  public maxColumns: number = 0;
  public appNameMarginTop: number = 0;
  public gridHorizontalPadding: number = 0;
  public gridVerticalPadding: number = 0;
  // 屏幕相关参数
  public screenHeight: number = 0;
  public screenWidth: number = 0;
  public sysTopHeight: number = 0;
  // 拖拽边框相关参数, 边框上左右到图标的距离,下到图标AppName的距离
  public dragBroderIconHorizontalDistance: number = 0;
  public dragBroderIconVerticalDistance: number = 0;
}