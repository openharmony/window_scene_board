/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import LayoutDescription from '../bean/LayoutDescription';

export default class DefaultDesktopLayoutInfo {
  public layoutInfo: GridLayoutItemInfo[] = [];
  public layoutDescription: LayoutDescription = new LayoutDescription();
  public isAppCatagory: Boolean = false;

  /**
   * 获取默认布局
   *
   * @returns 布局信息
   */
  static getDefaultLayoutInfo(): DefaultDesktopLayoutInfo {
    let defaultLayoutInfo = new DefaultDesktopLayoutInfo();
    const isPc: boolean = DeviceHelper.isPC();
    const isBigScreen: boolean = DeviceHelper.isBigScreenMachine();
    defaultLayoutInfo.layoutDescription = {
      pageCount: isBigScreen ? 2 : 1,
      row: !isPc ? 6 : 9,
      column: !isPc ? 4 : 16,
      maxPage: !isPc ? 18 : (isBigScreen ? 2 : 1),
      maxForm: 80
    };
    return defaultLayoutInfo;
  }

  static getSimpleLayoutInfo(): DefaultDesktopLayoutInfo {
    let defaultSimpleLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
    defaultSimpleLayoutInfo.layoutDescription = {
      pageCount: 1,
      row: 4,
      column: 3,
      maxPage: 18,
      maxForm: 1
    };
    return defaultSimpleLayoutInfo;
  }
};
