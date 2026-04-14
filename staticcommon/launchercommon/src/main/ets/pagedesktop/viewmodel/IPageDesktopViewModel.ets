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

import {
  GridLayoutItemInfo,
  CardItemInfo
} from '../../TsIndex';
import {
  FocusChangeListener
} from '../model/PageDesktopModel';
import { PageDesktopGridStyleConfig } from '../../layoutconfig/PageDesktopGridStyleConfig';

/**
 * 桌面ViewModel代理接口类
 */
export interface IPageDesktopViewModel {

  /**
   * 获取桌面获焦状态
   *
   * @returns true/false
   */
  getDesktopFocusState(): boolean;

  /**
   * 注册桌面获焦监听器
   *
   * @param key
   * @param listener
   */
  registerFocusChangeListener(key: string, listener: FocusChangeListener): void;

  /**
   * 反注册桌面获焦监听器
   *
   * @param key
   * @param listener
   */
  unregisterFocusChangeListener(key: string, listener: FocusChangeListener): void;

  /**
   * 设置多选拖拽开始
   *
   * @param multiDragStart
   * @param tag
   */
  setMultiDragStart(multiDragStart: boolean, tag?: string): void;

  /**
   * 选中状态变化
   *
   * @param items
   * @param selectStatus
   * @param isSingle
   */
  onSelectItemChange(items: string[], selectStatus: boolean, isSingle?: boolean): void;

  /**
   * 获取选中元素
   *
   * @returns
   */
  getCurrentSelectItemsInfo(): GridLayoutItemInfo[];

  /**
   * 是否有空间
   *
   * @param itemInfo
   * @returns boolean
   */
  hasEnoughArea(itemInfo: CardItemInfo): boolean;

  /**
   * 获取新建卡片状态
   *
   * @returns boolean
   */
  getCreateCardState(): boolean;

  /**
   * 获取元素ForEach Key
   *
   * @param item
   * @param desktopIconChange
   * @param isGameEngineValid
   * @param disabledLiveFormCount
   * @param isOuter
   * @returns
   */
  getForeachKey(item: GridLayoutItemInfo, desktopIconChange: number, isGameEngineValid?: boolean,
    disabledLiveFormCount?: number, isOuter?: boolean): string;

  /**
   * 添加卡片到桌面
   *
   * @param formCardItem
   * @param callback
   * @param setPositionBack
   * @returns
   */
  createCardToDeskTop(formCardItem: CardItemInfo | GridLayoutItemInfo, callback?: Callback<void>,
    setPositionBack?: (position: number[], page?: number, screenSelectType?: number) => void): Promise<number>;

  /**
   * 卸载应用
   *
   * @param uninstallBundleName
   * @param isUninstallable
   * @param appIndex
   * @param forceUninstall
   * @param showToast
   */
  uninstallApp(uninstallBundleName: string, isUninstallable: boolean, appIndex?: number, forceUninstall?: boolean,
    showToast?: boolean): void;

  /**
   * 获取桌面元素样式配置
   */
  getPageDesktopStyleConfig(): PageDesktopGridStyleConfig;

  /**
   * 设置拖拽截图
   */
  setSnapShotMap(key: string, forceUpdate: boolean): Promise<void>;
}