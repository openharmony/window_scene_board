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
import { DeviceHelper } from '../../common/DeviceHelper';
import { LengthMetrics } from '@ohos.arkui.node';
import { PageStorages } from '../../common/PageStorages';

const TAG = 'ManagementComponent-HeadComponent'
const COMPONENT_ID_BACK = TAG + '_Image_back';
const NAV_ICON_ID = TAG + 'Nav_icon';

@Component
export default struct HeadComponent {
  private headName: Resource | string = '';
  private navIcon: ResourceStr = '';
  private backMargin: LocalizedMargin = {};
  private textMargin: LocalizedMargin = {};
  private totalPadding: LocalizedPadding = {};
  private isClickBack: boolean = false;
  @Prop hideBackButton: boolean = false;
  @Prop isShowCloseButton: boolean = false;
  @State pcBackButtonColor: Resource | Color = Color.Transparent;
  @State backButtonRadius: Resource = $r('app.float.enable_component_image_radius');
  onClosePanel: () => void = () => {};

  aboutToAppear(): void {
    this.backMargin = {
      start: DeviceHelper.isPC() ? LengthMetrics.resource($r('app.float.pc_back_button_margin_l')) :
        LengthMetrics.resource($r('app.float.page_margin_l')),
      top: LengthMetrics.resource($r('app.float.head_component_title_margin_top'))
    };
    this.textMargin = {
      start: (this.hideBackButton && !this.navIcon) ? LengthMetrics.resource($r('app.float.nav_text_margin_l')) :
      LengthMetrics.resource($r('app.float.nav_text_margin_l_button')),
      top: LengthMetrics.resource($r('app.float.head_component_title_margin_top'))
    };
  }

  build() {
    Row() {
      Navigation()
        .title(this.isShowCloseButton ? this.NavigationCloseTitle : this.NavigationTitle)
        .id(COMPONENT_ID_BACK)
        .mode(NavigationMode.Stack)
        .hideBackButton(true)
        .titleMode(NavigationTitleMode.Mini)
        .height($r('app.float.page_title_height'))
        .margin({ start: LengthMetrics.vp(-12) })
        .padding(this.totalPadding)
    }
  }

  @Styles
  normalStyles() {
    .backgroundColor(DeviceHelper.isPC() ? this.pcBackButtonColor : $r('sys.color.ohos_id_color_button_normal'))
    .borderRadius(DeviceHelper.isPC() ? this.backButtonRadius : $r('app.float.nav_back_image_bg_radius'))
  }

  @Styles
  pressedStyles() {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
    .borderRadius(DeviceHelper.isPC() ? $r('app.float.enable_component_image_radius') :
    $r('app.float.nav_back_image_bg_radius'))
  }

  @Builder NavigationTitle() {
    Row() {
      if (!this.hideBackButton) {
        this.buildNavBackButton($r('sys.symbol.chevron_backward'), $r('app.string.psd_back_accessible'), false)
      }
      this.NavigationName()
    }
    .height($r('app.float.page_title_height'))
    .alignItems(VerticalAlign.Center)
  }

  @Builder NavigationName() {
    if (this.navIcon) {
      this.buildNavIcon()
    }
    Text(this.headName)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .fontSize($r('app.float.page_phrases_tittle_font'))
      .fontWeight(FontWeight.Bold)
      .maxFontScale(1)
      .fontFamily('HarmonyHeiTi-Medium')
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .margin(this.textMargin)
  }

  @Builder NavigationCloseTitle() {
    Row() {
      Row() {
        this.NavigationName()
      }
      this.buildNavBackButton($r('sys.symbol.xmark'), $r('app.string.close_accessibility_text'), true)
    }
    .height($r('app.float.page_title_height'))
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
  }

  @Builder
  buildNavBackButton(icon: Resource, accessibilityText: Resource, isClose: boolean) {
    Stack({ alignContent: Alignment.Center }) {
      SymbolGlyph(icon)
        .width($r('app.float.appitem_header_icon_width'))
        .height($r('app.float.appitem_header_icon_height'))
        .id(COMPONENT_ID_BACK)
        .draggable(false)
        .fontColor([$r('sys.color.ohos_fa_icon_primary')])
        .fontSize($r('app.float.appitem_header_icon_height'))
    }
    .width($r('app.float.nav_back_image_bg_width_height'))
    .height($r('app.float.nav_back_image_bg_width_height'))
    .onClick(() => {
      if (isClose) {
        this.onClosePanel();
        return;
      }
      if (!this.isClickBack) {
        PageStorages.popContext();
        this.isClickBack = true;
      }
    })
    .stateStyles({
      normal: this.normalStyles,
      pressed: this.pressedStyles,
    })
    .onHover((isHover: boolean) => {
      if (!DeviceHelper.isPC()) {
        return;
      }
      this.pcBackButtonColor = isHover ? $r('sys.color.ohos_id_color_button_normal') : Color.Transparent;
      this.backButtonRadius = isHover ? DeviceHelper.isPC() ? $r('app.float.enable_component_image_radius') :
        $r('sys.float.ohos_id_corner_radius_clicked') : $r('app.float.nav_back_image_bg_radius');
    })
    .margin(this.backMargin)
    .align(Alignment.Center)
    .accessibilityText(getContext(this)?.resourceManager.getStringSync(accessibilityText.id))
  }

  @Builder
  buildNavIcon() {
    Image(this.navIcon)
      .width($r('app.float.nav_back_image_bg_width_height'))
      .height($r('app.float.nav_back_image_bg_width_height'))
      .id(NAV_ICON_ID)
      .draggable(false)
      .margin({ start: LengthMetrics.resource($r('app.float.page_margin_l')) })
  }
}