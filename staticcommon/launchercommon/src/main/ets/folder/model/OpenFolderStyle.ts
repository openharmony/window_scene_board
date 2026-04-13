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
 * 展开态布局参数对象
 */
export class OpenFolderStyle {
  public iconSize: number = 0;
  public rowGap: number = 0;
  public columnGap: number = 0;
  // Grid上外边距
  public openFolderIconTopMargin: number = 0;
  // Grid下外边距,共同决定了Grid的宽高
  public openFolderIconBottomMargin: number = 0;
  public titleMarginTop: number = 0;
  // 导航点距离底部距离
  public indicatorBottom: number = 0;
  public iconMarginTop: number = 0;
  public appNameMarginTop: number = 0;
  public gridHorizontalPadding: number = 0;
  public gridVerticalPadding: number = 0;
  // 图标中心点位置
  public gridAppIconCenter: number[][] = [];

  public openGridHeight: number = 0;
  public openGridWidth: number = 0;
  public gridItemWidth: number = 0;
  public gridItemHeight: number = 0;
  // 拖拽边框相关属性
  public dragBorderMargin: number = 0;
  public dragBorderHeight: number = 0;
  public dragBorderWidth: number = 0;
}