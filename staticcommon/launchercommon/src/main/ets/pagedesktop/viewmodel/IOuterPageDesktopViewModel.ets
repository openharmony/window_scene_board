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

import {
  GridLayoutItemInfo,
} from '../../TsIndex';

/**
 * 外屏桌面ViewModel代理接口类
 */
export interface IOuterPageDesktopViewModel {

  /**
   * 外屏是否拥有空间
   *
   * @param itemInfo
   * @returns
   */
  outerHasAppItemEnoughArea(itemInfo: GridLayoutItemInfo): boolean;

  /**
   * 显示没有空间提示toast
   *
   * @param isDefaultStyle
   */
  showNoSpaceToast(isDefaultStyle?: boolean): void;

  /**
   * 添加应用到外屏桌面
   *
   * @param appItem
   * @param callback
   * @param setPositionBack
   * @returns
   */
  addOuterAppItemToDeskTop(appItem: GridLayoutItemInfo, callback?: Callback<void>,
    setPositionBack?: (position: number[], page?: number, screenSelectType?: number) => void): Promise<void>;

  /**
   * 删除应用
   * @param bundleName 应用包名
   * @param appIndex 主应用或分身应用标识
   */
  deleteOuterAppInfo(bundleName: string, appIndex?: number): void;
}