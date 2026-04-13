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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ConfigurationEvent } from '@ohos/frameworkwrapper';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';

const TAG = 'ConfigurationChangeHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class DarkModeChangeHandler {
  private tag: string;
  private callback: (isDark: boolean) => void;

  constructor(tag: string, callback: (isDarkMode: boolean) => void) {
    this.tag = tag;
    this.callback = callback;
  }

  public handle = (event: ConfigurationEvent): void => {
    if (!event) {
      log.showWarn('HandleDarkModeChanged for %{public}s. event is null.', this.tag);
    }

    const colorMode = event.config?.colorMode;
    if (colorMode == null || colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
      log.showWarn('HandleDarkModeChanged for %{public}s. color mode invalid. %{public}d', this.tag, colorMode);
    }

    log.showInfo('HandleDarkModeChanged for %{public}s. colorMode: %{public}d', this.tag, colorMode);
    this.callback(colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
  }
}
