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
import { LogDomain, Logger } from '@ohos/basicutils';
import {
  INotificationCardVm,
  ResourceVm,
  AccessibilityText,
  INotificationPrivacyVm,
  NotificationIconView,
  NotificationVmInjector,
  INotificationSwipeVm,
  INotificationVerticalSwipeVm
} from '@ohos/systemuicommon/newIndex';
import { NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import { NotificationConfig } from '../common/NotificationConfig';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = 'NotificationImmersiveView';
const log = Logger.getLogHelper(LogDomain.NC);

@ComponentV2
export struct NotificationImmersiveView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;
  @Param @Require ntf: NormalNotification;

  private colorVm = this.ntfVmInjector.getColorVm();
  private immersiveVm = this.ntfVmInjector.getImmersiveVm();
  private bannerVm = this.ntfVmInjector.getBannerVm();
  @Computed get cardVm(): INotificationCardVm {
    return this.ntfVmInjector.getCardVm(this.ntf);
  }
  @Computed get privacyVm(): INotificationPrivacyVm {
    return this.ntfVmInjector.getPrivacyVm(this.ntf);
  }
  @Computed get swipeVm(): INotificationSwipeVm | undefined {
    return this.ntfVmInjector.getSwipeVm(this.ntf);
  }
  @Computed get verticalSwipeVm(): INotificationVerticalSwipeVm | undefined {
    return this.ntfVmInjector.getVerticalSwipeVm();
  }

  aboutToAppear(): void {
    log.showInfo(TAG, `aboutToAppear for ${this.ntf.hashCode}`);
    this.immersiveVm.init(this.ntf);
  }

  @Monitor('ntf')
  onNtfChange() {
    log.showInfo(TAG, `onNtfChange for ${this.ntf.hashCode}`);
    this.immersiveVm.init(this.ntf);
  }

  build() {
    Row({ space: 12 }) {
      NotificationIconView({
        scene: this.ntfVmInjector.scene,
        ntf: this.ntf,
        isOnlyUseAppIcon: this.privacyVm.isProtected,
        scale: this.immersiveVm.iconScale,
      })
      AccessibilityText({ text: this.ntf.appLabel })
      this.buildTitle()
      this.buildContent()
      this.buildExpandIcon()
    }
    .id(this.ntfVmInjector.getId(`NotificationImmersiveView_${this.ntf.hashCode}`))
    .opacity(this.verticalSwipeVm?.bannerDeformState.bannerTextOpacity)
    .position(this.bannerVm.isImmersiveExpanded ? { x: 0, y: 0 } : undefined)
    .zIndex(1)
    .width('100%')
    .height(this.immersiveVm.cardHeight)
    .padding({
      left: $r('app.float.ntf_item_padding_start_end'),
      right: $r('app.float.ntf_item_padding_start_end'),
      top: $r('app.float.tint_ntf_item_padding_start_end'),
      bottom: $r('app.float.tint_ntf_item_padding_start_end')
    })
    .borderRadius(this.bannerVm.isImmersiveExpanded ? undefined : NotificationConfig.BORDER_RADIUS)
    .clip(true)
    .backgroundColor(this.bannerVm.isImmersiveExpanded ? undefined : this.cardVm.cardBgColor)
    .backgroundBrightnessInternal(this.bannerVm.isImmersiveExpanded ? undefined : this.cardVm.cardBgBrightness)
    .backgroundEffect(this.bannerVm.isImmersiveExpanded ? undefined : this.cardVm.cardBgEffect)
    .alignItems(VerticalAlign.Center)
    .offset({ start: LengthMetrics.vp(this.swipeVm?.offsetX) })
    .onSizeChange(this.immersiveVm.onSizeChange)
    .onClick(()=>{
      this.immersiveVm.onClick();
    })
    .shadow(this.bannerVm.isImmersiveExpanded ? undefined : this.cardVm.shadow)
  }

  @Builder
  buildTitle() {
    Text(this.immersiveVm.title)
      .id(this.immersiveVm.titleComponentId)
      .draggable(false)
      .width(this.immersiveVm.titleWidth)
      .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontWeight(FontWeight.Medium)
      .fontSize(ResourceVm.instance.getFontSize($r('app.float.ntf_title_font_size')))
      .fontFeature('\"ss08\" on')
      .fontColor(this.colorVm?.ntfThemeTextPrimaryColor)
      .wordBreak(WordBreak.BREAK_ALL)
      .lineHeight(ResourceVm.instance.getFontSize($r('app.float.ntf_text_line_height')))
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
      // 这里采用顶部对齐的方式是为了做展开动效效果更好实现
      .flexShrink(this.immersiveVm.content ? 0 : 1)
      .alignSelf(this.immersiveVm.titleAlignSelf)
      .translate(this.immersiveVm.titleTranslate)
  }

  @Builder
  buildContent() {
    if (this.immersiveVm.content) {
      Text(this.immersiveVm.content)
        .draggable(false)
        .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Regular)
        .fontSize(ResourceVm.instance.getFontSize($r('app.float.ntf_title_font_size')))
        .fontColor(this.colorVm?.ntfThemeTextPrimaryColor)
        .wordBreak(WordBreak.BREAK_ALL)
        .lineHeight(ResourceVm.instance.getFontSize($r('app.float.ntf_text_line_height')))
        .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
        .flexShrink(1)
        .opacity(this.immersiveVm.contentOpacity)
    }
  }

  @Builder
  buildExpandIcon() {
    if (this.immersiveVm.isShowExpandIcon) {
      // 这层stack用来挤压布局的剩余空间，并且让内容靠右对齐
      Stack({ alignContent: Alignment.End }) {
        Stack({ alignContent: Alignment.Center }) {
          Circle()
            .width($r('app.float.ntf_button_size_in_tint'))
            .height($r('app.float.ntf_button_size_in_tint'))
            .fill(this.colorVm?.immersiveBannerExpandIconColor)
            .foregroundBrightness(this.colorVm?.circleButtonBgBrightnessOptions)

          Image($r('app.media.ic_public_arrow_down'))
            .objectFit(ImageFit.Fill)
            .width($r('app.float.tint_ntf_arrow_width'))
            .height($r('app.float.tint_ntf_arrow_height'))
            .fillColor(this.colorVm?.ntfThemeTextPrimaryColor)
        }
      }
      .flexShrink(0)
      .flexGrow(1)
      .opacity(this.immersiveVm.contentOpacity)
    }
  }
}