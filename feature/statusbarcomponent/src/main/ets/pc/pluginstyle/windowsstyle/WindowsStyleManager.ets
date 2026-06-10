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
import { StyleManagerBase } from '../StyleManagerBase';
import { WinPluginGroupCalculate } from '../../plugingroup/windows/WinPluginGroupCalculate';
import { WindowsSortCalculate } from '../../pluginsort/windows/WindowsSortCalculate';
import { WinWindowPosCalculate } from '../../pluginwindow/control/WinWindowPosCalculate';

export class WindowsStyleManager extends StyleManagerBase {
  constructor() {
    super();
    this.pluginSlotMapping = new WinPluginGroupCalculate();
    this.windowPosControl = new WinWindowPosCalculate();
    this.sortControl = new WindowsSortCalculate();
  }
}