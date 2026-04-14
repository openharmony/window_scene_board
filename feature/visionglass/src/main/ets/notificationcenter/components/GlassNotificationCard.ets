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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassLayoutSize, NtfColor, NtfSize } from '../../common/constants/GlassLayoutConstants';
import { GlassTimeVM } from '../../common/utils/GlassTimeVM';
import NotificationConstant from '../common/NotificationConstant';
import { NotificationGlassVm, NotificationUtil } from '../vm/NotificationGlassVm';

const TAG = 'GlassNotificationCard';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct GlassNotificationCard {
  @ObjectLink notificationGlassVm: NotificationGlassVm;
  @Prop glassBorderRadius: string;
  @State timeVM: GlassTimeVM = new GlassTimeVM();

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.initTimeText();
  }

  private initTimeText(): void {
    if (this.notificationGlassVm) {
      this.timeVM.init(this.notificationGlassVm?.deliveryTime, this.notificationGlassVm?.hashCode);
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.timeVM.deinit();
  }

  build() {
    if (this.notificationGlassVm) {
      Row({ space: NotificationConstant.SPACE_20 }) {
        Image(this.notificationGlassVm.getAppIcon(true))
          .width(GlassLayoutSize.ICON_SIZE_66)
          .height(GlassLayoutSize.ICON_SIZE_66)
          .interpolation(ImageInterpolation.High)

        Column({ space: NotificationConstant.SPACE_8 }) {
          Row() {
            Text(this.notificationGlassVm.notificationContent.contentTitle)
              .width(NotificationConstant.TITLE_SIZE_200)
              .height(NotificationConstant.TITLE_SIZE_33)
              .fontColor(NtfColor.NTF_TITLE_FONT_COLOR)
              .fontSize(GlassLayoutSize.FONT_SIZE_28)
              .fontWeight(NtfSize.NTF_TITLE_FONT_WEIGHT)
              .lineHeight(GlassLayoutSize.FONT_SIZE_33)
              .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
              .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
              .maxLines(NotificationConstant.TITLE_MAX_LINE)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(this.timeVM.timeText)
              .height(NotificationConstant.TIME_SIZE_28)
              .fontColor(NtfColor.NTF_TIME_FONT_COLOR)
              .fontSize(GlassLayoutSize.FONT_SIZE_24)
              .lineHeight(GlassLayoutSize.FONT_SIZE_28)
              .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
              .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
              .textAlign(TextAlign.End)
          }
          .width(NotificationConstant.NTF_WIDTH_988)
          .height(NtfSize.NTF_SINGLE_ITEM_HEIGHT)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)

          Text(this.notificationGlassVm.notificationContent.contentText)
            .width(NotificationConstant.NTF_WIDTH_988)
            .fontColor(NtfColor.NTF_CONTENT_FONT_COLOR)
            .fontSize(GlassLayoutSize.FONT_SIZE_28)
            .lineHeight(GlassLayoutSize.FONT_SIZE_33)
            .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
            .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
            .maxLines(NotificationConstant.EXPAND_CONTENT_MAX_LINE)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .height('auto')
      }
      .backgroundColor(NtfColor.NTF_BACKGROUND_COLOR)
      .width(NotificationConstant.SINGLE_ITEM_WIDTH)
      .height('auto')
      .padding(NotificationConstant.NTF_PADDING_24)
      .borderRadius(this.glassBorderRadius)
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        log.showInfo(`click to handle ntf ${this.notificationGlassVm.hashCode}`);
        NotificationUtil.clickNft(this.notificationGlassVm);
      })
    }
  }
}
