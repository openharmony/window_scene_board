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
import { ExtendStyle } from '../../../common/Extendstyle';
import { LiveViewCommonConstants, SysTypeCode } from '../../../common/LiveConstants';
import { LiveProgressData } from '../../../data/extend/LiveProgressData';
import { LiveViewExtendStyle } from '../../../data/extend/LiveViewExtendStyle';
import { LiveViewData } from '../../../data/LiveViewData';
import { CardUtils } from '../LiveViewCardData';
import notificationManager from '@ohos.notificationManager';
import { LogWithHa } from '../../../../maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '../../../../maintenance/CommonExceptionCode';

const TAG = LiveViewCommonConstants.LOG_PREFIX + 'LiveProgressComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export struct LiveProgressComponent {
  @ObjectLink baseData: LiveViewData;
  @ObjectLink progressData: LiveProgressData;

  @State isPaused: boolean = false;

  private extendStyle: ExtendStyle = new LiveViewExtendStyle();

  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  build() {
    if (this.progressData) {
      Stack({ alignContent: Alignment.Center }) {
        Progress({
          value: this.getProgressExtend(),
          total: CardUtils.MAX_PROGRESS,
          type: ProgressType.Ring
        })
          .color(this.progressData.progressColor ? this.progressData.progressColor : this.extendStyle.progressColor)
          .height(this.extendStyle.progressHeight)
          .width(this.extendStyle.progressWidth)
          .style({
            strokeWidth: this.extendStyle.progressStrokeWidth
          })
          .accessibilityLevel('yes')
          .onClick(this.isAccessibilityMode && this.baseData.sysTypeCode === SysTypeCode.UPLOAD_DOWNLOAD ?
            this.handleClick : undefined)
        if (this.baseData.sysTypeCode === SysTypeCode.UPLOAD_DOWNLOAD) {
          Image(this.isPaused ? $r('app.media.ic_public_play') : $r('app.media.ic_public_pause'))
            .width(20)
            .height(20)
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .fillColor($r('sys.color.ohos_id_color_text_secondary'))
        }
      }
        .height(this.extendStyle.progressHeight)
        .width(this.extendStyle.progressWidth)
        .accessibilityLevel('no')
        .onClick(this.baseData.sysTypeCode === SysTypeCode.UPLOAD_DOWNLOAD ? this.handleClick : undefined)
    }
  }

  private getProgressExtend(): number {
    if (!this.progressData?.maxValue) {
      log.showError('progress error.');
      return 0;
    }
    return (this.progressData?.currentValue ?? 0) * CardUtils.MAX_PROGRESS / this.progressData?.maxValue;
  }

  private handleClick = async () => {
    log.showInfo(`Click progress button for ${this.baseData.hashCode}, isPaused: ${this.isPaused}`);
    const buttonOptions: notificationManager.ButtonOptions = {
      buttonName: this.isPaused ? 'start' : 'stop',
    };
    const bundle = this.baseData.agentBundle ?? {
      bundle: this.baseData.creatorBundleName,
      uid: this.baseData.creatorUid,
    };
    this.isPaused = !this.isPaused;
    try {
      await notificationManager.triggerSystemLiveView(bundle, this.baseData.id, buttonOptions);
    } catch (e) {
      LogWithHa.error(log, `Trigger system liveView fail: ${e}`,
        CommonExceptionCode.CREATE_DATA_SHARE_FAIL, e, this.baseData.creatorBundleName);
    }
  }
}