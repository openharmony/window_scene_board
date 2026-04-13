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
import { PluginDisplayStyle } from '../common/PluginConstants';
import { PluginStyleUtil } from '../common/PluginStyleUtil';
import { StyleManagerBase } from './StyleManagerBase';
import { WindowsStyleManager } from './windowsstyle/WindowsStyleManager';

export class StyleFactory {
  private static mInstance: StyleFactory;

  private pluginPositionMap: Map<PluginDisplayStyle, StyleManagerBase> = new Map([
    [PluginDisplayStyle.WINDOWS_STYLE, new WindowsStyleManager()],
  ]);

  public static getInstance(): StyleFactory {
    if (!StyleFactory.mInstance) {
      StyleFactory.mInstance = new StyleFactory();
    }
    return StyleFactory.mInstance;
  }

  public getStyleManager(style?: PluginDisplayStyle): StyleManagerBase | undefined {
    let specificStyle = style ?? PluginStyleUtil.getCurStatusBarType();
    return this.pluginPositionMap.get(specificStyle);
  }
}