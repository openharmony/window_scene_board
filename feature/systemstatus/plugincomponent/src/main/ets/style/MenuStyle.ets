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

/**
 * menu组件资源样式
 *
 * @since 204-3-27
 */

export class MenuStyle {
  /**
   * 菜单默认宽度
   */
  public defaultMenuWidth: Length = 160;

  /**
   * 菜单项默认高度
   */
  public defaultMenuHeight: Length = 40;

  /**
   * 菜单底板圆角
   */
  public menuContainerRadius: Length = 16;

  /**
   * 菜单项交互底板圆角
   */
  public menuItemRadius: Length = 12;

  /**
   * 菜单上方外边距
   */
  public menuTopMargin: Length = 2;

  /**
   * 菜单底板右侧内边距
   */
  public menuContainerRightPadding: Length = 4;

  /**
   * 菜单底板左侧内边距
   */
  public menuContainerLeftPadding: Length = 4;

  /**
   * 菜单底板上方内边距
   */
  public menuContainerTopPadding: Length = 4;

  /**
   * 菜单底板下方内边距
   */
  public menuContainerBottomPadding: Length = 4;

  /**
   * 菜单退出项
   */
  public exitItemText: ResourceStr = $r('app.string.exit');
}