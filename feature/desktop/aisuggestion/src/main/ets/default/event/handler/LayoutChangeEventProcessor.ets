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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import AiSuggestionActionManager from '../../manager/AiSuggestionActionManager';
import { AbstractLayoutChangeChecker } from '../../manager/layoutchangeeventprocessor/AbstractLayoutChangeChecker';
import { MainScreenLayoutChangeChecker } from '../../manager/layoutchangeeventprocessor/MainScreenLayoutChangeChecker';

const TAG = 'LayoutChangeEventProcessor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

export class LayoutChangeEventProcessor {
  private static instance: LayoutChangeEventProcessor;
  private checkerMap: Map<string, AbstractLayoutChangeChecker> = new Map();

  constructor() {
    this.init();
  }

  private init(): void {
    if (!this.checkerMap.has('inner')) {
      this.checkerMap.set('inner', new MainScreenLayoutChangeChecker());
    }
  }

  static getInstance(): LayoutChangeEventProcessor {
    if (LayoutChangeEventProcessor.instance == null) {
      LayoutChangeEventProcessor.instance = new LayoutChangeEventProcessor();
    }
    return LayoutChangeEventProcessor.instance;
  }

  public handleEvent(pageIndex: number): void {
    log.showInfo(`handleEvent pageIndex: ${pageIndex}`);
    for (const entry of this.checkerMap) {
      const checker = entry[1];
      if (checker.isLayoutChange(pageIndex)) {
        AiSuggestionActionManager.getInstance().screenChanged();
        return;
      }
    }
  }
}