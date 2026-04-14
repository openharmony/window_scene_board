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
import { DragGridPosition } from '@ohos/componentdrag';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { ItemParameter } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';

const TAG = 'DesktopLayoutManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export abstract class DesktopLayoutManager {

  protected static desktopLayoutManager: DesktopLayoutManager | undefined;

  public static setDesktopLayoutManager(desktopLayoutManager: DesktopLayoutManager): void {
    DesktopLayoutManager.desktopLayoutManager = desktopLayoutManager;
  }

  public static getDesktopLayoutManager(): DesktopLayoutManager | undefined {
    return DesktopLayoutManager.desktopLayoutManager;
  }

  abstract isAvailablePosition(column: number, row: number, page: number): boolean;

  abstract getItemPositionInScreen(area: GridLayoutItemInfo | ItemParameter,
    startPage: number): DragGridPosition | null;
}