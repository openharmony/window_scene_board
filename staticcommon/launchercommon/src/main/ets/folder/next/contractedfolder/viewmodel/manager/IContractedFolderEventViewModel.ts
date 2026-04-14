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

import { GridLayoutItemInfo, MenuDataOption, MenuInfo } from '../../../../../TsIndex';

/**
 * 折叠态文件夹View组件的控制接口，事件处理，由Feature层里的ViewModel实现
 */
export interface IContractedFolderEventViewModel {
  /**
   * 文件夹网格的鼠标事件
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param event 鼠标事件
   */
  onMouse(msg: string, folderId: string, event?: MouseEvent): void;

  /**
   * 拖拽开始手势判断
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param gestureInfo 手势
   * @param event 基础手势事件
   */
  onDragGestureJudgeBegin(msg: string, folderId: string, gestureInfo: GestureInfo): number;

  /**
   * 拖拽开始手势判断
   *
   * @param msg 用于DFX的日志打印
   * @param event 基础手势事件
   * @param folderId 文件夹id
   * @param dragStart 拖拽开始回调
   */
  onDragStart(msg: string, event: DragEvent, folderId: string, dragStart?: (event: DragEvent) => DragItemInfo): DragItemInfo | undefined;

  /**
   * 拖拽开始手势判断
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  onDragEnd(msg: string, folderId: string): boolean;

  /**
   * 图标长按效果取消
   */
  onIconPressCancel(): void;

  /**
   * 获取长按菜单出现的回调
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param isLongPress 是否长按触发的菜单显示
   * @returns 回调函数
   */
  onAppMenuAppear(msg: string, folderId: string, isLongPress: boolean): void;

  /**
   * 获取长按菜单显示的回调
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param isLongPress 是否长按触发的菜单显示
   * @returns 回调函数
   */
  onAppMenuDisappear(msg: string, folderId: string, isLongPress: boolean): void;

  /**
   * 菜单关闭
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  onMenuClose(msg: string, folderId: string): void;

  /**
   * 创建文件夹菜单
   *
   * @param convertFolder 文件夹大小转换
   * @param menuCallback 菜单回退
   * @param isConvertToSmall 是否大小转换
   * @param isCanRenameFolder 是否重命名
   * @returns
   */
  buildMenuInfoList(menuCallback: Function, isConvertToSmall: boolean,
    isRenameFolder: boolean): Array<MenuInfo>;

  /**
   * 文件夹点击事件处理统一入口
   *
   * @param msg 用于DFX日志打印
   * @param folderId 文件夹id
   * @param clickType 点击类型
   * @param appItem 应用
   */
  onClick(msg: string, folderId: string, clickType: number, appItem?: GridLayoutItemInfo): void;

  /**
   * 文件夹touch事件处理统一入口
   *
   * @param msg 用于DFX日志打印
   * @param folderId 文件夹id
   * @param event touch事件
   * @param item 触碰的item
   */
  onTouch(msg: string, folderId: string, event?: TouchEvent, item?: GridLayoutItemInfo): void;

  /**
   * 鼠标悬停处理
   *
   * @param msg DFX日志
   * @param folderId 文件夹id
   * @param isHover 鼠标是否悬停在图标上
   */
  onHover(msg: string, folderId: string, isHover: boolean): void;

  /**
   * 长按菜单截图配置项
   *
   * @param msg 事件描述
   * @param folderId 文件夹id
   * @param pageIndex 长按的文件夹所在页
   */
  getMenuOption(msg: string, folderId: string, pageIndex: number): MenuDataOption;

  /**
   * 打开应用，适配桌面布局启动应用接口
   *
   * @param msg 用于DFX日志
   * @param appItem 打开的应用item信息
   */
  openApplication(msg: string, appItem: GridLayoutItemInfo): void;

  /**
   * 卸载应用，适配桌面布局卸载应用接口
   *
   * @param msg 用于DFX日志
   * @param appItem 删除的应用item信息
   */
  uninstallApplication(msg: string, appItem: GridLayoutItemInfo): void;
}