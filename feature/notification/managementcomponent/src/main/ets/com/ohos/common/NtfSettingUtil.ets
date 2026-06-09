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
import display from '@ohos.display';
import { DeviceHelper, XTLayoutType } from './DeviceHelper';

export default class NtfSettingUtil {
  /**
   * 获取页面Navigation模式，
   * @returns 1：split分屏；0：stack堆叠
   */
  public navModeInit(): number {
    let navMode = (DeviceHelper.isPC() || DeviceHelper.isPad()) ? NavigationMode.Split : NavigationMode.Stack;
    if (display.isFoldable()) {
      navMode =
        display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED || NtfSettingUtil.isXTFoldExpandedMode() ?
        NavigationMode.Split : NavigationMode.Stack;
    }
    return navMode;
  }

  /**
   * 是否是XT展开态（用于判断navMode）
   */
  public static isXTFoldExpandedMode(): boolean {
    if (!DeviceHelper.isXTProductType()) {
      return false;
    }

    return DeviceHelper.isMatchXTFoldMode(XTLayoutType.M) || DeviceHelper.isMatchXTFoldMode(XTLayoutType.G);
  }
}