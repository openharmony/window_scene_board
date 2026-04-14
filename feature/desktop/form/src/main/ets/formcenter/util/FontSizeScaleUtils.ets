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
import { GlobalContext } from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';

const TAG: string = 'FontSizeScaleUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

class FontSizeScaleUtils {
  public getFontSizeScale(): number {
    let fontSizeScale = (GlobalContext.getInstance()
      .getObject('desktopContext') as ctx.ServiceExtensionContext).config.fontSizeScale || 1;
    log.showDebug(`getFontSizeScale fontSizeScale: ${fontSizeScale}`);
    return fontSizeScale;
  }
}

export const fontSizeScaleUtils = new FontSizeScaleUtils();