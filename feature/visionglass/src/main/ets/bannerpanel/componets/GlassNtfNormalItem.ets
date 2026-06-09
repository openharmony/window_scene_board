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
import { GlassNtfActionView } from './GlassNtfActionView';
import { GlassLayoutColor, NtfSize } from '../../common/constants/GlassLayoutConstants';
import { GlassBannerLayoutStyle } from '../view/GlassBannerStyle';
import GlassNtfConstant from '../common/GlassNtfConstant';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassTimeVM } from '../../common/utils/GlassTimeVM';

const TAG = 'GlassNtfNormalItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct GlassNtfNormalItem {
  @Consume ntf: NotificationEntry | null;
  @Consume @Watch('updateHeight') ntfExpand: boolean;
  @State ntfTitle: string = '';
  @State ntfContent: string = '';
  @State bannerHeight: number = GlassNtfConstant.NORMAL_HEIGHT;
  @State timeVM: GlassTimeVM = new GlassTimeVM();

  aboutToAppear(): void {
    log.showInfo('about to appear');
    if (!this.ntf) {
      return;
    }
    this.ntfTitle = this.getNtfTitle();
    this.ntfContent = this.getNtfContent();
    this.initTimeText();
  }

  aboutToDisappear(): void {
    log.showInfo('about to disappear');
    this.timeVM.deinit();
  }

  private initTimeText(): void {
    if (this.ntf) {
      this.timeVM.init(this.ntf?.deliveryTime, this.ntf?.hashCode)
    }
  }

  private getNtfTitle(): string {
    let title = '';
    if (!this.ntf) {
      return title;
    }
    if (this.ntf.isExpandable) {
      title = this.ntf.notificationContent.expandedTitle;
    } else {
      title = this.ntf.notificationContent.contentTitle;
    }
    return CommonUtils.isEmpty(title) ? ' ' : title;
  }

  private getNtfContent(): string {
    let content = '';
    if (!this.ntf) {
      return content;
    }
    if (this.ntf.isExpandable) {
      content = this.ntf.notificationContent.expandedContentText;
    } else {
      content = this.ntf.notificationContent.contentText;
    }
    return CommonUtils.isEmpty(content) ? ' ' : content;
  }

  private updateHeight() {
    if (this.ntfExpand) {
      this.bannerHeight = GlassNtfConstant.EXPAND_HEIGHT;
    } else {
      this.bannerHeight = GlassNtfConstant.NORMAL_HEIGHT;
    }
  }

  @Builder
  buildNtfAppIcon() {
    Image(this.ntf?.getAppIcon(true))
      .width(NtfSize.HINT_CALL_APP_SIZE)
      .height(NtfSize.HINT_CALL_APP_SIZE)
      .id(this.ntf?.hashCode + GlassNtfConstant.IMAGE_ICON_ID)
      .margin(GlassBannerLayoutStyle.NORMAL_APPICON_MARGIN)
  }

  @Builder
  buildNtfExpandAppIcon() {
    Image(this.ntf?.getAppIcon(true))
      .width(GlassBannerLayoutStyle.ICON_SIZE_58)
      .height(GlassBannerLayoutStyle.ICON_SIZE_58)
      .id(this.ntf?.hashCode + GlassNtfConstant.IMAGE_ICON_ID)
      .margin(GlassBannerLayoutStyle.NORMAL_APPICON_MARGIN)
  }

  @Builder
  buildNtfHeadPortrait() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Image(this.ntf?.overlayIcon)
        .width(GlassBannerLayoutStyle.ICON_SIZE_58)
        .height(GlassBannerLayoutStyle.ICON_SIZE_58)
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .borderRadius(GlassBannerLayoutStyle.CARD_LARGE_ICON_RADIUS)
        .clip(true)
        .interpolation(ImageInterpolation.Medium)
        .border({
          width: GlassBannerLayoutStyle.BORDER_WIDTH,
          color: GlassLayoutColor.BORDER_COLOR,
          radius: GlassBannerLayoutStyle.CARD_LARGE_ICON_RADIUS
        })
      Image(this.ntf?.getAppIcon(true))
        .width(GlassBannerLayoutStyle.NTF_HEAD_ICON_SIZE)
        .height(GlassBannerLayoutStyle.NTF_HEAD_ICON_SIZE)
        .margin(GlassBannerLayoutStyle.NORMAL_OVERLAY_ICON_MARGIN)
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
    }
    .margin(GlassBannerLayoutStyle.NORMAL_HEAD_PORTRAIT_MARGIN)
  }

  @Builder
  buildNtfContent() {
    Row() {
      Text(this.ntfTitle)
        .fontColor(GlassLayoutColor.TEXT_TITLE_COLOR)
        .fontSize(GlassBannerLayoutStyle.FONT_SIZE_28)
        .lineHeight(GlassBannerLayoutStyle.FONT_SIZE_33)
        .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_700)
        .fontFamily(GlassBannerLayoutStyle.FONT_FAMILY_SANS_SC)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .ellipsisMode(EllipsisMode.END)
      Text(this.ntfContent)
        .fontColor(GlassLayoutColor.TEXT_CONTENT_COLOR)
        .fontSize(GlassBannerLayoutStyle.FONT_SIZE_28)
        .lineHeight(GlassBannerLayoutStyle.FONT_SIZE_33)
        .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_700)
        .fontFamily(GlassBannerLayoutStyle.FONT_FAMILY_SANS_SC)
        .margin(GlassBannerLayoutStyle.NORMAL_CONTENT_MARGIN)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .ellipsisMode(EllipsisMode.END)
        .flexGrow(1)
        .flexShrink(1)
        .flexBasis(1)
    }
    .flexGrow(1)
    .flexShrink(1)
    .flexBasis(1)
  }

  @Builder
  buildNtfExpandContent() {
    Row() {
      Text(this.ntfTitle)
        .fontColor(GlassLayoutColor.TEXT_TITLE_COLOR)
        .fontSize(GlassBannerLayoutStyle.FONT_SIZE_28)
        .lineHeight(GlassBannerLayoutStyle.FONT_SIZE_33)
        .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_700)
        .fontFamily(GlassBannerLayoutStyle.FONT_FAMILY_SANS_SC)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .ellipsisMode(EllipsisMode.END)
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
    .width(GlassBannerLayoutStyle.BANNER_EXPAND_CONTENT_WIDTH)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin(GlassBannerLayoutStyle.NORMAL_EXPAND_TITLE_MARGIN)

    Text(this.ntfContent)
      .fontColor(GlassLayoutColor.TEXT_CONTENT_COLOR)
      .fontSize(GlassBannerLayoutStyle.FONT_SIZE_28)
      .lineHeight(GlassBannerLayoutStyle.FONT_SIZE_33)
      .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_700)
      .fontFamily(GlassBannerLayoutStyle.FONT_FAMILY_SANS_SC)
      .margin(GlassBannerLayoutStyle.NORMAL_EXPAND_CONTENT_MARGIN)
      .maxLines(3)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .ellipsisMode(EllipsisMode.END)
      .width(GlassBannerLayoutStyle.BANNER_EXPAND_CONTENT_WIDTH)
  }

  @Builder
  buildNtfExpand() {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      Image($r('app.media.glass_banner_arrow_down'))
        .width(GlassBannerLayoutStyle.NTF_EXPAND_ICON_WIDTH)
        .height(GlassBannerLayoutStyle.NTF_EXPAND_ICON_HEIGHT)
        .fillColor(GlassLayoutColor.NTF_EXPAND_ICON_COLOR)
    }
    .width(GlassBannerLayoutStyle.NTF_EXPAND_ICON_BG_SIZE)
    .height(GlassBannerLayoutStyle.NTF_EXPAND_ICON_BG_SIZE)
    .backgroundColor(GlassLayoutColor.NTF_EXPAND_ICON_BG_COLOR)
    .onClick(() => {
      this.ntfExpand = true;
    })
  }

  @Builder
  buildNtfFolds() {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      Image($r('app.media.glass_banner_arrow_up'))
        .width(GlassBannerLayoutStyle.NTF_EXPAND_ICON_WIDTH)
        .height(GlassBannerLayoutStyle.NTF_EXPAND_ICON_HEIGHT)
        .fillColor(GlassLayoutColor.NTF_EXPAND_ICON_COLOR)
    }
    .width(GlassBannerLayoutStyle.NTF_EXPAND_ICON_BG_SIZE)
    .height(GlassBannerLayoutStyle.NTF_EXPAND_ICON_BG_SIZE)
    .backgroundColor(GlassLayoutColor.NTF_EXPAND_ICON_BG_COLOR)
    .onClick(() => {
      this.ntfExpand = false;
    })
  }

  @Builder
  buildNtfNormalContent() {
    Row() {
      this.buildNtfContent()
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

  @Builder
  buildNtfFoldsContent() {
    Row() {
      this.buildNtfContent()
      this.buildNtfExpand()
    }
    .width(GlassBannerLayoutStyle.BANNER_FOLDS_CONTENT_WIDTH)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    if (this.ntf && !this.ntf.isLiveType()) {
      Row() {
        if (this.ntf.overlayIcon && this.ntfExpand) {
          this.buildNtfHeadPortrait()
        } else if (this.ntfExpand) {
          this.buildNtfExpandAppIcon()
        } else {
          this.buildNtfAppIcon()
        }
        if (!ArrayUtils.isEmpty(this.ntf.actionButtons)) {
          if (this.ntfExpand) {
            Column() {
              this.buildNtfExpandContent()
              Row() {
                GlassNtfActionView()
                this.buildNtfFolds()
              }
              .width(GlassBannerLayoutStyle.BANNER_EXPAND_CONTENT_WIDTH)
              .margin(GlassBannerLayoutStyle.NORMAL_EXPAND_COLUMN_MARGIN)
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width(GlassBannerLayoutStyle.BANNER_EXPAND_CONTENT_WIDTH)
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.SpaceBetween)
          } else {
            this.buildNtfFoldsContent()
          }
        } else {
          this.buildNtfNormalContent()
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding(GlassBannerLayoutStyle.BANNER_PADDING)
      .backgroundColor(GlassLayoutColor.BACKGROUND_REGULAR_COLOR)
      .backdropBlur(GlassBannerLayoutStyle.BANNER_BLUR)
      .borderRadius(GlassBannerLayoutStyle.BORDER_RADIUS)
    }
  }
}