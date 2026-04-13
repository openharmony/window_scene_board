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
import Constants from '../common/constants';
import { shutdownDialogVm } from '../vm/ShutdownDialogVm'

const TAG = 'ShutdownCustomDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export const enum LowerStatusDialogType {
  SHUTDOWN = 1, // 即将关机弹窗
  EMERGENCY_MODE = 2 // 即将进入应急模式弹窗
}

/**
 * 低电量关机弹框提醒
 */
@CustomDialog
export struct ShutdownCustomDialog {
  /**
   * 弹框管理器
   */
  dialogController?: CustomDialogController;

  @Prop dialogType: LowerStatusDialogType = LowerStatusDialogType.SHUTDOWN;

  private getDialogContent(): ResourceStr {
    const duration = shutdownDialogVm.getShutDownTimeDuration();
    log.showInfo(`getDialogContent: ${this.dialogType} ${duration}`);
    if (this.dialogType === LowerStatusDialogType.EMERGENCY_MODE) {
      return $r('app.string.battery_emergency_dialog_content', duration);
    }
    return $r('app.string.shutdown_dialog_content_new', duration);
  }

  build() {
    Column() {
      // 标题
      Text($r('app.string.shutdown_dialog_title'))
        .textAlign(TextAlign.Center)
        .constraintSize({
          minHeight: $r('app.float.dialog_title_min_height')
        })
        .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Bold)
        .draggable(false)
        .width('100%')
        .maxFontScale(Constants.FONT_SIZE_MAX_SCALE)

      // 内容
      Text(this.getDialogContent())
        .width('100%')
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .draggable(false)
        .maxFontScale(Constants.FONT_SIZE_MAX_SCALE)
    }
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .accessibilityGroup(true)
    .accessibilityLevel('yes')
    .padding({
      left: $r('sys.float.ohos_id_text_paragraph_margin_l'),
      right: $r('sys.float.ohos_id_text_paragraph_margin_l'),
      bottom: $r('sys.float.ohos_id_text_paragraph_margin_l')
    })
    .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))
    .clip(true)
  }
}