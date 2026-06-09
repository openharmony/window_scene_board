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

export default class DesktopUtils {

  /**
   * 桌面是否支持显示锁屏相关动效
   *
   * @returns true 支持
   */
  public static isSupportLockAnimation() : boolean {
    // 和全局滑动手势有关 AppStorage.get('isSupportLockAnimation');
    return true;
  }
}