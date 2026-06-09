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
import { image } from '@kit.ImageKit';
import { LengthMetrics } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { i18n } from '@kit.LocalizationKit';

const TAG = 'AppIconWithIndexSubIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const appIndexResourceMap: Map<number, Resource> = new Map([
  [1, $r('app.media.app_icon_clone_index_1')],
  [2, $r('app.media.app_icon_clone_index_2')],
  [3, $r('app.media.app_icon_clone_index_3')],
  [4, $r('app.media.app_icon_clone_index_4')],
  [5, $r('app.media.app_icon_clone_index_5')],
]);

const DEFAULT_BADGE_ICON_SIZE: number = 54;
const BADGE_OPACITY: number = 0.3;
const BADGE_COLOR: string = '#FF000000';
const BADGE_MAX_RADIUS: number = 10;
const BADGE_MIN_RADIUS: number = 1.5;
const BADGE_MARGIN: number = 4;
const BADGE_WIDTH: number = 20;
const BADGE_HEIGHT: number = 16;
const TEXT_WIDTH: number = 9;
const TEXT_HEIGHT: number = 8;
const RTL_BORDER_RADIUS: BorderRadiuses = {
  topLeft: BADGE_MIN_RADIUS,
  topRight: BADGE_MAX_RADIUS,
  bottomRight: BADGE_MIN_RADIUS,
  bottomLeft: BADGE_MAX_RADIUS,
};
const DEFAULT_BORDER_RADIUS: BorderRadiuses = {
  topLeft: BADGE_MAX_RADIUS,
  topRight: BADGE_MIN_RADIUS,
  bottomRight: BADGE_MAX_RADIUS,
  bottomLeft: BADGE_MIN_RADIUS,
};
const RTL_MARGIN: Margin = { left: BADGE_MARGIN, bottom: BADGE_MARGIN };
const DEFAULT_MARGIN: Margin = { right: BADGE_MARGIN, bottom: BADGE_MARGIN };

/**
 * 带下标的应用图标，使用此组件时，需要确保hap包内已经包含 appIndexResourceMap中的资源文件
 */
@Component
export struct AppIconWithIndexSubIcon {
  @Prop appIcon: image.PixelMap | string | Resource | undefined | null;
  @State needShowBadgeIcon?: boolean = false;
  index: number = 0;
  private compId: string = '';
  private compAlignRules?: AlignRuleOption = undefined;
  compMargin?: Margin | Length | LocalizedMargin;
  private appIconId: string = 'DEFAULT_APP_ICON';
  appIconSize: number = 64;
  private appIconMargin?: Margin | Length | LocalizedMargin;
  subIconSize: Length = 18;
  private subIconImage?: Resource;
  private subIconMargin?: Margin | Length | LocalizedMargin;
  private subIconOffset: Position | Edges | LocalizedEdges = {
    start: LengthMetrics.vp(6),
    top: LengthMetrics.vp(2)
  };

  aboutToAppear(): void {
    this.subIconImage = appIndexResourceMap.get(this.index);
  }

  build() {
    if (this.needShowBadgeIcon) {
      this.doBuildWithBadgeIcon();
    } else {
      this.doBuild();
    }
  }

  @Builder
  doBuildWithBadgeIcon() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      // 应用图标
      Image(this.appIcon)
        .iconImageCommonProperty()
        .width(DEFAULT_BADGE_ICON_SIZE)
        .height(DEFAULT_BADGE_ICON_SIZE)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .objectFit(ImageFit.Contain)
        .syncLoad(true)

      // 角标
      Stack() {
        Stack()
          .backgroundColor(BADGE_COLOR)
          .width('100%')
          .height('100%')
          .borderRadius(this.isSystemRTL() ? RTL_BORDER_RADIUS : DEFAULT_BORDER_RADIUS)
          .enabled(false)
          .opacity(BADGE_OPACITY)
        Image('')
          .width(TEXT_WIDTH)
          .height(TEXT_HEIGHT)
      }
      .width(BADGE_WIDTH)
      .height(BADGE_HEIGHT)
      .margin(this.isSystemRTL() ? RTL_MARGIN : DEFAULT_MARGIN)
    }
    .width(DEFAULT_BADGE_ICON_SIZE)
    .height(DEFAULT_BADGE_ICON_SIZE)
    .scale({
      x: this.appIconSize / DEFAULT_BADGE_ICON_SIZE,
      y: this.appIconSize / DEFAULT_BADGE_ICON_SIZE,
      centerX: this.isSystemRTL() ? '100%' : '0%',
      centerY: '50%'
    })
    .margin(this.index === 0 ? (this.compMargin ? this.compMargin : this.appIconMargin) : undefined)
  }

  @Builder
  doBuild() {
    if (this.index === 0) {
      this.buildAppIcon()
    } else {
      this.buildAppIconWithIndexSubIcon();
    }
  }

  @Builder
  buildAppIcon() {
    Image(this.appIcon)
      .iconImageCommonProperty()
      .width(this.appIconSize)
      .height(this.appIconSize)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .objectFit(ImageFit.Contain)
      .margin(this.index === 0 ? (this.compMargin ? this.compMargin : this.appIconMargin) : undefined)
      .syncLoad(true)
  }

  @Builder
  buildAppIconWithIndexSubIcon() {
    RelativeContainer() {
      this.buildAppIcon();
      Image(this.subIconImage)
        .width(this.subIconSize)
        .height(this.subIconSize)
        .margin(this.subIconMargin)
        .syncLoad(true)
        .alignRules({
          right: { anchor: this.appIconId, align: HorizontalAlign.End },
          bottom: { anchor: this.appIconId, align: VerticalAlign.Bottom }
        })
        .offset(this.subIconOffset)
    }
    .id(this.compId)
    .alignRules(this.compAlignRules)
    .margin(this.compMargin ? this.compMargin : this.appIconMargin)
    .height(this.appIconSize)
    .width(this.appIconSize)
  }

  @Styles
  iconImageCommonProperty() {
    .id(this.appIconId)
    .draggable(false)
    .visibility(this.appIcon ? Visibility.Visible : Visibility.None)
    .alignRules(this.index === 0 ? this.compAlignRules : undefined)
  }

  private isSystemRTL(): boolean {
    const systemLanguage: string = i18n.System.getSystemLanguage();
    const isRTL: boolean = i18n.isRTL(systemLanguage);
    return isRTL;
  }
}