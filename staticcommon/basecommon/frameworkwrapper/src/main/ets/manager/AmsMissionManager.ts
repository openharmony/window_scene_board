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

import image from '@ohos.multimedia.image';
import missionManager from '@ohos.app.ability.missionManager';
import { MissionInfo as OriginMissionInfo } from 'application/MissionInfo';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { BusinessError } from '@ohos.base';

const TAG = 'AmsMissionManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * missionManager for Launcher
 */
class AmsMissionManager {
  private static readonly RECENT_MISSIONS_LIMIT_NUM = 20;
  private mMissionId?: number;
  private mLockState?: boolean;

  static getInstance(): AmsMissionManager {
    if (globalThis.AmsMissionManagerInstance == null) {
      globalThis.AmsMissionManagerInstance = new AmsMissionManager();
      // remove this if toolchain fix requireNApi bug
      image.toString();
    }
    return globalThis.AmsMissionManagerInstance;
  }


  /**
  * Get origin recent missions
  *
  * @return {Array} missions
  */
  async getOriginRecentMissionsList(): Promise<Array<OriginMissionInfo>> {
    let missionInfos = new Array<OriginMissionInfo>();
    try {
      missionManager.getMissionInfos('', AmsMissionManager.RECENT_MISSIONS_LIMIT_NUM)
        .then((res) => {
          if (!CheckEmptyUtils.isEmptyArr(res)) {
            log.showDebug(`getOriginRecentMissionsList res.length: ${res.length}`);
            missionInfos = res;
          }
        })
        .catch((err: BusinessError) => {
          log.error('getOriginRecentMissionsList error:', err);
        });
    } catch (error) {
      log.error('getOriginRecentMissionsList getMissionInfos error:', error);
    }

    return missionInfos;
  }

  /**
   * Clear the given mission in the ability manager service.
   *
   * @param missionId
   */
  async clearMission(missionId: number): Promise<void> {
    log.showInfo(`clearMission Id:${missionId}`);
    try {
      missionManager.clearMission(missionId)
        .then((data) => {
          log.showDebug(`clearMission done, missionId:${missionId}`);
        })
        .catch((err: BusinessError) => {
          log.error('clearMission err:', err);
        });
    } catch (error) {
      log.error('missionManager.clearMission try error:', error);
    }

  }

  /**
   * Clear all missions in the ability manager service.
   * locked mission will not clear
   *
   * @return nothing.
   */
  async clearAllMissions(): Promise<void> {
    try {
      missionManager.clearAllMissions()
        .then((data) => {
          log.showDebug('clearAllMissions done');
        })
        .catch((err: BusinessError) => {
          log.error('clearAllMissions err:', err);
        });
    } catch (error) {
      log.error('missionManager.clearAllMissions try error:', error);
    }

  }

  /**
   * Move mission to front
   *
   * @param missionId
   */
  async moveMissionToFront(missionId: number, winMode?: number): Promise<void> {
    log.showInfo(`moveMissionToFront missionId:  ${missionId}`);
    let promise = winMode ? missionManager.moveMissionToFront(missionId, { windowMode: winMode }) :
    missionManager.moveMissionToFront(missionId);
    const res = await promise.catch((err: BusinessError) => {
      log.error('moveMissionToFront err:', err);
    });
    log.showDebug('moveMissionToFront missionId end, missionId:%{public}d', missionId);
    return res;
  }
}

export const amsMissionManager = AmsMissionManager.getInstance();