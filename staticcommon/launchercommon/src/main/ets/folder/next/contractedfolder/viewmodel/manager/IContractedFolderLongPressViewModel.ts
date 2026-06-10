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

/**
 * 折叠态文件夹View组件的控制接口，由Feature层里的ViewModel实现
 */
export interface IContractedFolderLongPressViewModel {
  /**
   * 图标长按效果取消
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param isAppTouch 按压图标
   */
  onIconPressCancel(msg: string, folderId: string, isAppTouch: boolean): void;

  /**
   * 长按触发截图
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param positionY 文件夹屏幕的Y方向位置
   */
  onActionSnapshot(msg: string, folderId: string): void;

  /**
   * 长按触发振动
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  onActionVibrator(msg: string, folderId: string): void;

  /**
   * 长按触发按压动效
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件id
   */
  onActionPressAnimation(msg: string, folderId: string): void;

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
   * 长按隐藏1*1文件夹角标
   *
   * @param folderId
   */
  onActionHideBadge(folderId: string): void;
}