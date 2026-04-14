/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { CommonConstants } from '../constants/CommonConstants';

export class IconCommonUtil {
  /**
   * 判断是否是非法值 最小值-6 最大值8
   */
  public static isValidIconSizeChange(iconSizeScale: number): boolean {
    return iconSizeScale >= CommonConstants.DESKTOP_ICON_CHANGE_SIZE_MIN &&
      iconSizeScale <= CommonConstants.DESKTOP_ICON_CHANGE_SIZE_MAX;
  }

  /**
   * 获取图标缩放档位
   */
  public static getDesktopIconChangeSize(): number {
    let desktopIconChangeSize: number = AppStorage.get<number>('settingIconChange') ?? 1;
    if (IconCommonUtil.isValidIconSizeChange(desktopIconChangeSize)) {
      return desktopIconChangeSize;
    } else {
      return 0;
    }
  }
}