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

import { AppStatus, MenuInfo } from '../../TsIndex';

/**
 * 业务侧集成图标组件时, 需要外部注入的函数
 */
export interface AppIconExternCb {
  /**
   * 获取图标所在的页面
   * @returns number 图标所在页面
   */
  getIndexInSwiper?: () => number,

  /**
   * 拖拽开始回调, 回调和默认实现都会执行
   * @param event DragEvent
   */
  dragStartExtend?: (event: DragEvent) => void;

  /**
   * 拖拽落位回调, 回调和默认实现都会执行
   * @param event DragEvent
   */
  dragEndExtend?: (event: DragEvent) => void;

  /**
   * 获取未安装菜单信息
   * @returns Map<AppStatus, MenuInfo[] 未安装的菜单信息
   */
  getNotInstalledMenuMap?: () => Map<AppStatus, MenuInfo[]>;

  /**
   * 菜单内容外部获取, 支持菜单显示的要传入
   * @returns MenuInfo[] 外部注入的菜单信息
   */
  getMenuInfo?: () => MenuInfo[];

  /**
   * 桌面图标点击事件外部回调, 该接口与默认实现都会执行
   * @param event 点击事件
   * @param fingers 触碰的手指数量
   */
  onIconClick?: (event?: ClickEvent, fingers?: number) => void;

  /**
   * 桌面图标Touch事件外部回调, 该接口与默认实现都会执行
   * @param event Touch事件
   */
  onIconTouch?: (event: TouchEvent) => void;

  /**
   * 是否使能touch事件处理
   * @returns boolean
   */
  enableHandleTouchEvent?: () => boolean;

  /**
   * 长按预汇聚事件
   * @param event GestureEvent
   */
  onLongPressPreGatherAction?: (event: GestureEvent) => void;

  /**
   * 是否隐藏图标父容器, 不注入接口，默认显示不做控制
   * @returns boolean 是否隐藏图标父组件
   */
  isHideIconContainer?: () => boolean;

  /**
   * 开始菜单拖拽
   * @param x 坐标x
   * @param y 坐标y
   */
  onMenuDragStart?: (x: number, y: number) => void;

  /**
   * 菜单出现
   */
  onMenuAppear?: (isLongPressShow: boolean) => void;

  /**
   * 菜单消失
   */
  onMenuDisappear?: (isLongPressShow: boolean) => void;

  /**
   * 设置菜单位置信息
   * @param event TouchEvent
   * @param iconId 图标组件Id
   */
  setMenuPosition?: (event: TouchEvent, iconId: string) => void;


  /**
   * 获取拖拽截图, 如果拖拽截图和默认截图不一样，可重写
   * @returns CustomBuilder 拖拽截图的CustomBuilder
   */
  getDragIconBuilder?: () => CustomBuilder;

  /**
   * 获取AppName, 针对部分场景，名字需要定制
   * @returns string appName
   */
  getAppName?: () => string;

  /**
   * 自定义处理禁用蒙层
   * @returns 禁用蒙层状态
   */
  isDisableMask?: (param?: boolean) => boolean;

  /**
   * 获取多选图标的菜单信息
   * @returns MenuInfo[] 注入的菜单信息
   */
  getMixMenuInfo?: () => MenuInfo[];

  /**
   * 图标是否多选
   * @returns 是否是多选
   */
  isMultiselect?: () => boolean;
}