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

import { LogHelper, LogDomain } from '@ohos/basicutils';

const TAG = 'MattesRotateStrategy';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const DEFAULT_PERSISTENT_ID = 0;
const DEFAULT_REQUESTED_ORIENTATION = 0;

/**
 * Defines class to tackle issues about mattes with rotation.
 *
 * @since 2024-11-06
 */
export class MattesRotateStrategy {
  private saveMattesPersistentId: number = DEFAULT_PERSISTENT_ID;
  private saveRequestedOrientation: number = DEFAULT_REQUESTED_ORIENTATION;
  private static instance: MattesRotateStrategy;

  private constructor() { }

  /**
   * get the singleton of class MattesRotateStrategy
   *
   * @returns MattesRotateStrategy singleton
   */
  public static getInstance(): MattesRotateStrategy {
    if (!MattesRotateStrategy.instance) {
      MattesRotateStrategy.instance = new MattesRotateStrategy();
    }
    return MattesRotateStrategy.instance;
  }

  /**
   * save the orientation parameters temporarily
   *
   * @param persistentId
   * @param requestedOrientation
   */
  public writeContainerOrientation(persistentId: number, requestedOrientation: number): void {
    this.saveMattesPersistentId = persistentId;
    this.saveRequestedOrientation = requestedOrientation;
    log.showInfo(`MattesLock: writeOrientation (${persistentId}, ${requestedOrientation})`);
  }

  /**
   * judge if persistentId and requestedOrientation has been saved
   *
   * @returns true: need to release and implement the orientation
   */
  public isNeedContainerOrientation(persistentId: number, requestedOrientation: number): boolean {
    log.showInfo(`MattesLock: isNeedOrientation (${persistentId}, ${requestedOrientation}), while ` +
      `(${this.saveMattesPersistentId}, ${this.saveRequestedOrientation}) have saved`);
    return (persistentId !== DEFAULT_PERSISTENT_ID && requestedOrientation !== DEFAULT_REQUESTED_ORIENTATION);
  }

  /**
   * get persistentId for containerRequestedOrientationChange
   *
   * @param curPersistentId current persistentId
   * @returns Orientation [saveMattesPersistentId, saveRequestedOrientation]
   */
  public getContainerRequestedOrientation(curPersistentId: number): [number, number] {
    if (curPersistentId === this.saveMattesPersistentId) {
      let outPersistentId: number = this.saveMattesPersistentId;
      let outRequestedOrientation: number = this.saveRequestedOrientation;
      log.showInfo(`MattesLock: getOrientation (${this.saveMattesPersistentId}, ${this.saveRequestedOrientation})` +
        `, while current persistentId = ${curPersistentId}`);
      this.saveMattesPersistentId = DEFAULT_PERSISTENT_ID;
      this.saveRequestedOrientation = DEFAULT_REQUESTED_ORIENTATION;
      return [outPersistentId, outRequestedOrientation];
    }
    log.showInfo(`MattesLock: getOrientation (0, 0), while (${this.saveMattesPersistentId}, ` +
      `${this.saveRequestedOrientation}) have saved`);
    return [DEFAULT_PERSISTENT_ID, DEFAULT_REQUESTED_ORIENTATION];
  }
}