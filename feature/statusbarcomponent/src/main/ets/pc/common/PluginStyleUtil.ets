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
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { PluginDisplayStyle } from './PluginConstants';

export class PluginStyleUtil {
  private static statusBarType: PluginDisplayStyle = PluginDisplayStyle.WINDOWS_STYLE;

  public static setCurStatusBarType(style: PluginDisplayStyle): void {
    PluginStyleUtil.statusBarType = style;
  }

  public static getStatusBarTypeValue(style: PluginDisplayStyle): number {
    return StatusBarType.TYPE_MAIN_WINDOW_STATUS_BAR;
  }

  public static getCurStatusBarType(): PluginDisplayStyle {
    return PluginStyleUtil.statusBarType;
  }

  public static getCurStatusBarTypeValue(): number {
    return PluginStyleUtil.getStatusBarTypeValue(PluginStyleUtil.statusBarType);
  }

  public static isWindowStyle(): boolean {
    return PluginStyleUtil.statusBarType === PluginDisplayStyle.WINDOWS_STYLE;
  }

  public static isMacStyle(): boolean {
    return PluginStyleUtil.statusBarType === PluginDisplayStyle.MAC_STYLE;
  }
}