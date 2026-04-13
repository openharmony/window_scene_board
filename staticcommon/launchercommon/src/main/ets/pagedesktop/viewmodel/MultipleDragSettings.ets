/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { DragItemPosition} from '@ohos/componentdrag';

const TAG = 'MultipleDragSettings';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export interface MultipleDragPosition {
  ino: string;
  position: DragItemPosition;
}

export default class MultipleDragSettings {
  private static instance: MultipleDragSettings;
  private multipleDragItems: MultipleDragPosition[] = [];
  private constructor() {}

  static getInstance(): MultipleDragSettings {
    if (!MultipleDragSettings.instance) {
      MultipleDragSettings.instance = new MultipleDragSettings();
    }
    return MultipleDragSettings.instance;
  }

  public addDragItem(item: MultipleDragPosition): void {
    log.showInfo(`addDragItem ino: ${item.ino}, column: ${item.position.column}, row: ${item.position.row}.`);
    const index: number = this.multipleDragItems.findIndex((dragItem: MultipleDragPosition) => {
      return dragItem.ino === item.ino;
    });
    if (index === -1) {
      this.multipleDragItems.push(item);
    } else {
      this.multipleDragItems[index] = item;
    }
  }

  public addDragItems(items: MultipleDragPosition[]): void {
    items.forEach((item: MultipleDragPosition) => {
      this.addDragItem(item);
    });
  }

  public getDragItems(): MultipleDragPosition[] {
    return this.multipleDragItems;
  }

  public getDragItemByUri(ino: string): MultipleDragPosition | undefined {
    const item: MultipleDragPosition | undefined = this.multipleDragItems.find((item => item.ino === ino));
    if (item) {
      return item;
    } else {
      if (this.multipleDragItems && AppStorage.get<boolean>('copyToDesktop')) {
        AppStorage.setOrCreate<boolean>('copyToDesktop', false);
        return this.multipleDragItems.pop();
      }
      log.showInfo(`getDragItemByUri: can not find ino: ${ino}.`);
      return {
        ino: ino,
        position: {
          page: 0,
          row: 0,
          column: 0,
          x: 0,
          y: 0,
        }
      };
    }
  }

  public deleteDragItem(ino: string): void {
    const index: number = this.multipleDragItems.findIndex((dragItem: MultipleDragPosition) => {
      return dragItem.ino === ino;
    });
    if (index === -1) {
      log.showInfo(`deleteDragItem failed: can not find ino: ${ino}.`);
      return;
    }
    this.multipleDragItems.splice(index, 1);
    log.showInfo('deleteDragItem success.');
  }
}