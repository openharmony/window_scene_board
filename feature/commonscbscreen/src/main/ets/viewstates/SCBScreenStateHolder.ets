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
import { SCBSceneSessionManager } from '@ohos/windowscene';

const TAG: string = 'SCBScreenStateSession';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * SCBScreen View States Holder.
 * @description just contains UI States getter & setter
 */
@Observed
export class SCBScreenStateHolder {
  public freeWindowModeEnabled_: boolean = false;

  constructor() {
    this.initFreeWindowConfig();
  }

  private initFreeWindowConfig(): void {
    this.freeWindowModeEnabled_ = SCBSceneSessionManager.getInstance().isPcOrPcMode();
    log.showInfo(`init with free window mode ${this.freeWindowModeEnabled_ ? 'enabled' : 'disabled'}`);
  }

  public get freeWindowModeEnabled(): boolean {
    return this.freeWindowModeEnabled_;
  }

  public set freeWindowModeEnabled(enabled: boolean) {
    this.freeWindowModeEnabled_ = enabled;
  }
}
