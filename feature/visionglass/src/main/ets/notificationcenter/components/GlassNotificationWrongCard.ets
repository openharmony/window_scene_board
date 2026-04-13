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

import NotificationConstant from '../common/NotificationConstant';
import { NotificationGlassVm, NotificationUtil } from '../vm/NotificationGlassVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlassLayoutSize, NtfColor, NtfSize } from '../../common/constants/GlassLayoutConstants';
import { GlassTimeVM } from '../../common/utils/GlassTimeVM';

const TAG = 'GlassNotificationSingleItem';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct GlassNotificationWrongCard {
  @ObjectLink notificationGlassVm: NotificationGlassVm;
  @Prop glassBorderRadius: string;
  @State notificationAppName: string = NotificationConstant.EMPTY_STRING;
  @State timeVM: GlassTimeVM = new GlassTimeVM();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.initTimeText();
  }

  private initTimeText(): void {
    if (this.notificationGlassVm) {
      this.timeVM.init(this.notificationGlassVm?.deliveryTime, this.notificationGlassVm?.hashCode);
    }
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.timeVM.deinit();
  }

  build() {
    Row({ space: NotificationConstant.SPACE_20 }) {
      Image(this.notificationGlassVm.getAppIcon(true))
        .width(GlassLayoutSize.ICON_SIZE_66)
        .height(GlassLayoutSize.ICON_SIZE_66)
        .interpolation(ImageInterpolation.High)

      Row() {
        Text($r('app.string.banner_hint_message'))
          .width(NtfSize.NTF_HIDE_CONTENT_WIDTH)
          .height(NotificationConstant.NOTIFICATIONCONTENT_SIZE_33)
          .fontColor(NtfColor.NTF_CONTENT_FONT_COLOR)
          .fontSize(GlassLayoutSize.FONT_SIZE_28)
          .lineHeight(GlassLayoutSize.FONT_SIZE_33)
          .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
          .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
          .maxLines(NotificationConstant.COLLAPSE_CONTEXT_MAX_LINE)
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
      .justifyContent(FlexAlign.SpaceBetween)
      .layoutWeight(1)
    }
    .backgroundColor(NtfColor.NTF_BACKGROUND_COLOR)
    .width(NotificationConstant.SINGLE_ITEM_WIDTH)
    .height(NotificationConstant.NTF_HEIGHT_122)
    .padding(NotificationConstant.NTF_PADDING_24)
    .borderRadius(this.glassBorderRadius)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      log.showInfo(`click to remove ntf ${this.notificationGlassVm.hashCode}`);
      NotificationUtil.clickNft(this.notificationGlassVm);
    })
  }
}