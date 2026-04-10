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
import { ResUtils } from '@ohos/windowscene';
import { NotificationConstants } from '@ohos/notificationcomponent/src/main/ets/common/NotificationConstants';

const TAG = NotificationConstants.NTF_LOG_PREFIX + 'NotificationEmptyTipPc';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

const COMPONENT_ID_EMPTY_TIP = TAG + '_Text_emptyTip';
const COMPONENT_ID_EMPTY_TIP_ICON = TAG + '_Image_emptyTip';
const TOP_PADDING_RADIO = 0.281;
const BOTTOM_PADDING_RADIO = 0.467;

/**
 * PC 面板无通知提示
 */
@Component
export struct NotificationEmptyTipPc {
  aboutToAppear() {
    log.info('About to appear')
  }
  build() {
    Column() {
      Image($r('app.media.ic_ntf_empty_tip'))
        .id(COMPONENT_ID_EMPTY_TIP_ICON)
        .objectFit(ImageFit.Contain)
        .width($r('app.float.ntf_empty_icon_size'))
        .height($r('app.float.ntf_empty_icon_size'))
        .draggable(false)
      Text($r('app.string.ntf_empty_text_tip'))
        .id(COMPONENT_ID_EMPTY_TIP)
        .fontColor($r('sys.color.font_secondary'))
        .fontSize($r('app.float.ntf_empty_font_size'))
        .fontWeight(FontWeight.Regular)
        .draggable(false)
        .margin({
          top: $r('app.float.ntf_header_common_margin')
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .offset({
      y: this.getTitleHeight()
    })
  }

  // 获取通知中心标题栏高度的一半，用于无通知插画居中偏移
  getTitleHeight(): string {
    return (-ResUtils.getNumberFromLengthExceptPx($r('app.float.ntf_center_header_pc_height')) /
      2).toString() + 'vp';
  }
}
