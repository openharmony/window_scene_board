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

import { GlassStatusBarStyle } from './GlassStatusBarStyle';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassNtfListVm } from '../../notificationcenter/vm/GlassNtfListVm';

const TAG: string = 'MessageCenterIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

/**
 * 消息中心
 */
@Component
export default struct MessageCenterIcon {
  @Consume contentColor: string;
  @State isShowRedHot: boolean = false;

  aboutToAppear(): void {
    log.showInfo('Notification messageLists subscribe success.');
    GlassNtfListVm.getInstance().registerRedHotCallback(this.updateRedHotStatus);
  }

  aboutToDisappear(): void {
  }

  updateRedHotStatus = (isShowRedHot: boolean): void => {
    this.isShowRedHot = isShowRedHot;
  }

  build() {
    Row() {
      Image($r('app.media.glass_ic_public_message_none'))
        .fillColor(this.contentColor)
      if (this.isShowRedHot) {
        Row()
          .size({
            width: GlassStatusBarStyle.RED_HOT_SIZE,
            height: GlassStatusBarStyle.RED_HOT_SIZE
          })
          .backgroundColor($r('sys.color.warning'))
          .position({
            left: GlassStatusBarStyle.RED_HOT_POSITION_X,
            top: GlassStatusBarStyle.RED_HOT_POSITION_Y
          })
          .borderRadius(GlassStatusBarStyle.RED_HOT_SIZE)
      }
    }
    .height(GlassStatusBarStyle.ICON_SIZE)
    .width(GlassStatusBarStyle.ICON_SIZE)
  }
}