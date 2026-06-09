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
import { EngineLoadStrategy } from '../strategy/EngineLoadStrategy';
import { ScbLoadStrategy } from '../strategy/ScbLoadStrategy';
import { SingularInstanceLoadStrategy } from '../strategy/SingularInstanceLoadStrategy';

const MAX_RETRY_COUNT: number = 5;

const TAG: string = 'TsResilienceHandler';

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Handler class to process all exceptional scenarios of ThemeEngine to make sure no black wallpaper would occur
 *
 * @since 2024-07-18
 */
export class TsResilienceHandler {
  private static instance: TsResilienceHandler;

  private retryCount: number = 0;

  private loadStrategy: EngineLoadStrategy = new SingularInstanceLoadStrategy();

  private constructor() {
  }

  public static getInstance(): TsResilienceHandler {
    if (!TsResilienceHandler.instance) {
      TsResilienceHandler.instance = new TsResilienceHandler();
    }

    return TsResilienceHandler.instance;
  }

  public getRetryCount(): number {
    return this.retryCount;
  }

  public updateRetryCount(): void {
    this.retryCount++;
  }

  public isRetryable(): boolean {
    return this.retryCount < MAX_RETRY_COUNT;
  }

  /**
   * Reset available retry count on TE load or new theme activation
   */
  public reset(): void {
    LOG.info(TAG, 'Reset available retry count as TE instance successfully loaded.');
    this.retryCount = 0;
    this.loadStrategy = new SingularInstanceLoadStrategy();
  }

  /**
   * Retry wallpaper load on exceptional circumstances
   */
  public retry(): void {
    this.updateRetryCount();
    LOG.info(TAG, `Retry start ThemeEngine instance, retry count: ${this.getRetryCount()}`);

    // On running out of retry opportunities, request SceneBoard to draw wallpaper
    if (!this.isRetryable()) {
      LOG.warn(TAG, 'Requesting SCB to load wallpaper as TE continuously failed to start');
      this.loadStrategy = new ScbLoadStrategy();
    }

    this.loadStrategy.execution();
  }
}