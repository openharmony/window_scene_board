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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import AVSessionManager from '@ohos.multimedia.avsession';
import { DfxParam } from '../Util/CommonInterface';
import { HiSysEvent, EventType, BizScene, BizState, StageResult, TriggerMode, SourceController,
  StartCAST } from '../Util/HiSysEvent';
import { globalStorage } from '../Util/GlobalStorage';
import Constants, { AVQueueInfo, NewTime, ShowingBundleTS } from '../Util/Constants';
import BusinessError from '@ohos.base';
import CommonUtils from '../Util/CommonUtils';

const TAG: string = 'ExpandHistoryCardController_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);


export default class ExpandHistoryCardController {
  private static controller: ExpandHistoryCardController | undefined = undefined;
  // 打点
  private pInfoName = globalStorage.getStringByKey('packageName');
  private pInfoVersion = globalStorage.getStringByKey('packageVersion');
  private clickAVQueueTime: number = 0;

  reportStartMediaPlayBack(info : AVQueueInfo, timeCost : number) : void {
    let startTime = new Date().getTime();
    let dfxParam : DfxParam = {
      PNAMEID: this.pInfoName,
      PVERSIONID: this.pInfoVersion,
      PACKAGE_NAME: info.bundleName,
      AVQUEUE_NAME: info.avQueueName,
      AVQUEUE_ID: info.avQueueId,
      TIME_COST: timeCost,
      TIME: startTime,
      SCREENSTATUS: this.getScreenStatus(),
      DEVICEMODELTYPE: 'phone',
      SCREENFOLDEDSTATUS: CommonUtils.isFoldExpanded() ? (CommonUtils.isThreeFoldProductInGState() ? 11 : 1) : 2
    };
    log.showInfo(' report HISTORY_AVQUEUE_PLAY:' + JSON.stringify(dfxParam));
    HiSysEvent.getEventParam(EventType.HISTORY_AVQUEUE_PLAY)
      .updateAllExtendParam(dfxParam)
      .reportEvent(true);
  }

  /**
   * 歌单变化
   */
  async clickAlbInfo(albumInfoList: Array<AVQueueInfo>, albInfo: AVQueueInfo) {
    AppStorage.setOrCreate('isStartAVPlaybackSuccess', true);
    log.showInfo('hisAVQueue click avqueue item bundleName ' + albInfo.bundleName +
      'avQueueName ' + albInfo.avQueueName + 'avQueueId ' + albInfo.avQueueId +
      'lastPlayedTime ' + albInfo.lastPlayedTime);
    this.clickAVQueueTime = new Date().getTime();
    await AVSessionManager.startAVPlayback(albInfo?.bundleName, albInfo?.avQueueId).then(() => {
      log.showInfo(`hisAVQueue success to startavplayback`);
      this.reportStartMediaPlayBack(albInfo, new Date().getTime() - this.clickAVQueueTime);
      this.clickAVQueueTime = 0;
    }).catch((err: BusinessError.BusinessError) => {
      this.reportStartMediaPlayBack(albInfo, -1);
      log.showInfo(`hisAVQueue fail to startavplayback--result: ${JSON.stringify(err)}`);
      AppStorage.setOrCreate('isStartAVPlaybackSuccess', false);
    })
  }

  public static getInstance(): ExpandHistoryCardController {
    if (!ExpandHistoryCardController.controller) {
      ExpandHistoryCardController.controller = new ExpandHistoryCardController();
    }
    return ExpandHistoryCardController.controller;
  }

  getScreenStatus(): number {
    if (DeviceHelper.getOrientation() === 1 || DeviceHelper.getOrientation() === 3 ) {
      return 1;
    } else {
      return 0;
    }
  }
}