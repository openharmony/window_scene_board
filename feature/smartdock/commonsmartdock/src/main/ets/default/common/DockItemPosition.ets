/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RectInfo } from '@ohos/basicutils';

const TAG = 'DockItemPosition';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class DockItemPosition {
  private static instance: DockItemPosition;
  private iconRect: RectInfo = new RectInfo();

  public setIconRect(iconRect: RectInfo): void {
    log.showInfo(`setIconRect in, left: ${iconRect.left}, right: ${iconRect.right}`);
    this.iconRect = iconRect;
  }

  public getIconRect(): RectInfo {
    log.showInfo(`getIconRect in, left: ${this.iconRect?.left}, right: ${this.iconRect?.right}`);
    return this.iconRect;
  }

  static getInstance(): DockItemPosition {
    if (!DockItemPosition.instance) {
      DockItemPosition.instance = new DockItemPosition();
    }
    return DockItemPosition.instance;
  }

}