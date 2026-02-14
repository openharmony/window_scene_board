/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

const TAG = 'SCBMidSceneParam';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * midScene life cycle, ignore scene
 */
export enum MidSceneLifeCycle {
  /**
   * default
   */
  UNDEFINED,
  /**
   * fullscene oneStep to waitingAdd
   */
  EXIT_FULLSCREEN_TO_WAITING,
  /**
   * enter waitingAdd or waitingReplace
   */
  WAITING,
  /**
   * waitingAdd or waitingReplace transfer to midScene
   */
  EXIT_WAITING_TO_MIDSCENE,
  /**
   * when in midScene
   */
  MIDSCENE,
  /**
   * midScene to waitingAdd or waitingReplace
   */
  EXIT_MIDSCENE_TO_WAITING,
  /**
   * exit midScene to full
   */
  EXIT_MIDSCENE_TO_FULL,
  /**
   * exit midScene to split
   */
  EXIT_MIDSCENE_TO_SPLIT,
  /**
   * replace midScene
   */
  REPLACE_MIDSCENE
}

/**
 * mid scene param
 */
@Observed
export class SCBMidSceneParam {
  /**
   * life cycle
   */
  private lifeCycle: MidSceneLifeCycle = MidSceneLifeCycle.UNDEFINED;

  /**
   * init SCBMidSceneParam
   */
  public init(): void {
    this.lifeCycle = MidSceneLifeCycle.UNDEFINED;
  }

  /**
   * set lifeCycle of midScene
   * @param lifeCycle MidSceneLifeCycle
   */
  public setLifeCycle(lifeCycle: MidSceneLifeCycle): void {
    log.showInfo(`[SCBMidScene] setLifeCycle ${lifeCycle}`);
    this.lifeCycle = lifeCycle;
  }

  /**
   * get lifeCycle of midScene
   * @returns MidSceneLifeCycle
   */
  public getLifeCycle(): MidSceneLifeCycle {
    return this.lifeCycle;
  }
}