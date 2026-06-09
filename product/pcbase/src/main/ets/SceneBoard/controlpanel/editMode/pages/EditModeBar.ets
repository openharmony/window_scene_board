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
import { ResUtils } from '@ohos/windowscene';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';

import { EditModeBarStyle } from '../style/EditModeStyle';
import { EditModeBarVm } from '../vm/EditModeBarVm';
import { EditModeBarViewData } from '../viewData/EditModeBarViewData';
import Constants from '../../common/constants';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = 'EditModeBar';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

@Component
export struct EditModeBar {
  @Link viewData: EditModeBarViewData;
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State confirmIconBgColor: ResourceColor = Color.Transparent;
  @State jackBackIconBgColor: ResourceColor = Color.Transparent;
  private editModeBarVm?: EditModeBarVm;

  aboutToAppear(): void {
    log.showInfo(TAG, 'EditModeBar aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'EditModeBar aboutToDisappear');
  }

  @Builder
  btnImage(image: Resource, isReverse: boolean = true) {
    Image(image)
      .matchTextDirection(isReverse)
      .width(EditModeBarStyle.getInstance().btnWidth)
      .height(EditModeBarStyle.getInstance().btnHeight)
      .fillColor(this.colorModeViewData.commonIconOffColor)
      .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOptionOnBackground)
  }

  @Builder
  jumpBack() {
    Column() {
      this.btnImage($r('app.media.cancle'))
    }
    .containerStyles()
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .margin({ left: EditModeBarStyle.getInstance().leftBtnMarginLeft })
    .backgroundColor(this.jackBackIconBgColor)
    .onClick((event: ClickEvent) => {
      this.onContainerClickEvent(false, event);
    })
    .onHover((isHover: boolean) => {
      this.onContainerHoverEvent(false, isHover);
    })
    .onTouch((event: TouchEvent) => {
      this.onContainerTouchEvent(false, event);
    })
  }

  @Builder
  editModeBarTitle() {
    Text($r('app.string.control_center_edit_panel_title_edit'))
      .align(Alignment.Start)
      .fontSize(ResUtils.getNumber($r('app.float.Control_center_head_font_size')) *
      this.controlCenterFontScale + 'vp')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Bold)
      .fontColor($r('sys.color.font_primary'))
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .width(EditModeBarStyle.getInstance().titleWidth)
      .height(EditModeBarStyle.getInstance().titleHeight)
      .margin({ left: EditModeBarStyle.getInstance().titleMarginLeft })
  }

  @Builder
  confirm() {
    Column() {
      this.btnImage($r('app.media.ic_selected'), false)
    }
    .onClick((event: ClickEvent) => {
      this.onContainerClickEvent(true, event);
    })
    .onHover((isHover: boolean) => {
      this.onContainerHoverEvent(true, isHover);
    })
    .onTouch((event: TouchEvent) => {
      this.onContainerTouchEvent(true, event);
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(this.confirmIconBgColor)
    .containerStyles()
    .margin({ end: LengthMetrics.vp(EditModeBarStyle.getInstance().rightBtnMarginRight) })
  }

  @Styles
  containerStyles() {
    .width(EditModeBarStyle.getInstance().btnWrapperWidth)
    .height(EditModeBarStyle.getInstance().btnWrapperHeight)
    .borderRadius($r('app.float.Control_center_setting_border'))
  }

  private onContainerClickEvent = (isConfirmIcon: boolean, event: ClickEvent) => {
    if (isConfirmIcon) {
      this.editModeBarVm?.confirm();
    } else {
      this.editModeBarVm?.jumpBack();
    }
  }

  private onContainerHoverEvent = (isConfirmIcon: boolean, isHover: boolean) => {
    const bgColor: ResourceColor = isHover ? $r('sys.color.interactive_hover') : Color.Transparent;
    if (isConfirmIcon) {
      this.confirmIconBgColor = bgColor;
    } else {
      this.jackBackIconBgColor = bgColor;
    }
  }

  private onContainerTouchEvent = (isConfirmIcon: boolean, event: TouchEvent) => {
    let bgColor: ResourceColor = Color.Transparent;
    if (!event || event.type === TouchType.Move) {
      return;
    }
    if (event.type === TouchType.Down) {
      bgColor = $r('sys.color.interactive_pressed');
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      bgColor = Color.Transparent;
    }
    if (isConfirmIcon) {
      this.confirmIconBgColor = bgColor;
    } else {
      this.jackBackIconBgColor = bgColor;
    }
  }

  build() {
    Row() {
      this.jumpBack()

      this.editModeBarTitle()

      this.confirm()
    }
    .id(Constants.EDIT_MODE_BAR_COMPONENT_ID)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(this.viewData.height)
  }
}