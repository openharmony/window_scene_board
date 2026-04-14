/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';


export interface ILayoutCacheManager {

  /**
   * 根据id查询所有item信息
   *
   * @param infoId item的唯一id
   * @returns GridLayoutItemInfo
   */
  selectGridLayoutItemById(infoId: string | number): GridLayoutItemInfo | undefined;

  /**
   * 根据ino查询item信息, 只有文件/文件夹才有ino
   *
   * @param ino item的file ino
   * @returns GridLayoutItemInfo | undefined
   */
  selectGridLayoutItemByIno(ino: string): GridLayoutItemInfo | undefined;
  /**
   * 根据bundleName查询所有item信息
   *
   * @param bundleName item的bundleName
   * @returns GridLayoutItemInfo的列表
   */
  selectGridLayoutItemsByBundleName(bundleName: string): GridLayoutItemInfo[];

  /**
   * 根据type查询所有item信息
   *
   * @param typeId 业务类型
   * @returns GridLayoutItemInfo的列表
   */
  selectGridLayoutItemsByType(typeId: number): GridLayoutItemInfo[];


  /**
   * 根据bundleName和类型查询所有item
   *
   * @param bundleName item的bundleName
   * @param typeId item类型
   * @returns GridLayoutItemInfo的列表
   */
  selectGridLayoutItemsByBundleAndType(bundleName: string, typeId: number): GridLayoutItemInfo[];

  /**
   * 根据位置信息查询item
   *
   * @param page 页数
   * @param row 行
   * @param col 列
   * @returns GridLayoutItemInfo
   */
  selectGridLayoutItemByPosition(page: number, row: number, col: number): GridLayoutItemInfo | undefined;

  /**
   * 获取指定index的item元素
   *
   * @param index 布局缓存的index
   * @returns item元素
   */
  selectGridLayoutItemByIndex(index: number): GridLayoutItemInfo | undefined;

  /**
   * 根据item获取元素所在的index
   *
   * @param item GridLayoutItemInfo
   * @returns 元素在布局列表位置信息
   */
  selectIndexInLayout(item: GridLayoutItemInfo): number;

  /**
   * 更新bundleName和type删除item
   *
   * @param bundleName bundleName
   * @param typeId 类型
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  deleteGridLayoutItemByBundleNameAndType(bundleName: string, typeId: number, label: string, isOperateDb: boolean): void;

  /**
   * 根据id删除item
   *
   * @param deleteItem 删除的item
   * @param label
   * @param isOperateDb
   */
  deleteGridLayoutItemById(deleteItem: GridLayoutItemInfo, label: string, isOperateDb: boolean): void;

  /**
   * 根据itemId删除GridLayoutItemInfo
   *
   * @param id
   * @param label
   * @param isOperateDb
   */
  deleteGridLayoutItemByItemId(id: string | number, label: string, isOperateDb: boolean): void;

  /**
   * 根据位置信息删除item
   *
   * @param page 页数
   * @param row 行
   * @param col 列
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  deleteGridLayoutItemByPosition(page: number, row: number, col: number, label: string, isOperateDb: boolean): void;

  /**
   * 根据id更新GridLayoutItem
   *
   * @param updateItem updateItem
   * @param label 业务标识
   * @param isOperateDb isOperateDb true需要数据库操作，false不需要
   */
  updateGridLayoutItemPositionById(updateItem: GridLayoutItemInfo, label: string, isOperateDb: boolean): void;
}