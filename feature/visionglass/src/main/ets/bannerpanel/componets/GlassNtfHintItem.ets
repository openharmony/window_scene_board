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

import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { GlassLayoutColor, NtfSize } from '../../common/constants/GlassLayoutConstants';
import { GlassBannerLayoutStyle } from '../view/GlassBannerStyle';
import GlassNtfConstant from '../common/GlassNtfConstant';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassTimeVM } from '../../common/utils/GlassTimeVM';

const TAG = 'GlassNtfHintItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct GlassNtfHintItem {
  @Consume ntf: NotificationEntry | null;
  @State timeVM: GlassTimeVM = new GlassTimeVM();

  aboutToAppear(): void {
    log.showInfo('about to appear');
    this.initTimeText();
  }

  private initTimeText(): void {
    if (this.ntf) {
      this.timeVM.init(this.ntf?.deliveryTime, this.ntf?.hashCode)
    }
  }

  aboutToDisappear(): void {
    log.showInfo('about to disappear');
    this.timeVM.deinit();
  }

  @Builder
  buildNtfAppIcon() {
    Image(this.ntf?.getAppIcon(true))
      .width(NtfSize.HINT_CALL_APP_SIZE)
      .height(NtfSize.HINT_CALL_APP_SIZE)
      .id(this.ntf?.hashCode + GlassNtfConstant.IMAGE_ICON_ID)
      .margin(GlassBannerLayoutStyle.NORMAL_APPICON_MARGIN)
      .onComplete((event) => {
        if (event) {
          log.showInfo(`Load content image success, ${event.loadingStatus}.`);
        }
      })
      .onError(() => {
        log.error(`Load content image error.`);
      })
  }

  @Builder
  buildNtfContent() {
    Row() {
      Text($r('app.string.banner_hint_message'))
        .fontColor(GlassLayoutColor.TEXT_TITLE_COLOR)
        .fontSize(GlassBannerLayoutStyle.FONT_SIZE_28)
        .lineHeight(GlassBannerLayoutStyle.FONT_SIZE_33)
        .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_700)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .ellipsisMode(EllipsisMode.END)
        .flexGrow(1)
        .flexShrink(1)
        .flexBasis(1)
        .layoutWeight(1)
      if (this.ntf?.deliveryTime) {
        Text(this.timeVM.timeText)
          .height(GlassBannerLayoutStyle.FONT_SIZE_32)
          .fontColor(GlassLayoutColor.TEXT_TIME_COLOR)
          .fontSize(GlassBannerLayoutStyle.FONT_SIZE_24)
          .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_400)
          .fontFamily(GlassBannerLayoutStyle.FONT_FAMILY_ohos_BOLD)
          .textAlign(TextAlign.End)
      }
    }
    .width(GlassBannerLayoutStyle.BANNER_FOLDS_CONTENT_WIDTH)
  }

  build() {
    if (this.ntf) {
      Column() {
        Row() {
          this.buildNtfAppIcon()
          this.buildNtfContent()
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }
      .width(GlassNtfConstant.HINT_WIDTH)
      .height(GlassNtfConstant.NORMAL_HEIGHT)
      .backgroundColor(GlassLayoutColor.BACKGROUND_REGULAR_COLOR)
      .backdropBlur(GlassBannerLayoutStyle.BANNER_BLUR)
      .borderRadius(GlassBannerLayoutStyle.BORDER_RADIUS)
      .justifyContent(FlexAlign.Center)
      .padding(GlassBannerLayoutStyle.BANNER_PADDING)
    }
  }
}