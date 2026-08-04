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

import { LengthMetrics } from '@kit.ArkUI'
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { FormCenterViewManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import lazy PcFormStyleConstants from '../../common/constants/PcFormStyleConstants';

@Component
export struct FormCenterNoticeItem {
  private mFormCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();

  build() {
    Column() {
      Column() {
        Divider()
          .color($r('sys.color.ohos_id_color_list_separator'))
          .vertical(false)
          .strokeWidth(px2vp(1))
          .height(px2vp(1))
      }

      Column() {
        Row() {
          Text($r('app.string.form_center_notice_text'))
            .key('FormCenterNoticeItem_Text')
            .font({
              family: 'HarmonyHeiTi',
              size: PcFormStyleConstants.PC_GRID_ITEM_TEXT_APP_NAME_SIZE,
              weight: FontWeight.Medium,
            })
            .fontColor($r('sys.color.font_secondary'))
            .height(DeviceHelper.isPC() ? '34%' : PcFormStyleConstants.NOTICE_ADD_TO_DESKTOP_TEXT_HEIGHT)
            .margin({
              top: LengthMetrics.vp(PcFormStyleConstants.NOTICE_ADD_TO_DESKTOP_TEXT_TOP),
              bottom: LengthMetrics.vp(PcFormStyleConstants.NOTICE_ADD_TO_DESKTOP_TEXT_BOTTOM),
              start: LengthMetrics.vp(PcFormStyleConstants.NOTICE_ADD_TO_DESKTOP_TEXT_START)
            })

          Blank()

          Button($r('app.string.form_center_notice_button'))
            .key('FormCenterNoticeItem_Button')
            .type(ButtonType.Normal)
            .fontSize(PcFormStyleConstants.PC_GRID_ITEM_TEXT_DESCRIPTION_SIZE)
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.comp_background_primary_contrary'))
            .height(DeviceHelper.isPC() ? '50%' : PcFormStyleConstants.NOTICE_FINISH_BUTTON_HEIGHT)
            .width(DeviceHelper.isPC() ? '12%' : PcFormStyleConstants.NOTICE_FINISH_BUTTON_WIDTH)
            .borderRadius($r('sys.float.corner_radius_level4'))
            .margin({
              top: LengthMetrics.vp(PcFormStyleConstants.NOTICE_FINISH_BUTTON_MARGIN_TOP),
              bottom: LengthMetrics.vp(PcFormStyleConstants.NOTICE_FINISH_BUTTON_MARGIN_BOTTOM),
              end: LengthMetrics.vp(PcFormStyleConstants.NOTICE_FINISH_BUTTON_MARGIN_END),
            })
            .onClick(() => {
              this.mFormCenterViewManager.closeFormCenterView();
            })
        }
        // .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
        .height('10%')
        .saturate(PcFormStyleConstants.PC_NOTICE_SATURATE)
        .backgroundColor('#0affffff')
      }
      .width('100%')
    }
  }
}