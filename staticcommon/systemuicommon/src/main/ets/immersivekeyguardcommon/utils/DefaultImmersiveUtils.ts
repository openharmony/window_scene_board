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
  DefaultImmersiveNtfTypeSwitch,
  DefaultImmersiveScreenSwitch,
  ImmersiveConstants
} from '../common/ImmersiveConstants';

/**
 * 默认进沉浸态工具
 */
export class DefaultImmersiveUtils {
  /**
   * 是否开启默认进沉浸态
   */
  public static isEnableDefaultImmersive(): boolean {
    return !!(ImmersiveConstants.NTF_DEFAULT_IMMERSIVE_SCREEN_SWITCH &&
     ImmersiveConstants.NTF_DEFAULT_IMMERSIVE_TYPE_SWITCH);
  }

  /**
   * 是否开启播控通知进沉浸态
   */
  public static isEnableImmersiveBroad(): boolean {
    return !!(ImmersiveConstants.NTF_DEFAULT_IMMERSIVE_TYPE_SWITCH & DefaultImmersiveNtfTypeSwitch.NTF_TYPE_BROAD);
  }

  /**
   * 是否开启三方实况通知进沉浸态
   */
  public static isEnableImmersiveLive(): boolean {
    return !!(ImmersiveConstants.NTF_DEFAULT_IMMERSIVE_TYPE_SWITCH & DefaultImmersiveNtfTypeSwitch.NTF_TYPE_LIVE);
  }

  /**
   * 是否开启新形态小折叠外屏场景
   */
  public static isEnableSmallFoldOuterScreen(): boolean {
    return !!(ImmersiveConstants.NTF_DEFAULT_IMMERSIVE_SCREEN_SWITCH & DefaultImmersiveScreenSwitch.SMALL_OUTER_SCREEN);
  }

  /**
   * 是否开启默认屏幕场景
   */
  public static isEnableDefaultScreen(): boolean {
    return !!(ImmersiveConstants.NTF_DEFAULT_IMMERSIVE_SCREEN_SWITCH & DefaultImmersiveScreenSwitch.DEFAULT_SCREEN);
  }

  /**
   * 是否开启对应App沉浸式
   */
  public static isEnableAppImmersive(bundleName: string): boolean {
    if (ImmersiveConstants.NTF_DEFAULT_IMMERSIVE_APP_SWITCH.length === 0) {
      return true;
    }
    return ImmersiveConstants.NTF_DEFAULT_IMMERSIVE_APP_SWITCH.includes(bundleName);
  }
}