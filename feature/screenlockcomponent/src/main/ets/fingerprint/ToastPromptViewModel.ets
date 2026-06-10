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

// prompt toast duration time(ms)
const DURATION_TIME = 2500;
const TAG = 'ToastPromptViewModel'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export enum PromptShowPos {
  NONE = 0,
  HOME = 1,
  PSD = 2,
  FINGERPRINT_VIEW = 3
}
const DEFALTE_PSD_TOAST_POSITIONY: number = 176;
const POSSIBLE_POSITION_Y: number[] = [176, 136, 128, 88]

export class ToastPromptViewModel {
  public prompt: string | undefined = undefined;
  promptShowPos: PromptShowPos = PromptShowPos.NONE;
  psdToastPositionY: number = DEFALTE_PSD_TOAST_POSITIONY;
  private timerId: number = -1;

  constructor() {
  }

  public showToastPrompt(propStr: string, promptShowPos: PromptShowPos) {
    if (this.timerId !== -1) {
      log.showInfo(`timer id is ${this.timerId}, need to clear timeout.`);
      clearTimeout(this.timerId);
      this.timerId = -1;
      this.prompt = undefined;
      this.promptShowPos = PromptShowPos.NONE;
    }
    this.prompt = propStr;
    this.promptShowPos = promptShowPos;
    this.timerId = setTimeout(() => {
      log.showInfo(`duration time(${DURATION_TIME}) prompt`);
      this.prompt = undefined;
      this.promptShowPos = PromptShowPos.NONE;
    }, DURATION_TIME);
  }

  public isShowPrompt(promptShowPos: PromptShowPos): boolean {
    return this.promptShowPos === promptShowPos;
  }

  public adjustPsdToastPositionY(offset: number): void {
    let isCorrect = POSSIBLE_POSITION_Y.find((item: number) => item === this.psdToastPositionY + offset);
    if (offset === 0 || !isCorrect) {
      log.showInfo('adjustPsdToastPositionY, offset is zero, no need to set.');
      return;
    }

    this.psdToastPositionY = this.psdToastPositionY + offset;
    log.showInfo(`adjustPsdToastPositionY, psdToastPositionY is ${this.psdToastPositionY}.`);
  }

  public restorePsdToastPositionY(): void {
    log.showInfo(`restorePsdToastPositionY, psdToastPositionY is ${this.psdToastPositionY} begin.`);
    this.psdToastPositionY = DEFALTE_PSD_TOAST_POSITIONY;
    log.showInfo(`restorePsdToastPositionY, psdToastPositionY is ${this.psdToastPositionY}.`);
  }
}